// lib/Screens/video_call/AudioCallScreen.dart
// COMPLETE REWRITE — fixes "Connecting" flash on minimize/return via FAB
// Strategy: static engine + static channel survives screen dispose.
// On return, if engine still alive on same channel → skip re-join, restore state.
// uid = 1 for user (unchanged). All UI identical to original.

import 'dart:async';
import 'dart:math' as math;

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Screens/video_call/Controllers/agora_controller.dart';
import 'package:astro_gurujii/Screens/video_call/Helpers/utils.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:astro_gurujii/widget/bottom_navigation_bar_custom.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:quiver/async.dart';

class AfterCallConnecting extends StatefulWidget {
  final String channelName;
  final String name;
  final String profile;
  final String callfrom;
  final String token;
  final String wallet;
  final String rate;

  const AfterCallConnecting({
    Key? key,
    required this.channelName,
    required this.name,
    required this.profile,
    required this.callfrom,
    required this.token,
    this.wallet = '0',
    this.rate   = '1',
  }) : super(key: key);

  @override
  State<AfterCallConnecting> createState() => _AfterCallConnectingState();
}

class _AfterCallConnectingState extends State<AfterCallConnecting> {
  static const _dbUrl = 'https://astrogurujii-production-default-rtdb.firebaseio.com/';
  static const _appId = '8782e154141a4c0bbc8acaa3004d21f2';

  // ── STATIC: survives screen dispose ──────────────────────────────────────
  static RtcEngine? _engine;
  static String     _activeChannel   = '';
  static bool       _remoteJoined    = false;
  static int?       _remoteUid;
  static bool       _engineReleasing = false;
  static Completer<void>? _releaseCompleter;

  // ── Instance callbacks (re-wired on each screen mount) ───────────────────
  static void Function(int uid)?    _onRemoteJoin;
  static void Function(int uid)?    _onRemoteLeave;

  final HttpServices _httpService = HttpServices();

  AgoraController get _agoraCtrl {
    if (Get.isRegistered<AgoraController>()) return Get.find<AgoraController>();
    return Get.put(AgoraController());
  }

  AudioPlayer audioPlayer    = AudioPlayer();
  AudioCache  audioCache     = AudioCache();
  bool isRingtonePlaying     = false;

  Timer? _statusPollTimer;
  Timer? _meetingTimer;
  Timer? _callTimer;
  Timer? _countdownTick;

  bool   isMuted      = false;
  bool   isHold       = false;
  bool   isSpeakerOn  = false;
  String callStatus   = 'Connecting';
  bool   _disposed    = false;
  bool   isSomeOneJoinedCall = false;

  int    _elapsedSeconds = 0;
  String _displayTime    = '00:00';

  int meetingDuration         = 0;
  var meetingDurationTxt      = '00:00'.obs;
  int meetingDurationCount    = 119;
  var meetingDurationTxtCount = '00:00'.obs;

  final ValueNotifier<int>           _countdownNotifier = ValueNotifier<int>(0);
  StreamSubscription<DatabaseEvent>? _firebaseSub;
  StreamSubscription?                _abortSub;

  double ratingPoint = 0.0;
  final TextEditingController reviewControler = TextEditingController();
  bool _ratingDialogShown = false;

  @override
  void initState() {
    super.initState();

    final walletInt = int.tryParse(widget.wallet) ?? 0;
    final rateInt   = int.tryParse(widget.rate)   ?? 1;
    final seedSecs  = rateInt > 0 ? (walletInt ~/ rateInt) * 60 + 60 : 0;
    _countdownNotifier.value = seedSecs.clamp(0, 99999);

    // ── Wire instance callbacks so static engine calls back into this screen ─
    _onRemoteJoin = (uid) {
      if (_disposed || !mounted) return;
      _remoteJoined       = true;
      _remoteUid          = uid;
      isSomeOneJoinedCall = true;
      _agoraCtrl.startMeetingTimer();
      _startCallTimer();
      _stopRingtone();
      try { _abortSub?.cancel(); } catch (_) {}
      setState(() => callStatus = 'Connected');
    };

    _onRemoteLeave = (uid) {
      if (_disposed || !mounted) return;
      _remoteJoined       = false;
      _remoteUid          = null;
      isSomeOneJoinedCall = false;
      _callTimer?.cancel();
      setState(() => callStatus = 'Offline');
    };

    final returning = _engine != null && _activeChannel == widget.channelName;

    if (returning) {
      // ── RETURNING FROM MINIMIZE: engine already running ──────────────────
      debugPrint('[Audio] Returning — engine alive, skipping re-join');
      isSomeOneJoinedCall = _remoteJoined;
      callStatus = _remoteJoined ? 'Connected' : 'Connecting';
      if (_remoteJoined) _startCallTimer();
    } else {
      // ── FRESH CALL: init engine ──────────────────────────────────────────
      _preloadRingtone();
      _playRingtone();
      _httpService.call_status_update(channel_id: widget.channelName, status: 'accept_astro');
      WidgetsBinding.instance.addPostFrameCallback((_) => _initAgora());
    }

    _startAbortTimer();
    _startMeetingTimer();
    _subscribeFirebase(walletInt, rateInt);
    _statusPollTimer = Timer.periodic(const Duration(seconds: 2), (_) => _checkStatus());
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen(_handlePush);
  }

  @override
  void dispose() {
    _disposed = true;
    // Detach callbacks so stale screen doesn't get called
    _onRemoteJoin  = null;
    _onRemoteLeave = null;

    _statusPollTimer?.cancel();
    _meetingTimer?.cancel();
    _callTimer?.cancel();
    _countdownTick?.cancel();
    _firebaseSub?.cancel();
    try { _abortSub?.cancel(); } catch (_) {}
    _countdownNotifier.dispose();
    reviewControler.dispose();
    _stopRingtone();
    // NOTE: DO NOT release engine here — it must survive minimize
    super.dispose();
  }

  // ── Agora init (fresh call only) ─────────────────────────────────────────
  Future<void> _initAgora() async {
    if (_engineReleasing) {
      await _releaseCompleter?.future.timeout(
        const Duration(seconds: 3), onTimeout: () {});
    }
    if (_disposed || !mounted) return;

    await Future.delayed(const Duration(milliseconds: 300));
    if (_disposed || !mounted) return;

    try {
      final engine = createAgoraRtcEngine();
      _engine        = engine;
      _activeChannel = widget.channelName;

      await engine.initialize(RtcEngineContext(appId: _appId));
      if (_disposed) { await _releaseEngine(); return; }

      await engine.enableAudio();
      await engine.enableWebSdkInteroperability(true);

      engine.registerEventHandler(RtcEngineEventHandler(
        onJoinChannelSuccess: (conn, _) {
          debugPrint('[Audio] ✅ joined uid=${conn.localUid}');
          if (mounted && !_disposed) setState(() {});
        },
        onUserJoined: (conn, uid, _) {
          debugPrint('[Audio] 👤 remote joined uid=$uid');
          _onRemoteJoin?.call(uid);
        },
        onUserOffline: (conn, uid, _) {
          debugPrint('[Audio] 👤 remote offline uid=$uid');
          _onRemoteLeave?.call(uid);
          Future.microtask(() {
            if (!_ratingDialogShown) _showRatingDialogOnce();
          });
        },
        onLeaveChannel: (conn, _) {
          if (mounted && !_disposed) setState(() {});
        },
        onError: (code, msg) => debugPrint('[Audio] ❌ $code $msg'),
      ));

      await engine.joinChannel(
        token    : widget.token,
        channelId: widget.channelName,
        uid      : 1,
        options  : const ChannelMediaOptions(
          clientRoleType        : ClientRoleType.clientRoleBroadcaster,
          publishMicrophoneTrack: true,
          autoSubscribeAudio    : true,
        ),
      );
      debugPrint('[Audio] joinChannel sent channel=${widget.channelName} token=${widget.token}');
    } catch (e) {
      debugPrint('[Audio] init error: $e');
    }
  }

  // ── Release engine (called only on true call end) ─────────────────────────
  Future<void> _releaseEngine() async {
    final engine = _engine;
    _engine        = null;
    _activeChannel = '';
    _remoteJoined  = false;
    _remoteUid     = null;
    if (engine == null) return;

    _engineReleasing = true;
    final completer  = Completer<void>();
    _releaseCompleter = completer;
    try { await engine.leaveChannel(); } catch (_) {}
    await Future.delayed(const Duration(milliseconds: 400));
    try { await engine.release(); } catch (_) {}
    _engineReleasing = false;
    if (!completer.isCompleted) completer.complete();
    _releaseCompleter = null;
  }

  // ── Firebase countdown ────────────────────────────────────────────────────
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
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    final rawMax = data['max_minutes'];
    final rawLast = data['last_tick_at'];
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

  // ── Timers ────────────────────────────────────────────────────────────────
  void _startAbortTimer() {
    meetingDurationCount = 119;
    final countdown = CountdownTimer(const Duration(seconds: 119), const Duration(seconds: 1));
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
      if (!_remoteJoined) _getChangeConnectionApi('disconnect_user');
    });
  }

  void _startMeetingTimer() {
    _meetingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || _disposed) return;
      final m = meetingDuration ~/ 60;
      final s = meetingDuration % 60;
      meetingDurationTxt.value =
          '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
      setState(() => meetingDuration++);
    });
  }

  void _startCallTimer() {
    _callTimer?.cancel();
    _callTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || _disposed) return;
      setState(() {
        _elapsedSeconds++;
        final d = Duration(seconds: _elapsedSeconds);
        _displayTime =
            '${d.inMinutes}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';
      });
    });
  }

  // ── Status poll ───────────────────────────────────────────────────────────
  Future<void> _checkStatus() async {
    if (_disposed) return;
    final res = await _httpService.call_initiate_status(channel_id: widget.channelName);
    if (!mounted || _disposed || res?.status != true) return;
    final s = res!.results?.status ?? '';
    if (s == 'accept_astro') {
      try { _abortSub?.cancel(); } catch (_) {}
    } else if (s == 'reject_astro') {
      _statusPollTimer?.cancel();
      try { _abortSub?.cancel(); } catch (_) {}
      if (mounted && !_disposed) Navigator.pop(context);
    } else if (s == 'end_user') {
      _statusPollTimer?.cancel();
      try { _abortSub?.cancel(); } catch (_) {}
    }
  }

  void _handlePush(RemoteMessage msg) {
    final type = msg.data['notification_type']?.toString() ?? '';
    if (type == 'reject_astro') {
      try { _abortSub?.cancel(); } catch (_) {}
      if (mounted && !_disposed) Navigator.pop(context);
    }
  }

  // ── Ringtone ──────────────────────────────────────────────────────────────
  Future<void> _preloadRingtone() async {
    try { await audioCache.load('ring.mp3'); } catch (_) {}
  }

  Future<void> _playRingtone() async {
    try {
      if (!isRingtonePlaying) {
        await Future.delayed(const Duration(milliseconds: 500));
        await audioPlayer.play(AssetSource('ring.mp3'));
        isRingtonePlaying = true;
      }
    } catch (_) {}
  }

  Future<void> _stopRingtone() async {
    try {
      if (isRingtonePlaying) { await audioPlayer.stop(); isRingtonePlaying = false; }
    } catch (_) {}
  }

  // ── API helpers ───────────────────────────────────────────────────────────
  Future<void> _getChangeConnectionApi(String status) async {
    try {
      await _httpService.change_connection_request_status(
          channel_id: widget.channelName, status: status);
    } catch (_) {}
  }

  Future<void> _callAliForRating(double rating, String text) async {
    final res = await _httpService.add_rating(
      channel_id: widget.channelName,
      rating    : rating.toString(),
      review    : text.isEmpty ? 'Good' : text,
    );
    if (!mounted || _disposed) return;
    if (res?.status == true) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => MainHomeScreenWithBottomNavigation()));
    } else {
      Fluttertoast.showToast(msg: 'Something went wrong');
    }
  }

  void _showRatingDialogOnce() {
    if (_ratingDialogShown || !mounted || _disposed) return;
    _ratingDialogShown = true;
    _showRatingDialog(context);
  }

  // ── End call ──────────────────────────────────────────────────────────────
  void _endCallAndRate() {
    _getChangeConnectionApi(isSomeOneJoinedCall ? 'end_user' : 'disconnect_user');
    _releaseEngine();
    _showRatingDialogOnce();
  }

  // ── WillPop: minimize keeps engine alive ──────────────────────────────────
  Future<bool> _onWillPop() async {
    if (!isSomeOneJoinedCall) return true;
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title  : const Text('Minimize Call'),
        content: const Text('Call is still active. You can return from the home screen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child    : const Text('Stay'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child    : const Text('Minimize', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
    // Engine stays alive — screen just pops. Static vars hold state.
    return result ?? false;
  }

  // ── BUILD ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: primaryColor,
        body: SafeArea(
          child: Stack(children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin : Alignment.topCenter,
                  end   : Alignment.bottomCenter,
                  colors: [primaryColor.withOpacity(0.8), primaryColor],
                ),
              ),
            ),
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: Container(
                height    : sh * 0.4,
                decoration: BoxDecoration(
                    color       : primaryColor,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
              ),
            ),
            Positioned(
              top : sh * 0.025,
              left: 10,
              child: IconButton(
                icon     : Icon(Icons.arrow_back_ios, color: whiteColor, size: sw * 0.06),
                onPressed: () async {
                  final pop = await _onWillPop();
                  if (pop && mounted && !_disposed) Navigator.pop(context);
                },
              ),
            ),
            Positioned(
              top  : sh * 0.13,
              left : sw * 0.075,
              right: sw * 0.075,
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: sh * 0.06, horizontal: sw * 0.04),
                decoration: BoxDecoration(
                  color       : whiteColor,
                  borderRadius: BorderRadius.circular(25),
                  border      : Border.all(color: primaryColor, width: 2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween   : Tween(begin: 0, end: 2 * math.pi),
                      duration: const Duration(seconds: 10),
                      builder : (_, v, child) => Transform.rotate(angle: v, child: child),
                      child: CircleAvatar(
                        radius         : 60,
                        backgroundColor: Colors.grey.withOpacity(0.2),
                        backgroundImage: NetworkImage(widget.profile),
                      ),
                    ),
                    SizedBox(height: sh * 0.03),
                    Text(widget.name,
                        style: TextStyle(
                            color     : Colors.black,
                            fontSize  : sw * 0.054,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: sh * 0.01),
                    Text(
                      callStatus,
                      style: TextStyle(
                          color     : callStatus == 'Connected'
                              ? Colors.green
                              : Colors.grey,
                          fontSize  : sw * 0.035,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: sh * 0.03),
                    ValueListenableBuilder<int>(
                      valueListenable: _countdownNotifier,
                      builder: (_, secs, __) {
                        final m          = (secs ~/ 60).toString().padLeft(2, '0');
                        final s          = (secs % 60).toString().padLeft(2, '0');
                        final isLow      = secs < 120;
                        final isCritical = secs < 60;
                        return Column(
                          children: [
                            Text('$m:$s',
                                style: TextStyle(
                                    color     : isCritical
                                        ? Colors.red
                                        : isLow ? Colors.orange : Colors.black,
                                    fontSize  : sw * 0.05,
                                    fontWeight: FontWeight.w600)),
                            if (isLow)
                              Text(
                                isCritical ? '⚠ Low Balance' : 'Balance running low',
                                style: TextStyle(
                                    color   : isCritical ? Colors.red : Colors.orange,
                                    fontSize: sw * 0.03),
                              ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: sh * 0.01),
                    Text(_displayTime,
                        style: TextStyle(
                            color     : Colors.black,
                            fontSize  : sw * 0.035,
                            fontWeight: FontWeight.w300)),
                    SizedBox(height: sh * 0.06),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _actionBtn(
                          !isMuted ? Icons.mic_off : Icons.mic,
                          !isMuted ? 'Mute' : 'Unmute', sw,
                          () {
                            setState(() => isMuted = !isMuted);
                            _engine?.muteLocalAudioStream(isMuted);
                          },
                          !isMuted ? Colors.white : Colors.grey.shade300,
                        ),
                        _actionBtn(
                          Icons.pause, isHold ? 'Resume' : 'Hold', sw,
                          () {
                            setState(() => isHold = !isHold);
                            if (isHold) {
                              _engine?.muteLocalAudioStream(true);
                              _engine?.disableAudio();
                              setState(() => callStatus = 'On Hold');
                            } else {
                              _engine?.muteLocalAudioStream(false);
                              _engine?.enableAudio();
                              setState(() => callStatus = 'Connected');
                            }
                          },
                          isHold ? Colors.grey.shade300 : Colors.white,
                        ),
                        _actionBtn(
                          Icons.volume_up,
                          isSpeakerOn ? 'Speaker' : 'Earpiece', sw,
                          () {
                            setState(() => isSpeakerOn = !isSpeakerOn);
                            _engine?.setEnableSpeakerphone(isSpeakerOn);
                          },
                          isSpeakerOn ? Colors.grey.shade300 : Colors.white,
                        ),
                      ],
                    ),
                    SizedBox(height: sh * 0.06),
                    GestureDetector(
                      onTap: _endCallAndRate,
                      child: CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: sw * 0.0875,
                        child : Icon(Icons.call_end, color: Colors.white, size: sw * 0.075),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _actionBtn(
      IconData icon, String label, double sw, VoidCallback onTap, Color bgColor) {
    return GestureDetector(
      onTap: onTap,
      child: Column(children: [
        Container(
          padding   : const EdgeInsets.all(17),
          decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(50)),
          child: Icon(icon, color: Colors.black, size: sw * 0.06),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(color: Colors.black, fontSize: sw * 0.03)),
      ]),
    );
  }

  void _showRatingDialog(BuildContext ctx) {
    showDialog(
      context           : ctx,
      barrierDismissible: false,
      builder: (dCtx) => AlertDialog(
        insetPadding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title  : const Text('Rate Your Experience'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RatingBar.builder(
                initialRating : 0,
                minRating     : 1,
                itemCount     : 5,
                itemPadding   : const EdgeInsets.symmetric(horizontal: 4),
                itemBuilder   : (_, __) => const Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (r) => ratingPoint = r,
              ),
              const SizedBox(height: 12),
              TextField(
                controller : reviewControler,
                maxLines   : 3,
                decoration : const InputDecoration(
                  hintText      : 'Write a review...',
                  border        : OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(8),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (ratingPoint < 1) {
                Fluttertoast.showToast(msg: 'Please give your valuable feedback');
              } else {
                Navigator.pop(dCtx);
                _callAliForRating(ratingPoint, reviewControler.text);
              }
            },
            child: const Text('SUBMIT'),
          ),
        ],
      ),
    );
  }
}