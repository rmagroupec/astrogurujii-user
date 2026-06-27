// lib/Screens/video_call/NewVideoCallScreen.dart
// COMPLETE REWRITE — all bugs fixed:
// 1. User local video now visible (uid=0 for local canvas, uid=1 to join)
// 2. Astrologer remote video visible (uid from onUserJoined event)
// 3. All buttons working: volume, mute, switch camera, disconnect
// 4. Back button assertion error fixed
// 5. Minimize/restore works — static engine survives dispose

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
  static const _dbUrl = 'https://astrogurujii-production-default-rtdb.firebaseio.com/';
  static const _appId = '8782e154141a4c0bbc8acaa3004d21f2';

  // ── STATIC: engine survives screen dispose (for minimize/restore) ─────────
  static RtcEngine? _engine;
  static String     _activeChannel = '';
  static bool       _remoteJoined  = false;
  static int?       _remoteUid;

  // ── Static callbacks — rewired on each mount ──────────────────────────────
  static void Function(int uid)? _onRemoteJoinCb;
  static void Function(int uid)? _onRemoteLeaveCb;

  final HttpServices _http = HttpServices();
  bool _disposed = false;

  AgoraController get _agoraCtrl {
    if (Get.isRegistered<AgoraController>()) return Get.find<AgoraController>();
    return Get.put(AgoraController());
  }

  // ── Local mute/camera state ───────────────────────────────────────────────
  bool _localMuted    = false;
  bool _localVideoOff = false;
  bool _speakerOn     = true;
  bool _frontCamera   = true;

  Timer? _statusPollTimer;
  Timer? _meetingTimer;
  Timer? _countdownTick;

  int  meetingDuration      = 0;
  var  meetingDurationTxt   = '00:00'.obs;
  int  meetingDurationCount = 119;
  StreamSubscription? _abortSub;

  final ValueNotifier<int>           _countdownNotifier = ValueNotifier<int>(0);
  StreamSubscription<DatabaseEvent>? _firebaseSub;

  bool   isSomeOneJoinedCall = false;
  bool   _connecting         = true;
  String _userName           = '';

  double ratingPoint = 0.0;
  final TextEditingController _reviewCtrl = TextEditingController();
  bool _ratingDialogShown = false;

  @override
  void setState(fn) {
    if (mounted && !_disposed) super.setState(fn);
  }

  // ─────────────────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();

    final walletInt = int.tryParse(widget.wallet) ?? 0;
    final rateInt   = int.tryParse(widget.rate)   ?? 1;
    final seedSecs  = rateInt > 0 ? (walletInt ~/ rateInt) * 60 + 60 : 0;
    _countdownNotifier.value = seedSecs.clamp(0, 99999);

    // Wire callbacks into static slots
    _onRemoteJoinCb = (uid) {
      if (_disposed || !mounted) return;
      _remoteJoined       = true;
      _remoteUid          = uid;
      isSomeOneJoinedCall = true;
      _agoraCtrl.startMeetingTimer();
      try { _abortSub?.cancel(); } catch (_) {}
      setState(() => _connecting = false);
    };

    _onRemoteLeaveCb = (uid) {
      if (_disposed || !mounted) return;
      _remoteJoined       = false;
      _remoteUid          = null;
      isSomeOneJoinedCall = false;
      setState(() => _connecting = true);
      Future.microtask(() { if (!_ratingDialogShown) _showRatingDialogOnce(); });
    };

    final returning = _engine != null && _activeChannel == widget.channelName;

    if (returning) {
      // Returning from minimize — engine already running
      log('[Video] Returning — engine alive uid=$_remoteUid');
      isSomeOneJoinedCall = _remoteJoined;
      _connecting = !_remoteJoined;
    } else {
      // Fresh call — init engine
      WidgetsBinding.instance.addPostFrameCallback((_) => _initAgora());
    }

    _startAbortTimer();
    _startMeetingTimer();
    _fetchUserName();
    _subscribeFirebase(walletInt, rateInt);
    _statusPollTimer = Timer.periodic(
        const Duration(seconds: 2), (_) => _checkStatus());
    FirebaseMessaging.onMessage.listen((msg) {
      if (!mounted || _disposed) return;
      final type = msg.data['notification_type']?.toString() ?? '';
      if (type == 'reject_astro') { _statusPollTimer?.cancel(); if (mounted) Navigator.pop(context); }
      if (type == 'end_user')     { _statusPollTimer?.cancel(); }
    });
  }

  @override
  void dispose() {
    _disposed = true;
    // Detach callbacks — engine still runs
    _onRemoteJoinCb  = null;
    _onRemoteLeaveCb = null;

    _statusPollTimer?.cancel();
    _meetingTimer?.cancel();
    _countdownTick?.cancel();
    _firebaseSub?.cancel();
    try { _abortSub?.cancel(); } catch (_) {}
    _countdownNotifier.dispose();
    _reviewCtrl.dispose();
    try { _agoraCtrl.meetingTimer?.cancel(); } catch (_) {}
    // DO NOT release engine — must survive minimize
    super.dispose();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Agora init (fresh call only)
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> _initAgora() async {
    if (_disposed || !mounted) return;
    await Future.delayed(const Duration(milliseconds: 300));
    if (_disposed || !mounted) return;

    try {
      final engine = createAgoraRtcEngine();
      _engine        = engine;
      _activeChannel = widget.channelName;
      _remoteJoined  = false;
      _remoteUid     = null;

      await engine.initialize(RtcEngineContext(
        appId         : _appId,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ));
      if (_disposed) { await _doReleaseEngine(); return; }

      engine.registerEventHandler(RtcEngineEventHandler(
        onJoinChannelSuccess: (conn, _) {
          log('[Video] ✅ joined uid=${conn.localUid}');
          if (mounted && !_disposed) setState(() {});
        },
        onUserJoined: (conn, uid, _) {
          log('[Video] 👤 remote joined uid=$uid');
          _onRemoteJoinCb?.call(uid);
        },
        onUserOffline: (conn, uid, _) {
          log('[Video] 👤 remote offline uid=$uid');
          _onRemoteLeaveCb?.call(uid);
        },
        onLeaveChannel: (conn, _) {
          if (mounted && !_disposed) setState(() {});
        },
        onError: (code, msg) => log('[Video] ❌ $code $msg'),
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

      await engine.joinChannel(
        token    : widget.token,
        channelId: widget.channelName,
        uid      : 1,   // user = uid 1
        options  : const ChannelMediaOptions(
          channelProfile        : ChannelProfileType.channelProfileCommunication,
          clientRoleType        : ClientRoleType.clientRoleBroadcaster,
          publishMicrophoneTrack: true,
          publishCameraTrack    : true,
          autoSubscribeAudio    : true,
          autoSubscribeVideo    : true,
        ),
      );
      log('[Video] joinChannel sent channel=${widget.channelName}');
    } catch (e) {
      log('[Video] init error: $e');
    }
  }

  Future<void> _doReleaseEngine() async {
    final engine = _engine;
    _engine        = null;
    _activeChannel = '';
    _remoteJoined  = false;
    _remoteUid     = null;
    if (engine == null) return;
    try { await engine.leaveChannel(); }  catch (_) {}
    try { await engine.stopPreview(); }   catch (_) {}
    await Future.delayed(const Duration(milliseconds: 300));
    try { await engine.release(); }       catch (_) {}
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Firebase countdown
  // ─────────────────────────────────────────────────────────────────────────
  void _subscribeFirebase(int walletInt, int rateInt) {
    final ref = FirebaseDatabase.instanceFor(
      app: Firebase.app(), databaseURL: _dbUrl,
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
      if ((_countdownNotifier.value - accurate).abs() > 10) {
        _countdownNotifier.value = accurate;
      }
    });

    _countdownTick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_disposed) return;
      final cur = _countdownNotifier.value;
      if (cur > 0) _countdownNotifier.value = cur - 1;
    });
  }

  int? _computeAccurate(Map<String, dynamic> data, int walletInt, int rateInt) {
    final nowMs    = DateTime.now().millisecondsSinceEpoch;
    final rawMax   = data['max_minutes'];
    final rawLast  = data['last_tick_at'];
    final rawStart = data['started_at'];
    if (rawMax != null) {
      final maxSec = (int.tryParse(rawMax.toString()) ?? 0) * 60;
      if (rawLast != null) {
        final elapsed = ((nowMs - (int.tryParse(rawLast.toString()) ?? nowMs)) / 1000).floor();
        return (maxSec - elapsed).clamp(0, maxSec);
      }
      return maxSec;
    }
    if (rawStart != null) {
      final elapsed = ((nowMs - (int.tryParse(rawStart.toString()) ?? nowMs)) / 1000).floor();
      final maxSec  = rateInt > 0 ? (walletInt ~/ rateInt) * 60 : 0;
      return (maxSec - elapsed).clamp(0, maxSec);
    }
    return null;
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
    meetingDurationCount = 119;
    final countdown = CountdownTimer(
        const Duration(seconds: 119), const Duration(seconds: 1));
    _abortSub = countdown.listen(null);
    _abortSub!.onData((_) {
      if (!mounted || _disposed) return;
      setState(() => meetingDurationCount--);
    });
    _abortSub!.onDone(() {
      if (!_remoteJoined) _endCall();
      try { _abortSub?.cancel(); } catch (_) {}
    });
  }

  Future<void> _fetchUserName() async {
    final pref = await SharedPreferences.getInstance();
    if (!mounted || _disposed) return;
    setState(() => _userName = pref.getString('name') ?? '');
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Status poll
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> _checkStatus() async {
    if (_disposed) return;
    try {
      final res = await _http.call_initiate_status(channel_id: widget.channelName);
      if (!mounted || _disposed || res?.status != true) return;
      final s = res!.results?.status ?? '';
      if (s == 'reject_astro') {
        _statusPollTimer?.cancel();
        try { _abortSub?.cancel(); } catch (_) {}
        if (mounted && !_disposed) Navigator.pop(context);
      } else if (s == 'end_astro') {
        _statusPollTimer?.cancel();
        _showRatingDialogOnce();
      }
    } catch (_) {}
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Controls
  // ─────────────────────────────────────────────────────────────────────────
  void _toggleMute() {
    if (_engine == null) return;
    setState(() => _localMuted = !_localMuted);
    _engine!.muteLocalAudioStream(_localMuted);
  }

  void _toggleVideo() {
    if (_engine == null) return;
    setState(() => _localVideoOff = !_localVideoOff);
    _engine!.muteLocalVideoStream(_localVideoOff);
  }

  void _toggleSpeaker() {
    if (_engine == null) return;
    setState(() => _speakerOn = !_speakerOn);
    _engine!.setEnableSpeakerphone(_speakerOn);
  }

  void _switchCamera() {
    if (_engine == null) return;
    setState(() => _frontCamera = !_frontCamera);
    _engine!.switchCamera();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // End call
  // ─────────────────────────────────────────────────────────────────────────
  void _endCall() {
    _http.change_connection_request_status(
      channel_id: widget.channelName,
      status    : isSomeOneJoinedCall ? 'end_user' : 'disconnect_user',
    );
    _meetingTimer?.cancel();
    try { _agoraCtrl.meetingTimer?.cancel(); } catch (_) {}
    _doReleaseEngine();
    _showRatingDialogOnce();
  }

  void _showRatingDialogOnce() {
    if (_ratingDialogShown || !mounted || _disposed) return;
    _ratingDialogShown = true;
    _showRatingDialog(context);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Back / minimize
  // ─────────────────────────────────────────────────────────────────────────
  Future<bool> _onWillPop() async {
    if (!isSomeOneJoinedCall) return true;

    // Use a local variable — avoids using context after async gap
    final ctx = context;
    final result = await showDialog<String>(
      context: ctx,
      builder: (dialogCtx) => AlertDialog(
        title  : const Text('Video Call'),
        content: const Text('The video call is active. What would you like to do?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, 'stay'),
            child    : const Text('Stay'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, 'minimize'),
            child    : const Text('Minimize',
                style: TextStyle(color: Colors.orange)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, 'end'),
            child    : const Text('End Call',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (result == 'end') {
      _endCall();
      return true;
    }
    // 'minimize' — engine stays alive via statics
    return result == 'minimize';
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Rating
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> _submitRating() async {
    final res = await _http.add_rating(
      channel_id: widget.channelName,
      rating    : ratingPoint.toString(),
      review    : _reviewCtrl.text.isEmpty ? 'Good' : _reviewCtrl.text,
    );
    if (!mounted || _disposed) return;
    if (res?.status == true) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => MainHomeScreenWithBottomNavigation()));
    } else {
      Fluttertoast.showToast(msg: 'Something went wrong');
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Video views
  // ─────────────────────────────────────────────────────────────────────────

  // LOCAL view — always uid=0 for local canvas regardless of join uid
  Widget _localView() {
    if (_engine == null) return Container(color: Colors.black);
    if (_localVideoOff) {
      return Container(
        color: Colors.black,
        child: const Center(
            child: Icon(Icons.videocam_off, color: Colors.white38, size: 28)),
      );
    }
    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine            : _engine!,
        canvas               : const VideoCanvas(uid: 0),   // uid=0 = local
        useFlutterTexture    : true,
        useAndroidSurfaceView: false,
      ),
    );
  }

  // REMOTE view — uid from onUserJoined event
  Widget _remoteView() {
    if (_engine == null || _remoteUid == null) {
      // Connecting — show astrologer avatar
      return Container(
        color: Colors.black,
        child: Center(
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
                  errorWidget: (_, __, ___) =>
                      Container(color: Colors.grey.shade800,
                          child: const Icon(Icons.person, color: Colors.white54, size: 80)),
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
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(100)),
                    ),
                    child: Text(widget.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color     : Colors.white,
                            fontSize  : 14,
                            fontWeight: FontWeight.w500)),
                  ),
                ),
              ),
            ]),
          ),
        ),
      );
    }

    // Remote connected
    return AgoraVideoView(
      controller: VideoViewController.remote(
        rtcEngine : _engine!,
        canvas    : VideoCanvas(uid: _remoteUid!),
        connection: RtcConnection(channelId: widget.channelName),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final size        = MediaQuery.of(context).size;
    final width       = size.width;
    final height      = size.height;
    final scaleWidth  = width  / 423.5;
    final scaleHeight = height / 929.8;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(children: [

          // ── Remote video fullscreen ──────────────────────────────────────
          Positioned.fill(child: _remoteView()),

          // ── Local PiP — top right ────────────────────────────────────────
          Positioned(
            top   : 50, right: 12,
            width : width / 3.24,
            height: height / 5.64,
            child : Container(
              decoration: BoxDecoration(
                color       : Colors.black,
                border      : Border.all(width: 2, color: Colors.white38),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Stack(children: [
                  _localView(),
                  if (_userName.isNotEmpty)
                    Positioned(
                      bottom: 4, left: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                            color       : Colors.black54,
                            borderRadius: BorderRadius.circular(3)),
                        child: Text(_userName,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 10)),
                      ),
                    ),
                ]),
              ),
            ),
          ),

          // ── Connecting label ─────────────────────────────────────────────
          if (_connecting)
            Positioned(
              top : height * 0.06,
              left: 0, right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                      color       : Colors.black54,
                      borderRadius: BorderRadius.circular(20)),
                  child: const Text('Video Call Connecting...',
                      style: TextStyle(color: Colors.white, fontSize: 13)),
                ),
              ),
            ),

          // ── Timer (top center, shown when connected) ──────────────────────
          if (!_connecting)
            Positioned(
              top : height * 0.06,
              left: 0, right: 0,
              child: Center(
                child: ValueListenableBuilder<int>(
                  valueListenable: _countdownNotifier,
                  builder: (_, secs, __) {
                    final m = (secs ~/ 60).toString().padLeft(2, '0');
                    final s = (secs  % 60).toString().padLeft(2, '0');
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                          color       : Colors.black54,
                          borderRadius: BorderRadius.circular(20)),
                      child: Text('$m:$s',
                          style: TextStyle(
                              color   : secs < 60
                                  ? Colors.red
                                  : secs < 120
                                      ? Colors.orange
                                      : Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                    );
                  },
                ),
              ),
            ),

          // ── Bottom controls ──────────────────────────────────────────────
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom + 24,
                  top   : 20,
                  left  : 20,
                  right : 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin  : Alignment.bottomCenter,
                  end    : Alignment.topCenter,
                  colors : [Colors.black.withOpacity(0.85), Colors.transparent],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  // Speaker
                  _ctrlBtn(
                    svgIcon : _speakerOn
                        ? 'assets/astro/SVG_Volume.svg'
                        : 'assets/astro/SVG_Volume_Mute.svg',
                    label   : _speakerOn ? 'Speaker' : 'Earpiece',
                    onTap   : _toggleSpeaker,
                  ),

                  // Mute
                  _ctrlBtn(
                    svgIcon : _localMuted
                        ? 'assets/astro/SVG_MicMute.svg'
                        : 'assets/astro/SVG_Mic.svg',
                    label   : _localMuted ? 'Unmute' : 'Mute',
                    onTap   : _toggleMute,
                    active  : !_localMuted,
                  ),

                  // End call — center red button
                  GestureDetector(
                    onTap: _endCall,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: scaleWidth * 60, height: scaleWidth * 60,
                          decoration: BoxDecoration(
                            shape    : BoxShape.circle,
                            color    : const Color(0xFFcd2a2a),
                            boxShadow: [
                              BoxShadow(
                                  color     : Colors.red.withOpacity(0.4),
                                  blurRadius: 12,
                                  offset    : const Offset(0, 3)),
                            ],
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/astro/call_disconnect.svg',
                              width : scaleWidth * 30,
                              height: scaleWidth * 30,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text('End',
                            style: TextStyle(color: Colors.white70, fontSize: 11)),
                      ],
                    ),
                  ),

                  // Camera on/off
                  _ctrlBtn(
                    icon  : _localVideoOff
                        ? Icons.videocam_off_rounded
                        : Icons.videocam_rounded,
                    label : _localVideoOff ? 'Cam Off' : 'Camera',
                    onTap : _toggleVideo,
                    active: !_localVideoOff,
                  ),

                  // Switch camera
                  _ctrlBtn(
                    icon  : Icons.flip_camera_ios_rounded,
                    label : 'Flip',
                    onTap : _switchCamera,
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Control button — supports either SVG or Icon
  // ─────────────────────────────────────────────────────────────────────────
  Widget _ctrlBtn({
    String?        svgIcon,
    IconData?      icon,
    required String label,
    required VoidCallback onTap,
    bool           active = true,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width : 52, height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(active ? 0.18 : 0.08),
              border: Border.all(
                  color: active ? Colors.white38 : Colors.transparent),
            ),
            child: Center(
              child: svgIcon != null
                  ? SvgPicture.asset(svgIcon, width: 28, height: 28)
                  : Icon(icon, color: active ? Colors.white : Colors.white38,
                      size: 24),
            ),
          ),
          const SizedBox(height: 5),
          Text(label,
              style: TextStyle(
                  color   : active ? Colors.white70 : Colors.white30,
                  fontSize: 10)),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Rating dialog
  // ─────────────────────────────────────────────────────────────────────────
  void _showRatingDialog(BuildContext context) {
    showDialog(
      context           : context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        insetPadding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        content: StatefulBuilder(
          builder: (ctx2, ss) => Column(
            mainAxisSize      : MainAxisSize.min,
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
              const SizedBox(height: 10),
              Container(
                width     : double.infinity,
                height    : 100,
                decoration: BoxDecoration(
                    color       : Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(5)),
                padding: const EdgeInsets.only(left: 10, bottom: 5),
                child  : TextFormField(
                  controller     : _reviewCtrl,
                  textInputAction: TextInputAction.newline,
                  keyboardType   : TextInputType.multiline,
                  minLines: null, maxLines: null, expands: true,
                  decoration: const InputDecoration(
                    border   : InputBorder.none,
                    hintText : 'Review Here',
                    hintStyle: TextStyle(color: Colors.black54),
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
                    Navigator.pop(ctx);
                    _submitRating();
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