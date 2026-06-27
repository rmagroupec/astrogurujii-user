// lib/Screens/video_call/ActiveCallService.dart
//
// Singleton that keeps the Agora RtcEngine alive while the call screen is
// minimized so that returning via the FAB does NOT trigger a re-join
// (which previously caused "Connecting" to flash).
//
// TWO USAGE PATTERNS:
//
// A) Service-managed (original): service creates and owns the engine.
//      await ActiveCallService.instance.initAndJoin(...);
//      ActiveCallService.instance.minimize();   // on back press
//      ActiveCallService.instance.rewire(...);  // on screen return
//      await ActiveCallService.instance.endCall();
//
// B) Screen-managed (new — used by AudioCallScreen & NewVideoCallScreen):
//    The screen creates the engine itself (existing code unchanged).
//    After joinChannel succeeds, the screen registers it here:
//      ActiveCallService.instance.trackExternalEngine(engine, channelId, ...);
//    On minimize, the screen sets _engineHandedOff = true so dispose() skips release.
//    On screen return, the rewire path is used — no re-join needed.
//      ActiveCallService.instance.rewire(...);
//    On true call end:
//      await ActiveCallService.instance.endCall();

import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';

typedef OnRemoteJoined  = void Function(int uid);
typedef OnRemoteLeft    = void Function(int uid);
typedef OnCallError     = void Function(ErrorCodeType code, String msg);
typedef OnJoinSuccess   = void Function();

class ActiveCallService {
  ActiveCallService._();
  static final ActiveCallService instance = ActiveCallService._();

  static const _appId = '8782e154141a4c0bbc8acaa3004d21f2';

  // ── Engine ─────────────────────────────────────────────────────────────────
  RtcEngine? _engine;
  bool       _joined    = false;
  bool       _isActive  = false;
  String     _channelId = '';

  // ── Whether we own the engine (true) or it's screen-managed (false) ────────
  bool _ownsEngine = true;

  // ── Connected remote users ─────────────────────────────────────────────────
  final List<int> remoteUsers = [];

  // ── Callbacks — rewired each time screen mounts ────────────────────────────
  OnJoinSuccess?  _onJoinSuccess;
  OnRemoteJoined? _onRemoteJoined;
  OnRemoteLeft?   _onRemoteLeft;
  OnCallError?    _onError;

  // ── Public getters ─────────────────────────────────────────────────────────
  RtcEngine? get engine       => _engine;
  bool       get isActive     => _isActive;
  bool       get isJoined     => _joined;
  String     get channelId    => _channelId;
  bool       get hasRemoteUser => remoteUsers.isNotEmpty;

  // ─────────────────────────────────────────────────────────────────────────
  // initAndJoin — called ONCE when call first starts (pattern A)
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> initAndJoin({
    required String         channelId,
    required String         token,
    required OnRemoteJoined onRemoteJoined,
    required OnRemoteLeft   onRemoteLeft,
    OnJoinSuccess?          onJoinSuccess,
    OnCallError?            onError,
    int                     uid = 1,
  }) async {
    // If already active on same channel, just rewire
    if (_isActive && _channelId == channelId && _engine != null) {
      debugPrint('[ActiveCallService] Already active on $channelId — rewiring only');
      rewire(
        onRemoteJoined: onRemoteJoined,
        onRemoteLeft  : onRemoteLeft,
        onJoinSuccess : onJoinSuccess,
        onError       : onError,
      );
      return;
    }

    await _release();

    _channelId      = channelId;
    _isActive       = true;
    _ownsEngine     = true;
    _onRemoteJoined = onRemoteJoined;
    _onRemoteLeft   = onRemoteLeft;
    _onJoinSuccess  = onJoinSuccess;
    _onError        = onError;
    remoteUsers.clear();

    _engine = createAgoraRtcEngine();
    await _engine!.initialize(RtcEngineContext(appId: _appId));
    await _engine!.enableAudio();

    _registerHandlers();

    await _engine!.enableWebSdkInteroperability(true);

    try {
      await _engine!.joinChannel(
        token    : token,
        channelId: channelId,
        uid      : uid,
        options  : const ChannelMediaOptions(),
      );
      _joined = true;
      debugPrint('[ActiveCallService] ✅ joined $channelId as uid=$uid');
    } on AgoraRtcException catch (e) {
      if (e.code == -17) {
        debugPrint('[ActiveCallService] ⚠️ -17 already in channel — ignoring');
        _joined = true;
      } else {
        debugPrint('[ActiveCallService] ❌ joinChannel failed: ${e.code}');
        _onError?.call(ErrorCodeType.values.firstWhere(
          (v) => v.value() == e.code,
          orElse: () => ErrorCodeType.errFailed,
        ), e.message ?? '');
      }
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // trackExternalEngine — pattern B
  // Called by AudioCallScreen / NewVideoCallScreen AFTER they have already
  // created their own engine and called joinChannel successfully.
  // The service takes a reference so that minimize/rewire work, but does NOT
  // release/destroy this engine (the screen still owns it for the call end).
  // ─────────────────────────────────────────────────────────────────────────
  void trackExternalEngine({
    required RtcEngine      engine,
    required String         channelId,
    required OnRemoteJoined onRemoteJoined,
    required OnRemoteLeft   onRemoteLeft,
    OnJoinSuccess?          onJoinSuccess,
    OnCallError?            onError,
  }) {
    _engine         = engine;
    _channelId      = channelId;
    _isActive       = true;
    _joined         = true;
    _ownsEngine     = false; // screen manages engine lifecycle
    _onRemoteJoined = onRemoteJoined;
    _onRemoteLeft   = onRemoteLeft;
    _onJoinSuccess  = onJoinSuccess;
    _onError        = onError;
    remoteUsers.clear();
    debugPrint('[ActiveCallService] 📌 tracking external engine for $channelId');
  }

  // ─────────────────────────────────────────────────────────────────────────
  // rewire — called when screen re-mounts (return from minimize)
  // Does NOT re-join. Just re-attaches the callbacks.
  // ─────────────────────────────────────────────────────────────────────────
  void rewire({
    required OnRemoteJoined onRemoteJoined,
    required OnRemoteLeft   onRemoteLeft,
    OnJoinSuccess?          onJoinSuccess,
    OnCallError?            onError,
  }) {
    _onRemoteJoined = onRemoteJoined;
    _onRemoteLeft   = onRemoteLeft;
    _onJoinSuccess  = onJoinSuccess;
    _onError        = onError;
    _registerHandlers();
    debugPrint('[ActiveCallService] 🔄 callbacks re-wired for $_channelId');
  }

  // ─────────────────────────────────────────────────────────────────────────
  // minimize — called when user presses back to go to home screen
  // Engine stays alive — DO NOT call endCall() or release()
  // ─────────────────────────────────────────────────────────────────────────
  void minimize() {
    debugPrint('[ActiveCallService] ⬇ minimized — engine stays alive');
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Controls — forwarded to engine
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> muteLocalAudio(bool mute) async {
    await _engine?.muteLocalAudioStream(mute);
  }

  Future<void> setSpeakerphone(bool on) async {
    await _engine?.setEnableSpeakerphone(on);
  }

  Future<void> disableAudio() async {
    await _engine?.disableAudio();
  }

  Future<void> enableAudio() async {
    await _engine?.enableAudio();
  }

  Future<void> muteAllRemote(bool mute) async {
    await _engine?.muteAllRemoteAudioStreams(mute);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // endCall — called when call truly ends
  // For pattern B (external engine), just clears references — the screen
  // still releases the engine in its own dispose().
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> endCall() async {
    debugPrint('[ActiveCallService] 🔴 ending call $_channelId (ownsEngine=$_ownsEngine)');
    _isActive = false;
    if (_ownsEngine) {
      await _release();
    } else {
      // Just clear references; screen will release the engine
      _engine    = null;
      _joined    = false;
      _channelId = '';
      remoteUsers.clear();
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Internal
  // ─────────────────────────────────────────────────────────────────────────
  void _registerHandlers() {
    _engine?.registerEventHandler(RtcEngineEventHandler(
      onJoinChannelSuccess: (conn, elapsed) {
        _joined = true;
        debugPrint('[ActiveCallService] onJoinChannelSuccess uid=${conn.localUid}');
        _onJoinSuccess?.call();
      },
      onUserJoined: (conn, uid, elapsed) {
        debugPrint('[ActiveCallService] 👤 remote joined uid=$uid');
        if (!remoteUsers.contains(uid)) remoteUsers.add(uid);
        _onRemoteJoined?.call(uid);
      },
      onUserOffline: (conn, uid, reason) {
        debugPrint('[ActiveCallService] 👤 remote left uid=$uid');
        remoteUsers.remove(uid);
        _onRemoteLeft?.call(uid);
      },
      onLeaveChannel: (conn, stats) {
        _joined = false;
        remoteUsers.clear();
      },
      onError: (code, msg) {
        debugPrint('[ActiveCallService] ❌ error $code: $msg');
        _onError?.call(code, msg);
      },
    ));
  }

  Future<void> _release() async {
    final engine = _engine;
    _engine    = null;
    _joined    = false;
    _channelId = '';
    remoteUsers.clear();

    if (engine != null && _ownsEngine) {
      try { await engine.leaveChannel(); } catch (_) {}
      await Future.delayed(const Duration(milliseconds: 200));
      try { await engine.release(); }     catch (_) {}
    }
  }
}