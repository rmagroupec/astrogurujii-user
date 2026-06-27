// lib/Screens/live/components/top_section.dart
//
// Redesigned to match AstroTalk live UI exactly:
// - Host pill (avatar + name + dynamic subtitle + signal bars + timer)
// - Separate Grid icon, Follow button, overflow chevron, Close (X) button
// - "Private call" lock badge shown only when a user is connected

import 'dart:async';
import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:astro_gurujii/Screens/Models/GetLiveUser.dart';
import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Screens/live/components/reportAstro.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../Setup/SetUp.dart';
import '../../AstroDetails/AstroDetails.dart';
import '../../Models/AstroDetailsModel.dart';
import '../../pooja_orders/controller/PoojaOrderController.dart';

class TopSection extends StatefulWidget {
  final String name;
  final String screenType;
  final RtcEngine agoraEngine;
  final bool isUserConnected; // true when audience joined = show "Private call"

  var astroid;
  var id;
  final String astroImage;
  final List<String> numberOfuserJoin;

  TopSection({
    this.astroid,
    this.id,
    required this.name,
    required this.astroImage,
    required this.numberOfuserJoin,
    required this.screenType,
    required this.agoraEngine,
    this.isUserConnected = false,
  });

  @override
  State<TopSection> createState() => _TopSectionState();
}

class _TopSectionState extends State<TopSection> {
  final HttpServices _httpServices = HttpServices();
  List<Results> data = [];
  var usersCount = 0;

  // Live timer
  int _elapsedSeconds = 0;
  Timer? _liveTimer;

  String get _timerLabel {
    final m = _elapsedSeconds ~/ 60;
    final s = _elapsedSeconds % 60;
    return '${m.toString().padLeft(2, '0')} m ${s.toString().padLeft(2, '0')} s';
  }

  // When a viewer is connected we're in a "private" 1:1 moment, so the
  // subtitle under the host name switches from a watching-count to "& Private".
  String get _subtitle =>
      widget.isUserConnected ? '& Private' : '$usersCount watching';

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _listenFCM();
    astroDetailsApi();
    _fetchUserCount();
    _startPolling();
    _startLiveTimer();
  }

  @override
  void dispose() {
    _liveTimer?.cancel();
    super.dispose();
  }

  void _startLiveTimer() {
    _liveTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _elapsedSeconds++);
    });
  }

  void _listenFCM() {
    FirebaseMessaging.onMessage.listen((msg) {
      log('FCM foreground: ${msg.data}');
    });
  }

  // ── API calls ─────────────────────────────────────────────────────────────

  void astroDetailsApi() async {
    var res = await _httpServices.astrologer_details(id: widget.astroid);
    if (res?.status == true && mounted) {
      setState(() => data = res!.results!);
    }
  }

  void _fetchUserCount() {
    if (widget.screenType == "home") {
      _httpServices.get_live_users_count(id: widget.id).then((value) {
        if (value['success'] == true && mounted) {
          setState(() => usersCount = value['data']['usersCount'] ?? 0);
        }
      }).catchError((e) => log('get_live_users_count error: $e'));
    } else if (widget.screenType == "pooja") {
      _httpServices.get_live_users_count_forPooja(id: widget.id).then((value) {
        if (value['success'] == true && mounted) {
          setState(() => usersCount = value['data']['usersCount'] ?? 0);
        }
      }).catchError((e) => log('get_live_users_count_forPooja error: $e'));
    }
  }

  void _startPolling() {
    Timer.periodic(const Duration(seconds: 10), (_) {
      if (!mounted) return;
      _fetchUserCount();
    });
  }

  void callFollowApi() async {
    var res = await _httpServices.follow_astro(id: widget.astroid);
    if (res?.status == true) {
      Fluttertoast.showToast(msg: res!.message!);
      astroDetailsApi();
    } else {
      Fluttertoast.showToast(msg: res?.message ?? '');
    }
  }

  // ── Call end ──────────────────────────────────────────────────────────────

  void onCallEnd(BuildContext context, String id) async {
    if (widget.screenType == "home") {
      _httpServices.leaveLiveForHome(live_id: id).then((v) {
        Fluttertoast.showToast(msg: v['message'].toString());
      });
    } else if (widget.screenType == "pooja") {
      PoojaOrderController controller = Get.put(PoojaOrderController());
      controller.leaveLive(id);
    }
    widget.agoraEngine.leaveChannel();
    widget.agoraEngine.release();
    Navigator.pop(context);
  }

  Future<void> _showReportDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (_) => ReportDialog(widget.astroid.toString()),
    );
  }

  // TODO: wire this to whatever the overflow chevron should open
  // (e.g. a "more options" sheet). Left as a no-op for now.
  void _onOverflowTap() {}

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final bool isFollowed =
        data.isNotEmpty && data[0].is_Follow.toString() == "1";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Status bar space ──
        SizedBox(height: MediaQuery.of(context).padding.top + 8),

        // ── Top bar ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              // Host info pill — avatar, name, subtitle, signal bars, timer
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AstroDetails(
                        astroLogerName: widget.name,
                        categoryId: widget.astroid,
                      ),
                    ),
                  ),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.42),
                      borderRadius: BorderRadius.circular(w / 12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Avatar
                        ClipOval(
                          child: Image.network(
                            widget.astroImage,
                            width: w / 11,
                            height: w / 11,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => CircleAvatar(
                              radius: w / 22,
                              backgroundColor: const Color(0xFF9C6B4A),
                              child: Text(
                                widget.name.isNotEmpty ? widget.name[0] : 'A',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 7),
                        // Name + subtitle
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.name,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: w / 28,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                _subtitle,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: w / 38,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 1,
                          height: 18,
                          color: Colors.white24,
                        ),
                        const SizedBox(width: 8),
                        // Signal bars
                        _SignalBars(),
                        const SizedBox(width: 8),
                        // Live timer
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            _timerLabel,
                            style:
                                const TextStyle(color: Colors.white, fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Grid icon
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    const Icon(Icons.grid_view_rounded, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 8),
              // Follow / Followed button — now its own pill, outside the host info pill
              GestureDetector(
                onTap: callFollowApi,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    gradient: isFollowed
                        ? null
                        : const LinearGradient(
                            colors: [Color(0xFFDD9750), Color(0xFFEE4262)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                    color: isFollowed ? Colors.white24 : null,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isFollowed ? 'Followed' : 'Follow',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              // Overflow chevron
              GestureDetector(
                onTap: _onOverflowTap,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  child: Icon(Icons.chevron_right, color: Colors.white70, size: 20),
                ),
              ),
              const SizedBox(width: 6),
              // Close button
              GestureDetector(
                onTap: () => onCallEnd(context, widget.id.toString()),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // ── "Private call" badge — only when a viewer is connected ──
        if (widget.isUserConnected)
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.45),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.lock_outline, color: Colors.white, size: 13),
                  SizedBox(width: 5),
                  Text('Private call', style: TextStyle(color: Colors.white, fontSize: 12)),
                ],
              ),
            ),
          ),

        const SizedBox(height: 6),

        // ── Report icon ──
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () => _showReportDialog(context),
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Image.asset(
                "assets/images/reporticonAstro.png",
                height: 36,
                width: 36,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Signal bars widget ────────────────────────────────────────────────────────

class _SignalBars extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [4.0, 7.0, 10.0, 13.0]
          .map((h) => Container(
                width: 3,
                height: h,
                margin: const EdgeInsets.only(right: 1.5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(1),
                ),
              ))
          .toList(),
    );
  }
}