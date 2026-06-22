// lib/Screens/live/LiveVideoCallScreen.dart
//
// Only change from original:
// initAgoraRTC() now fetches an Agora audience token from
// POST /user_api/agora_token { channel_id } before calling joinChannel.
// Everything else — UI, event handlers, chat, gifts — is identical.

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Screens/live/components/pageViewScreen.dart';
import 'package:astro_gurujii/Screens/video_call/Controllers/agora_controller.dart';
import 'package:astro_gurujii/Screens/video_call/Helpers/utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/GetGiftModel.dart';

class LiveVideoCallScreen extends StatefulWidget {
  final String? screenType;
  final String? channelName;
  var id;
  final String? astroid;
  final String? name;
  final String? astroImage;
  final List<String>? numberOfuserJoin;
  final String? profile;

  LiveVideoCallScreen({
    this.channelName,
    this.id,
    this.name,
    this.astroid,
    this.profile,
    this.astroImage,
    this.numberOfuserJoin,
    this.screenType,
  });

  @override
  VideoCallScreenState createState() => VideoCallScreenState();
}

class VideoCallScreenState extends State<LiveVideoCallScreen> {
  ScrollController scrollController   = ScrollController();
  TextEditingController messageController = TextEditingController();
  bool isFirst = false;
  String? chatId;
  static final _users = <int>[];
  final _infoStrings   = <String>[];
  HttpServices _httpService = HttpServices();
  bool isSomeOneJoinedCall  = false;
  final AgoraController agoraController = Get.put(AgoraController());

  int networkQuality = 3;
  Color networkQualityBarColor = Colors.green;
  bool status = true;
  late Timer timer;
  late Timer timeree;
  late Timer meetingTimer;
  var meetingDurationTxt = "00:00".obs;
  var mins = 0;
  int meetingDuration = 0;

  late RtcEngine _engine;
  int _myUid = 0;
  static const _dbUrl = "https://astrogurujii-production-default-rtdb.firebaseio.com/";
DatabaseReference? _viewerRef;
  // chat
  late DatabaseReference RootRef;
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController       = ScrollController();
  FocusNode focusNode = FocusNode();
  late DatabaseReference messageChatReference;
  bool isShowSticker = false;
  int _limit          = 20;
  int _limitIncrement = 20;

  @override
  void setState(fn) {
    try {
      if (mounted) super.setState(fn);
    } catch (e) {}
  }

  void onFocusChange() {
    if (focusNode.hasFocus) setState(() => isShowSticker = false);
  }

  _scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() => _limit += _limitIncrement);
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.screenType == "home") {
      joinLiveAstrologer(widget.id);
    } else if (widget.screenType == "pooja") {
      joinLiveForPooja(widget.id);
    }

    focusNode.addListener(onFocusChange);
    listScrollController.addListener(_scrollListener);

    // ✅ FIX: fetch token first, then init Agora
    initAgoraRTC();

   final db = FirebaseDatabase.instanceFor(
  app: Firebase.app(),
  databaseURL: _dbUrl,
).ref();

messageChatReference = db.child("GroupLive").child(widget.channelName!);
_viewerRef = db.child("LiveViewers").child(widget.channelName!);

debugPrint('🟢 USER channelName = ${widget.channelName}');
  }

  @override
  void dispose() {
    _viewerRef?.child(_myUid.toString()).remove();
    try { _engine.leaveChannel(); } catch (_) {}
    try { _engine.stopPreview(); }  catch (_) {}
    try { _engine.release(); }      catch (_) {}
    super.dispose();
  }
  

  final HttpServices _httpServices = HttpServices();
  List<Data> dataGifts = [];

  void getListGift() async {
    var res = await _httpServices.getGiftsListing();
    if (res!.status == true) {
      setState(() => dataGifts = res.data!);
    } else {
      Fluttertoast.showToast(msg: res.message!);
    }
  }

  void joinLiveAstrologer(String liveId) async {
    var res = await _httpServices.joinLiveAstrologerApi(liveId);
    if (res?.status != true) {
      Fluttertoast.showToast(msg: res?.message ?? '');
    }
  }

  void joinLiveForPooja(String pujaId) async {
    var res = await _httpServices.joinLiveForPoojaApi(pujaId);
    if (res?.status != true) {
      Fluttertoast.showToast(msg: res?.message ?? '');
    }
  }

  // ── Fetch audience token from backend ─────────────────────────────────────
  Future<String> _fetchAgoraToken(String channelId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('token') ?? '';

      final response = await http.post(
        Uri.parse('https://admin.astrogurujii.com/user_api/agora_token'),
        headers: {
          'Content-Type' : 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({'channel_id': channelId}),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == true) {
          return body['token'] as String? ?? '';
        }
      }
    } catch (e) {
      debugPrint('⚠️ agora_token fetch failed: $e — joining without token');
    }
    return '';
  }

  // ── Init Agora ────────────────────────────────────────────────────────────
  Future<void> initAgoraRTC() async {
    if (getAgoraAppId().isEmpty) {
      Get.snackbar("", "Agora APP_ID Is Not Valid");
      return;
    }

    await _initAgoraRtcEngine();

    // ✅ FIX 1: LiveBroadcasting profile — must match the astrologer broadcaster
    await _engine.setChannelProfile(
        ChannelProfileType.channelProfileLiveBroadcasting);

    // ✅ FIX 2: Audience role with level 1 (low latency)
    await _engine.setClientRole(
      role: ClientRoleType.clientRoleAudience,
      options: const ClientRoleOptions(
        audienceLatencyLevel:
            AudienceLatencyLevelType.audienceLatencyLevelLowLatency,
      ),
    );

    await _engine.setVideoEncoderConfiguration(
      const VideoEncoderConfiguration(
        dimensions  : VideoDimensions(width: 640, height: 360),
        frameRate   : 30,
        bitrate     : 800,
        orientationMode: OrientationMode.orientationModeAdaptive,
      ),
    );

    // ✅ FIX 3: fetch real token — empty string only works if App Certificate disabled
    final agoraToken = await _fetchAgoraToken(widget.channelName ?? '');

    await _engine.joinChannel(
      token    : agoraToken,
      channelId: widget.channelName ?? '',
      uid      : 0,
      options  : const ChannelMediaOptions(),
    );
  }

  Future<void> _initAgoraRtcEngine() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(appId: getAgoraAppId()));
    _addAgoraEventHandlers();
    await _engine.enableVideo();
    await _engine.startPreview();
  }

  void _addAgoraEventHandlers() {
    _engine.registerEventHandler(RtcEngineEventHandler(
      onError: (ErrorCodeType code, String msg) {
        setState(() => _infoStrings.add('onError: $code $msg'));
      },
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        log('joinChannelSuccess uid=${connection.localUid}');
        _myUid = connection.localUid ?? 0;
        _viewerRef?.child(_myUid.toString()).set(true);
        setState(() =>
            _infoStrings.add('onJoinChannel: ${connection.channelId}'));
      },
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        log('leaveChannel');
         _myUid = connection.localUid ?? 0;
         _viewerRef?.child(_myUid.toString()).remove();
        setState(() {
          _infoStrings.add('onLeaveChannel');
          _users.clear();
        });
      },
      onUserJoined: (RtcConnection connection, int uid, int elapsed) {
        log('userJoined $uid');
        agoraController.startMeetingTimer();
        isSomeOneJoinedCall = true;
        setState(() {
          _infoStrings.add('userJoined: $uid');
          _users.add(uid);
        });
      },
      onUserOffline: (RtcConnection connection, int uid,
          UserOfflineReasonType reason) {
        log('userOffline $uid');
        setState(() {
          _infoStrings.add('userOffline: $uid');
          _users.remove(uid);
          Navigator.pop(context);
        });
      },
      onFirstRemoteVideoFrame: (RtcConnection connection, int uid,
          int width, int height, int elapsed) {
        setState(() =>
            _infoStrings.add('firstRemoteVideo: $uid ${width}x$height'));
      },
    ));
  }

  List<Widget> _getRenderViews() {
    final List<Widget> list = [];
    list.add(AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: _engine,
        canvas   : const VideoCanvas(uid: 0),
      ),
    ));
    for (final uid in _users) {
      list.add(AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine : _engine,
          canvas    : VideoCanvas(uid: uid),
          connection: RtcConnection(channelId: widget.channelName ?? ''),
        ),
      ));
    }
    return list;
  }

  Widget _videoView(view) => Expanded(child: Container(child: view));

  Widget _expandedVideoRow(List<Widget> views) => Expanded(
        child: Row(children: views.map<Widget>(_videoView).toList()),
      );

  Widget buildJoinUserUI() {
    final views = _getRenderViews();
    if (isSomeOneJoinedCall) {
      setState(() {
        if (status) {
          status = false;
          meetingDurationTxt = "00:00".obs;
          meetingDuration    = 0;
        }
      });
    }
    switch (views.length) {
      case 1:
        return Container();
      case 2:
      case 3:
      case 4:
        return Container(
          width : Get.width,
          height: Get.height,
          child : Stack(children: [
            Align(
              alignment: Alignment.topLeft,
              child    : Column(children: [
                _expandedVideoRow([views[1]]),
              ]),
            ),
          ]),
        );
      default:
        return Container();
    }
  }

  void onCallEnd(BuildContext context) async {
    _users.clear();
     _viewerRef?.child(_myUid.toString()).remove();
    try { await _engine.leaveChannel(); }  catch (_) {}
    try { await _engine.stopPreview(); }   catch (_) {}
    try { await _engine.release(); }       catch (_) {}
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Stack(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                buildNormalVideoUI(),
                PageViewScreen(
                  screenType          : widget.screenType!,
                  id                  : widget.id,
                  astroid             : widget.astroid,
                  textEditingController: textEditingController,
                  listScrollController : listScrollController,
                  focusNode            : focusNode,
                  messageChatReference : messageChatReference,
                  channelName          : widget.channelName!,
                  astroImage           : widget.astroImage!,
                  name                 : widget.name!,
                  numberOfuserJoin     : widget.numberOfuserJoin!,
                  dataGifts            : dataGifts,
                  agoraEngine          : _engine,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNormalVideoUI() {
    return SizedBox(
      height: Get.height,
      child : Stack(children: [
        buildJoinUserUI(),
        (_users.isEmpty && status)
            ? Align(
                alignment: Alignment.topCenter,
                child    : Container(
                  height    : Get.height,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color.fromRGBO(252, 155, 4, 1),
                      Color.fromRGBO(143, 40, 34, 1),
                    ]),
                  ),
                ),
              )
            : Container(),
      ]),
    );
  }
}