// lib/Screens/chats_screen/chat/Chat.dart
//
// ROOT CAUSE OF CHAT NOT CONNECTING:
//
//  1. PATH MISMATCH — gid vs channelId
//     User app was passing:  gid = fbChannelId  (fb_channel_id from API)
//     Astrologer app uses:   groupId = channelId (channel_id from API, NOT fb_channel_id)
//     These are DIFFERENT values. Firebase has no matching data at the paths.
//     FIX: gid must equal channelId (channel_id), same as astrologer.
//
//  2. SINGLE PATH READ — user only saw their own messages
//     rootRef was set to: Group/{gid}/{userId}/{astrologerId}
//     Astrologer writes to: Group/{channelId}/{astrologerId}/{userId}
//     User never read astrologer's messages.
//     FIX: Subscribe BOTH paths, merge + deduplicate by message_id, sort by date_time.
//     Same pattern used by web React ChatScreen (Chatviewonlyscreen.tsx).
//
//  3. BIRTH INFO path also used gid (fbChannelId) instead of channelId.
//     FIX: Use fbchannelID (= channelId from API) consistently as the group root.
//
// HOW TO PASS CORRECT VALUES FROM ChatCallingScreen:
//   Chat(
//     channelID   : fb_channel_id,   // kept for legacy compat
//     fbchannelID : channel_id,       // API channel_id — used for status API + group root
//     gid         : channel_id,       // ← MUST equal fbchannelID (= astrologer's groupId)
//     ...
//   )

import 'dart:async';
import 'dart:io';

import 'package:astro_gurujii/Screens/MyWallet.dart';
import 'package:astro_gurujii/Screens/chats_screen/chat/audio_play_pop_up.dart';
import 'package:astro_gurujii/Screens/chats_screen/chat/count_down_manager.dart';
import 'package:astro_gurujii/Setup/app_colors.dart';
import 'package:astro_gurujii/widget/bottom_navigation_bar_custom.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../WebServices/HttpServices.dart';
import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Screens/chats_screen/image/ImageModel.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../WebviewScreen.dart';
import '../Loading.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Stateless shell
// ─────────────────────────────────────────────────────────────────────────────
class Chat extends StatelessWidget {
  final String? channelID;    // fb_channel_id (legacy)
  final String? fbchannelID;  // channel_id from API — used for status poll + group root
  final String? astrologerId;
  final String? name;
  final String? astroName;
  final String? gid;          // MUST equal fbchannelID (= astrologer's groupId)
  final String? currency;
  final String? astrologerChatRate;
  final String? astrologerImage;
  final String? wallet;
  final String? place;
  final String? dob;
  final String? tob;
  final String? gender;

  const Chat({
    Key? key,
    this.gender,
    this.fbchannelID,
    this.place,
    this.dob,
    this.tob,
    this.channelID,
    this.astrologerId,
    this.name,
    this.astroName,
    this.gid,
    this.currency,
    this.astrologerChatRate,
    this.astrologerImage,
    this.wallet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => MainHomeScreenWithBottomNavigation()),
        );
        return false;
      },
      child: Scaffold(
        body: ChatScreen(
          gender             : gender,
          place              : place,
          dob                : dob,
          tob                : tob,
          channelID          : channelID,
          fbchannelID        : fbchannelID,
          astrologerId       : astrologerId,
          astroName          : astroName,
          name               : name,
          gid                : gid,
          currency           : currency,
          astrologerChatRate : astrologerChatRate,
          astrologerImage    : astrologerImage,
          wallet             : wallet,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ChatScreen StatefulWidget
// ─────────────────────────────────────────────────────────────────────────────
class ChatScreen extends StatefulWidget {
  final String? channelID;
  final String? fbchannelID;
  final String? astrologerId;
  final String? astroName;
  final String? name;
  final String? gid;
  final String? currency;
  final String? astrologerChatRate;
  final String? astrologerImage;
  final String? wallet;
  final String? place;
  final String? dob;
  final String? tob;
  final String? gender;

  const ChatScreen({
    Key? key,
    this.gender,
    this.place,
    this.dob,
    this.tob,
    this.channelID,
    this.fbchannelID,
    this.astrologerId,
    this.astroName,
    this.name,
    this.gid,
    this.currency,
    this.astrologerChatRate,
    this.astrologerImage,
    this.wallet,
  }) : super(key: key);

  @override
  State createState() => _ChatScreenState();
}

// ─────────────────────────────────────────────────────────────────────────────
// State
// ─────────────────────────────────────────────────────────────────────────────
class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {

  static const _dbUrl =
      'https://astrogurujii-production-default-rtdb.firebaseio.com/';

  DatabaseReference get _firebaseRef => FirebaseDatabase.instanceFor(
        app        : Firebase.app(),
        databaseURL: _dbUrl,
      ).ref();

  // ── FIX 1: The group root key MUST be the API channel_id (= astrologer's groupId)
  //    gid passed from ChatCallingScreen should already be = fbchannelID = channel_id
  String get _groupRoot => widget.gid ?? widget.fbchannelID ?? '';

  // ── Firebase paths ───────────────────────────────────────────────────────
  // User's own read path (messages sent by user, received by astrologer)
  DatabaseReference? _userToAstroRef;
  // Astrologer's write path (messages sent by astrologer, received by user)
  DatabaseReference? _astroToUserRef;

  StreamSubscription<DatabaseEvent>? _userSub;
  StreamSubscription<DatabaseEvent>? _astroSub;

  // Merged message map: messageId → data  (deduplicates both paths)
  final Map<String, Map<String, dynamic>> _messageMap = {};
  List<Map<String, dynamic>> _messages = [];

  SharedPreferences? prefs;
  String? id;

  // ── Countdown ─────────────────────────────────────────────────────────────
  late final CountdownManager countdownManager;

  // ── Timers ────────────────────────────────────────────────────────────────
  Timer? _pollTimer;
  Timer? _recordingTimer;

  // ── UI state ──────────────────────────────────────────────────────────────
  double ratingPoint        = 0.0;
  bool   iscallActive       = false;
  bool   showRechargeOption = false;
  bool   showLowRecharge    = false;
  bool   _ratingDialogShown = false;

  // ── Recording ─────────────────────────────────────────────────────────────
  bool                  _isRecording = false;
  bool                  newRecording = false;
  int                   _elapsedTime = 0;
  FlutterSoundPlayer    _audioPlayer = FlutterSoundPlayer();
  FlutterSoundPlayer?   _player;
  FlutterSoundRecorder? _recorder;
  String?               _filePath;

  // ── Animation (mic press) ─────────────────────────────────────────────────
  AnimationController? _controller;
  Animation<double>?   _scaleAnimation;

  // ── Controllers ───────────────────────────────────────────────────────────
  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController reviewControler       = TextEditingController();
  final ScrollController      listScrollController  = ScrollController();
  final FocusNode             focusNode             = FocusNode();

  // ── Services ──────────────────────────────────────────────────────────────
  final HttpServices _httpService  = HttpServices();
  final HttpServices _httpServices = HttpServices();

  // ── Image picker ──────────────────────────────────────────────────────────
  XFile?            _imageFiler;
  final ImagePicker _picker = ImagePicker();

  String userimage =
      'https://admin.astropush.com/images/i/user_d.jpg';

  Size?   _size;
  double? _height, _width;

  // ═══════════════════════════════════════════════════════════════════════════
  // initState
  // ═══════════════════════════════════════════════════════════════════════════
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync   : this,
    );
    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 2.0).animate(_controller!);

    countdownManager = CountdownManager();
    countdownManager.timeLeftNotifier.addListener(_onTimeLeftChanged);
    countdownManager.statusNotifier.addListener(_onServerStatusChange);

    final walletInt = int.tryParse(widget.wallet ?? '0') ?? 0;
    final rateInt   = int.tryParse(widget.astrologerChatRate ?? '1') ?? 1;
    countdownManager.start(
      channelId    : widget.fbchannelID!,
      initialWallet: walletInt,
      perMinCharge : rateInt,
    );

    _pollTimer = Timer.periodic(
      const Duration(seconds: 2),
      (_) => _checkForNewStatus(),
    );

    focusNode.addListener(_onFocusChange);
    _initializeRecorder();
    _getProfile();
    _readLocalAndSubscribe();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // dispose
  // ═══════════════════════════════════════════════════════════════════════════
  @override
  void dispose() {
    _pollTimer?.cancel();
    _recordingTimer?.cancel();

    countdownManager.timeLeftNotifier.removeListener(_onTimeLeftChanged);
    countdownManager.statusNotifier.removeListener(_onServerStatusChange);
    countdownManager.dispose();

    _userSub?.cancel();
    _astroSub?.cancel();

    textEditingController.dispose();
    reviewControler.dispose();
    listScrollController.dispose();
    focusNode.dispose();

    _audioPlayer.closePlayer();
    _player?.closePlayer();
    _recorder?.closeRecorder();
    _controller?.dispose();

    super.dispose();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // FIX 2: Subscribe BOTH Firebase paths and merge messages
  // ═══════════════════════════════════════════════════════════════════════════
  Future<void> _readLocalAndSubscribe() async {
    prefs = await SharedPreferences.getInstance();
    id    = prefs!.getString('id') ?? '';

    if (_groupRoot.isEmpty || id!.isEmpty || widget.astrologerId == null) {
      debugPrint('[Chat] ⚠️ Cannot subscribe — missing groupRoot/userId/astrologerId');
      debugPrint('[Chat] groupRoot=$_groupRoot userId=$id astrologerId=${widget.astrologerId}');
      return;
    }

    debugPrint('[Chat] Subscribing paths:');
    debugPrint('[Chat]   user→astro: Group/$_groupRoot/$id/${widget.astrologerId}');
    debugPrint('[Chat]   astro→user: Group/$_groupRoot/${widget.astrologerId}/$id');

    // Path 1: messages sent by user (user is from, astrologer is to)
    _userToAstroRef = _firebaseRef
        .child('Group')
        .child(_groupRoot)
        .child(id!)
        .child(widget.astrologerId!);

    // Path 2: messages sent by astrologer (astrologer is from, user is to)
    _astroToUserRef = _firebaseRef
        .child('Group')
        .child(_groupRoot)
        .child(widget.astrologerId!)
        .child(id!);

    _userSub = _userToAstroRef!.onValue.listen((event) {
      _mergeSnapshot(event.snapshot, source: 'user');
    });

    _astroSub = _astroToUserRef!.onValue.listen((event) {
      _mergeSnapshot(event.snapshot, source: 'astro');
    });

    // Send birth info once
    await _sendBirthInfoOnce();
  }

  void _mergeSnapshot(DataSnapshot snapshot, {required String source}) {
    if (!mounted) return;
    if (snapshot.value == null) return;

    final data = Map<String, dynamic>.from(snapshot.value as Map);
    data.forEach((key, value) {
      if (value is Map) {
        final msg     = Map<String, dynamic>.from(value);
        final msgId   = msg['message_id']?.toString() ?? key;
        _messageMap[msgId] = msg;
      }
    });

    // Sort by date_time ascending
    final sorted = _messageMap.values.toList()
      ..sort((a, b) {
        final at = (a['date_time'] ?? 0) as int;
        final bt = (b['date_time'] ?? 0) as int;
        return at.compareTo(bt);
      });

    setState(() => _messages = sorted);

    // Scroll to bottom after merge
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (listScrollController.hasClients) {
        listScrollController.animateTo(
          listScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve   : Curves.easeOut,
        );
      }
    });
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // FIX 3: Send birth info to correct path (groupRoot = channel_id)
  // ═══════════════════════════════════════════════════════════════════════════
  Future<void> _sendBirthInfoOnce() async {
    if (id == null || widget.astrologerId == null) return;
    if (!(widget.gender?.isNotEmpty ?? false)) return;

    final sentKey     = 'birth_sent_${widget.fbchannelID}';
    final alreadySent = prefs!.getBool(sentKey) ?? false;
    if (alreadySent) return;

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final pushRef   = _userToAstroRef!.push();
    final pushId    = pushRef.key;

    final senderPath   = 'Group/$_groupRoot/$id/${widget.astrologerId}';
    final receiverPath = 'Group/$_groupRoot/${widget.astrologerId}/$id';

    final senderMessage =
        ' Name : ${widget.name}'
        '\n Gender : ${widget.gender}'
        '\n Birth Date : ${widget.dob}'
        '\n Birth Time : ${widget.tob}'
        '\n Birth Location : ${widget.place}';

    final Map<String, dynamic> body = {
      'date'                     : '',
      'from'                     : id,
      'mRecipientOrSenderStatus' : 0,
      'message'                  : senderMessage,
      'message_id'               : pushId,
      'date_time'                : timestamp,
      'name'                     : widget.name,
      'time'                     : '',
      'to'                       : widget.astrologerId,
      'type'                     : 'text',
    };

    await _firebaseRef.update({
      '$senderPath/$pushId'  : body,
      '$receiverPath/$pushId': body,
    });
    await prefs!.setBool(sentKey, true);
    debugPrint('[Chat] ✅ Birth info sent to both paths');
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Send message — writes to BOTH paths
  // ═══════════════════════════════════════════════════════════════════════════
  Future<void> onSendMessage(String? content, int type) async {
    final messageType = type == 1 ? 'image' : type == 3 ? 'audio' : 'text';

    if (content == null || content.trim().isEmpty) {
      Fluttertoast.showToast(
          msg            : 'Nothing to send',
          backgroundColor: Colors.black,
          textColor      : Colors.red);
      return;
    }

    textEditingController.clear();

    if (id == null || id!.isEmpty) {
      prefs = await SharedPreferences.getInstance();
      id    = prefs!.getString('id') ?? '';
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final name      = prefs!.getString('name');

    final senderPath   = 'Group/$_groupRoot/$id/${widget.astrologerId}';
    final receiverPath = 'Group/$_groupRoot/${widget.astrologerId}/$id';

    final pushRef = _userToAstroRef!.push();
    final pushId  = pushRef.key;

    final Map<String, dynamic> body = {
      'date'                     : '',
      'from'                     : id,
      'mRecipientOrSenderStatus' : 0,
      'message'                  : content,
      'message_id'               : pushId,
      'date_time'                : timestamp,
      'name'                     : name,
      'time'                     : '',
      'to'                       : widget.astrologerId,
      'type'                     : messageType,
    };

    await _firebaseRef.update({
      '$senderPath/$pushId'  : body,
      '$receiverPath/$pushId': body,
    });
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Countdown callbacks
  // ═══════════════════════════════════════════════════════════════════════════
  void _onTimeLeftChanged() {
    if (!mounted) return;
    final secs    = countdownManager.timeLeftNotifier.value;
    final minutes = secs ~/ 60;
    setState(() {
      showLowRecharge    = minutes < 5;
      showRechargeOption = minutes < 1;
    });
    if (secs == 0) _endChatWebservice();
  }

  void _onServerStatusChange() {
    final status = countdownManager.statusNotifier.value;
    if (['end_astro', 'end_user', 'wallet_empty'].contains(status)) {
      _cancelTimers();
      _showRatingDialogOnce();
    }
  }

  void _cancelTimers() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  void _showRatingDialogOnce() {
    if (_ratingDialogShown || !mounted) return;
    _ratingDialogShown = true;
    _show(context);
  }

  void _onFocusChange() {
    if (focusNode.hasFocus) setState(() {});
  }

  String _fmt(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds  % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // API calls
  // ═══════════════════════════════════════════════════════════════════════════
  Future<void> _endChatWebservice() async {
    final res = await _httpService.change_connection_request_status(
      channel_id: widget.fbchannelID!,
      status    : 'end_user',
    );
    if (res?.status == true) {
      _cancelTimers();
      _showRatingDialogOnce();
    }
  }

  Future<void> _checkForNewStatus() async {
    final res = await _httpService.call_initiate_status(
        channel_id: widget.fbchannelID!);
    if (!mounted) return;
    final status = res?.results?.status ?? '';
    if (status == 'reject_astro') {
      _pollTimer?.cancel();
      Navigator.pop(context);
    } else if (status == 'end_astro') {
      _cancelTimers();
      _showRatingDialogOnce();
    }
  }

  Future<void> _callAliForRating(double rating, String review) async {
    final res = await _httpService.add_rating(
      channel_id: widget.fbchannelID!,
      rating    : rating.toString(),
      review    : review,
    );
    if (res?.status == true) setState(() { iscallActive = true; });
    else Fluttertoast.showToast(msg: 'Something went wrong');
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (_) => MainHomeScreenWithBottomNavigation()),
      (route) => false,
    );
  }

  void _getProfile() async {
    final res = await _httpServices.profile_api();
    if (!mounted) return;
    if (res?.status == true) setState(() => userimage = res!.results!.profileImg!);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Recording
  // ═══════════════════════════════════════════════════════════════════════════
  Future<void> _initializeRecorder() async {
    _recorder ??= FlutterSoundRecorder();
    await _recorder!.openRecorder();
  }

  Future<bool> _requestMic() async =>
      (await Permission.microphone.request()).isGranted;

  void _startRecordingUi() {
    setState(() { _isRecording = true; newRecording = true; });
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_isRecording) { setState(() => _elapsedTime++); }
      else              { t.cancel(); }
    });
  }

  void _stopRecordingUi() {
    setState(() { _isRecording = false; newRecording = false; _elapsedTime = 0; });
    _recordingTimer?.cancel();
    _recordingTimer = null;
  }

  Future<void> _startRecording() async {
    setState(() => _isRecording = true);
    await AudioPlayer().play(AssetSource('astro/tingsms_c373e6104879406.mp3'));
    await _initializeRecorder();
    final dir = await getApplicationDocumentsDirectory();
    _filePath = '${dir.path}/audio_message.aac';
    await _recorder!.startRecorder(toFile: _filePath, codec: Codec.aacADTS);
    _startRecordingUi();
  }

  Future<void> _stopRecording() async {
    if (_recorder == null || !_isRecording) return;
    await AudioPlayer().play(AssetSource('astro/tingsms_c373e6104879406.mp3'));
    await _recorder?.stopRecorder();
    if (_filePath != null) {
      final res = await _httpServices.mp3_image_update(path: _filePath!);
      if (res?.status == true) {
        await onSendMessage(res?.results, 3);
      } else {
        Fluttertoast.showToast(
            msg: 'Audio upload failed.', backgroundColor: Colors.red);
      }
    }
    _stopRecordingUi();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Image
  // ═══════════════════════════════════════════════════════════════════════════
  void _pickImage(ImageSource source) async {
    try {
      final f = await _picker.pickImage(source: source);
      if (f == null) return;
      setState(() { _imageFiler = f; });
      final res = await _httpServices.chat_image_update(img: f.path);
      if (res?.status == true) {
        await onSendMessage(res?.results, 1);
      } else {
        Fluttertoast.showToast(
            msg: 'Image upload failed.', backgroundColor: Colors.red);
      }
    } catch (_) {
      Fluttertoast.showToast(
          msg: 'An error occurred.', backgroundColor: Colors.red);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    _size   = MediaQuery.of(context).size;
    _height = _size!.height;
    _width  = _size!.width;

    return Stack(
      children: [
        Column(
          children: [
            _buildAppBar(),
            Expanded(child: _buildMessageList()),
            if (iscallActive)
              Padding(
                  padding: const EdgeInsets.all(8),
                  child  : _buildInputRating()),
            if (showRechargeOption) _buildRechargeBanner(),
            if (!iscallActive) _buildInput(),
          ],
        ),
        Positioned.fill(child: _buildLoading()),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // App bar
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildAppBar() {
    return Container(
      decoration: BoxDecoration(
        color     : Colors.white,
        boxShadow : [
          BoxShadow(
            color      : Colors.grey.withOpacity(0.2),
            spreadRadius: 1, blurRadius: 6,
            offset     : const Offset(0, 3),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
          child  : Row(
            children: [
              IconButton(
                icon    : const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) => MainHomeScreenWithBottomNavigation()),
                ),
              ),
              CircleAvatar(
                radius         : 23,
                backgroundImage: CachedNetworkImageProvider(
                    widget.astrologerImage!),
                backgroundColor: Colors.grey.shade200,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment : MainAxisAlignment.center,
                  children: [
                    Text(
                      capitalize(widget.astroName!),
                      style: const TextStyle(
                          color     : Colors.black,
                          fontSize  : 16,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        ValueListenableBuilder<int>(
                          valueListenable: countdownManager.timeLeftNotifier,
                          builder: (_, secs, __) => Text(
                            _fmt(secs),
                            style: TextStyle(
                              color     : showLowRecharge
                                  ? Colors.red
                                  : Colors.grey[600],
                              fontSize  : 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (showLowRecharge)
                          const Text('(Low Balance)',
                              style: TextStyle(
                                  color: Colors.red, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),
              if (!iscallActive)
                GestureDetector(
                  onTap: _confirmEndChat,
                  child: const Icon(Icons.call_end,
                      color: Colors.red, size: 32),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmEndChat() {
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title  : const Text('End Chat'),
        content: const Text('Are you sure you want to end your chat?'),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          InkWell(
            onTap : () => Navigator.pop(ctx, false),
            child : _dialogBtn('Cancel', filled: false),
          ),
          InkWell(
            onTap: () async {
              Navigator.pop(ctx);
              await _endChatWebservice();
            },
            child: _dialogBtn('Yes', filled: true),
          ),
        ],
      ),
    );
  }

  Widget _dialogBtn(String label, {required bool filled}) {
    return Container(
      margin    : const EdgeInsets.all(10),
      height    : 45, width: 100,
      decoration: BoxDecoration(
        color       : filled ? AppColors.orangeColor : null,
        border      : filled ? null
            : Border.all(color: AppColors.orangeColor, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(label,
            style: TextStyle(
                color: filled ? Colors.white : AppColors.orangeColor)),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // FIX 2: Message list — renders from _messages (merged from both paths)
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildMessageList() {
    if (id == null) return const SizedBox.shrink();

    return Expanded(
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/astro/chat_bg.jpg',
                fit: BoxFit.cover),
          ),
          ListView.builder(
            controller: listScrollController,
            padding   : const EdgeInsets.symmetric(
                horizontal: 10.0, vertical: 8.0),
            itemCount : _messages.length,
            itemBuilder: (_, index) {
              final msg  = _messages[index];
              final isMe = msg['from']?.toString() == id;

              return Row(
                mainAxisAlignment:
                    isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: Container(
                      constraints:
                          BoxConstraints(maxWidth: _width! * 0.7),
                      padding: const EdgeInsets.all(12.0),
                      margin : EdgeInsets.only(
                        bottom: 10.0,
                        right : isMe ? 10.0 : 0,
                        left  : isMe ? 0 : 10.0,
                      ),
                      decoration: BoxDecoration(
                        color: isMe
                            ? const Color(0xFFF4F4F4).withOpacity(0.5)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildMsgContent(msg),
                          const SizedBox(height: 5.0),
                          Text(
                            DateFormat('dd MMM yyyy hh:mm a').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  (msg['date_time'] ??
                                      DateTime.now()
                                          .millisecondsSinceEpoch) as int),
                            ),
                            style: const TextStyle(
                                color     : Color(0xFF595959),
                                fontSize  : 9.0,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMsgContent(Map<String, dynamic> msg) {
    final type    = msg['type']    ?? 'text';
    final message = (msg['message'] ?? '').toString();

    if (type == 'text') {
      return Text(message,
          style: const TextStyle(
              color      : Color(0xFF383838),
              fontSize   : 12.0,
              wordSpacing: 1,
              fontWeight : FontWeight.w600));
    }
    if (type == 'image') {
      return GestureDetector(
        onTap: () => Navigator.push(context,
            MaterialPageRoute(
                builder: (_) => WebviewScreen(url: message))),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(message,
              width : 200, height: 200, fit: BoxFit.cover,
              loadingBuilder: (_, child, prog) {
                if (prog == null) return child;
                return Center(child: CircularProgressIndicator(
                  value: prog.expectedTotalBytes != null
                      ? prog.cumulativeBytesLoaded /
                          prog.expectedTotalBytes!
                      : null,
                ));
              },
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.broken_image,
                      size: 100, color: Colors.grey)),
        ),
      );
    }
    if (type == 'audio') {
      return _buildAudioBtn(message);
    }
    // sticker/gif
    return Image.asset('images/$message.gif',
        width: 100, height: 100, fit: BoxFit.cover);
  }

  Widget _buildAudioBtn(String mp3) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white, shape: BoxShape.circle),
      child: IconButton(
        icon     : Icon(Icons.play_arrow, color: primaryColor),
        onPressed: () {
          if (mp3.isNotEmpty) {
            showDialog(
                context: context,
                builder: (_) => AudioPlayerPopup(mp3File: mp3));
          } else {
            Fluttertoast.showToast(
                msg: 'Kindly wait, audio is loading.');
          }
        },
      ),
    );
  }

  Widget _buildLoading() =>
      Positioned(child: false ? const Loading() : const SizedBox.shrink());

  // ─────────────────────────────────────────────────────────────────────────
  // Input bar
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildInput() {
    return Container(
      padding  : const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, greyColor44],
          begin : Alignment.topCenter,
          end   : Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft : Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          _iconBtn(Icons.image, () {
            showModalBottomSheet(
                context: context, builder: (_) => _bottomSheet());
          }),
          const SizedBox(width: 10),
          Flexible(
            child: Container(
              height    : 45,
              decoration: BoxDecoration(
                  color       : Colors.white,
                  borderRadius: BorderRadius.circular(25)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child  : newRecording
                    ? Center(
                        child: Text(_fmt(_elapsedTime),
                            style: TextStyle(
                                color: blackColor, fontSize: 15)))
                    : TextField(
                        readOnly  : iscallActive,
                        onSubmitted: (_) => onSendMessage(
                            textEditingController.text, 0),
                        style     : TextStyle(
                            color: blackColor, fontSize: 15),
                        controller: textEditingController,
                        decoration: InputDecoration(
                          border   : InputBorder.none,
                          hintText : 'Type your message...',
                          hintStyle: TextStyle(color: greyColor),
                        ),
                        focusNode: focusNode,
                      ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onLongPress: () async {
              _controller?.forward();
              if (await _requestMic()) await _startRecording();
            },
            onLongPressEnd   : (_) async {
              _controller?.reverse();
              await _stopRecording();
            },
            onLongPressCancel: () async {
              _controller?.reverse();
              await _stopRecording();
            },
            child: AnimatedBuilder(
              animation: _scaleAnimation!,
              builder  : (_, child) =>
                  Transform.scale(scale: _scaleAnimation!.value, child: child),
              child: Container(
                width : 40, height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isRecording ? Colors.red : Colors.green,
                ),
                child: Icon(
                  _isRecording ? Icons.stop : Icons.mic,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width : 40, height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, primaryColor.withOpacity(0.8)],
                begin : Alignment.topLeft,
                end   : Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: IconButton(
              icon     : const Icon(Icons.send, color: Colors.white),
              onPressed: () =>
                  onSendMessage(textEditingController.text, 0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25)),
        child: IconButton(
            icon: Icon(icon), onPressed: onTap, color: primaryColor),
      ),
    );
  }

  Widget _bottomSheet() {
    return Container(
      height : 200,
      margin : const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
          color       : Colors.white,
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
              text      : 'Choose Photo',
              fontSize  : 20,
              fontWeight: FontWeight.bold,
              color     : blueColor),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _sheetBtn(Icons.camera, 'Camera', () {
                _pickImage(ImageSource.camera);
                Navigator.pop(context);
              }),
              _sheetBtn(Icons.image, 'Gallery', () {
                _pickImage(ImageSource.gallery);
                Navigator.pop(context);
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sheetBtn(IconData icon, String label, VoidCallback onTap) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape  : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10))),
      icon     : Icon(icon, color: Colors.white),
      label    : CustomText(text: label, color: Colors.white),
      onPressed: onTap,
    );
  }

  Widget _buildInputRating() {
    return Card(
      color: card9,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child  : Stack(
          children: [
            Container(
              color  : card9,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child  : Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius         : 25,
                              backgroundImage:
                                  CachedNetworkImageProvider(userimage),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 150,
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(capitalize(widget.name!),
                                      style: const TextStyle(
                                          color     : Colors.black,
                                          fontSize  : 18,
                                          fontWeight: FontWeight.w500)),
                                  RatingBar.builder(
                                    itemSize      : 25,
                                    glowColor     : const Color(0xfff19425),
                                    ignoreGestures: true,
                                    allowHalfRating: true,
                                    initialRating : ratingPoint,
                                    itemBuilder   : (_, __) =>
                                        const Icon(Icons.star,
                                            color: Color(0xfff19425)),
                                    onRatingUpdate: (r) =>
                                        setState(() => ratingPoint = r),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap : _showRatingDialogOnce,
              child : const Align(
                alignment: Alignment.centerRight,
                child    : Icon(Icons.more_vert),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRechargeBanner() {
    return Container(
      decoration: BoxDecoration(
        color       : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow   : [
          BoxShadow(
              color      : Colors.grey.withOpacity(0.2),
              spreadRadius: 3, blurRadius: 6,
              offset     : const Offset(0, 3)),
        ],
      ),
      padding: const EdgeInsets.all(15),
      margin : const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child  : Container(
        padding  : const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFA726), Color(0xFFFF7043)],
            begin : Alignment.topLeft,
            end   : Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children    : [
            Row(
              children: [
                CircleAvatar(
                  radius         : 30,
                  backgroundImage: CachedNetworkImageProvider(
                      widget.astrologerImage!),
                  backgroundColor: Colors.grey.shade200,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    'Hi ${widget.name},\nLet\'s continue at ₹${widget.astrologerChatRate}/min',
                    style: const TextStyle(
                        fontSize  : 16,
                        fontWeight: FontWeight.w500,
                        color     : Colors.white),
                    overflow: TextOverflow.clip,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => MyWallet())),
              child: Container(
                width     : double.infinity,
                padding   : const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Color(0xFFFF7043), Color(0xFFFF5722)],
                      begin : Alignment.topLeft,
                      end   : Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text('Recharge Now',
                      style: TextStyle(
                          fontSize  : 18,
                          fontWeight: FontWeight.bold,
                          color     : Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Rating dialog
  // ─────────────────────────────────────────────────────────────────────────
  void _show(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context           : context,
      builder: (ctx) => AlertDialog(
        insetPadding: const EdgeInsets.only(
            left: 20, right: 20, bottom: 10),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)),
        content: StatefulBuilder(
          builder: (_, ss) => Column(
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
                        color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () => ss(() {
                  if (ratingPoint < 1) {
                    Fluttertoast.showToast(
                        msg: 'Please give your valuable feedback');
                  } else {
                    Navigator.pop(ctx);
                    _callAliForRating(ratingPoint, reviewControler.text);
                  }
                }),
                child: Container(
                  height   : 45,
                  width    : double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
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