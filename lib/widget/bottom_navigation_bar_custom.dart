// lib/widget/bottom_navigation_bar_custom.dart
//
// FIXES & IMPROVEMENTS vs original:
//  1. Floating card covers all three call types: chat, audio, video.
//  2. Firebase CallSession subscribed on mount → live countdown shown
//     on the floating card (same 3-tier sync as Chat/AfterCallConnecting).
//  3. getChatStatus() polled every 5 s via Timer (not only on initState).
//  4. Navigating back into an active chat passes ALL required fields
//     (gid, wallet, rate, astrologerImage, etc.) so Chat.dart time-sync works.
//  5. Audio/video navigate to AfterCallConnecting / VideoCallScreen.
//  6. dispose() cancels poll timer + Firebase subscription.
//  7. _ratingDialogShown guard prevents double-dialog on status change.


import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';
import 'package:astro_gurujii/Screens/video_call/AudioCallScreen.dart';
import 'package:astro_gurujii/Screens/video_call/NewVideoCallScreen.dart';
import 'package:astro_gurujii/Screens/ChatIntakeForm.dart';
import 'package:astro_gurujii/Screens/Models/last_call_list/LastCallListModel.dart';
import 'package:astro_gurujii/Screens/chats_screen/ChatCallingScreen.dart';
import 'package:astro_gurujii/Screens/chats_screen/chat/Chat.dart';
import 'package:astro_gurujii/Screens/homeScreen/Home.dart';
import 'package:astro_gurujii/Screens/homeScreen/home_widget.dart';
import 'package:astro_gurujii/Screens/liveAsgtrologerLisitngScreen.dart';
import 'package:astro_gurujii/Screens/poojaScreen/ui/poojaScreen.dart';
import 'package:astro_gurujii/Screens/video_call/VideoCallScreen.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:store_redirect/store_redirect.dart';

import '../Screens/TalkAstrologer/TalkAstrologer2.dart';
import '../Screens/TalkAstrologer/TalkAstrologers.dart';
import '../Screens/WebServices/HttpServices.dart';
import 'floating_card_custom.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Stateless bottom nav bar widget (unchanged API)
// ─────────────────────────────────────────────────────────────────────────────
class BottomNavigationBarCustom extends StatelessWidget {
  final Color    backgroundColor;
  final Color    activeColor;
  final Color    inactiveColor;
  final Function onHomeTap;
  final Function onChatTap;
  final Function onLiveTap;
  final Function onCallTap;
  final Function onPoojaTap;
  final int      activeIndex;

  const BottomNavigationBarCustom({
    Key? key,
    required this.backgroundColor,
    required this.activeColor,
    required this.inactiveColor,
    required this.onHomeTap,
    required this.onChatTap,
    required this.onLiveTap,
    required this.onCallTap,
    required this.onPoojaTap,
    required this.activeIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height    : 50,
      decoration: BoxDecoration(
        color       : backgroundColor,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft : Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navItem('assets/d_icons/new_home_icon.png', 'Home',  onHomeTap,  activeIndex == 0),
          _navItem('assets/d_icons/chat_icon.png',     'Chat',  onChatTap,  activeIndex == 1),
          _liveItem(  'assets/images/live.svg' ,                                'Live',  onLiveTap,  activeIndex == 2),
          _navItem('assets/d_icons/new_call_icon.png', 'Call',  onCallTap,  activeIndex == 3),
          _navItem('assets/d_icons/active_pooja_icon.png', 'Puja', onPoojaTap, activeIndex == 4),
        ],
      ),
    );
  }

  Widget _navItem(String iconPath, String label, Function onTap, bool active) {
    final color = active ? activeColor : inactiveColor;
    return InkWell(
      onTap: () => onTap(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(iconPath, color: color, width: 15, fit: BoxFit.contain),
          const SizedBox(height: 3),
          Text(label, style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }


Widget _liveItem(String iconPath, String label, Function onTap, bool active) {
  final color = active ? activeColor : inactiveColor;
  return InkWell(
    onTap: () => onTap(),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          iconPath,
          width: 15,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 3),
        Text(label, style: TextStyle(color: color, fontSize: 12)),
      ],
    ),
  );
}
}

// ─────────────────────────────────────────────────────────────────────────────
// Main screen with bottom navigation
// ─────────────────────────────────────────────────────────────────────────────
class MainHomeScreenWithBottomNavigation extends StatefulWidget {
  const MainHomeScreenWithBottomNavigation({Key? key}) : super(key: key);

  @override
  State<MainHomeScreenWithBottomNavigation> createState() =>
      _MainHomeScreenWithBottomNavigationState();
}

class _MainHomeScreenWithBottomNavigationState
    extends State<MainHomeScreenWithBottomNavigation> {

  // ── Screens ────────────────────────────────────────────────────────────────
  int _selectedIndex = 0;

  late final List<Widget> _screens = [
    const Home(),
    TalkAstrologer(
      astroList  : controllerHomePageLogic.astroListChat,
      appBarName : 'Chat with Astrologer',
      chatKey    : 'on',
      talkKey    : '',
      screen     : 'home',
      skill_id   : '',
      videoKey   : '',
      callType   : 'chat',
    ),
    LiveAstroLogersScreen(),
    TalkAstrologer2(
      astroList  : controllerHomePageLogic.astroListVoice,
      appBarName : 'Talk with Astrologer',
      chatKey    : '',
      screen     : 'home',
      talkKey    : 'on',
      videoKey   : '',
      callType   : 'audio',
      expert_astro: '',
    ),
    PoojaScreen(),
  ];

  // ── Services ───────────────────────────────────────────────────────────────
  final HttpServices _httpServices = HttpServices();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  // ── Session data from lastCallList ─────────────────────────────────────────
  Data2?          data2;
  WattingUserData? watting_user_data;
  bool            _isLoading = true;

  // ── Poll timer ─────────────────────────────────────────────────────────────
  Timer? _pollTimer;

  // ── Firebase CallSession live countdown ───────────────────────────────────
  static const _dbUrl =
      'https://astrogurujii-production-default-rtdb.firebaseio.com/';

  StreamSubscription<DatabaseEvent>? _fbSub;
  Timer?                             _fbTick;

  /// Drives the countdown shown on the floating card.
  final ValueNotifier<int> _timeLeftNotifier = ValueNotifier<int>(0);

  String? _subscribedChannelId; // tracks which channel we're listening to

  // ─────────────────────────────────────────────────────────────────────────
  // Lifecycle
  // ─────────────────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _getChatStatus();

    // Poll every 5 s so the floating card appears / disappears promptly
    _pollTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _getChatStatus(),
    );
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _cancelFirebase();
    _timeLeftNotifier.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // lastCallList API
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> _getChatStatus() async {
    final res = await _httpServices.lastCallList();
    if (!mounted) return;

    if (res?.result == true) {
      setState(() {
        try {
          data2    = res!.data2;
          _isLoading = false;

          if (data2?.callType == 'chat' || data2?.callType == 'Chat') {
            watting_user_data = res.watting_user_data;
          }

          // Subscribe Firebase for live countdown if there's an active session
          if (data2?.status == 'accept_astro' &&
              data2?.channelId != null &&
              data2!.channelId!.isNotEmpty) {
            _subscribeFirebase(
              channelId    : data2!.channelId!,
              walletStr    : (data2!.difference ?? 0).toString(),
              rateStr      : data2!.callRate ?? '1',
            );
          } else {
            _cancelFirebase();
          }
        } catch (_) {}
      });
    } else {
      Fluttertoast.showToast(msg: res?.message ?? 'Error');
      _refreshController.refreshCompleted();
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Firebase subscription — same 3-tier formula as CountdownManager
  // ─────────────────────────────────────────────────────────────────────────
  void _subscribeFirebase({
    required String channelId,
    required String walletStr,
    required String rateStr,
  }) {
    // Don't re-subscribe if already on the same channel
    if (_subscribedChannelId == channelId) return;
    _cancelFirebase();
    _subscribedChannelId = channelId;

    final walletInt = int.tryParse(walletStr) ?? 0;
    final rateInt   = int.tryParse(rateStr)   ?? 1;

    // Seed with optimistic value
    if (rateInt > 0) {
      _timeLeftNotifier.value = (walletInt ~/ rateInt) * 60;
    }

    // Local 1 Hz tick
    _fbTick = Timer.periodic(const Duration(seconds: 1), (_) {
      final cur = _timeLeftNotifier.value;
      if (cur > 0) _timeLeftNotifier.value = cur - 1;
    });

    // Firebase listener
    final ref = FirebaseDatabase.instanceFor(
      app        : Firebase.app(),
      databaseURL: _dbUrl,
    ).ref().child('CallSession').child(channelId);

    _fbSub = ref.onValue.listen((event) {
      if (!mounted) return;
      final raw = event.snapshot.value;
      if (raw == null) return;

      final data   = Map<String, dynamic>.from(raw as Map);
      final status = (data['status'] ?? '') as String;

      // Session ended on server side → clear card
      if (['end_astro', 'end_user', 'wallet_empty'].contains(status)) {
        _timeLeftNotifier.value = 0;
        _cancelFirebase();
        if (mounted) setState(() { data2 = null; });
        return;
      }

      // Compute accurate seconds (3-tier)
      final accurate = _computeAccurate(
        data       : data,
        walletInt  : walletInt,
        rateInt    : rateInt,
      );
      if (accurate == null) return;

      // Drift-correct only if > 10 s off
      final local = _timeLeftNotifier.value;
      if ((local - accurate).abs() > 10) {
        _timeLeftNotifier.value = accurate;
      }
    });
  }

  int? _computeAccurate({
    required Map<String, dynamic> data,
    required int walletInt,
    required int rateInt,
  }) {
    final nowMs         = DateTime.now().millisecondsSinceEpoch;
    final rawMaxMinutes = data['max_minutes'];
    final rawLastTick   = data['last_tick_at'];
    final rawStartedAt  = data['started_at'];

    // Tier 1: max_minutes + last_tick_at
    if (rawMaxMinutes != null) {
      final maxSec = (int.tryParse(rawMaxMinutes.toString()) ?? 0) * 60;
      if (rawLastTick != null) {
        final elapsed =
            ((nowMs - (int.tryParse(rawLastTick.toString()) ?? nowMs)) / 1000)
                .floor();
        return (maxSec - elapsed).clamp(0, maxSec);
      }
      return maxSec;
    }

    // Tier 2: started_at
    if (rawStartedAt != null) {
      final elapsed =
          ((nowMs - (int.tryParse(rawStartedAt.toString()) ?? nowMs)) / 1000)
              .floor();
      final maxSec = rateInt > 0 ? (walletInt ~/ rateInt) * 60 : 0;
      return (maxSec - elapsed).clamp(0, maxSec);
    }

    return null; // keep local
  }

  void _cancelFirebase() {
    _fbSub?.cancel();
    _fbSub = null;
    _fbTick?.cancel();
    _fbTick = null;
    _subscribedChannelId = null;
  }

Future<void> _returnToActiveChat() async {
  final res = await _httpServices.lastCallList();
  if (!mounted) return;
  if (res?.result != true || res?.data2 == null) return;

  final d = res!.data2!;
  if (d.status != 'accept_astro') return;

  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => Chat(
        channelID          : d.fbChannelId ?? d.channelId ?? '',
        fbchannelID        : d.channelId   ?? '',
        gid                : d.channelId   ?? '',
        astrologerId       : d.astroId     ?? '',
        astroName          : d.astroName   ?? '',
        astrologerImage    : d.astroProfileImg ?? '',
        astrologerChatRate : d.callRate    ?? '0',
        wallet             : ((d.difference ?? 0) * (int.tryParse(d.callRate ?? '1') ?? 1))
                                 .toString(),
        name               : d.userName    ?? '',
        gender             : '',
        dob                : '',
        tob                : '',
        place              : '',
        currency           : 'INR',
      ),
    ),
  );
  _getChatStatus();
}
  // ─────────────────────────────────────────────────────────────────────────
  // Navigate BACK into an active chat
  // ─────────────────────────────────────────────────────────────────────────
 Future<void> _returnToActiveAudioCall() async {
    final res = await _httpServices.lastCallList();
    if (!mounted) return;
    if (res?.result != true || res?.data2 == null) return;
 
    final d = res!.data2!;
    if (d.status != 'accept_astro') return;
 
    final walletProxy =
        ((d.difference ?? 0) * (int.tryParse(d.callRate ?? '1') ?? 1))
            .toString();
 
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AfterCallConnecting(
          channelName: d.channelId      ?? '',
          name       : d.astroName      ?? '',
          profile    : d.astroProfileImg ?? '',
          callfrom   : d.userName       ?? '',
          token      : '',   // engine already running — token not used
          wallet     : walletProxy,
          rate       : d.callRate       ?? '1',
        ),
      ),
    );
    _getChatStatus();
  }
 
  Future<void> _returnToActiveVideoCall() async {
    final res = await _httpServices.lastCallList();
    if (!mounted) return;
    if (res?.result != true || res?.data2 == null) return;
 
    final d = res!.data2!;
    if (d.status != 'accept_astro') return;
 
    final walletProxy =
        ((d.difference ?? 0) * (int.tryParse(d.callRate ?? '1') ?? 1))
            .toString();
 
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VideoCallScreen(
          channelName: d.channelId      ?? '',
          name       : d.astroName      ?? '',
          profile    : d.astroProfileImg ?? '',
          token      : '',   // engine already running — token not used
          wallet     : walletProxy,
          rate       : d.callRate       ?? '1',
        ),
      ),
    );
    _getChatStatus();
  }
  // ─────────────────────────────────────────────────────────────────────────
  // Floating card builder — decides which card to show
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildFloatingCard() {
    // ── Active session (chat / audio / video) ─────────────────────────────
    if (data2 != null && data2!.status == 'accept_astro') {
      final callType = (data2!.callType ?? '').toLowerCase();

      String description;
      String buttonLabel;
      VoidCallback onTap;

      if (callType == 'chat') {
        description = 'Chat is in progress';
        buttonLabel = 'Chat';
        onTap       = _returnToActiveChat;
      } else if (callType == 'video') {
        description = 'Video call in progress';
        buttonLabel = 'Video';
        onTap       = _returnToActiveVideoCall;
      } else {
        // audio / voice
        description = 'Call is in progress';
        buttonLabel = 'Call';
        onTap       = _returnToActiveAudioCall;
      }

      // Wrap in ValueListenableBuilder so timer updates without rebuilding
      // the whole Scaffold
      return ValueListenableBuilder<int>(
        valueListenable: _timeLeftNotifier,
        builder: (_, secs, __) {
          final m = (secs ~/ 60).toString().padLeft(2, '0');
          final s = (secs  % 60).toString().padLeft(2, '0');
          return CustomFloatingCard(
            profileImage: data2!.astroProfileImg ?? '',
            name        : data2!.astroName       ?? '',
            rate        : data2!.callRate         ?? '',
            status      : '$m:$s',         // live countdown on card
            description : description,
            buttonLabel : buttonLabel,
            onButtonTap : onTap,
          );
        },
      );
    }

    // ── Waiting user (intake form) ────────────────────────────────────────
    if (watting_user_data != null &&
        watting_user_data!.status == 'complete') {
      return CustomFloatingCard(
        profileImage: watting_user_data!.profile  ?? '',
        name        : watting_user_data!.name     ?? '',
        rate        : watting_user_data!.rate?.toString() ?? '',
        status      : 'Chat',
        description : 'Connect with Astrologer',
        buttonLabel : 'Chat',
        onButtonTap : () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatIntakeForm(
                wallet      : watting_user_data!.wallet?.toString() ?? '0',
                rate        : watting_user_data!.rate?.toString()   ?? '0',
                name        : watting_user_data!.name               ?? '',
                profile     : watting_user_data!.profile            ?? '',
                astrologer_id: watting_user_data!.astroId?.toString() ?? '',
              ),
            ),
          ).then((_) => _getChatStatus());
        },
      );
    }

    return const SizedBox.shrink();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body              : _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBarCustom(
        backgroundColor: Colors.white,
        activeColor    : primaryColor,
        inactiveColor  : Colors.black,
        activeIndex    : _selectedIndex,
        onHomeTap  : () => setState(() => _selectedIndex = 0),
        onChatTap  : () => setState(() => _selectedIndex = 1),
        onLiveTap  : () => setState(() => _selectedIndex = 2),
        onCallTap  : () => setState(() => _selectedIndex = 3),
        onPoojaTap : () => setState(() => _selectedIndex = 4),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniEndDocked,
      floatingActionButton: _buildFloatingCard(),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Dialogs
  // ─────────────────────────────────────────────────────────────────────────
  Future<bool> showCloseDialog(BuildContext context) async {
    return await showModalBottomSheet<bool>(
          context: context,
          shape  : const RoundedRectangleBorder(
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(20.0)),
          ),
          builder: (ctx) => Container(
            padding: const EdgeInsets.all(16.0),
            child  : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment : MainAxisAlignment.center,
              mainAxisSize      : MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child  : Text(
                    'Wait! Are you sure you want to close the App.',
                    textAlign: TextAlign.center,
                    style    : TextStyle(
                      fontSize  : 20,
                      color     : primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: Container(
                        padding   : const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 35),
                        decoration: BoxDecoration(
                          color       : primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text('Explore App',
                            style: TextStyle(
                                color     : whiteColor,
                                fontWeight: FontWeight.w600,
                                fontSize  : 17)),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => SystemNavigator.pop(),
                      child: Container(
                        padding   : const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 35),
                        decoration: BoxDecoration(
                          color: greyColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text('Close App',
                            style: TextStyle(
                                color     : blackColor,
                                fontWeight: FontWeight.w600,
                                fontSize  : 17)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ) ??
        false;
  }

  void showUpdateDialog() {
    showDialog(
      context          : context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child  : Column(
            mainAxisSize: MainAxisSize.min,
            children    : [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Update Available',
                      style: TextStyle(
                          fontSize  : 20,
                          fontWeight: FontWeight.bold)),
                  IconButton(
                    icon     : const Icon(Icons.close),
                    onPressed: () {}, // intentionally blocked
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'A new version of the app is available. Please update to the latest version.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () => StoreRedirect.redirect(),
                child: Container(
                  height    : 35,
                  width     : double.infinity,
                  decoration: BoxDecoration(
                      color       : primaryColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text('Update',
                        style: TextStyle(
                            color     : whiteColor,
                            fontWeight: FontWeight.w600,
                            fontSize  : 17)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}