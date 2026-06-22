// lib/Screens/chats_screen/ChatCallingScreen.dart
//
// KEY FIX: gid passed to Chat() must = channel_id (API), NOT fb_channel_id.
//
// Astrologer's ChatProvider.initializeChat() receives groupId = channel_id.
// Firebase path: Group/{channel_id}/{astrologerId}/{userId}
//
// BEFORE (broken):
//   gid: fb_channel_id   ← wrong! creates Group/{fb_channel_id}/... path
//
// AFTER (fixed):
//   gid: widget.channel_id  ← correct! matches Group/{channel_id}/...
//
// fb_channel_id is kept as channelID for backward compat but is NOT used
// as the Firebase group root anymore.

import 'dart:async';
import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Screens/chats_screen/chat/Chat.dart';
import 'package:astro_gurujii/Screens/video_call/Helpers/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiver/async.dart';

import '../../widget/bottom_navigation_bar_custom.dart';

class ChatCallingScreen extends StatefulWidget {
  var kundali;
  final String? name;
  final String? astroName;
  final String? profile;
  final String? astrologer_id;
  var channel_id;           // API channel_id — used as group root AND for status poll
  final String? wallet;
  final String? rate;
  final String? place;
  final String? tob;
  final String? dob;
  final String? gender;

  ChatCallingScreen({
    this.kundali,
    this.astroName,
    this.gender,
    this.dob,
    this.tob,
    this.place,
    this.wallet,
    this.rate,
    this.name,
    this.profile,
    this.astrologer_id,
    this.channel_id,
  });

  @override
  State<StatefulWidget> createState() => ChatCallingScreenState();
}

class ChatCallingScreenState extends State<ChatCallingScreen> {
  final HttpServices _httpService = HttpServices();

  String _fbChannelId = ''; // fb_channel_id returned by call_initiate (legacy)

  Timer? _pollTimer;
  Timer? _abortTimer;

  int  _secondsRemaining = 180;
  int  meetingDuration   = 2;
  var  meetingDurationTxt = '00:00';
  StreamSubscription? _countdownSub;

  // ─────────────────────────────────────────────────────────────────────────
  // Start chat via API
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> callStartChat() async {
    final res = await _httpService.call_initiate(
      kundli       : widget.kundali,
      channel_id   : widget.channel_id,
      astrologer_id: widget.astrologer_id!,
      call_type    : 'chat',
    );
    if (!mounted) return;

    if (res?.status == true) {
      setState(() {
        widget.channel_id = res!.channel_id;
        _fbChannelId      = res.fb_channel_id ?? '';
      });
      // Start polling only after we have a valid channel
      _pollTimer = Timer.periodic(
        const Duration(seconds: 2),
        (_) => _checkForNewStatus(),
      );
    } else {
      Fluttertoast.showToast(msg: res?.message ?? 'Failed to connect');
      if (mounted) Navigator.pop(context);
    }
  }

  Future<void> _endChatWebservice() async {
    final res = await _httpService.call_status_update(
      channel_id: widget.channel_id,
      status    : 'disconnect_user',
    );
    _pollTimer?.cancel();
    if (!mounted) return;
    Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (_) => MainHomeScreenWithBottomNavigation()),
    );
  }

  Future<void> _checkForNewStatus() async {
    final res = await _httpService.call_initiate_status(
        channel_id: widget.channel_id);
    if (!mounted) return;
    if (res?.status != true) return;

    final status = res!.results?.status ?? '';

    if (status == 'accept_astro') {
      _pollTimer?.cancel();
      try { _countdownSub?.cancel(); } catch (_) {}
      _abortTimer?.cancel();

      Navigator.pop(context);

      // FIX: gid MUST equal widget.channel_id (= astrologer's groupId)
      // fbchannelID = widget.channel_id (same value, used for status API)
      // channelID   = _fbChannelId (fb_channel_id, kept for legacy compat)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Chat(
            channelID          : _fbChannelId,      // fb_channel_id (legacy)
            fbchannelID        : widget.channel_id.toString(), // API channel_id
            astrologerId       : widget.astrologer_id!,
            name               : widget.name!,
            place              : widget.place ?? '',
            dob                : widget.dob   ?? '',
            astroName          : widget.astroName!,
            tob                : widget.tob   ?? '',
            gender             : widget.gender ?? '',
            // ▼ FIX: gid = channel_id, NOT fb_channel_id
            gid                : widget.channel_id.toString(),
            currency           : 'INR',
            astrologerChatRate : widget.rate ?? '0',
            astrologerImage    : widget.profile!,
            wallet             : widget.wallet ?? '0',
          ),
        ),
      );
    } else if (status == 'reject_astro') {
      _pollTimer?.cancel();
      _abortTimer?.cancel();
      try { _countdownSub?.cancel(); } catch (_) {}
      if (mounted) Navigator.pop(context);
    } else if (status == 'end_user') {
      _pollTimer?.cancel();
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Lifecycle
  // ─────────────────────────────────────────────────────────────────────────
  @override
  void dispose() {
    _pollTimer?.cancel();
    _abortTimer?.cancel();
    try { _countdownSub?.cancel(); } catch (_) {}
    super.dispose();
  }

  // 3-minute abort countdown
  void _startAbortTimer() {
    _abortTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        t.cancel();
        if (mounted) Navigator.pop(context);
      }
    });
  }

  // Meeting duration display (legacy — from wallet/rate)
  void _startMeetingTimer() {
    final countdown = CountdownTimer(
        Duration(seconds: meetingDuration), const Duration(seconds: 1));
    _countdownSub = countdown.listen(null);
    _countdownSub!.onData((_) {
      if (!mounted) return;
      final m = meetingDuration ~/ 60;
      final s = meetingDuration % 60;
      setState(() {
        meetingDurationTxt =
            '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
        meetingDuration = (meetingDuration - 1).clamp(0, meetingDuration);
      });
    });
    _countdownSub!.onDone(() {
      try { _countdownSub?.cancel(); } catch (_) {}
    });
  }

  void _calculateAndStart() {
    final walletAmount   = double.tryParse(widget.wallet ?? '0')  ?? 0.0;
    final astrologerRate = double.tryParse(widget.rate   ?? '0')  ?? 0.0;

    if (astrologerRate > 0) {
      meetingDuration = ((walletAmount / astrologerRate) * 60).round();
      if (meetingDuration > 0) callStartChat();
    }
  }

  @override
  void initState() {
    super.initState();
    _calculateAndStart();
    _startMeetingTimer();
    _startAbortTimer();
  }

  String get _formattedTime {
    final m = _secondsRemaining ~/ 60;
    final s = _secondsRemaining % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  // ─────────────────────────────────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/bg1.png', fit: BoxFit.cover),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 200),
                      Container(
                        width: 180,
                        decoration: BoxDecoration(
                          shape : BoxShape.circle,
                          border: Border.all(
                              color: const Color(0xFFD1D3FF), width: 2),
                        ),
                        child: CircleAvatar(
                          radius         : 65,
                          backgroundImage:
                              NetworkImage(widget.profile ?? ''),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.astroName ?? '',
                        style: const TextStyle(
                            color     : Colors.black87,
                            fontSize  : 23,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 10),
                      const Text('Connecting......',
                          style: TextStyle(color: Colors.pink, fontSize: 18)),
                      Text(_formattedTime,
                          style: const TextStyle(
                              color: Colors.pink, fontSize: 18)),
                      const SizedBox(height: 200),
                      InkWell(
                        onTap: _endChatWebservice,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child : Image.asset('assets/images/call_end.png',
                              height: 62),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: const EdgeInsets.only(left: 10, top: 30),
                    child : TextButton(
                      onPressed: () {},
                      child: const Icon(Icons.arrow_back_outlined,
                          color: Colors.white, size: 24.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}