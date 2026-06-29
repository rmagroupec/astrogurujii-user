// // lib/Screens/live/components/bottom_section.dart
// // Changes from original:
// //  1. Accepts private-call props (privateCallState, callbacks)
// //  2. Phone icon in _RightIconRail now triggers onRequestPrivateCall / onEndPrivateCall
// //  3. Requesting badge (spinner + cancel) shown above input when pending
// //  4. Active badge (lock + mic toggle + end) shown above input when connected
// //  5. Everything else (gift, chat, input bar) is identical

// import 'dart:collection';

// import 'package:astro_gurujii/Screens/live/LiveVideoCallScreen.dart';
// import 'package:astro_gurujii/Screens/live/components/chat_streem.dart';
// import 'package:astro_gurujii/Setup/SetUp.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../Models/GetGiftModel.dart';
// import 'gift_bottm_sheet.dart';

// class BottomSection extends StatefulWidget {
//   final String screenType;

//   TextEditingController textEditingController;
//   ScrollController listScrollController;
//   FocusNode focusNode;
//   DatabaseReference messageChatReference;
//   String channelName;
//   String astroId;
//   var id;
//   List<Data>? dataGifts;

//   // ── Private call props (new) ──────────────────────────────────────────────
//   final _PrivateCallState privateCallState;
//   final bool privateMicMuted;
//   final Future<void> Function() onRequestPrivateCall;
//   final Future<void> Function() onEndPrivateCall;
//   final Future<void> Function() onCancelRequest;
//   final Future<void> Function() onTogglePrivateMic;

//   BottomSection({
//     Key? key,
//     required this.textEditingController,
//     required this.listScrollController,
//     required this.focusNode,
//     required this.dataGifts,
//     required this.astroId,
//     required this.id,
//     required this.messageChatReference,
//     required this.channelName,
//     required this.screenType,
//     // private call
//     this.privateCallState = _PrivateCallState.none,
//     this.privateMicMuted = false,
//     required this.onRequestPrivateCall,
//     required this.onEndPrivateCall,
//     required this.onCancelRequest,
//     required this.onTogglePrivateMic,
//   }) : super(key: key);

//   @override
//   State<BottomSection> createState() => _BottomSectionState();
// }

// class _BottomSectionState extends State<BottomSection> {
//   bool muted = true;
//   String? id;
//   SharedPreferences? prefs;
//   String groupChatId = '';

//   TextEditingController textTobeSend = TextEditingController();

//   int usersPerMinute = 0;
//   int giftsPerMinute = 0;
//   int hourglassBadgeCount = 0;

//   Future<void> onSendMessage(String content, int type) async {
//     if (content.trim() == '') {
//       Fluttertoast.showToast(
//           msg: 'Nothing to send',
//           backgroundColor: Colors.black,
//           textColor: Colors.red);
//       return;
//     }

//     prefs = await SharedPreferences.getInstance();
//     id = prefs?.getString('id') ?? '';
//     if (id.hashCode <= widget.channelName.hashCode) {
//       groupChatId = '$id-${widget.channelName}';
//     } else {
//       groupChatId = '${widget.channelName}-$id';
//     }

//     var user_id = prefs?.getString('id');
//     var name = prefs?.getString('name');
//     var timestamp = DateTime.now().millisecondsSinceEpoch;
//     var messageSenderRef = 'GroupLive/${widget.channelName}';
//     var messageReceiverRef = 'GroupLive/${widget.channelName}';

//     widget.messageChatReference = widget.messageChatReference
//         .child('Group')
//         .child(widget.channelName)
//         .push();

//     var messagePushId = widget.messageChatReference.key;
//     Map reqBody = {
//       'date': '',
//       'from': user_id,
//       'message': content,
//       'message_id': messagePushId,
//       'date_time': timestamp,
//       'name': name,
//       'time': '',
//     };

//     var s1 = '$messageSenderRef/$messagePushId';
//     var s2 = '$messageReceiverRef/$messagePushId';

//     var MessageBodyDetails = HashMap<String, Map>();
//     MessageBodyDetails[s1] = reqBody;
//     MessageBodyDetails[s2] = reqBody;

//     FirebaseDatabase.instance.ref().update(MessageBodyDetails);
//   }

//   void _openGiftSheet() {
//     GiftBottomSheets.showGistBottomSheet(
//       screenType: widget.screenType,
//       id: widget.id.toString(),
//       context: context,
//       dataGifts: widget.dataGifts,
//       astroId: widget.astroId.toString(),
//     );
//   }

//   void _shareApp() {
//     Share.share(
//         'https://play.google.com/store/apps/details?id=com.user.astrogurujii&hl=en_IN');
//   }

//   void _onPhoneTap() {
//     final state = widget.privateCallState;
//     if (state == _PrivateCallState.none) {
//       widget.onRequestPrivateCall();
//     } else if (state == _PrivateCallState.accepted) {
//       widget.onEndPrivateCall();
//     }
//     // if requesting, phone icon is disabled (spinner shown separately)
//   }

//   void _onSendRailTap() {
//     _shareApp();
//   }

//   // ─────────────────────────────────────────────────────────────────────────
//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;
//     const double inputBarHeight = 56;

//     final isRequesting =
//         widget.privateCallState == _PrivateCallState.requesting;
//     final isActive = widget.privateCallState == _PrivateCallState.accepted;

//     return Container(
//       height: height * 0.5,
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [
//             const Color.fromRGBO(0, 0, 0, 0),
//             Colors.black.withOpacity(0.3),
//           ],
//         ),
//       ),
//       child: Stack(
//         children: [
//           // ── Left column: Send Gift + chat feed ──────────────────────────
//           Positioned(
//             left: 12,
//             right: width * 0.22,
//             bottom: inputBarHeight + 12,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 _SendGiftButton(onTap: _openGiftSheet),
//                 const SizedBox(height: 10),
//                 ChatStreem(
//                   textEditingController: widget.textEditingController,
//                   listScrollController: widget.listScrollController,
//                   focusNode: widget.focusNode,
//                   channelName: widget.channelName,
//                   messageChatReference: widget.messageChatReference,
//                 ),
//               ],
//             ),
//           ),

//           // ── Right vertical icon rail ─────────────────────────────────────
//           Positioned(
//             right: 10,
//             bottom: inputBarHeight + 12,
//             child: _RightIconRail(
//               hourglassBadgeCount: hourglassBadgeCount,
//               usersPerMinute: usersPerMinute,
//               giftsPerMinute: giftsPerMinute,
//               privateCallState: widget.privateCallState,
//               onSendTap: _onSendRailTap,
//               onGiftTap: _openGiftSheet,
//               onPhoneTap: _onPhoneTap,
//             ),
//           ),

//           // ── Private call active badge ─────────────────────────────────────
//           if (isActive)
//             Positioned(
//               left: 12,
//               right: width * 0.22,
//               bottom: inputBarHeight + 12 + 60,
//               child: _PrivateActiveBadge(
//                 width: width,
//                 isMuted: widget.privateMicMuted,
//                 onToggleMic: widget.onTogglePrivateMic,
//                 onEnd: widget.onEndPrivateCall,
//               ),
//             ),

//           // ── Requesting badge ──────────────────────────────────────────────
//           if (isRequesting)
//             Positioned(
//               left: 12,
//               right: width * 0.22,
//               bottom: inputBarHeight + 12 + 60,
//               child: _RequestingBadge(
//                 onCancel: widget.onCancelRequest,
//               ),
//             ),

//           // ── Bottom "Say hi..." input bar ──────────────────────────────────
//           Positioned(
//             left: 0,
//             right: 0,
//             bottom: 0,
//             child: Container(
//               height: inputBarHeight,
//               padding: EdgeInsets.symmetric(
//                   horizontal: width / 28.26, vertical: 8),
//               color: Colors.black.withOpacity(0.30),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Container(
//                       padding: EdgeInsets.symmetric(
//                           horizontal: width / 42.44),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius:
//                             BorderRadius.circular(width / 14.33),
//                       ),
//                       child: TextFormField(
//                         maxLines: 1,
//                         controller: textTobeSend,
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: width / 28.26,
//                           fontWeight: FontWeight.w400,
//                         ),
//                         decoration: InputDecoration(
//                           hintText: 'Say hi...',
//                           border: InputBorder.none,
//                           focusedBorder: InputBorder.none,
//                           enabledBorder: InputBorder.none,
//                           hintStyle: TextStyle(
//                             color: Colors.black54,
//                             fontSize: width / 28.26,
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
//                         onFieldSubmitted: (val) {
//                           onSendMessage(textTobeSend.text.toString(), 0);
//                           textTobeSend.clear();
//                         },
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: width / 42.40),
//                   InkWell(
//                     onTap: () {
//                       onSendMessage(textTobeSend.text.toString(), 0);
//                       textTobeSend.clear();
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.all(9),
//                       decoration: const BoxDecoration(
//                           color: Colors.blue,
//                           shape: BoxShape.circle),
//                       child: Icon(Icons.send,
//                           color: Colors.white,
//                           size: width / 19.27),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ═════════════════════════════════════════════════════════════════════════════
// // Sub-widgets
// // ═════════════════════════════════════════════════════════════════════════════

// // ── Send Gift pill ────────────────────────────────────────────────────────────
// class _SendGiftButton extends StatelessWidget {
//   final VoidCallback onTap;
//   const _SendGiftButton({required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(30),
//       child: Container(
//         padding:
//             const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(30),
//         ),
//         child: const Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(Icons.card_giftcard, color: Colors.black87, size: 16),
//             SizedBox(width: 6),
//             Text(
//               'Send Gift',
//               style: TextStyle(
//                 color: Colors.black87,
//                 fontSize: 13,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ── Right vertical icon rail ──────────────────────────────────────────────────
// class _RightIconRail extends StatelessWidget {
//   final int hourglassBadgeCount;
//   final int usersPerMinute;
//   final int giftsPerMinute;
//   final _PrivateCallState privateCallState;
//   final VoidCallback onSendTap;
//   final VoidCallback onGiftTap;
//   final VoidCallback onPhoneTap;

//   const _RightIconRail({
//     required this.hourglassBadgeCount,
//     required this.usersPerMinute,
//     required this.giftsPerMinute,
//     required this.privateCallState,
//     required this.onSendTap,
//     required this.onGiftTap,
//     required this.onPhoneTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final w = MediaQuery.of(context).size.width;
//     final isActive = privateCallState == _PrivateCallState.accepted;
//     final isRequesting = privateCallState == _PrivateCallState.requesting;

//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         // Send / share
//         _RailIconButton(
//           icon: Icons.send_rounded,
//           onTap: onSendTap,
//           width: w,
//         ),
//         SizedBox(height: w * 0.04),

//         // Gift
//         _RailIconButton(
//           icon: Icons.card_giftcard_rounded,
//           onTap: onGiftTap,
//           width: w,
//         ),
//         SizedBox(height: w * 0.04),

//         // Hourglass with badge
//         Stack(
//           clipBehavior: Clip.none,
//           children: [
//             _RailIconButton(
//               icon: Icons.hourglass_bottom_rounded,
//               onTap: () {},
//               width: w,
//             ),
//             if (hourglassBadgeCount > 0)
//               Positioned(
//                 top: -4,
//                 right: -4,
//                 child: Container(
//                   padding: const EdgeInsets.all(3),
//                   decoration: const BoxDecoration(
//                       color: Colors.red, shape: BoxShape.circle),
//                   child: Text(
//                     '$hourglassBadgeCount',
//                     style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 8,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//         SizedBox(height: w * 0.04),

//         // Phone — private call
//         GestureDetector(
//           onTap: isRequesting ? null : onPhoneTap,
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 200),
//             width: w * 0.10,
//             height: w * 0.10,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: isActive
//                   ? Colors.green.withOpacity(0.25)
//                   : isRequesting
//                       ? Colors.orange.withOpacity(0.20)
//                       : Colors.white.withOpacity(0.15),
//               border: Border.all(
//                 color: isActive
//                     ? Colors.green
//                     : isRequesting
//                         ? Colors.orange
//                         : Colors.white24,
//                 width: 1.5,
//               ),
//             ),
//             child: isRequesting
//                 ? const Padding(
//                     padding: EdgeInsets.all(10),
//                     child: CircularProgressIndicator(
//                         color: Colors.orange,
//                         strokeWidth: 2),
//                   )
//                 : Icon(
//                     isActive
//                         ? Icons.call_rounded
//                         : Icons.call_outlined,
//                     color:
//                         isActive ? Colors.green : Colors.white70,
//                     size: w * 0.045,
//                   ),
//           ),
//         ),

//         SizedBox(height: w * 0.04),

//         // Viewers per min
//         _StatLabel(
//           icon: Icons.people_alt_outlined,
//           value: '$usersPerMinute/m',
//           width: w,
//         ),
//         SizedBox(height: w * 0.025),

//         // Gifts per min
//         _StatLabel(
//           icon: Icons.circle,
//           iconColor: Colors.red,
//           value: '$giftsPerMinute/m',
//           width: w,
//         ),
//       ],
//     );
//   }
// }

// class _RailIconButton extends StatelessWidget {
//   final IconData icon;
//   final VoidCallback onTap;
//   final double width;

//   const _RailIconButton({
//     required this.icon,
//     required this.onTap,
//     required this.width,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: width * 0.10,
//         height: width * 0.10,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: Colors.white.withOpacity(0.15),
//         ),
//         child:
//             Icon(icon, color: Colors.white70, size: width * 0.045),
//       ),
//     );
//   }
// }

// class _StatLabel extends StatelessWidget {
//   final IconData icon;
//   final Color iconColor;
//   final String value;
//   final double width;

//   const _StatLabel({
//     required this.icon,
//     required this.value,
//     required this.width,
//     this.iconColor = Colors.white70,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(icon, color: iconColor, size: width * 0.035),
//         const SizedBox(width: 3),
//         Text(value,
//             style: TextStyle(
//                 color: Colors.white70, fontSize: width * 0.028)),
//       ],
//     );
//   }
// }

// // ── Private call active badge ─────────────────────────────────────────────────
// class _PrivateActiveBadge extends StatelessWidget {
//   final double width;
//   final bool isMuted;
//   final Future<void> Function() onToggleMic;
//   final Future<void> Function() onEnd;

//   const _PrivateActiveBadge({
//     required this.width,
//     required this.isMuted,
//     required this.onToggleMic,
//     required this.onEnd,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(
//           horizontal: width * 0.03, vertical: width * 0.018),
//       decoration: BoxDecoration(
//         color: Colors.black.withOpacity(0.65),
//         borderRadius: BorderRadius.circular(16),
//         border:
//             Border.all(color: Colors.green.withOpacity(0.5), width: 1),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const Icon(Icons.lock_outline, color: Colors.white54, size: 13),
//           const SizedBox(width: 6),
//           const Text('Private call',
//               style: TextStyle(color: Colors.white, fontSize: 12)),
//           const SizedBox(width: 12),
//           GestureDetector(
//             onTap: onToggleMic,
//             child: Icon(
//               isMuted ? Icons.mic_off : Icons.mic,
//               color: isMuted ? Colors.red : Colors.white,
//               size: width * 0.045,
//             ),
//           ),
//           const SizedBox(width: 8),
//           GestureDetector(
//             onTap: onEnd,
//             child: Icon(Icons.call_end_rounded,
//                 color: Colors.red, size: width * 0.045),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ── Requesting badge ──────────────────────────────────────────────────────────
// class _RequestingBadge extends StatelessWidget {
//   final Future<void> Function() onCancel;
//   const _RequestingBadge({required this.onCancel});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding:
//           const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.black.withOpacity(0.65),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//             color: Colors.orange.withOpacity(0.5), width: 1),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const SizedBox(
//             width: 12,
//             height: 12,
//             child: CircularProgressIndicator(
//                 color: Colors.orange, strokeWidth: 2),
//           ),
//           const SizedBox(width: 8),
//           const Text('Waiting for response...',
//               style: TextStyle(color: Colors.white70, fontSize: 12)),
//           const SizedBox(width: 8),
//           GestureDetector(
//             onTap: onCancel,
//             child: const Icon(Icons.close_rounded,
//                 color: Colors.white54, size: 16),
//           ),
//         ],
//       ),
//     );
//   }
// }