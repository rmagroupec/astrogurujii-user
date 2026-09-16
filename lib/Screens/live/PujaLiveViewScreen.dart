import 'dart:async';
import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../WebServices/HttpServices.dart';

enum _LiveState { connecting, notStarted, live, ended, error }

enum _RitualStepStatus { done, inProgress, upcoming }

class RitualStep {
  final String title;
  final _RitualStepStatus status;
  RitualStep({required this.title, required this.status});

  factory RitualStep.fromMap(Map data) => RitualStep(
        title: data['title']?.toString() ?? '',
        status: switch (data['status']?.toString()) {
          'done' => _RitualStepStatus.done,
          'in_progress' => _RitualStepStatus.inProgress,
          _ => _RitualStepStatus.upcoming,
        },
      );
}

class PujaLiveViewScreen extends StatefulWidget {
  final String pujaId;
  final String pujaTitle;
  final String pujaImage;

  const PujaLiveViewScreen({
    Key? key,
    required this.pujaId,
    this.pujaTitle = 'Puja Live',
    this.pujaImage = '',
  }) : super(key: key);

  @override
  State<PujaLiveViewScreen> createState() => _PujaLiveViewScreenState();
}

class _PujaLiveViewScreenState extends State<PujaLiveViewScreen> {
  static const _dbUrl = 'https://astrogurujii-production-default-rtdb.firebaseio.com/';

  final HttpServices _httpServices = HttpServices();

  RtcEngine? _engine;
  int? _remoteUid;
  _LiveState _state = _LiveState.connecting;
  String _errorMessage = '';
  bool _hasEverGoneLive = false;

  String? _appId;
  String? _channelId;
  String? _token;
  DateTime? _tokenExpiryAt;
  Timer? _renewCheckTimer;

  // ── engagement data ────────────────────────────────────────────────────
  String _myId = '';
  String _myName = 'Devotee';

  DatabaseReference get _db =>
      FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: _dbUrl).ref();

  DatabaseReference? _viewerRef;
  StreamSubscription<DatabaseEvent>? _viewerSub;
  int _watchingLive = 0;

  DatabaseReference? _blessingsRef;
  int _blessingsCount = 0;

  DatabaseReference? _ritualRef;
  StreamSubscription<DatabaseEvent>? _ritualSub;
  List<RitualStep> _ritualSteps = [];

  int? _totalDevotees;

  final TextEditingController _blessingCtrl = TextEditingController();
  final FocusNode _blessingFocus = FocusNode();

  String get _shareLink => 'https://vaidikguru.com/puja-live/${widget.pujaId}';

  @override
  void initState() {
    super.initState();
    _loadUser();
    _start();
    _loadDevoteeCount();
  }

  @override
  void dispose() {
    _renewCheckTimer?.cancel();
    _viewerSub?.cancel();
    _ritualSub?.cancel();
    _blessingCtrl.dispose();
    _blessingFocus.dispose();
    _leaveFirebasePresence();
    _teardown();
    super.dispose();
  }

  Future<void> _loadUser() async {
    final p = await SharedPreferences.getInstance();
    _myId = p.getString('id') ?? '';
    _myName = p.getString('name') ?? 'Devotee';
  }

  Future<void> _loadDevoteeCount() async {
    // Reuses the existing puja-details endpoint, which already returns a
    // `participents` count — no new API needed just for this stat.
    final detail = await _httpServices.poojaDetailsApi(widget.pujaId);
    if (mounted && detail?.participents != null) {
      setState(() => _totalDevotees = int.tryParse(detail!.participents.toString()));
    }
  }

  Future<void> _teardown() async {
    try {
      await _engine?.leaveChannel();
      await _engine?.release();
    } catch (e) {
      log('[PujaLive] teardown error: $e');
    }
    _engine = null;
  }

  void _leaveFirebasePresence() {
    if (_myId.isNotEmpty) _viewerRef?.child(_myId).remove();
  }

  void _setState(_LiveState s, {String? error}) {
    if (!mounted) return;
    setState(() {
      _state = s;
      if (error != null) _errorMessage = error;
    });
  }

  // ── Step 1: fetch a fresh join token ────────────────────────────────────
  Future<void> _start() async {
    _setState(_LiveState.connecting);

    final joinInfo = await _httpServices.pujaLiveJoin(widget.pujaId);
    if (!mounted) return;

    if (joinInfo == null) {
      _setState(_LiveState.error, error: 'Could not reach the server. Check your connection.');
      return;
    }

    if (joinInfo['status'] != true) {
      final msg = joinInfo['message']?.toString() ?? '';
      if (msg.toLowerCase().contains('not live') || msg.toLowerCase().contains('not started')) {
        _setState(_LiveState.notStarted);
      } else {
        _setState(_LiveState.error, error: msg.isNotEmpty ? msg : 'Could not join this live puja');
      }
      return;
    }

    _appId     = joinInfo['app_id']?.toString() ?? '';
    _channelId = joinInfo['channel_id']?.toString() ?? '';
    _token     = joinInfo['token']?.toString() ?? '';
    final expiresIn = int.tryParse(joinInfo['expires_in']?.toString() ?? '') ?? 3600;
    _tokenExpiryAt  = DateTime.now().add(Duration(seconds: expiresIn));

    if (_appId!.isEmpty || _channelId!.isEmpty || _token!.isEmpty) {
      _setState(_LiveState.error, error: 'Live stream is not available right now');
      return;
    }

    _initFirebaseEngagement();
    await _initAgoraAndJoin();
  }

  // Viewer count, blessings feed, and ritual sequence all key off the puja's
  // channelId so they stay in sync across every device watching this puja.
  void _initFirebaseEngagement() {
    _viewerRef    = _db.child('PujaLiveViewers').child(_channelId!);
    _blessingsRef = _db.child('PujaBlessings').child(_channelId!);
    _ritualRef    = _db.child('PujaRitualSequence').child(_channelId!);

    if (_myId.isNotEmpty) _viewerRef!.child(_myId).set(true);

    _viewerSub = _viewerRef!.onValue.listen((event) {
      final val = event.snapshot.value;
      if (mounted) setState(() => _watchingLive = (val is Map) ? val.length : 0);
    });

    _blessingsRef!.onValue.listen((event) {
      final val = event.snapshot.value;
      if (mounted) setState(() => _blessingsCount = (val is Map) ? val.length : 0);
    });

    _ritualSub = _ritualRef!.onValue.listen((event) {
      final val = event.snapshot.value;
      if (!mounted) return;
      if (val is Map) {
        final steps = val.values
            .whereType<Map>()
            .map((m) => RitualStep.fromMap(m))
            .toList();
        setState(() => _ritualSteps = steps);
      } else {
        setState(() => _ritualSteps = []);
      }
    });
  }

  // ── Step 2: join as pure audience — no camera/mic publish at all ───────
  Future<void> _initAgoraAndJoin() async {
    try {
      _engine = createAgoraRtcEngine();
      await _engine!.initialize(RtcEngineContext(
        appId         : _appId!,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ));

      _engine!.registerEventHandler(RtcEngineEventHandler(
        onJoinChannelSuccess: (conn, elapsed) {
          log('[PujaLive] ✅ joined channel uid=${conn.localUid}');
          if (!_hasEverGoneLive) _setState(_LiveState.notStarted);
        },
        onUserJoined: (conn, uid, elapsed) {
          log('[PujaLive] 👤 host stream joined uid=$uid');
          _hasEverGoneLive = true;
          if (mounted) setState(() { _remoteUid = uid; _state = _LiveState.live; });
        },
        onUserOffline: (conn, uid, reason) {
          log('[PujaLive] 👤 host stream left uid=$uid reason=$reason');
          if (mounted && uid == _remoteUid) {
            setState(() {
              _remoteUid = null;
              _state = _hasEverGoneLive ? _LiveState.ended : _LiveState.notStarted;
            });
          }
        },
        onTokenPrivilegeWillExpire: (conn, token) async => _renewToken(),
        onError: (code, msg) => log('[PujaLive] ❌ error $code: $msg'),
        onConnectionStateChanged: (conn, state, reason) {
          if (state == ConnectionStateType.connectionStateFailed) {
            _setState(_LiveState.error, error: 'Lost connection to the live stream');
          }
        },
      ));

      await _engine!.setClientRole(role: ClientRoleType.clientRoleAudience);
      await _engine!.enableAudio();
      await _engine!.enableVideo();

      await _engine!.joinChannel(
        token    : _token!,
        channelId: _channelId!,
        uid      : 0,
        options  : const ChannelMediaOptions(
          clientRoleType        : ClientRoleType.clientRoleAudience,
          publishCameraTrack    : false,
          publishMicrophoneTrack: false,
          autoSubscribeVideo    : true,
          autoSubscribeAudio    : true,
        ),
      );

      _startRenewWatcher();
    } catch (e) {
      log('[PujaLive] ❌ join failed: $e');
      _setState(_LiveState.error, error: 'Failed to connect to the live stream');
    }
  }

  void _startRenewWatcher() {
    _renewCheckTimer?.cancel();
    _renewCheckTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (_tokenExpiryAt == null) return;
      if (_tokenExpiryAt!.difference(DateTime.now()).inSeconds <= 60) _renewToken();
    });
  }

  Future<void> _renewToken() async {
    final joinInfo = await _httpServices.pujaLiveJoin(widget.pujaId);
    if (joinInfo == null || joinInfo['status'] != true) return;
    final newToken = joinInfo['token']?.toString() ?? '';
    final expiresIn = int.tryParse(joinInfo['expires_in']?.toString() ?? '') ?? 3600;
    if (newToken.isEmpty) return;
    try {
      await _engine?.renewToken(newToken);
      _token = newToken;
      _tokenExpiryAt = DateTime.now().add(Duration(seconds: expiresIn));
    } catch (e) {
      log('[PujaLive] ❌ renewToken failed: $e');
    }
  }

  Future<void> _retry() async {
    await _teardown();
    _hasEverGoneLive = false;
    await _start();
  }

  Future<void> _leave() async {
    _leaveFirebasePresence();
    await _teardown();
    if (mounted) Navigator.pop(context);
  }

  Future<void> _sendBlessing() async {
    final text = _blessingCtrl.text.trim();
    if (text.isEmpty || _blessingsRef == null) return;
    _blessingCtrl.clear();
    _blessingFocus.unfocus();
    final ref = _blessingsRef!.push();
    await ref.set({
      'name'      : _myName,
      'message'   : text,
      'date_time' : DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<void> _copyLink() async {
    await Clipboard.setData(ClipboardData(text: _shareLink));
    Fluttertoast.showToast(msg: 'Link copied to clipboard');
  }

  Future<void> _shareOnWhatsApp() async {
    final text = Uri.encodeComponent('🙏 Join this sacred puja live: $_shareLink');
    final url = Uri.parse('https://wa.me/?text=$text');
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Could not open WhatsApp');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async { await _leave2(); return false; },
      child: Scaffold(
        backgroundColor: const Color(0xFF120A08),
        body: SafeArea(
          child: Column(children: [
            _topBar(),
            Expanded(child: _buildBody()),
          ]),
        ),
      ),
    );
  }

  // WillPopScope needs a bool return but we want _leave()'s async cleanup —
  // this wrapper runs it then lets the pop happen via _leave()'s own Navigator.pop.
  Future<void> _leave2() async {
    await _leave();
  }

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(children: [
        GestureDetector(
          onTap: _leave,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(50)),
            child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(
          widget.pujaTitle,
          maxLines: 1, overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        )),
        if (_state == _LiveState.live)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(20)),
            child: Row(mainAxisSize: MainAxisSize.min, children: const [
              Icon(Icons.circle, color: Colors.white, size: 7),
              SizedBox(width: 4),
              Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
            ]),
          ),
      ]),
    );
  }

  Widget _buildBody() {
    switch (_state) {
      case _LiveState.connecting:
        return _statusScreen(icon: const CircularProgressIndicator(color: Colors.orange), title: 'Connecting…');
      case _LiveState.notStarted:
        return _statusScreen(
          icon: const Icon(Icons.schedule_rounded, color: Colors.white54, size: 56),
          title: 'Puja hasn\'t started yet',
          subtitle: 'This screen updates automatically the moment it goes live.',
          showRefresh: true,
        );
      case _LiveState.ended:
        return _statusScreen(
          icon: const Icon(Icons.stop_circle_outlined, color: Colors.white54, size: 56),
          title: 'Live video has stopped',
          subtitle: 'The broadcast may resume shortly, or the puja may have ended.',
          showRefresh: true,
        );
      case _LiveState.error:
        return _statusScreen(
          icon: const Icon(Icons.error_outline, color: Colors.redAccent, size: 56),
          title: 'Something went wrong',
          subtitle: _errorMessage,
          showRefresh: true,
        );
      case _LiveState.live:
        return _liveContent();
    }
  }

  // ── Full engaged-viewer layout, once the stream is actually live ───────
  Widget _liveContent() {
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        AspectRatio(
          aspectRatio: 16 / 10,
          child: (_remoteUid == null || _engine == null)
              ? const Center(child: CircularProgressIndicator(color: Colors.orange))
              : AgoraVideoView(
                  controller: VideoViewController.remote(
                    rtcEngine : _engine!,
                    canvas    : VideoCanvas(uid: _remoteUid),
                    connection: RtcConnection(channelId: _channelId!),
                  ),
                ),
        ),
        const SizedBox(height: 14),
        if (_ritualSteps.isNotEmpty) _ritualSequenceCard(),
        const SizedBox(height: 14),
        _sendBlessingsCard(),
        const SizedBox(height: 14),
        _shareCard(),
        const SizedBox(height: 14),
        _statsCard(),
      ],
    );
  }

  // ── Ritual Sequence ──────────────────────────────────────────────────────
  Widget _ritualSequenceCard() {
    return _sectionCard(
      title: 'Ritual Sequence',
      icon: Icons.format_list_bulleted_rounded,
      child: Column(
        children: _ritualSteps.map((step) {
          final isDone   = step.status == _RitualStepStatus.done;
          final isActive = step.status == _RitualStepStatus.inProgress;
          final color = isDone ? Colors.green
              : isActive ? Colors.orange
              : Colors.white38;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(children: [
              Icon(
                isDone ? Icons.check_circle : isActive ? Icons.play_circle_fill : Icons.radio_button_unchecked,
                color: color, size: 18,
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(
                step.title,
                style: TextStyle(
                  color: isActive ? Colors.orange : Colors.white70,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  fontSize: 13.5,
                ),
              )),
              if (isActive)
                const Text('in progress', style: TextStyle(color: Colors.orange, fontSize: 11)),
            ]),
          );
        }).toList(),
      ),
    );
  }

  // ── Send Blessings (live comments) ──────────────────────────────────────
  Widget _sendBlessingsCard() {
    return _sectionCard(
      title: 'Send Blessings',
      icon: Icons.volunteer_activism_rounded,
      child: Column(children: [
        if (_blessingsRef != null)
          SizedBox(
            height: 180,
            child: FirebaseAnimatedList(
              query  : _blessingsRef!.orderByChild('date_time').limitToLast(50),
              reverse: true,
              itemBuilder: (_, snap, __, ___) {
                final raw = snap.value;
                if (raw == null) return const SizedBox.shrink();
                final data = Map<String, dynamic>.from(raw as Map);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: RichText(text: TextSpan(children: [
                    TextSpan(
                      text: '${data['name'] ?? 'Devotee'}  ',
                      style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    TextSpan(
                      text: data['message']?.toString() ?? '',
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ])),
                );
              },
            ),
          ),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
                color: Colors.white10, borderRadius: BorderRadius.circular(24)),
            child: TextField(
              controller: _blessingCtrl,
              focusNode : _blessingFocus,
              style     : const TextStyle(color: Colors.white, fontSize: 13.5),
              decoration: const InputDecoration(
                hintText : 'Send a blessing…',
                hintStyle: TextStyle(color: Colors.white38),
                border   : InputBorder.none,
                isDense  : true,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
              onSubmitted: (_) => _sendBlessing(),
            ),
          )),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _sendBlessing,
            child: Container(
              padding: const EdgeInsets.all(11),
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.orange),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
            ),
          ),
        ]),
      ]),
    );
  }

  // ── Share This Pooja ─────────────────────────────────────────────────────
  Widget _shareCard() {
    return _sectionCard(
      title: 'Share This Pooja',
      icon: Icons.ios_share_rounded,
      child: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(10)),
          child: Row(children: [
            Expanded(child: Text(
              _shareLink,
              maxLines: 1, overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white60, fontSize: 12.5),
            )),
            GestureDetector(
              onTap: _copyLink,
              child: const Row(children: [
                Icon(Icons.copy_rounded, color: Colors.orange, size: 15),
                SizedBox(width: 4),
                Text('Copy', style: TextStyle(color: Colors.orange, fontSize: 12.5, fontWeight: FontWeight.w600)),
              ]),
            ),
          ]),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _shareOnWhatsApp,
            icon : const Icon(Icons.whatshot_rounded, size: 0), // placeholder, replaced below
            label: const Text('Share on WhatsApp', style: TextStyle(fontWeight: FontWeight.w600)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF25D366),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 13),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
      ]),
    );
  }

  // ── Trust / social-proof stats row ──────────────────────────────────────
  Widget _statsCard() {
    return _sectionCard(
      title: null,
      icon: null,
      child: Column(children: [
        Row(children: [
          Expanded(child: _statItem(Icons.groups_rounded, '$_watchingLive', 'WATCHING LIVE')),
          Expanded(child: _statItem(Icons.favorite_rounded, '$_blessingsCount', 'BLESSINGS SENT')),
        ]),
        const SizedBox(height: 18),
        Row(children: [
          Expanded(child: _statItem(
              Icons.emoji_people_rounded,
              _totalDevotees != null ? '$_totalDevotees' : '—',
              'TOTAL DEVOTEES')),
          Expanded(child: _statItem(Icons.verified_user_rounded, '100%', 'SACRED & SECURE')),
        ]),
      ]),
    );
  }

  Widget _statItem(IconData icon, String value, String label) {
    return Column(children: [
      Icon(icon, color: Colors.orange, size: 22),
      const SizedBox(height: 6),
      Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
      const SizedBox(height: 2),
      Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10, letterSpacing: 0.5)),
    ]);
  }

  Widget _sectionCard({required String? title, required IconData? icon, required Widget child}) {
    return Container(
      margin : const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (title != null) ...[
          Row(children: [
            Icon(icon, color: Colors.orange, size: 16),
            const SizedBox(width: 6),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 12),
        ],
        child,
      ]),
    );
  }

  Widget _statusScreen({
    required Widget icon,
    required String title,
    String? subtitle,
    bool showRefresh = false,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          if (widget.pujaImage.isNotEmpty) ...[
            ClipOval(child: Image.network(widget.pujaImage, width: 84, height: 84, fit: BoxFit.cover)),
            const SizedBox(height: 20),
          ],
          icon,
          const SizedBox(height: 16),
          Text(title, textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600)),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(subtitle, textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white54, fontSize: 13, height: 1.4)),
          ],
          if (showRefresh) ...[
            const SizedBox(height: 22),
            OutlinedButton.icon(
              onPressed: _retry,
              icon : const Icon(Icons.refresh, color: Colors.white70, size: 18),
              label: const Text('Refresh', style: TextStyle(color: Colors.white70)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white24),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
            ),
          ],
        ]),
      ),
    );
  }
}