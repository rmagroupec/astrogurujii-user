// // lib/Screens/live/components/pageViewScreen.dart
// // Accepts and forwards private-call props to LiveScreenInfo

// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:astro_gurujii/Screens/live/LiveVideoCallScreen.dart';
// import 'package:astro_gurujii/Screens/live/components/LiveScreenInfo.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';

// import '../../Models/GetGiftModel.dart';

// class PageViewScreen extends StatefulWidget {
//   final String screenType;
//   final RtcEngine agoraEngine;

//   final TextEditingController textEditingController;
//   final ScrollController listScrollController;
//   final FocusNode focusNode;
//   final DatabaseReference messageChatReference;
//   final String channelName;
//   final String? astroid;
//   final String name;
//   final String astroImage;
//   final List<String> numberOfuserJoin;
//   final List<Data>? dataGifts;
//   final String? id;

//   // ── Private call props ────────────────────────────────────────────────────
//   final bool isUserConnected;
//   final _PCState pcState;
//   final int secondsLeft;
//   final String countdownLabel;
//   final bool privateMicMuted;
//   final void Function() onPhoneTap;
//   final Future<void> Function() onEndPrivateCall;
//   final Future<void> Function() onTogglePrivateMic;

//   const PageViewScreen({
//     Key? key,
//     this.id,
//     required this.textEditingController,
//     required this.dataGifts,
//     required this.listScrollController,
//     this.astroid,
//     required this.focusNode,
//     required this.messageChatReference,
//     required this.channelName,
//     required this.name,
//     required this.astroImage,
//     required this.agoraEngine,
//     required this.numberOfuserJoin,
//     required this.screenType,
//     // private call
//     this.isUserConnected  = false,
//     this.pcState          = _PCState.none,
//     this.secondsLeft      = 0,
//     this.countdownLabel   = '00 m 00 s',
//     this.privateMicMuted  = false,
//     required this.onPhoneTap,
//     required this.onEndPrivateCall,
//     required this.onTogglePrivateMic,
//   }) : super(key: key);

//   @override
//   State<PageViewScreen> createState() => _PageViewScreenState();
// }

// class _PageViewScreenState extends State<PageViewScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return PageView(
//       controller     : PageController(initialPage: 1),
//       scrollDirection: Axis.horizontal,
//       children: [
//         Container(color: Colors.transparent, child: const SizedBox()),
//         LiveScreenInfo(
//           id                   : widget.id,
//           textEditingController: widget.textEditingController,
//           listScrollController : widget.listScrollController,
//           astroid              : widget.astroid,
//           focusNode            : widget.focusNode,
//           channelName          : widget.channelName,
//           messageChatReference : widget.messageChatReference,
//           astroImage           : widget.astroImage,
//           name                 : widget.name,
//           dataGifts            : widget.dataGifts,
//           numberOfuserJoin     : widget.numberOfuserJoin,
//           screenType           : widget.screenType,
//           agoraEngine          : widget.agoraEngine,
//           // private call
//           isUserConnected      : widget.isUserConnected,
//           pcState              : widget.pcState,
//           secondsLeft          : widget.secondsLeft,
//           countdownLabel       : widget.countdownLabel,
//           privateMicMuted      : widget.privateMicMuted,
//           onPhoneTap           : widget.onPhoneTap,
//           onEndPrivateCall     : widget.onEndPrivateCall,
//           onTogglePrivateMic   : widget.onTogglePrivateMic,
//         ),
//       ],
//     );
//   }
// }