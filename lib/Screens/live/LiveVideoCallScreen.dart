// lib/Screens/live/LiveVideoCallScreen.dart
//
// ══════════════════════════════════════════════════════════════════════════════
// USER SIDE — Complete Live Stream Screen
//
// FIXES in this version:
// 1. CHAT FIX: textTobeSend now actually sends — onFieldSubmitted & send button
//    both call _sendChatMessage() which pushes to GroupLive/<channelName>/<pushId>
// 2. WALLET COUNTDOWN: Private call uses Firebase CallSession/<privateChannelId>
//    with the same 3-tier countdown formula as audio/video calls
// 3. PRIVATE CALL FLOW: call_initiate API → pending Firebase node →
//    astrologer accepts → join private Agora channel (Communication, audio only)
//    → server debits wallet per minute via CallSession
// 4. END CALL: sends call_status_update "end_user" to stop billing
// 5. MIC TOGGLE works on private engine, not public engine
// ══════════════════════════════════════════════════════════════════════════════

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:astro_gurujii/Screens/Models/AstroDetailsModel.dart';
import 'package:astro_gurujii/Screens/Models/GetGiftModel.dart';
import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Screens/live/components/chat_streem.dart';
import 'package:astro_gurujii/Screens/live/components/gift_bottm_sheet.dart';
import 'package:astro_gurujii/Screens/liveAsgtrologerLisitngScreen.dart';
import 'package:astro_gurujii/Screens/video_call/Controllers/agora_controller.dart';
import 'package:astro_gurujii/Screens/video_call/Helpers/utils.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:astro_gurujii/Setup/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum _PCState { none, requesting, active }

class LiveVideoCallScreen extends StatefulWidget {
  final String? screenType;
  final String? channelName;
  final String? astrologerId;
  final String? astrologerName;
  final String? astrologerImage;
  final String? id;
  final List<String>? numberOfuserJoin;
  final String? profile;

  const LiveVideoCallScreen({
    Key? key,
    this.channelName,
    this.id,
    this.astrologerId,
    this.astrologerName,
    this.astrologerImage,
    this.numberOfuserJoin,
    this.screenType,
    this.profile,
  }) : super(key: key);

  @override
  State<LiveVideoCallScreen> createState() => _LiveVideoCallScreenState();
}

class _LiveVideoCallScreenState extends State<LiveVideoCallScreen> {
  static const _appId   = '8782e154141a4c0bbc8acaa3004d21f2';
  static const _dbUrl   = 'https://astrogurujii-production-default-rtdb.firebaseio.com/';
  static const _baseUrl = 'https://admin.astrogurujii.com/';

  // ── Agora public stream ───────────────────────────────────────────────────
  late RtcEngine _engine;
  bool _engineReady        = false;
  int? _remoteUid;
  bool _remoteVideoDecoding = false;

  final AgoraController agoraController = Get.put(AgoraController());
  final HttpServices    _httpService    = HttpServices();

  // ── Astro details ─────────────────────────────────────────────────────────
  List<Results> _astroDetails = [];

  bool get _isFollowing =>
      _astroDetails.isNotEmpty &&
      _astroDetails[0].is_Follow.toString() == '1';

  String get _perMinRate {
    if (_astroDetails.isEmpty) return '';
    final offer = _astroDetails[0].per_min_voice_call_offer?.toString() ?? '';
    final base  = _astroDetails[0].perMinVoiceCall?.toString()          ?? '';
    if (offer.isNotEmpty && offer != '0' && offer != 'null') return '₹$offer/min';
    if (base.isNotEmpty  && base  != '0' && base  != 'null') return '₹$base/min';
    return 'Free';
  }

  // ── Firebase ──────────────────────────────────────────────────────────────
  DatabaseReference? _viewerRef;
  late DatabaseReference messageChatReference;
  DatabaseReference? _privateCallRef;
  int _myUid = 0;

  // ── Chat controllers ──────────────────────────────────────────────────────
  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController textTobeSend          = TextEditingController();
  final ScrollController      listScrollController  = ScrollController();
  final FocusNode             focusNode             = FocusNode();

  List<Data> dataGifts = [];

  // ── Private call ──────────────────────────────────────────────────────────
  _PCState   _pcState          = _PCState.none;
  String     _privateChannelId = '';
  String     _privateToken     = '';
  RtcEngine? _privateEngine;
  bool       _privateMicMuted  = false;

  // Wallet countdown (synced with Firebase CallSession)
  int    _secondsRemaining = 0;
  Timer? _countdownTick;
  StreamSubscription<DatabaseEvent>? _sessionSub;

  StreamSubscription<DatabaseEvent>? _privateCallSub;

  String _authToken = '';
  String _myId      = '';
  String _myName    = '';

  // ── Lifecycle ─────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _loadPrefs().then((_) {
      _initFirebase();
      _initAgoraRTC();
      _loadGifts();
      _loadAstroDetails();
      if (widget.screenType == 'home')  _joinLive(widget.id);
      if (widget.screenType == 'pooja') _joinPooja(widget.id);
    });
  }

  @override
  void dispose() {
    _countdownTick?.cancel();
    _privateCallSub?.cancel();
    _sessionSub?.cancel();
    textEditingController.dispose();
    textTobeSend.dispose();
    focusNode.dispose();
    listScrollController.dispose();
    _viewerRef?.child(_myUid.toString()).remove();
    try { _engine.leaveChannel(); } catch (_) {}
    try { _engine.stopPreview();  } catch (_) {}
    try { _engine.release();      } catch (_) {}
    _releasePrivateEngine();
    super.dispose();
  }

  Future<void> _loadPrefs() async {
    final p = await SharedPreferences.getInstance();
    _authToken = p.getString('token') ?? '';
    _myId      = p.getString('id')    ?? '';
    _myName    = p.getString('name')  ?? 'User';
  }

  Future<void> _loadAstroDetails() async {
    if (widget.astrologerId == null) return;
    final res = await _httpService.astrologer_details(id: widget.astrologerId!);
    if (res?.status == true && mounted) {
      setState(() => _astroDetails = res!.results ?? []);
    }
  }

  void _initFirebase() {
    final db = FirebaseDatabase.instanceFor(
        app: Firebase.app(), databaseURL: _dbUrl).ref();

    // ✅ CHAT FIX: path = GroupLive/<channelName>
    // ChatStreem listens on messageChatReference.orderByChild("date_time")
    // _sendChatMessage() pushes directly here → both read & write paths match
    messageChatReference = db.child('GroupLive').child(widget.channelName ?? '');
    _viewerRef           = db.child('LiveViewers').child(widget.channelName ?? '');
    _privateCallRef      = db.child('LivePrivateCall').child(widget.channelName ?? '');

    _viewerRef!.child(_myUid.toString()).set(true);
    _privateCallSub = _privateCallRef!.onValue.listen(_onPrivateCallSnapshot);
  }

  void _loadGifts() async {
    final res = await _httpService.getGiftsListing();
    if (res?.status == true && mounted) setState(() => dataGifts = res!.data!);
  }

  Future<void> _joinLive(id) async {
    final res = await _httpService.joinLiveAstrologerApi(id);
    if (res?.status != true) Fluttertoast.showToast(msg: res?.message ?? '');
  }

  Future<void> _joinPooja(id) async {
    final res = await _httpService.joinLiveForPoojaApi(id);
    if (res?.status != true) Fluttertoast.showToast(msg: res?.message ?? '');
  }

  // ── Agora public stream ───────────────────────────────────────────────────
  Future<void> _initAgoraRTC() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(appId: getAgoraAppId()));

    _engine.registerEventHandler(RtcEngineEventHandler(
      onError: (code, msg) => log('Agora error $code: $msg'),
      onJoinChannelSuccess: (conn, elapsed) {
        _myUid = conn.localUid ?? 0;
        _viewerRef?.child(_myUid.toString()).set(true);
        if (mounted) setState(() => _engineReady = true);
      },
      onUserJoined: (conn, uid, elapsed) {
        agoraController.startMeetingTimer();
        if (mounted) setState(() { _remoteUid = uid; _remoteVideoDecoding = true; });
      },
      onRemoteVideoStateChanged: (conn, uid, state, reason, elapsed) {
        final decoding = state == RemoteVideoState.remoteVideoStateDecoding ||
                         state == RemoteVideoState.remoteVideoStateStarting;
        if (mounted) setState(() {
          if (decoding) { _remoteUid = uid; _remoteVideoDecoding = true; }
          else if (uid == _remoteUid) { _remoteVideoDecoding = false; }
        });
      },
      onUserOffline: (conn, uid, reason) {
        if (mounted) setState(() { _remoteUid = null; _remoteVideoDecoding = false; });
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted && _remoteUid == null) Navigator.pop(context);
        });
      },
      onLeaveChannel: (conn, stats) {
        if (mounted) setState(() { _remoteUid = null; _remoteVideoDecoding = false; });
      },
    ));

    await _engine.setChannelProfile(ChannelProfileType.channelProfileLiveBroadcasting);
    await _engine.setClientRole(
      role   : ClientRoleType.clientRoleAudience,
      options: const ClientRoleOptions(
        audienceLatencyLevel: AudienceLatencyLevelType.audienceLatencyLevelLowLatency,
      ),
    );
    await _engine.enableVideo();
    await _engine.startPreview();

    final token = await _fetchAgoraToken(widget.channelName ?? '');
    await _engine.joinChannel(
      token    : token,
      channelId: widget.channelName ?? '',
      uid      : 0,
      options  : const ChannelMediaOptions(
        publishCameraTrack    : false,
        publishMicrophoneTrack: false,
        clientRoleType        : ClientRoleType.clientRoleAudience,
        autoSubscribeVideo    : true,
        autoSubscribeAudio    : true,
      ),
    );
  }

  Future<String> _fetchAgoraToken(String channelId) async {
    try {
      final resp = await http.post(
        Uri.parse('${_baseUrl}user_api/agora_token'),
        headers: {
          'Content-Type' : 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
        body: jsonEncode({'channel_id': channelId}),
      );
      if (resp.statusCode == 200) {
        final body = jsonDecode(resp.body);
        if (body['status'] == true) return body['token'] as String? ?? '';
      }
    } catch (e) { log('agora_token error: $e'); }
    return '';
  }

  // ── Chat send ─────────────────────────────────────────────────────────────
  // ✅ FIX: push directly to messageChatReference (GroupLive/<channelName>)
  Future<void> _sendChatMessage(String content) async {
    final text = content.trim();
    if (text.isEmpty) return;

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final pushRef   = messageChatReference.push();

    await pushRef.set({
      'date'      : '',
      'from'      : _myId,
      'message'   : text,
      'message_id': pushRef.key,
      'date_time' : timestamp,
      'name'      : _myName,
      'time'      : '',
    });

    textTobeSend.clear();
  }

  // ── Follow / Unfollow ─────────────────────────────────────────────────────
  Future<void> _toggleFollow() async {
    final res = await _httpService.follow_astro(id: widget.astrologerId ?? '');
    if (res?.status == true) {
      Fluttertoast.showToast(msg: res!.message ?? '');
      _loadAstroDetails();
    } else {
      Fluttertoast.showToast(msg: res?.message ?? '');
    }
  }

  // ── Leave stream ──────────────────────────────────────────────────────────
  void _leaveStream() {
    _viewerRef?.child(_myUid.toString()).remove();
    if (_pcState == _PCState.active)     _endPrivateCall();
    if (_pcState == _PCState.requesting) _cancelRequest();
    try { _engine.leaveChannel(); } catch (_) {}
    try { _engine.stopPreview();  } catch (_) {}
    try { _engine.release();      } catch (_) {}
    Navigator.pop(context);
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  PRIVATE CALL
  // ══════════════════════════════════════════════════════════════════════════

  void _onPhoneTap() {
    if (_pcState == _PCState.none)       _showPrivateCallModal();
    if (_pcState == _PCState.requesting) _cancelRequest();
    if (_pcState == _PCState.active)     _endPrivateCall();
  }

  void _showPrivateCallModal() {
    final sw = MediaQuery.of(context).size.width;
    showModalBottomSheet(
      context: context, backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A2E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: EdgeInsets.fromLTRB(sw * 0.06, 16, sw * 0.06, 36),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4,
              decoration: BoxDecoration(color: Colors.white24,
                  borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 24),
          CircleAvatar(
            radius: sw * 0.10,
            backgroundImage: (widget.astrologerImage?.isNotEmpty ?? false)
                ? NetworkImage(widget.astrologerImage!) : null,
            backgroundColor: Colors.white12,
            child: (widget.astrologerImage?.isEmpty ?? true)
                ? Icon(Icons.person, size: sw * 0.10, color: Colors.white38) : null,
          ),
          const SizedBox(height: 14),
          Text(widget.astrologerName ?? 'Astrologer',
              style: const TextStyle(color: Colors.white,
                  fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(color: Colors.white10,
                borderRadius: BorderRadius.circular(20)),
            child: const Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.lock_outline, color: Colors.orangeAccent, size: 15),
              SizedBox(width: 6),
              Text('Private Audio Call',
                  style: TextStyle(color: Colors.white70, fontSize: 13)),
            ]),
          ),
          const SizedBox(height: 16),
          const Text(
            'Connect privately with the astrologer.\nOther viewers will not hear your conversation.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54, fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 28),
          Row(children: [
            Expanded(child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white24),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text('Cancel',
                  style: TextStyle(color: Colors.white70, fontSize: 15)),
            )),
            const SizedBox(width: 14),
            Expanded(child: ElevatedButton(
              onPressed: () { Navigator.pop(context); _initiateCall(); },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.call_rounded, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text('Connect', style: TextStyle(color: Colors.white,
                    fontSize: 15, fontWeight: FontWeight.bold)),
              ]),
            )),
          ]),
        ]),
      ),
    );
  }

  // Step 1: call_initiate API → write pending node to Firebase
  Future<void> _initiateCall() async {
    if (widget.astrologerId == null) return;
    if (mounted) setState(() => _pcState = _PCState.requesting);

    try {
      // Use existing call_initiate API — same as audio call
      final resp = await http.post(
        Uri.parse('${_baseUrl}user_api/call_initiate'),
        headers: {
          'Content-Type' : 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
        body: jsonEncode({
          'astrologer_id': widget.astrologerId,
          'call_type'    : 'audio',              // audio-only private call
          'fb_channel_id': '${_myId}_${widget.astrologerId}_${DateTime.now().millisecondsSinceEpoch}',
        }),
      );

      if (resp.statusCode != 200) throw Exception('HTTP ${resp.statusCode}');
      final body = jsonDecode(resp.body);

      if (body['status'] != true) {
        Fluttertoast.showToast(msg: body['message'] ?? 'Call initiation failed');
        if (mounted) setState(() => _pcState = _PCState.none);
        return;
      }

      // Store the private channel details returned by the server
      _privateChannelId = body['channel_id']   as String? ?? '';
      _privateToken     = body['agora_token']   as String? ?? '';

      if (_privateChannelId.isEmpty) {
        if (mounted) setState(() => _pcState = _PCState.none);
        return;
      }

      // Write pending node → astrologer app will listen and show the popup
      await _privateCallRef!.set({
        'status'    : 'pending',
        'channel_id': _privateChannelId,
        'user_id'   : _myId,
        'user_name' : _myName,
        'timestamp' : DateTime.now().millisecondsSinceEpoch,
      });

      log('[Private] Request sent → $_privateChannelId');
    } catch (e) {
      log('[Private] _initiateCall error: $e');
      Fluttertoast.showToast(msg: 'Failed to request call');
      if (mounted) setState(() => _pcState = _PCState.none);
    }
  }

  // Firebase listener — fires when astrologer accepts / rejects / ends
  void _onPrivateCallSnapshot(DatabaseEvent event) {
    if (!mounted) return;
    if (event.snapshot.value == null) {
      if (_pcState == _PCState.active) _onCallEndedByAstro();
      return;
    }
    final data   = Map<String, dynamic>.from(event.snapshot.value as Map);
    final status = data['status'] as String? ?? '';

    if (status == 'accepted' && _pcState == _PCState.requesting) {
      _onCallAccepted();
    } else if (status == 'rejected' && _pcState == _PCState.requesting) {
      Fluttertoast.showToast(msg: 'Call declined by astrologer');
      if (mounted) setState(() { _pcState = _PCState.none; _privateChannelId = ''; });
    } else if ((status == 'ended' || status == 'end_astro') &&
               _pcState == _PCState.active) {
      _onCallEndedByAstro();
    }
  }

  // Step 2: astrologer accepted → join private Agora channel + start wallet countdown
  Future<void> _onCallAccepted() async {
    if (mounted) setState(() => _pcState = _PCState.active);

    // Join private audio channel (Communication profile, broadcaster so two-way audio)
    _privateEngine = createAgoraRtcEngine();
    await _privateEngine!.initialize(RtcEngineContext(appId: getAgoraAppId()));
    await _privateEngine!.setChannelProfile(
        ChannelProfileType.channelProfileCommunication);
    await _privateEngine!.enableAudio();
    await _privateEngine!.disableVideo();
    await _privateEngine!.setDefaultAudioRouteToSpeakerphone(true);
    await _privateEngine!.setEnableSpeakerphone(true);

    _privateEngine!.registerEventHandler(RtcEngineEventHandler(
      onJoinChannelSuccess: (conn, _) =>
          log('[Private] ✅ Joined ${conn.localUid}'),
      onUserOffline: (conn, uid, _) {
        // Astrologer left the private channel → end from our side too
        _onCallEndedByAstro();
      },
      onError: (code, msg) => log('[Private] ❌ $code $msg'),
    ));

    await _privateEngine!.joinChannel(
      token    : _privateToken,
      channelId: _privateChannelId,
      uid      : 1,
      options  : const ChannelMediaOptions(
        publishMicrophoneTrack: true,
        publishCameraTrack    : false,
        clientRoleType        : ClientRoleType.clientRoleBroadcaster,
        autoSubscribeAudio    : true,
        autoSubscribeVideo    : false,
      ),
    );

    // ── Wallet countdown — same 3-tier Firebase formula as audio/video calls ──
    _startWalletCountdown();

    Fluttertoast.showToast(msg: '🔒 Private call connected');
  }

  // ── 3-tier wallet countdown (mirrors CountdownManager) ───────────────────
  void _startWalletCountdown() {
    _sessionSub?.cancel();
    _countdownTick?.cancel();

    final ref = FirebaseDatabase.instanceFor(
      app: Firebase.app(), databaseURL: _dbUrl,
    ).ref().child('CallSession').child(_privateChannelId);

    // Local 1 Hz tick — immediately gives smooth UI countdown
    _countdownTick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _countdownTick?.cancel();
          _endPrivateCall();
        }
      });
    });

    // Firebase sync — server is the source of truth, drift-correct if > 10 s off
    _sessionSub = ref.onValue.listen((event) {
      if (!mounted || event.snapshot.value == null) return;
      final data   = Map<String, dynamic>.from(event.snapshot.value as Map);
      final status = data['status'] as String? ?? '';

      // Server ended the call (wallet empty / astrologer ended)
      if (['end_astro', 'end_user', 'wallet_empty'].contains(status)) {
        _onCallEndedByAstro();
        return;
      }

      // Compute server-accurate seconds (3-tier)
      final accurate = _computeAccurateSecs(data);
      if (accurate == null) return;

      // Drift-correct only if more than 10 s off
      if ((_secondsRemaining - accurate).abs() > 10) {
        if (mounted) setState(() => _secondsRemaining = accurate);
      }
    });
  }

  // Mirrors the same formula used in AudioCallScreen / CountdownManager
  int? _computeAccurateSecs(Map<String, dynamic> data) {
    final nowMs    = DateTime.now().millisecondsSinceEpoch;
    final rawMax   = data['max_minutes'];
    final rawLast  = data['last_tick_at'];
    final rawStart = data['started_at'];

    // Tier 1: max_minutes + last_tick_at (most common after first server debit)
    if (rawMax != null) {
      final maxSec = (int.tryParse(rawMax.toString()) ?? 0) * 60;
      if (rawLast != null) {
        final elapsed = ((nowMs - (int.tryParse(rawLast.toString()) ?? nowMs)) / 1000).floor();
        return (maxSec - elapsed).clamp(0, maxSec);
      }
      return maxSec;
    }

    // Tier 2: started_at (before first debit tick)
    if (rawStart != null) {
      final elapsed = ((nowMs - (int.tryParse(rawStart.toString()) ?? nowMs)) / 1000).floor();
      // Fall back to current countdown if no rate info
      return (_secondsRemaining - elapsed).clamp(0, _secondsRemaining);
    }

    return null;
  }

  void _onCallEndedByAstro() {
    Fluttertoast.showToast(msg: 'Private call ended');
    _cleanupPrivateCall();
    if (mounted) setState(() { _pcState = _PCState.none; _secondsRemaining = 0; });
  }

  Future<void> _endPrivateCall() async {
    _countdownTick?.cancel();
    _sessionSub?.cancel();

    if (_privateChannelId.isNotEmpty) {
      // Tell server to stop billing
      try {
        await http.post(
          Uri.parse('${_baseUrl}user_api/call_status_update'),
          headers: {
            'Content-Type' : 'application/json',
            'Authorization': 'Bearer $_authToken',
          },
          body: jsonEncode({
            'channel_id': _privateChannelId,
            'status'    : 'end_user',
          }),
        );
      } catch (_) {}

      // Update Firebase so astrologer knows too
      _privateCallRef?.update({'status': 'ended'});
    }

    _cleanupPrivateCall();
    if (mounted) setState(() { _pcState = _PCState.none; _secondsRemaining = 0; });
  }

  Future<void> _cancelRequest() async {
    if (_privateChannelId.isNotEmpty) {
      try {
        await http.post(
          Uri.parse('${_baseUrl}user_api/call_status_update'),
          headers: {
            'Content-Type' : 'application/json',
            'Authorization': 'Bearer $_authToken',
          },
          body: jsonEncode({
            'channel_id': _privateChannelId,
            'status'    : 'reject_user',
          }),
        );
      } catch (_) {}
      _privateCallRef?.remove();
    }
    if (mounted) setState(() { _pcState = _PCState.none; _privateChannelId = ''; });
  }

  void _cleanupPrivateCall() {
    _releasePrivateEngine();
    _privateChannelId = '';
    _privateMicMuted  = false;
  }

  Future<void> _togglePrivateMic() async {
    _privateMicMuted = !_privateMicMuted;
    await _privateEngine?.muteLocalAudioStream(_privateMicMuted);
    if (mounted) setState(() {});
  }

  void _releasePrivateEngine() {
    try { _privateEngine?.leaveChannel(); } catch (_) {}
    try { _privateEngine?.release();      } catch (_) {}
    _privateEngine = null;
  }

  String get _countdownLabel {
    final m = _secondsRemaining ~/ 60;
    final s = _secondsRemaining % 60;
    return '${m.toString().padLeft(2, '0')} m ${s.toString().padLeft(2, '0')} s';
  }

  // ── Bottom sheets ─────────────────────────────────────────────────────────
  void _showWaitlistSheet() {
    showModalBottomSheet(
      context: context, backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _WaitlistSheet(
        astroName: widget.astrologerName ?? '',
        astroImg : widget.astrologerImage ?? '',
        users    : widget.numberOfuserJoin ?? [],
        onJoin   : () {
          Navigator.pop(context);
          Fluttertoast.showToast(msg: 'You have joined the waitlist!');
        },
      ),
    );
  }

  void _showJoinCallSheet() {
    showModalBottomSheet(
      context: context, backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _JoinCallSheet(
        astroName : widget.astrologerName ?? '',
        astroImg  : widget.astrologerImage ?? '',
        perMinRate: _perMinRate,
        onJoin    : () => Navigator.pop(context),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  BUILD
  // ══════════════════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final mq  = MediaQuery.of(context);
    final sw  = mq.size.width;
    final sh  = mq.size.height;
    final top = mq.padding.top;
    final isPrivateActive = _pcState == _PCState.active;
    final isRequesting    = _pcState == _PCState.requesting;
    final waitCount       = widget.numberOfuserJoin?.length ?? 0;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: true,
        body: Stack(children: [

          // ── Layer 1: Live video ──────────────────────────────────────────
          Positioned.fill(
            child: _engineReady && _remoteVideoDecoding && _remoteUid != null
                ? AgoraVideoView(
                    controller: VideoViewController.remote(
                      rtcEngine : _engine,
                      canvas    : VideoCanvas(uid: _remoteUid!),
                      connection: RtcConnection(channelId: widget.channelName ?? ''),
                    ),
                  )
                : _WaitingOverlay(
                    image: widget.astrologerImage,
                    name : widget.astrologerName,
                  ),
          ),

          // ── Layer 2: Top gradient ────────────────────────────────────────
          Positioned(
            top: 0, left: 0, right: 0, height: sh * 0.28,
            child: Container(decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin : Alignment.topCenter,
                end   : Alignment.bottomCenter,
                colors: [Colors.black87, Colors.transparent],
              ),
            )),
          ),

          // ── Layer 3: Bottom gradient ─────────────────────────────────────
          Positioned(
            bottom: 0, left: 0, right: 0, height: sh * 0.55,
            child: Container(decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin : Alignment.bottomCenter,
                end   : Alignment.topCenter,
                colors: [Colors.black, Colors.transparent],
              ),
            )),
          ),

          // ── Layer 4: Top bar ─────────────────────────────────────────────
          Positioned(
            top: top + 12, left: sw * 0.03, right: sw * 0.03,
            child: Row(children: [

              // Host pill
              Expanded(child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: sw * 0.025, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.45),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white12),
                ),
                child: Row(children: [
                  CircleAvatar(
                    radius: sw * 0.038,
                    backgroundImage: (widget.astrologerImage?.isNotEmpty ?? false)
                        ? NetworkImage(widget.astrologerImage!) : null,
                    backgroundColor: Colors.white12,
                    child: (widget.astrologerImage?.isEmpty ?? true)
                        ? const Icon(Icons.person,
                            color: Colors.white54, size: 16) : null,
                  ),
                  SizedBox(width: sw * 0.02),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(widget.astrologerName ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white,
                              fontSize: sw * 0.034,
                              fontWeight: FontWeight.bold)),
                      if (isPrivateActive)
                        Text('& Private',
                            style: TextStyle(color: Colors.white70,
                                fontSize: sw * 0.026)),
                    ],
                  )),
                  _SignalBars(),
                ]),
              )),

              SizedBox(width: sw * 0.015),

              _TopBtn(icon: Icons.grid_view_rounded,
                  onTap: () => Navigator.push(context, MaterialPageRoute(
                      builder: (_) => LiveAstroLogersScreen()))),

              SizedBox(width: sw * 0.015),

              // Follow button (real state from server)
              GestureDetector(
                onTap: _toggleFollow,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 7),
                  decoration: BoxDecoration(
                    gradient: _isFollowing ? null : const LinearGradient(
                      colors: [Color(0xFFDD9750), Color(0xFFEE4262)],
                      begin : Alignment.topCenter,
                      end   : Alignment.bottomCenter,
                    ),
                    color       : _isFollowing ? Colors.white24 : null,
                    borderRadius: BorderRadius.circular(20),
                    border      : _isFollowing
                        ? Border.all(color: Colors.white38) : null,
                  ),
                  child: Text(
                    _isFollowing ? 'Following' : 'Follow',
                    style: TextStyle(color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: sw * 0.030),
                  ),
                ),
              ),

              SizedBox(width: sw * 0.015),
              _TopBtn(icon: Icons.close_rounded, onTap: _leaveStream),
            ]),
          ),

          // ── Layer 4b: Second row — badges ────────────────────────────────
          Positioned(
            top: top + 72, left: sw * 0.03,
            child: Row(children: [

              // Active private call badge + timer + mic + end
              if (isPrivateActive) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.65),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                        color: Colors.orange.withOpacity(0.5)),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.lock_rounded,
                        color: Colors.orange, size: 14),
                    const SizedBox(width: 6),
                    Text(_countdownLabel,
                        style: const TextStyle(color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: _togglePrivateMic,
                      child: Icon(
                        _privateMicMuted ? Icons.mic_off : Icons.mic,
                        color: _privateMicMuted
                            ? Colors.red : Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: _endPrivateCall,
                      child: const Icon(Icons.call_end_rounded,
                          color: Colors.red, size: 16),
                    ),
                  ]),
                ),
                SizedBox(width: sw * 0.02),
              ],

              // Requesting badge
              if (isRequesting) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                        color: Colors.orange.withOpacity(0.5)),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const SizedBox(width: 12, height: 12,
                        child: CircularProgressIndicator(
                            color: Colors.orange, strokeWidth: 2)),
                    const SizedBox(width: 8),
                    const Text('Waiting for astrologer...',
                        style: TextStyle(color: Colors.orange,
                            fontSize: 12)),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _cancelRequest,
                      child: const Icon(Icons.close,
                          color: Colors.white54, size: 14),
                    ),
                  ]),
                ),
              ],

              // Idle: waitlist + per-min chip
              if (!isPrivateActive && !isRequesting) ...[
                GestureDetector(
                  onTap: _showWaitlistSheet,
                  child: Stack(clipBehavior: Clip.none, children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.50),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: const Icon(Icons.hourglass_bottom_rounded,
                          color: Colors.white, size: 17),
                    ),
                    if (waitCount > 0)
                      Positioned(
                        top: -4, right: -4,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle),
                          child: Text('$waitCount',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                  ]),
                ),
                SizedBox(width: sw * 0.02),

                if (_perMinRate.isNotEmpty)
                  GestureDetector(
                    onTap: _showJoinCallSheet,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.50),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.call_rounded,
                            color: Colors.orangeAccent, size: 13),
                        const SizedBox(width: 5),
                        Text(_perMinRate,
                            style: const TextStyle(color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600)),
                      ]),
                    ),
                  ),
              ],
            ]),
          ),

          // ── Layer 5: Bottom section ──────────────────────────────────────
          Positioned(
            bottom: 0, left: 0, right: 0,
            height: sh * 0.52,
            child: _BottomSection(
              sw           : sw,
              sh           : sh,
              bot          : mq.padding.bottom,
              channelName  : widget.channelName   ?? '',
              screenType   : widget.screenType    ?? '',
              liveId       : widget.id?.toString() ?? '',
              astroId      : widget.astrologerId  ?? '',
              dataGifts    : dataGifts,
              messageChatRef      : messageChatReference,
              pcState      : _pcState,
              onPhoneTap   : _onPhoneTap,
              textController      : textTobeSend,
              focusNode    : focusNode,
              listController      : listScrollController,
              textEditingController: textEditingController,
              onSendMessage: _sendChatMessage,   // ✅ wired to real send
            ),
          ),
        ]),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
//  BOTTOM SECTION
// ══════════════════════════════════════════════════════════════════════════════
class _BottomSection extends StatelessWidget {
  final double sw, sh, bot;
  final String channelName, screenType, liveId, astroId;
  final List<Data> dataGifts;
  final DatabaseReference messageChatRef;
  final _PCState pcState;
  final VoidCallback onPhoneTap;
  final TextEditingController textController;
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final ScrollController listController;
  final ValueChanged<String> onSendMessage;   // ✅ callback for real send

  const _BottomSection({
    required this.sw, required this.sh, required this.bot,
    required this.channelName, required this.screenType,
    required this.liveId, required this.astroId,
    required this.dataGifts, required this.messageChatRef,
    required this.pcState, required this.onPhoneTap,
    required this.textController, required this.focusNode,
    required this.listController, required this.textEditingController,
    required this.onSendMessage,
  });

  @override
  Widget build(BuildContext context) {
    const inputH = 52.0;
    return Stack(children: [

      // Left: Gift button + chat stream
      Positioned(
        left: sw * 0.03, right: sw * 0.22, bottom: inputH + 8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize      : MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => GiftBottomSheets.showGistBottomSheet(
                screenType: screenType, id: liveId,
                context: context, dataGifts: dataGifts, astroId: astroId,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 9),
                decoration: BoxDecoration(color: Colors.white,
                    borderRadius: BorderRadius.circular(30)),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.card_giftcard, color: Colors.black87, size: 16),
                  SizedBox(width: 6),
                  Text('Send Gift', style: TextStyle(color: Colors.black87,
                      fontWeight: FontWeight.w600, fontSize: 13)),
                ]),
              ),
            ),
            const SizedBox(height: 10),
            ChatStreem(
              textEditingController: textEditingController,
              listScrollController : listController,
              focusNode            : focusNode,
              messageChatReference : messageChatRef,
              channelName          : channelName,
            ),
          ],
        ),
      ),

      // Right icon rail
      Positioned(
        right: sw * 0.02, bottom: inputH + 8,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          _RailIcon(
            icon : Icons.near_me_outlined,
            faded: true,
            onTap: () => Share.share(
                'https://play.google.com/store/apps/details?id=com.user.astrogurujii'),
          ),
          const SizedBox(height: 14),
          _RailIcon(
            icon : Icons.card_giftcard,
            onTap: () => GiftBottomSheets.showGistBottomSheet(
              screenType: screenType, id: liveId,
              context: context, dataGifts: dataGifts, astroId: astroId,
            ),
          ),
          const SizedBox(height: 14),

          // Phone icon → private call
          GestureDetector(
            onTap: onPhoneTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 38, height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: pcState == _PCState.active
                    ? Colors.red.withOpacity(0.25)
                    : pcState == _PCState.requesting
                        ? Colors.orange.withOpacity(0.25)
                        : Colors.white.withOpacity(0.22),
                border: Border.all(
                  color: pcState == _PCState.active ? Colors.red
                      : pcState == _PCState.requesting
                          ? Colors.orange : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Icon(
                pcState == _PCState.active
                    ? Icons.call_end_rounded
                    : pcState == _PCState.requesting
                        ? Icons.hourglass_empty_rounded : Icons.call,
                color: pcState == _PCState.active ? Colors.red
                    : pcState == _PCState.requesting
                        ? Colors.orange : Colors.white,
                size: 18,
              ),
            ),
          ),
        ]),
      ),

      // ✅ CHAT FIX: input bar now calls onSendMessage
      Positioned(
        left: 0, right: 0, bottom: 0,
        child: Container(
          height: inputH,
          padding: EdgeInsets.symmetric(horizontal: sw * 0.03, vertical: 8),
          color: Colors.black.withOpacity(0.30),
          child: Row(children: [
            Expanded(child: Container(
              padding: EdgeInsets.symmetric(horizontal: sw * 0.04),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30)),
              child: TextFormField(
                maxLines: 1,
                controller: textController,
                focusNode : focusNode,
                style: const TextStyle(color: Colors.black, fontSize: 14),
                decoration: const InputDecoration(
                  hintText       : 'Say hi...',
                  border         : InputBorder.none,
                  focusedBorder  : InputBorder.none,
                  enabledBorder  : InputBorder.none,
                  hintStyle      : TextStyle(color: Colors.black54, fontSize: 14),
                ),
                textInputAction: TextInputAction.send,
                // ✅ onFieldSubmitted actually sends now
                onFieldSubmitted: (val) => onSendMessage(val),
              ),
            )),
            SizedBox(width: sw * 0.025),
            InkWell(
              // ✅ Send button actually sends now
              onTap: () => onSendMessage(textController.text),
              child: Container(
                padding: const EdgeInsets.all(9),
                decoration: const BoxDecoration(
                    color: Colors.blue, shape: BoxShape.circle),
                child: Icon(Icons.send, color: Colors.white, size: sw / 19),
              ),
            ),
          ]),
        ),
      ),
    ]);
  }
}

// ══════════════════════════════════════════════════════════════════════════════
//  WAITLIST SHEET  (unchanged)
// ══════════════════════════════════════════════════════════════════════════════
class _WaitlistSheet extends StatelessWidget {
  final String astroName, astroImg;
  final List<String> users;
  final VoidCallback onJoin;
  const _WaitlistSheet({required this.astroName, required this.astroImg,
      required this.users, required this.onJoin});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 40, height: 4,
            decoration: BoxDecoration(color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: 20),
        Row(children: [
          CircleAvatar(
            radius: 26,
            backgroundImage: astroImg.isNotEmpty ? NetworkImage(astroImg) : null,
            backgroundColor: Colors.orange.shade50,
            child: astroImg.isEmpty
                ? Text(astroName.isNotEmpty ? astroName[0].toUpperCase() : 'A',
                    style: const TextStyle(color: Colors.orange,
                        fontWeight: FontWeight.bold, fontSize: 20)) : null,
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(astroName, style: const TextStyle(fontWeight: FontWeight.bold,
                fontSize: 16, color: Colors.black87)),
            const SizedBox(height: 3),
            Text('Waiting List · ${users.length} in queue',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
          ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(20)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.hourglass_bottom_rounded,
                  color: Colors.orange, size: 14),
              const SizedBox(width: 4),
              Text('${users.length}', style: const TextStyle(color: Colors.orange,
                  fontWeight: FontWeight.bold, fontSize: 14)),
            ]),
          ),
        ]),
        const SizedBox(height: 18),
        Divider(color: Colors.grey.shade100),
        const SizedBox(height: 14),
        if (users.isNotEmpty) ...[
          Align(alignment: Alignment.centerLeft,
              child: Text('People in queue',
                  style: TextStyle(color: Colors.grey.shade600,
                      fontSize: 12, fontWeight: FontWeight.w500))),
          const SizedBox(height: 12),
          SizedBox(
            height: 64,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: users.length,
              itemBuilder: (_, i) => Container(
                margin: const EdgeInsets.only(right: 10),
                child: Column(children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.primaries[i % Colors.primaries.length]
                        .withOpacity(0.18),
                    child: Text('${i + 1}',
                        style: TextStyle(
                          color: Colors.primaries[i % Colors.primaries.length],
                          fontWeight: FontWeight.bold, fontSize: 14,
                        )),
                  ),
                  const SizedBox(height: 4),
                  Text('#${i + 1}',
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 9)),
                ]),
              ),
            ),
          ),
          const SizedBox(height: 18),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              Icon(Icons.info_outline, color: Colors.grey.shade400, size: 18),
              const SizedBox(width: 10),
              Text('No one waiting — be the first!',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
            ]),
          ),
          const SizedBox(height: 18),
        ],
        SizedBox(
          width: double.infinity, height: 52,
          child: ElevatedButton(
            onPressed: onJoin,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orangeColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
            child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.queue_rounded, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text('Join Waitlist', style: TextStyle(color: Colors.white,
                  fontSize: 15, fontWeight: FontWeight.bold)),
            ]),
          ),
        ),
      ]),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
//  JOIN CALL SHEET  (unchanged)
// ══════════════════════════════════════════════════════════════════════════════
class _JoinCallSheet extends StatelessWidget {
  final String astroName, astroImg, perMinRate;
  final VoidCallback onJoin;
  const _JoinCallSheet({required this.astroName, required this.astroImg,
      required this.perMinRate, required this.onJoin});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 40, height: 4,
            decoration: BoxDecoration(color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: 22),
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Stack(children: [
            Container(
              decoration: BoxDecoration(shape: BoxShape.circle,
                  border: Border.all(color: Colors.red, width: 2.5)),
              child: CircleAvatar(
                radius: 38,
                backgroundImage: astroImg.isNotEmpty ? NetworkImage(astroImg) : null,
                backgroundColor: Colors.orange.shade50,
                child: astroImg.isEmpty
                    ? Text(astroName.isNotEmpty ? astroName[0].toUpperCase() : 'A',
                        style: const TextStyle(color: Colors.orange,
                            fontWeight: FontWeight.bold, fontSize: 26)) : null,
              ),
            ),
            Positioned(bottom: 2, right: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(color: Colors.red,
                    borderRadius: BorderRadius.circular(10)),
                child: const Text('LIVE', style: TextStyle(color: Colors.white,
                    fontSize: 7, fontWeight: FontWeight.bold)),
              ),
            ),
          ]),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(astroName, style: const TextStyle(fontWeight: FontWeight.bold,
                fontSize: 18, color: Colors.black87)),
            const SizedBox(height: 4),
            const Text('Live Now', style: TextStyle(color: Colors.red,
                fontSize: 12, fontWeight: FontWeight.w500)),
          ])),
        ]),
        const SizedBox(height: 24),
        Divider(color: Colors.grey.shade100),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.orange.shade100)),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.orange.withOpacity(0.15),
                  shape: BoxShape.circle),
              child: const Icon(Icons.call_rounded, color: Colors.orange, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Private Audio Call Rate',
                  style: TextStyle(fontWeight: FontWeight.bold,
                      color: Colors.black87, fontSize: 14)),
              const SizedBox(height: 4),
              Text(perMinRate, style: const TextStyle(color: Colors.orange,
                  fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text('Charged only during private call',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
            ])),
          ]),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12)),
          child: Row(children: [
            const Icon(Icons.lock_outline, color: Colors.grey, size: 16),
            const SizedBox(width: 10),
            Expanded(child: Text(
              'Tap the 📞 phone icon during the live stream to start a private audio call.',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            )),
          ]),
        ),
        const SizedBox(height: 22),
        SizedBox(
          width: double.infinity, height: 54,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFFDD9750), Color(0xFFEE4262)]),
              borderRadius: BorderRadius.circular(14),
            ),
            child: ElevatedButton(
              onPressed: onJoin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor    : Colors.transparent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.play_circle_filled_rounded,
                    color: Colors.white, size: 22),
                SizedBox(width: 10),
                Text('Continue Watching',
                    style: TextStyle(color: Colors.white,
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ]),
            ),
          ),
        ),
      ]),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
//  Small helper widgets
// ══════════════════════════════════════════════════════════════════════════════

class _WaitingOverlay extends StatelessWidget {
  final String? image; final String? name;
  const _WaitingOverlay({this.image, this.name});
  @override
  Widget build(BuildContext context) => Container(
    color: Colors.black,
    child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
      CircleAvatar(
        radius: 60,
        backgroundImage: (image?.isNotEmpty ?? false)
            ? NetworkImage(image!) : null,
        backgroundColor: Colors.white12,
        child: (image?.isEmpty ?? true)
            ? const Icon(Icons.person, size: 60, color: Colors.white38) : null,
      ),
      const SizedBox(height: 16),
      Text(name ?? '', style: const TextStyle(color: Colors.white70,
          fontSize: 18, fontWeight: FontWeight.w500)),
      const SizedBox(height: 16),
      const SizedBox(width: 28, height: 28,
          child: CircularProgressIndicator(
              color: Colors.orange, strokeWidth: 2.5)),
      const SizedBox(height: 10),
      const Text('Connecting to live...',
          style: TextStyle(color: Colors.white38, fontSize: 13)),
    ])),
  );
}

class _TopBtn extends StatelessWidget {
  final IconData icon; final VoidCallback onTap;
  const _TopBtn({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.40),
          borderRadius: BorderRadius.circular(50)),
      child: Icon(icon, color: Colors.white, size: 20),
    ),
  );
}

class _SignalBars extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [4.0, 7.0, 10.0, 13.0].map((h) => Container(
      width: 3, height: h, margin: const EdgeInsets.only(right: 1.5),
      decoration: BoxDecoration(color: Colors.white,
          borderRadius: BorderRadius.circular(1)),
    )).toList(),
  );
}

class _RailIcon extends StatelessWidget {
  final IconData icon; final VoidCallback onTap; final bool faded;
  const _RailIcon({required this.icon, required this.onTap, this.faded = false});
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap, borderRadius: BorderRadius.circular(20),
    child: Container(
      width: 38, height: 38,
      decoration: BoxDecoration(
          color : Colors.white.withOpacity(faded ? 0.12 : 0.22),
          shape : BoxShape.circle),
      child: Icon(icon,
          color: Colors.white.withOpacity(faded ? 0.6 : 1), size: 18),
    ),
  );
}