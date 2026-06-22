// import 'package:astro_gurujii/Screens/homeScreen/chatLisitngModel.dart';
// import 'package:astro_gurujii/Screens/homeScreen/view_chat_screen.dart';
// import 'package:astro_gurujii/Setup/app_colors.dart';
// import 'package:astro_gurujii/Utilities/CustomText.dart';
// import 'package:flutter/material.dart';
//
// import '../../Models/AstroDetailsModel.dart';
//
// class MyOrder extends StatelessWidget {
//   final List<Results> data;
//   final ChatListingModelN? chatListingModelN;
//   final Function(String) astroDetailsApi;
//
//   const MyOrder({
//     Key? key,
//     required this.astroDetailsApi,
//     required this.chatListingModelN,
//     required this.data,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     // Check if chatListingModelN or its data list is null or empty
//     if (chatListingModelN?.data?.isEmpty ?? true) {
//       return Center(
//         child: CustomText(
//           text: 'No chat data available',
//           fontSize: 18,
//           color: Colors.black,
//           fontWeight: FontWeight.w500,
//         ),
//       );
//     }
//
//     var chatData = chatListingModelN?.data?[0]; // Safely access the first element
//
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10), // More space on top/bottom for a balanced look
//       padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(30), // Bigger rounded corners for a modern feel
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1), // Soft shadow
//             spreadRadius: 2,
//             blurRadius: 12,
//             offset: Offset(0, 6), // Elevated effect
//           ),
//         ],
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start, // Align profile and buttons better
//         children: [
//           // Profile Section
//           CircleAvatar(
//             radius: 30,
//             backgroundImage: NetworkImage(
//               chatData?.astroProfileImg ?? '',
//             ),
//           ),
//           SizedBox(width: 15),
//           // Astrologer Details
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Name and Date/Time
//                 CustomText(
//                   text: chatData?.astroDisplayName ?? 'Astrologer Name',
//                   fontSize: 20,
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 SizedBox(height: 5),
//                 CustomText(
//                   text: chatData?.callDate ?? 'Date/Time',
//                   fontSize: 14,
//                   color: Colors.black54,
//                   fontWeight: FontWeight.w400,
//                 ),
//                 SizedBox(height: 15),
//                 // Buttons Section
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute space evenly between buttons
//                   children: [
//                     // View Chat Button with icon
//                     InkWell(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (ctx) => ChatViewOnly(
//                               channelID: chatData?.fbChannelId.toString(),
//                               fbchannelID: chatData?.channelId,
//                               astrologer_id: chatData?.astrId,
//                               name: chatData?.userName,
//                               astroName: chatData?.astroDisplayName,
//                               gender: "",
//                               gid: chatData?.fbChannelId,
//                               currency: "INR",
//                               astrologer_image: chatData?.astroProfileImg,
//                               rating: chatData?.rating,
//                             ),
//                           ),
//                         );
//                       },
//                       child: Container(
//                         padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [AppColors.appblueColor, Colors.blueAccent],
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                           ),
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(Icons.chat_bubble_outline, color: Colors.white, size: 15), // Chat icon
//                             SizedBox(width: 3),
//                             CustomText(
//                               text: 'View Chat',
//                               color: Colors.white,
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 10),
//                     // Chat Again Button with icon
//                     InkWell(
//                       onTap: () async {
//                         /// 1 check status astrologer is busy or offline
//                         // await getProfile();
//                         await  astroDetailsApi(chatListingModelN?.data![0].astrId);
//
//                         if (data[0].is_busy == 0 &&
//                             data[0].isChatOnline == "off") {
//                           callNotifyMeApi(
//                               id: data[0].id.toString(), type: "chat");
//                         } else {
//                           var callRate =
//                           (data[0].per_min_chat_offer.isEmpty)
//                               ? data[0].perMinChat.toString()
//                               : data[0].per_min_chat_offer.toString();
//                           if (setCheckForChat(
//                               wallet.toString(), callRate)) {
//                             bottomSheet(
//                                 data[0].astro_number.toString(),
//                                 context,
//                                 data[0].id.toString(),
//                                 (data[0].per_min_chat_offer.isEmpty)
//                                     ? data[0].perMinChat.toString()
//                                     : data[0]
//                                     .per_min_chat_offer
//                                     .toString(),
//                                 "5",
//                                 data[0].profileImg,
//                                 currency,
//                                 "+91",
//                                 data[0].name,
//                                 wallet.toString(),
//                                 "chat",
//                                 loading);
//                           } else {
//
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (ctx) => ChatIntakeForm(
//                                         wallet: wallet.toString(),
//                                         rate: callRate,
//                                         name: data[0].name,
//                                         profile: data[0].profileImg,
//                                         astrologer_id:
//                                         data[0].id.toString())))
//                                 .then((value) => {getProfile()});
//
//                           }
//                         }
//                       },
//                       child: Container(
//                         padding: EdgeInsets.symmetric(vertical: 10, horizontal: 7),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(30),
//                           border: Border.all(color: AppColors.appblueColor),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(Icons.refresh, color: AppColors.appblueColor, size: 15), // Refresh icon
//                             SizedBox(width: 3),
//                             CustomText(
//                               text: 'Chat Again',
//                               color: AppColors.appblueColor,
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
