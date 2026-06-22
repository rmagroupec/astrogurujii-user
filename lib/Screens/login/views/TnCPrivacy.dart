// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:life_guru/app/common/app_images.dart';
// import 'package:life_guru/app/common/utils/webViewUrls.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class TnCPrivacyPolicy extends StatefulWidget {
//   var url;
//   TnCPrivacyPolicy({Key? key, this.url}) : super(key: key);

//   @override
//   State<TnCPrivacyPolicy> createState() => _TnCPrivacyPolicyState();
// }

// class _TnCPrivacyPolicyState extends State<TnCPrivacyPolicy> {
//   var loadingPercentage = 0;
//   late final WebViewController controller;

//   @override
//   void initState() {
//     super.initState();
//     // controller = WebViewController()
//     //   ..setNavigationDelegate(NavigationDelegate(

//     //     onPageStarted: (url) {
//     //       setState(() {
//     //         loadingPercentage = 0;
//     //       });
//     //     },
//     //     onProgress: (progress) {
//     //       setState(() {
//     //         loadingPercentage = progress;
//     //       });
//     //     },
//     //     onPageFinished: (url) {
//     //       setState(() {
//     //         loadingPercentage = 100;
//     //       });
//     //     },
//     //   ))
//     //   ..loadRequest(
//     //     Uri.parse(widget.url),
//     //   );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: PreferredSize(
//           preferredSize: const Size.fromHeight(80),
//           child: Container(
//             padding: const EdgeInsets.fromLTRB(15, 40, 15, 15),
//             width: Get.width,
//             decoration: const BoxDecoration(
//                 gradient: LinearGradient(colors: [
//               Color.fromRGBO(255, 221, 181, 1),
//               Color.fromRGBO(255, 249, 237, 1),
//             ])),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 SvgPicture.asset(AppImages.lgIcon),
// // Image.asset(
// //   AppImages.lgIcon,
// // ),
// // Row(
// //   children: [
// //     appBarActionIcons(Icons.notifications_active, "1"),
// //     space(w: 10),
// //     InkWell(
// //         onTap: () {
// //           Get.to(WalletView());
// //         },
// //         child: appBarActionIcons(Icons.wallet, "2"))
// //   ],
// // ),
//               ],
//             ),
//           ),
//         ),
//         body: Stack(
//           children: [
//             WebViewWidget(
//               controller: controller,
//             ),
//             if (loadingPercentage < 100)
//               LinearProgressIndicator(
//                 value: loadingPercentage / 100.0,
//               ),
//           ],
//         ));
//   }
// }
