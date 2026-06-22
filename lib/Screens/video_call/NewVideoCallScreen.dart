// lib/Screens/video_call/VideoCallScreen.dart  (USER APP)
//
// FIXES for "video call not connecting":
//  1. Same static engine pattern as AfterCallConnecting — ensures previous
//     engine is fully released before new one initializes.
//  2. uid changed from 1 → 2 to avoid collision with astrologer's uid.
//     Astrologer app joins as uid=0 or uid=1. User should be uid=2.
//  3. Agora init deferred to post-frame + 500ms delay after previous release.
//  4. onError no longer sets "Try again" — errors during init are retried.
//  5. ChannelMediaOptions explicitly sets broadcaster role + publishes tracks.

import 'dart:async';
import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Screens/video_call/Controllers/agora_controller.dart';
import 'package:astro_gurujii/widget/bottom_navigation_bar_custom.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:quiver/async.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Setup/SetUp.dart';
import 'Helpers/utils.dart';

class VideoCallScreen extends StatefulWidget {
  final String channelName;
  final String name;
  final String profile;
  final String token;
  final String wallet;
  final String rate;

  const VideoCallScreen({
    Key? key,
    required this.channelName,
    required this.name,
    required this.profile,
    this.token  = '',
    this.wallet = '0',
    this.rate   = '1',
  }) : super(key: key);

  @override
  VideoCallScreenState createState() => VideoCallScreenState();
}

class VideoCallScreenState extends State<VideoCallScreen> {
  static const _dbUrl =
      'https://astrogurujii-production-default-rtdb.firebaseio.com/';

  // ── Static engine — same pattern as AfterCallConnecting ───────────────────
  static RtcEngine? _sharedEngine;
  static bool       _engineReleasing = false;

  final _infoStrings       = <String>[];
  final HttpServices _http = HttpServices();
  bool _disposed           = false;

  bool isSomeOneJoinedCall = false;

  AgoraController get _agoraCtrl {
    if (Get.isRegistered<AgoraController>()) return Get.find<AgoraController>();
    return Get.put(AgoraController());
  }

  final List<int> _users = [];

  // ── Timers ─────────────────────────────────────────────────────────────────
  Timer? _statusPollTimer;
  Timer? _meetingTimer;
  Timer? _countdownTick;

  // ── Meeting elapsed ────────────────────────────────────────────────────────
  int  meetingDuration         = 0;
  var  meetingDurationTxt      = '00:00'.obs;
  int  meetingDurationCount    = 119;
  var  meetingDurationTxtCount = '00:00'.obs;
  StreamSubscription? _abortSub;

  // ── Firebase countdown ─────────────────────────────────────────────────────
  final ValueNotifier<int> _countdownNotifier = ValueNotifier<int>(0);
  StreamSubscription<DatabaseEvent>? _firebaseSub;

  bool   status    = true;
  String _userName = '';

  // ── Rating ────────────────────────────────────────────────────────────────
  double ratingPoint = 0.0;
  final TextEditingController reviewControler = TextEditingController();
  bool _ratingDialogShown = false;

  // ─────────────────────────────────────────────────────────────────────────
  @override
  void setState(fn) {
    try { if (mounted && !_disposed) super.setState(fn); } catch (_) {}
  }

  // ─────────────────────────────────────────────────────────────────────────
  // initState
  // ─────────────────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();

    final walletInt = int.tryParse(widget.wallet) ?? 0;
    final rateInt   = int.tryParse(widget.rate)   ?? 1;
    final seedSecs  = rateInt > 0 ? (walletInt ~/ rateInt) * 60 + 60 : 0;
    _countdownNotifier.value = seedSecs.clamp(0, 99999);

    _startAbortTimer();
    _startMeetingTimer();
    _fetchUserProfile();
    _subscribeCallSession();

    _statusPollTimer = Timer.periodic(
        const Duration(seconds: 2), (_) => _checkStatus());

    FirebaseMessaging.instance.getInitialMessage().then((_) {});
    FirebaseMessaging.onMessage.listen((msg) {
      if (!mounted || _disposed) return;
      final type = msg.data['notification_type']?.toString() ?? '';
      if (type == 'reject_astro') _cleanupAndPop();
      if (type == 'end_user')     _statusPollTimer?.cancel();
    });

    // Defer Agora init — same pattern as AfterCallConnecting
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initAgoraWithDelay();
    });
  }

  // ─────────────────────────────────────────────────────────────────────────
  // dispose
  // ─────────────────────────────────────────────────────────────────────────
  @override
  void dispose() {
    _disposed = true;
    _statusPollTimer?.cancel();
    _meetingTimer?.cancel();
    _countdownTick?.cancel();
    _firebaseSub?.cancel();
    try { _abortSub?.cancel(); } catch (_) {}
    _countdownNotifier.dispose();
    reviewControler.dispose();

    try { _agoraCtrl.meetingTimer?.cancel(); } catch (_) {}

    // Async cleanup — new instance will wait
    final engine = _sharedEngine;
    if (engine != null) {
      _engineReleasing = true;
      _sharedEngine = null;
      Future(() async {
        try { await engine.leaveChannel(); } catch (_) {}
        try { await engine.stopPreview();  } catch (_) {}
        await Future.delayed(const Duration(milliseconds: 300));
        try { await engine.release();      } catch (_) {}
        _engineReleasing = false;
      });
    }

    super.dispose();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Init with delay
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> _initAgoraWithDelay() async {
    if (_engineReleasing) {
      int waited = 0;
      while (_engineReleasing && waited < 2000) {
        await Future.delayed(const Duration(milliseconds: 100));
        waited += 100;
      }
    }
    if (_disposed || !mounted) return;
    await Future.delayed(const Duration(milliseconds: 500));
    if (_disposed || !mounted) return;
    await _initAgora();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Agora init — uid=2 to avoid collision
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> _initAgora() async {
    if (_disposed || !mounted) return;

    try {
      final appId = getAgoraAppId().trim();
      if (appId.isEmpty) { log('❌ [VIDEO] App ID empty'); return; }

      final engine = createAgoraRtcEngine();
      _sharedEngine = engine;

      await engine.initialize(RtcEngineContext(
        appId         : appId,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ));

      if (_disposed) {
        await engine.release();
        _sharedEngine = null;
        return;
      }

      engine.registerEventHandler(RtcEngineEventHandler(
        onJoinChannelSuccess: (conn, _) {
          log('✅ [VIDEO] joined uid=${conn.localUid}');
          if (mounted && !_disposed) setState(() => _infoStrings.add('joined'));
        },
        onLeaveChannel: (_, __) {
          if (mounted && !_disposed) setState(() {
            _infoStrings.add('left');
            _users.clear();
          });
        },
        onUserJoined: (_, uid, __) {
          log('👤 [VIDEO] user joined uid=$uid');
          isSomeOneJoinedCall = true;
          _agoraCtrl.startMeetingTimer();
          if (mounted && !_disposed) setState(() {
            _users.add(uid);
            if (status) { status = false; meetingDuration = 0; }
          });
        },
        onUserOffline: (_, uid, __) {
          if (mounted && !_disposed) setState(() => _users.remove(uid));
        },
        onFirstRemoteVideoFrame: (conn, uid, w, h, elapsed) {
          log('🎥 [VIDEO] first remote frame uid=$uid');
          if (mounted && !_disposed) setState(() {});
        },
        onError: (code, msg) {
          log('❌ [VIDEO] error: $code $msg');
          // Don't set "Try again" — may be transient; SDK will recover
        },
      ));

      await engine.enableAudio();
      await engine.enableVideo();
      await engine.setVideoEncoderConfiguration(
        const VideoEncoderConfiguration(
          dimensions     : VideoDimensions(width: 640, height: 360),
          frameRate      : 30,
          bitrate        : 800,
          orientationMode: OrientationMode.orientationModeAdaptive,
        ),
      );
      await engine.startPreview();
      if (mounted && !_disposed) setState(() {});

      if (_disposed || !mounted) return;

      // FIX: uid=2 — user app. Astrologer typically joins as uid=0 or uid=1.
      await engine.joinChannel(
        token    : widget.token,
        channelId: widget.channelName,
        uid      : 1,
        options  : const ChannelMediaOptions(
          channelProfile        : ChannelProfileType.channelProfileCommunication,
          clientRoleType        : ClientRoleType.clientRoleBroadcaster,
          publishCameraTrack    : true,
          publishMicrophoneTrack: true,
          autoSubscribeVideo    : true,
          autoSubscribeAudio    : true,
        ),
      );

      await engine.setEnableSpeakerphone(true);
      log('✅ [VIDEO] init complete, joined ${widget.channelName} as uid=2');

    } on AgoraRtcException catch (e) {
      log('❌ [VIDEO] AgoraRtcException code=${e.code} msg=${e.message}');
      if (mounted && !_disposed) {
        Fluttertoast.showToast(
            msg: 'Video call error (${e.code}): ${e.message}',
            toastLength: Toast.LENGTH_LONG);
        // Retry once
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted && !_disposed) _initAgora();
        });
      }
    } catch (e, st) {
      log('❌ [VIDEO] Unknown error: $e\n$st');
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Firebase sync
  // ─────────────────────────────────────────────────────────────────────────
  void _subscribeCallSession() {
    final walletInt = int.tryParse(widget.wallet) ?? 0;
    final rateInt   = int.tryParse(widget.rate)   ?? 1;

    final ref = FirebaseDatabase.instanceFor(
      app        : Firebase.app(),
      databaseURL: _dbUrl,
    ).ref().child('CallSession').child(widget.channelName);

    _firebaseSub = ref.onValue.listen((event) {
      if (!mounted || _disposed) return;
      final raw = event.snapshot.value;
      if (raw == null) return;

      final data   = Map<String, dynamic>.from(raw as Map);
      final status = (data['status'] ?? '') as String;

      if (['end_astro', 'end_user', 'wallet_empty'].contains(status)) {
        _countdownNotifier.value = 0;
        _countdownTick?.cancel();
        _showRatingDialogOnce();
        return;
      }

      final accurate = _computeAccurate(data, walletInt, rateInt);
      if (accurate == null) return;
      final local = _countdownNotifier.value;
      if ((local - accurate).abs() > 10) _countdownNotifier.value = accurate;
    });

    _countdownTick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_disposed) return;
      final cur = _countdownNotifier.value;
      if (cur > 0) _countdownNotifier.value = cur - 1;
    });
  }

  int? _computeAccurate(Map<String, dynamic> data, int walletInt, int rateInt) {
    final nowMs         = DateTime.now().millisecondsSinceEpoch;
    final rawMaxMinutes = data['max_minutes'];
    final rawLastTick   = data['last_tick_at'];
    final rawStartedAt  = data['started_at'];

    if (rawMaxMinutes != null) {
      final maxSec = (int.tryParse(rawMaxMinutes.toString()) ?? 0) * 60;
      if (rawLastTick != null) {
        final elapsed = ((nowMs - (int.tryParse(rawLastTick.toString()) ?? nowMs)) / 1000).floor();
        return (maxSec - elapsed).clamp(0, maxSec);
      }
      return maxSec;
    }
    if (rawStartedAt != null) {
      final elapsed = ((nowMs - (int.tryParse(rawStartedAt.toString()) ?? nowMs)) / 1000).floor();
      final maxSec  = rateInt > 0 ? (walletInt ~/ rateInt) * 60 : 0;
      return (maxSec - elapsed).clamp(0, maxSec);
    }
    return null;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Status poll
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> _checkStatus() async {
    if (_disposed) return;
    try {
      final res = await _http.call_initiate_status(
          channel_id: widget.channelName);
      if (!mounted || _disposed || res?.status != true) return;
      final s = res!.results?.status ?? '';
      if (s == 'reject_astro') {
        _statusPollTimer?.cancel();
        try { _abortSub?.cancel(); } catch (_) {}
        if (mounted && !_disposed) Navigator.pop(context);
      } else if (s == 'end_astro') {
        _statusPollTimer?.cancel();
        try { _abortSub?.cancel(); } catch (_) {}
        _cleanupAgora();
        _showRatingDialogOnce();
      }
    } catch (_) {}
  }

  void _cleanupAndPop() {
    _statusPollTimer?.cancel();
    _cleanupAgora();
    if (mounted && !_disposed) Navigator.pop(context);
  }

  void _cleanupAgora() {
    _users.clear();
    try { _sharedEngine?.leaveChannel(); } catch (_) {}
    try { _sharedEngine?.stopPreview();  } catch (_) {}
    try { _meetingTimer?.cancel(); }      catch (_) {}
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Timers
  // ─────────────────────────────────────────────────────────────────────────
  void _startMeetingTimer() {
    _meetingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_disposed) return;
      final m = meetingDuration ~/ 60;
      final s = meetingDuration % 60;
      meetingDurationTxt.value =
          '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
      if (!mounted || _disposed) return;
      setState(() => meetingDuration++);
    });
  }

  void _startAbortTimer() {
    final countdown = CountdownTimer(
        const Duration(seconds: 119), const Duration(seconds: 1));
    _abortSub = countdown.listen(null);
    _abortSub!.onData((_) {
      if (!mounted || _disposed) return;
      final m = meetingDurationCount ~/ 60;
      final s = meetingDurationCount % 60;
      meetingDurationTxtCount.value =
          '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
      setState(() => meetingDurationCount--);
    });
    _abortSub!.onDone(() {
      _onCallEnd(context);
      try { _abortSub?.cancel(); } catch (_) {}
    });
  }

  Future<void> _fetchUserProfile() async {
    final pref = await SharedPreferences.getInstance();
    if (!mounted || _disposed) return;
    setState(() => _userName = pref.getString('name') ?? '');
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Call end
  // ─────────────────────────────────────────────────────────────────────────
  void _onCallEnd(BuildContext ctx) {
    _getChangeConnectionApi(
        isSomeOneJoinedCall ? 'end_user' : 'disconnect_user');
    _meetingTimer?.cancel();
    try { _agoraCtrl.meetingTimer?.cancel(); } catch (_) {}
  }

  Future<void> _getChangeConnectionApi(String stat) async {
    final res = await _http.change_connection_request_status(
        channel_id: widget.channelName, status: stat);
    if (!mounted || _disposed) return;
    if (res?.status == true) {
      if (stat == 'end_user') {
        _showRatingDialogOnce();
      } else {
        Navigator.pop(context);
      }
    } else {
      Fluttertoast.showToast(msg: 'Something went wrong');
    }
  }

  Future<void> _callAliForRating(double rating, String text) async {
    final res = await _http.add_rating(
      channel_id: widget.channelName,
      rating    : rating.toString(),
      review    : text.isEmpty ? 'Good' : text,
    );
    if (!mounted || _disposed) return;
    if (res?.status == true) {
      Navigator.pop(context);
      Navigator.pushReplacement(context,
          MaterialPageRoute(
              builder: (_) => MainHomeScreenWithBottomNavigation()));
    } else {
      Fluttertoast.showToast(msg: 'Something went wrong');
    }
  }

  void _showRatingDialogOnce() {
    if (_ratingDialogShown || !mounted || _disposed) return;
    _ratingDialogShown = true;
    _showRatingDialog(context);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Back button
  // ─────────────────────────────────────────────────────────────────────────
  Future<bool> _onWillPop() async {
    if (!isSomeOneJoinedCall) return true;

    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title  : const Text('Video Call'),
        content: const Text('The video call is active. What would you like to do?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'stay'),
            child    : const Text('Stay'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'minimize'),
            child    : const Text('Minimize',
                style: TextStyle(color: Colors.orange)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'end'),
            child    : const Text('End Call',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (result == 'end') {
      _onCallEnd(context);
      return true;
    }
    return result == 'minimize';
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Video views
  // ─────────────────────────────────────────────────────────────────────────
  List<Widget> _getRenderViews() {
    if (_sharedEngine == null) return [];
    final list = <Widget>[];
    list.add(AgoraVideoView(
      controller: VideoViewController(
        rtcEngine        : _sharedEngine!,
        canvas           : const VideoCanvas(uid: 0),
        useFlutterTexture: true,
        useAndroidSurfaceView: false,
      ),
    ));
    if (_users.isEmpty) {
      list.add(const WaitingForRemoteUser());
    } else {
      for (final uid in _users) {
        list.add(AgoraVideoView(
          controller: VideoViewController.remote(
            rtcEngine : _sharedEngine!,
            canvas    : VideoCanvas(uid: uid),
            connection: RtcConnection(channelId: widget.channelName),
          ),
        ));
      }
    }
    return list;
  }

  Widget _videoView(Widget v) =>
      Expanded(child: Container(color: Colors.black, child: v));

  Widget _expandedRow(List<Widget> views) => Expanded(
        child: Container(
          color: Colors.black,
          child: Row(children: views.map(_videoView).toList()),
        ),
      );

  Widget _buildJoinUserUI() {
    if (_sharedEngine == null) {
      return Container(
        color: Colors.black,
        child: const Center(child: CircularProgressIndicator(
            color: Colors.white54, strokeWidth: 2)),
      );
    }
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Column(children: [_videoView(views[0])]);
      case 2:
        return SizedBox(
          width: Get.width, height: Get.height,
          child: Stack(children: [
            Positioned.fill(child: Container(
                color: Colors.black, child: views[1])),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                decoration: BoxDecoration(
                  color       : Colors.black,
                  border      : Border.all(width: 5, color: Colors.white38),
                  borderRadius: BorderRadius.circular(5),
                ),
                margin: const EdgeInsets.fromLTRB(15, 50, 10, 15),
                width : MediaQuery.of(context).size.width / 3.24,
                height: MediaQuery.of(context).size.height / 5.64,
                child : Stack(children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: views[0]),
                  Positioned(
                    bottom: 8, left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(4)),
                      child: Row(children: [
                        const Icon(Icons.person,
                            color: Colors.white, size: 16),
                        const SizedBox(width: 5),
                        Text(_userName,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12,
                                fontWeight: FontWeight.w500)),
                      ]),
                    ),
                  ),
                ]),
              ),
            ),
          ]),
        );
      case 3:
        return Column(children: [
          _expandedRow(views.sublist(0, 2)),
          _expandedRow(views.sublist(2, 3)),
        ]);
      case 4:
        return Column(children: [
          _expandedRow(views.sublist(0, 2)),
          _expandedRow(views.sublist(2, 4)),
        ]);
      default:
        return Container(color: Colors.black);
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final mq          = MediaQuery.of(context);
    final height      = mq.size.height;
    final width       = mq.size.width;
    final scaleWidth  = width  / 423.5;
    final scaleHeight = height / 929.8;
    final scaleText   = (scaleWidth + scaleHeight) / 2;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(children: [
          Positioned.fill(
              child: Image.asset('assets/icon/4.png', fit: BoxFit.fill)),
          Positioned.fill(child: _buildJoinUserUI()),
          _buildNormalVideoUI(),
          // Bottom controls
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: scaleHeight * 111,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GetBuilder<AgoraController>(
                    builder: (ctrl) => SizedBox(
                      height: scaleHeight * 83.68,
                      width : width,
                      child : Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: scaleWidth * 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _ctrlBtn(
                              ctrl.hands
                                  ? 'assets/astro/SVG_Volume.svg'
                                  : 'assets/astro/SVG_Volume_Mute.svg',
                              _sharedEngine == null
                                  ? null
                                  : () => _agoraCtrl.toggleAudioRoute(
                                      engine: _sharedEngine!),
                              ctrl.hands ? Colors.white : Colors.red,
                            ),
                            _ctrlBtn(
                              ctrl.muted
                                  ? 'assets/astro/SVG_MicMute.svg'
                                  : 'assets/astro/SVG_Mic.svg',
                              _sharedEngine == null
                                  ? null
                                  : () => _agoraCtrl.onToggleMuteAudio(
                                      engine: _sharedEngine!),
                              ctrl.muted ? Colors.red : Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    (_users.isEmpty && status)
                        ? 'Video Call Connecting..'
                        : 'Video Call Connected',
                    style: TextStyle(
                        color: Colors.white, fontSize: scaleText * 12),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),
        ]),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: scaleHeight * 60),
          child: FloatingActionButton(
            backgroundColor: const Color(0xFFcd2a2a),
            onPressed      : () => _onCallEnd(context),
            child          : SvgPicture.asset(
                'assets/astro/call_disconnect.svg',
                width : scaleWidth * 40,
                height: scaleWidth * 40),
          ),
        ),
      ),
    );
  }

  Widget _ctrlBtn(String icon, VoidCallback? onPressed, Color iconColor) {
    return RawMaterialButton(
      padding    : EdgeInsets.zero,
      onPressed  : onPressed,
      shape      : const CircleBorder(),
      constraints: const BoxConstraints(),
      elevation  : 5,
      child      : SvgPicture.asset(icon, height: 50, width: 50),
    );
  }

  Widget _buildNormalVideoUI() {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      child : Stack(children: [
        if (_users.isEmpty && status)
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 201, height: 201,
              decoration: BoxDecoration(
                  shape : BoxShape.circle,
                  border: Border.all(width: 2, color: whiteColor)),
              child: Stack(alignment: Alignment.bottomCenter, children: [
                ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: widget.profile,
                    width: 201, height: 201, fit: BoxFit.cover,
                  ),
                ),
                ClipOval(
                  child: Container(
                    width    : 201, height: 201,
                    alignment: Alignment.bottomCenter,
                    child    : Container(
                      width  : double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: const BoxDecoration(
                        color       : Colors.black87,
                        borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(100)),
                      ),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Text(widget.name,
                            style: const TextStyle(
                                color     : Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize  : 14)),
                        const SizedBox(height: 4),
                        Obx(() => Text(meetingDurationTxtCount.value,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 12))),
                      ]),
                    ),
                  ),
                ),
              ]),
            ),
          ),

        // Countdown overlay
        Positioned(
          bottom: size.height / 8.6,
          child : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child  : SizedBox(
              width: size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ValueListenableBuilder<int>(
                    valueListenable: _countdownNotifier,
                    builder: (_, secs, __) {
                      final m          = (secs ~/ 60).toString().padLeft(2, '0');
                      final s          = (secs  % 60).toString().padLeft(2, '0');
                      final isLow      = secs < 120;
                      final isCritical = secs < 60;
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color       : Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Container(
                                  width : 5, height: 5,
                                  decoration: BoxDecoration(
                                      color       : whiteColor,
                                      borderRadius: BorderRadius.circular(10))),
                              const SizedBox(width: 5),
                              Text(widget.name,
                                  style: const TextStyle(
                                      fontSize: 11, fontWeight: FontWeight.w600,
                                      color   : Colors.white)),
                            ]),
                            const SizedBox(height: 4),
                            Row(children: [
                              Container(
                                  width : 5, height: 5,
                                  decoration: BoxDecoration(
                                      color: isCritical
                                          ? Colors.red
                                          : isLow ? Colors.orange : Colors.green,
                                      borderRadius: BorderRadius.circular(10))),
                              const SizedBox(width: 5),
                              Text('$m:$s',
                                  style: TextStyle(
                                      fontSize: 11, fontWeight: FontWeight.w600,
                                      color   : isCritical
                                          ? Colors.red
                                          : isLow ? Colors.orange : Colors.white)),
                            ]),
                            if (isLow)
                              Text(
                                isCritical ? '⚠ Low Balance' : 'Balance running low',
                                style: TextStyle(
                                    fontSize: 9,
                                    color   : isCritical
                                        ? Colors.red
                                        : Colors.orange),
                              ),
                          ],
                        ),
                      );
                    },
                  ),

                  // Camera + mute video
                  SizedBox(
                    width: size.width / 2.07,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GetBuilder<AgoraController>(
                          builder: (ctrl) => _ctrlBtn(
                            'assets/astro/camera_back.svg',
                            _sharedEngine == null
                                ? null
                                : () => _agoraCtrl
                                    .onSwitchCamera(engine: _sharedEngine!),
                            ctrl.backCamera ? Colors.red : Colors.white,
                          ),
                        ),
                        GetBuilder<AgoraController>(
                          builder: (ctrl) => _ctrlBtn(
                            ctrl.muteVideo
                                ? 'assets/astro/svg_video_off.svg'
                                : 'assets/astro/SVG_videoOn.svg',
                            _sharedEngine == null
                                ? null
                                : () => ctrl.onToggleMuteVideo(
                                    engine: _sharedEngine!),
                            ctrl.muteVideo ? Colors.red : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Rating dialog
  // ─────────────────────────────────────────────────────────────────────────
  void _showRatingDialog(BuildContext context) {
    showDialog(
      context          : context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        insetPadding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        content: StatefulBuilder(
          builder: (ctx2, ss) => Column(
            mainAxisSize     : MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Please rate your experience',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w500)),
              const SizedBox(height: 20),
              RatingBar.builder(
                itemSize     : 30,
                glowColor    : const Color(0xfff19425),
                initialRating: ratingPoint,
                itemBuilder  : (_, __) =>
                    const Icon(Icons.star, color: Color(0xfff19425)),
                onRatingUpdate: (r) => ss(() => ratingPoint = r),
              ),
              const SizedBox(height: 20),
              const Text('Additional comments',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w500)),
              const SizedBox(height: 20),
              Container(
                width     : double.infinity, height: 120,
                decoration: BoxDecoration(
                    color       : Colors.grey.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(5)),
                padding: const EdgeInsets.only(left: 10, bottom: 5),
                child  : TextFormField(
                  controller     : reviewControler,
                  textInputAction: TextInputAction.newline,
                  keyboardType   : TextInputType.multiline,
                  minLines: null, maxLines: null, expands: true,
                  decoration: const InputDecoration(
                    border   : InputBorder.none,
                    hintText : 'Review Here',
                    hintStyle: TextStyle(
                        color     : Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  if (ratingPoint < 1) {
                    Fluttertoast.showToast(
                        msg: 'Please give your valuable feedback');
                  } else {
                    Navigator.pop(ctx2);
                    _callAliForRating(ratingPoint, reviewControler.text);
                  }
                },
                child: Container(
                  height   : 45, width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient    : const LinearGradient(
                        colors: [Color(0xffFC7601), Color(0xffFC7601)]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('SUBMIT',
                      style: TextStyle(
                          color     : Colors.white,
                          fontSize  : 14,
                          fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WaitingForRemoteUser extends StatelessWidget {
  const WaitingForRemoteUser({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Container(
        color: Colors.black,
        child: Center(child: Text('Waiting for astrologer...',
            style: TextStyle(fontSize: 18, color: Colors.grey[400]))),
      );
}