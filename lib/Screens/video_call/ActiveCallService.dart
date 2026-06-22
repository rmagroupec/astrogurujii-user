// lib/Screens/video_call/ActiveCallService.dart
//
// Flutter equivalent of the web AudioCallContext + Agora client ref.
//
// WEB PATTERN (React):
//   - AudioCallContext holds Agora IAgoraRTCClient in a ref
//   - minimize() just navigates back — does NOT leave channel
//   - Returning to screen: reads existing client from context, no re-join
//
// FLUTTER PROBLEM:
//   - AfterCallConnecting.dispose() releases the Agora engine
//   - New screen instance must re-joinChannel → requires fresh token
//   - Token fetch + join introduces delay → shows "Connecting" again
//
// FLUTTER SOLUTION (this file):
//   - ActiveCallService singleton holds the RtcEngine
//   - AfterCallConnecting uses this service instead of creating its own engine
//   - On minimize (back press): engine stays alive in service
//   - On return: screen re-wires event handlers, does NOT re-join
//   - Engine is only released when call truly ends (end_user / end_astro)
//
// USAGE:
//   // Start call (first time):
//   await ActiveCallService.instance.initAndJoin(channelId, token, onUserJoined, onUserOffline);
//
//   // Minimize (back from screen — DON'T call dispose on screen):
//   ActiveCallService.instance.minimize();
//
//   // Return to screen:
//   ActiveCallService.instance.rewire(onUserJoined, onUserOffline, onError);
//
//   // End call:
//   await ActiveCallService.instance.endCall();

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
  bool       _isActive  = false;  // true while call is live
  String     _channelId = '';

  // ── Connected remote users ─────────────────────────────────────────────────
  final List<int> remoteUsers = [];

  // ── Callbacks — rewired each time screen mounts ────────────────────────────
  OnJoinSuccess?  _onJoinSuccess;
  OnRemoteJoined? _onRemoteJoined;
  OnRemoteLeft?   _onRemoteLeft;
  OnCallError?    _onError;

  // ── Public getters ─────────────────────────────────────────────────────────
  RtcEngine? get engine    => _engine;
  bool       get isActive  => _isActive;
  bool       get isJoined  => _joined;
  String     get channelId => _channelId;
  bool       get hasRemoteUser => remoteUsers.isNotEmpty;

  // ─────────────────────────────────────────────────────────────────────────
  // initAndJoin — called ONCE when call first starts
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> initAndJoin({
    required String         channelId,
    required String         token,
    required OnRemoteJoined onRemoteJoined,
    required OnRemoteLeft   onRemoteLeft,
    OnJoinSuccess?          onJoinSuccess,
    OnCallError?            onError,
    int                     uid = 2,
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

    // Clean up any previous session
    await _release();

    _channelId      = channelId;
    _isActive       = true;
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
    // Re-register handlers with updated callbacks
    _registerHandlers();
    debugPrint('[ActiveCallService] 🔄 callbacks re-wired for $channelId');
  }

  // ─────────────────────────────────────────────────────────────────────────
  // minimize — called when user presses back to go to home screen
  // Engine stays alive — DO NOT call endCall() or release()
  // ─────────────────────────────────────────────────────────────────────────
  void minimize() {
    debugPrint('[ActiveCallService] ⬇ minimized — engine stays alive');
    // Nothing to do — engine continues running
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
  // endCall — called when call truly ends (user pressed end / server ended)
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> endCall() async {
    debugPrint('[ActiveCallService] 🔴 ending call $channelId');
    _isActive = false;
    await _release();
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
    _engine  = null;
    _joined  = false;
    _channelId = '';
    remoteUsers.clear();

    if (engine != null) {
      try { await engine.leaveChannel(); } catch (_) {}
      await Future.delayed(const Duration(milliseconds: 200));
      try { await engine.release(); }     catch (_) {}
    }
  }
}