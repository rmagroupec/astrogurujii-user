// lib/Screens/video_call/UserCallProvider.dart
//
// Singleton provider that holds the Agora engine for BOTH audio and video
// calls on the USER side. Mirrors the astrologer's AudioCallProvider pattern.
//
// KEY RULE:
//   - Engine is created ONCE when call starts (init / initVideo)
//   - On minimize: provider keeps engine alive, screen just pops
//   - On return via FAB: screen calls rewire() — NO re-join, NO re-init
//   - Engine released only when call truly ends (end())
//
// Agora uid = 1 for user (as per existing code)

import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

typedef OnUserCallEnded = void Function(String reason);

enum UserCallType { audio, video }

class UserCallProvider extends ChangeNotifier {
  // ── Singleton ──────────────────────────────────────────────────────────────
  UserCallProvider._();
  static final UserCallProvider instance = UserCallProvider._();

  static const _appId  = '8782e154141a4c0bbc8acaa3004d21f2';
  static const _dbUrl  = 'https://astrogurujii-production-default-rtdb.firebaseio.com/';

  // ── Engine state ───────────────────────────────────────────────────────────
  RtcEngine?    _engine;
  UserCallType? _callType;
  String        _channelId = '';
  bool          _isActive  = false;
  bool          _isEnded   = false;
  bool          _disposed  = false;

  // ── Remote state ───────────────────────────────────────────────────────────
  bool _remoteJoined   = false;
  int? _remoteUid;
  bool _remoteVideoOn  = true;

  // ── Controls ───────────────────────────────────────────────────────────────
  bool _muted      = false;
  bool _speakerOn  = true;
  bool _isVideoOn  = true;

  // ── Duration ───────────────────────────────────────────────────────────────
  Duration _callDuration = Duration.zero;
  Timer?   _durationTimer;

  // ── Firebase ───────────────────────────────────────────────────────────────
  StreamSubscription<DatabaseEvent>? _firebaseSub;
  Timer?                             _countdownTick;
  final ValueNotifier<int>           countdownNotifier = ValueNotifier<int>(0);

  // ── Callback ───────────────────────────────────────────────────────────────
  OnUserCallEnded? _onEnded;

  // ── Getters ────────────────────────────────────────────────────────────────
  RtcEngine? get engine        => _engine;
  bool       get isActive      => _isActive;
  bool       get isEnded       => _isEnded;
  bool       get remoteJoined  => _remoteJoined;
  int?       get remoteUid     => _remoteUid;
  bool       get remoteVideoOn => _remoteVideoOn;
  bool       get muted         => _muted;
  bool       get speakerOn     => _speakerOn;
  bool       get isVideoOn     => _isVideoOn;
  String     get channelId     => _channelId;
  UserCallType? get callType   => _callType;

  String get duration {
    final m = _callDuration.inMinutes.toString().padLeft(2, '0');
    final s = (_callDuration.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  // ── Safe notify ────────────────────────────────────────────────────────────
  void _notify() {
    if (_disposed) return;
    if (SchedulerBinding.instance.schedulerPhase != SchedulerPhase.idle) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_disposed) notifyListeners();
      });
    } else {
      notifyListeners();
    }
  }

  // ── Re-wire callback only (called when screen returns from minimize) ────────
  void rewire({required OnUserCallEnded onEnded}) {
    _onEnded = onEnded;
    debugPrint('[UserCallProvider] 🔄 rewired for $_channelId');
    // If remote already joined while minimized, restart duration timer
    if (_remoteJoined && (_durationTimer == null || !_durationTimer!.isActive)) {
      _startDurationTimer();
    }
  }

  // ── INIT AUDIO ─────────────────────────────────────────────────────────────
  Future<void> initAudio({
    required String         channelId,
    required String         token,
    required OnUserCallEnded onEnded,
    int                     wallet = 0,
    int                     rate   = 1,
  }) async {
    // Guard: if engine already running on this channel, just rewire
    if (_engine != null && _channelId == channelId) {
      debugPrint('[UserCallProvider] ⚠️ initAudio called but engine active — rewiring only');
      _onEnded = onEnded;
      return;
    }

    await _releaseEngine();

    _callType   = UserCallType.audio;
    _channelId  = channelId;
    _onEnded    = onEnded;
    _isActive   = true;
    _isEnded    = false;
    _remoteJoined = false;
    _remoteUid    = null;
    _callDuration = Duration.zero;

    // Seed countdown from wallet/rate
    final seedSecs = rate > 0 ? (wallet ~/ rate) * 60 + 60 : 0;
    countdownNotifier.value = seedSecs.clamp(0, 99999);

    _engine = createAgoraRtcEngine();
    await _engine!.initialize(RtcEngineContext(
      appId         : _appId,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));
    await _engine!.enableAudio();

    _engine!.registerEventHandler(RtcEngineEventHandler(
      onJoinChannelSuccess: (conn, elapsed) {
        debugPrint('[UserCallProvider] ✅ audio joined uid=${conn.localUid}');
        _notify();
      },
      onUserJoined: (conn, uid, elapsed) {
        debugPrint('[UserCallProvider] 👤 audio remote joined uid=$uid');
        _remoteJoined = true;
        _remoteUid    = uid;
        _startDurationTimer();
        _engine?.setEnableSpeakerphone(true);
        _speakerOn = true;
        _notify();
      },
      onUserOffline: (conn, uid, reason) {
        debugPrint('[UserCallProvider] 👤 audio remote offline uid=$uid');
        _remoteJoined = false;
        _remoteUid    = null;
        _durationTimer?.cancel();
        _notify();
        Future.microtask(() => _onEnded?.call('User disconnected'));
      },
      onLeaveChannel: (conn, stats) {
        _remoteJoined = false;
        _notify();
      },
      onError: (code, msg) => debugPrint('[UserCallProvider] ❌ audio error $code: $msg'),
    ));

    await _engine!.enableWebSdkInteroperability(true);

    try {
      await _engine!.joinChannel(
        token    : token,
        channelId: channelId,
        uid      : 1,   // user uid = 1
        options  : const ChannelMediaOptions(
          clientRoleType         : ClientRoleType.clientRoleBroadcaster,
          publishMicrophoneTrack : true,
          autoSubscribeAudio     : true,
          autoSubscribeVideo     : false,
        ),
      );
    } on AgoraRtcException catch (e) {
      if (e.code == -17) {
        debugPrint('[UserCallProvider] ⚠️ -17 already in channel — ignoring');
      } else {
        debugPrint('[UserCallProvider] ❌ joinChannel failed: ${e.code}');
      }
    }

    _subscribeFirebase(wallet, rate);
    _notify();
  }

  // ── INIT VIDEO ─────────────────────────────────────────────────────────────
  Future<void> initVideo({
    required String          channelId,
    required String          token,
    required OnUserCallEnded onEnded,
    int                      wallet = 0,
    int                      rate   = 1,
  }) async {
    if (_engine != null && _channelId == channelId) {
      debugPrint('[UserCallProvider] ⚠️ initVideo called but engine active — rewiring only');
      _onEnded = onEnded;
      return;
    }

    await _releaseEngine();

    _callType   = UserCallType.video;
    _channelId  = channelId;
    _onEnded    = onEnded;
    _isActive   = true;
    _isEnded    = false;
    _remoteJoined = false;
    _remoteUid    = null;
    _callDuration = Duration.zero;
    _remoteVideoOn = true;

    final seedSecs = rate > 0 ? (wallet ~/ rate) * 60 + 60 : 0;
    countdownNotifier.value = seedSecs.clamp(0, 99999);

    _engine = createAgoraRtcEngine();
    await _engine!.initialize(RtcEngineContext(
      appId         : _appId,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));

    _engine!.registerEventHandler(RtcEngineEventHandler(
      onJoinChannelSuccess: (conn, elapsed) {
        debugPrint('[UserCallProvider] ✅ video joined uid=${conn.localUid}');
        _notify();
      },
      onUserJoined: (conn, uid, elapsed) {
        debugPrint('[UserCallProvider] 👤 video remote joined uid=$uid');
        _remoteJoined  = true;
        _remoteUid     = uid;
        _remoteVideoOn = true;
        _startDurationTimer();
        _engine?.setEnableSpeakerphone(true);
        _speakerOn = true;
        _notify();
      },
      onUserOffline: (conn, uid, reason) {
        debugPrint('[UserCallProvider] 👤 video remote offline uid=$uid');
        _remoteJoined = false;
        _remoteUid    = null;
        _durationTimer?.cancel();
        _notify();
        Future.microtask(() => _onEnded?.call('User disconnected'));
      },
      onRemoteVideoStateChanged: (conn, uid, state, reason, elapsed) {
        _remoteVideoOn = state == RemoteVideoState.remoteVideoStateDecoding ||
                         state == RemoteVideoState.remoteVideoStateStarting;
        _notify();
      },
      onLeaveChannel: (conn, stats) {
        _remoteJoined = false;
        _notify();
      },
      onError: (code, msg) => debugPrint('[UserCallProvider] ❌ video error $code: $msg'),
    ));

    await _engine!.enableAudio();
    await _engine!.enableVideo();
    await _engine!.setVideoEncoderConfiguration(
      const VideoEncoderConfiguration(
        dimensions     : VideoDimensions(width: 640, height: 360),
        frameRate      : 30,
        bitrate        : 800,
        orientationMode: OrientationMode.orientationModeAdaptive,
      ),
    );
    await _engine!.startPreview();
    _notify();

    try {
      await _engine!.joinChannel(
        token    : token,
        channelId: channelId,
        uid      : 1,   // user uid = 1
        options  : const ChannelMediaOptions(
          channelProfile        : ChannelProfileType.channelProfileCommunication,
          clientRoleType        : ClientRoleType.clientRoleBroadcaster,
          publishMicrophoneTrack: true,
          publishCameraTrack    : true,
          autoSubscribeAudio    : true,
          autoSubscribeVideo    : true,
        ),
      );
    } on AgoraRtcException catch (e) {
      if (e.code == -17) {
        debugPrint('[UserCallProvider] ⚠️ -17 already in channel — ignoring');
      } else {
        debugPrint('[UserCallProvider] ❌ joinChannel failed: ${e.code}');
      }
    }

    _subscribeFirebase(wallet, rate);
    _notify();
  }

  // ── Firebase countdown ─────────────────────────────────────────────────────
  void _subscribeFirebase(int walletInt, int rateInt) {
    _firebaseSub?.cancel();
    _countdownTick?.cancel();

    final ref = FirebaseDatabase.instanceFor(
      app        : Firebase.app(),
      databaseURL: _dbUrl,
    ).ref().child('CallSession').child(_channelId);

    _firebaseSub = ref.onValue.listen((event) {
      final raw = event.snapshot.value;
      if (raw == null) return;
      final data   = Map<String, dynamic>.from(raw as Map);
      final status = (data['status'] ?? '') as String;

      if (['end_astro', 'end_user', 'wallet_empty'].contains(status) && !_isEnded) {
        countdownNotifier.value = 0;
        _countdownTick?.cancel();
        Future.microtask(() => _onEnded?.call('Call ended'));
        return;
      }

      final accurate = _computeAccurate(data, walletInt, rateInt);
      if (accurate == null) return;
      final local = countdownNotifier.value;
      if ((local - accurate).abs() > 10) countdownNotifier.value = accurate;
    });

    _countdownTick = Timer.periodic(const Duration(seconds: 1), (_) {
      final cur = countdownNotifier.value;
      if (cur > 0) countdownNotifier.value = cur - 1;
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

  // ── Duration timer ─────────────────────────────────────────────────────────
  void _startDurationTimer() {
    _durationTimer?.cancel();
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _callDuration += const Duration(seconds: 1);
      _notify();
    });
  }

  // ── Controls ───────────────────────────────────────────────────────────────
  Future<void> toggleMute() async {
    _muted = !_muted;
    await _engine?.muteLocalAudioStream(_muted);
    _notify();
  }

  Future<void> toggleSpeaker() async {
    _speakerOn = !_speakerOn;
    try { await _engine?.setEnableSpeakerphone(_speakerOn); } catch (_) {}
    _notify();
  }

  Future<void> toggleVideo() async {
    _isVideoOn = !_isVideoOn;
    await _engine?.muteLocalVideoStream(!_isVideoOn);
    _notify();
  }

  // ── End call ───────────────────────────────────────────────────────────────
  Future<void> end() async {
    if (_isEnded) return;
    _isEnded  = true;
    _isActive = false;

    _durationTimer?.cancel();
    _firebaseSub?.cancel();
    _countdownTick?.cancel();

    await _releaseEngine();

    _remoteJoined  = false;
    _remoteUid     = null;
    _callDuration  = Duration.zero;
    _muted         = false;
    _speakerOn     = true;
    _isVideoOn     = true;
    _channelId     = '';
    _callType      = null;

    _notify();
  }

  // ── Release engine ─────────────────────────────────────────────────────────
  Future<void> _releaseEngine() async {
    final engine = _engine;
    _engine = null;
    if (engine != null) {
      try { await engine.leaveChannel(); }  catch (_) {}
      try { await engine.stopPreview(); }   catch (_) {}
      await Future.delayed(const Duration(milliseconds: 300));
      try { await engine.release(); }       catch (_) {}
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _durationTimer?.cancel();
    _firebaseSub?.cancel();
    _countdownTick?.cancel();
    countdownNotifier.dispose();
    try { _engine?.release(); } catch (_) {}
    _engine = null;
    super.dispose();
  }
}