//
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:natasha/WebServices/HttpServices.dart';
// import 'package:natasha/model/AddedClientModal.dart';
// import 'package:natasha/model/FeedBackModal.dart';
// import 'package:natasha/model/GetProfileModal.dart';
// import 'package:natasha/screens/AllRatingScreen.dart';
// import 'package:natasha/screens/CustomDrawer.dart';
// import 'package:natasha/screens/MyClients.dart';
// import 'package:natasha/screens/Notification.dart';
// import 'package:natasha/utils/customToast.dart';
// import 'package:percent_indicator/linear_percent_indicator.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../utils/CustomText.dart';
// import 'package:badges/badges.dart' as badges;
// import '../utils/Elevated_Button.dart';
// import '../utils/sharedWidgets.dart';
// import '../values/color.dart';
// import '../values/fonts.dart';
// import '../values/imageLinks.dart';
// import '../values/strings.dart';
//
// class Dashboard extends StatefulWidget {
//   const Dashboard({Key? key}) : super(key: key);
//
//   @override
//   State<Dashboard> createState() => _DashboardState();
// }
//
// class _DashboardState extends State<Dashboard> {
//   final HttpServices httpServices = HttpServices();
//   List<ClientData> data = [];
//   List<FeedbackArray> feedbackArray=[];
//   bool _isLoading = true;
//   FeedData? feedData;
//   String? channelId = "",totalCount="",notiCount="0";
//   void client() async {
//     var res = await httpServices.clientData();
//     if (res!.status == true) {
//       setState(() {
//         totalCount=res.today_count.toString();
//         data = res.data!;
//         channelId = res.channelId;
//       });
//     } else {
//       toast.showFlutterToast(res.message!);
//     }
//   }
//
//   void feedBack()async{
//     var res=await httpServices.feedBAckApi();
//     if(res!.status==true)
//     {
//       setState((){
//         feedData=res.data;
//         feedbackArray=res.feedbackArray!;
//       });
//     }
//     else{
//
//       Fluttertoast.showToast(msg: res.message!);
//
//     }
//   }
//
//   Future<void> getProfileData() async {
//     var res = await httpServices.getProfile();
//     if (res?.status == true) {
//       final prefs = await SharedPreferences.getInstance();
//       prefs.getString('token');
//       setState(() {
//         details = res!.data;
//         _isLoading = false;
//         prefs.setString('name', res.data!.name! ?? '');
//         prefs.setString('number', res.data!.number! ?? '');
//         prefs.setString('email', res.data!.email! ?? '');
//         prefs.setString('image', res.data!.image!);
//        notiCount=res.unseen.toString();
//       });
//     } else {
//       _isLoading = false;
//     }
//   }
//
//
//   GetProfileData? details;
//
//   @override
//   initState() {
//     getProfileData();
//     client();
//     feedBack();
//     super.initState();
//   }
//   Future onRefresh()async{
//     getProfileData();
//     client();
//     feedBack();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return RefreshIndicator(
//       onRefresh: onRefresh,
//       child: Scaffold(
//         key: _scaffoldKey,
//         drawer: const CustomDrawer(),
//         backgroundColor: ColorData.colorF6F6F6,
//         appBar: PreferredSize(
//           preferredSize: const Size.fromHeight(110.0),
//           child: _buildAppBar(context),
//         ),
//         body: (_isLoading)
//             ? const Center(
//                 child: CircularProgressIndicator(),
//               )
//             : SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     const SizedBox(
//                       height: 10,
//                     ),
//
//                     /// Hello Natasha & calendar
//                     Container(
//                       margin: const EdgeInsets.symmetric(horizontal: 10),
//                       height: 50,
//                       width: MediaQuery.of(context).size.width,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           ///Hello Natasha
//                           Container(
//                             height: 50,
//                             alignment: Alignment.centerLeft,
//                             child: Column(
//                               children: [
//                                 Text("Hello ${details!.name.toString()}",
//                                     style: GoogleFonts.poppins(
//                                         textStyle: TextStyle(
//                                             color: ColorData.colorFF6A66,
//                                             fontSize: 20,
//                                             fontWeight: FontWeight.w500))),
//                                 // Text(
//                                 //   "Welcome Back...",
//                                 //   style: GoogleFonts.poppins(
//                                 //       textStyle: TextStyle(
//                                 //           color: ColorData.color1F1F1F,
//                                 //           fontSize: 12,
//                                 //           fontWeight: FontWeight.w300)),
//                                 // )
//                               ],
//                             ),
//                           ),
//
//                           const Spacer(),
//
//                           ///Calendar
//                           // Container(
//                           //   height: 30,
//                           //   width: 90,
//                           //   padding: EdgeInsets.zero,
//                           //   alignment: Alignment.center,
//                           //   decoration: BoxDecoration(
//                           //       border: Border.all(color: Colors.black12),
//                           //       color: Colors.white,
//                           //       borderRadius: BorderRadius.circular(7)),
//                           //   child: Row(
//                           //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           //     children: [
//                           //       Text(
//                           //         'Today',
//                           //         style: GoogleFonts.dmSans(
//                           //             color: ColorData.color747474,
//                           //             fontSize: 14,
//                           //             fontWeight: FontWeight.w400),
//                           //       ),
//                           //       IconButton(
//                           //           onPressed: () {},
//                           //           icon: SvgPicture.asset(ImageLinks.calender)
//                           //         // Icon(
//                           //         //   Icons.calendar_month,
//                           //         //   color: ColorData.color444444,
//                           //       )
//                           //     ],
//                           //   ),
//                           // )
//                         ],
//                       ),
//                     ),
//
//                     /// Meetings and clients cards
//                     Container(
//                       margin: const EdgeInsets.symmetric(horizontal: 10),
//                       child: Row(
//                         children: [
//                           /// My Scheduled Meetings
//                           Expanded(
//                             flex: 1,
//                             child: Container(
//                               height: 155,
//                               alignment: Alignment.center,
//                               // width: MediaQuery.of(context).size.width/3,
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(15),
//                                   gradient: LinearGradient(
//                                       begin: Alignment.bottomCenter,
//                                       end: Alignment.topCenter,
//                                       colors: [
//                                         ColorData.color000000,
//                                         ColorData.colorF2F2F2,
//                                       ])),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   const SizedBox(height: 12),
//                                   Container(
//                                     alignment: Alignment.topLeft,
//                                     margin: const EdgeInsets.symmetric(
//                                       horizontal: 8,
//                                     ),
//                                     child: SvgPicture.asset(
//                                       ImageLinks.meetings,
//                                       height: 25,
//                                       width: 25,
//                                     ),
//                                   ),
//                                   //  const Spacer(),
//                                   const SizedBox(height: 12),
//                                   Container(
//                                     alignment: Alignment.center,
//                                     child: Text(
//                                       'Today Clients',
//                                       style: GoogleFonts.poppins(
//                                           color: ColorData.color45413C,
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w500),
//                                     ),
//                                   ),
//                                   Container(
//                                     alignment: Alignment.center,
//                                     child: Text(
//                                       totalCount.toString()??"",
//                                       style: GoogleFonts.poppins(
//                                           color: ColorData.colorFFFFFF,
//                                           fontSize: 24,
//                                           fontWeight: FontWeight.w500),
//                                     ),
//                                   ),
//                                   // Container(
//                                   //   alignment: Alignment.center,
//                                   //   child: Text(
//                                   //     StringData.scheduledMeeting,
//                                   //     textAlign: TextAlign.center,
//                                   //     overflow: TextOverflow.visible,
//                                   //     style: GoogleFonts.poppins(
//                                   //         color: ColorData.colorFFFFFF,
//                                   //         fontSize: 10,
//                                   //         fontWeight: FontWeight.w300),
//                                   //   ),
//                                   // ),
//                                   const Spacer(),
//                                   InkWell(
//                                     onTap: () {},
//                                     child: Container(
//                                         margin: const EdgeInsets.symmetric(
//                                             horizontal: 8, vertical: 8),
//                                         alignment: Alignment.bottomRight,
//                                         child:
//                                             SvgPicture.asset(ImageLinks.eyeIcon)),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//
//                           const SizedBox(
//                             width: 10,
//                           ),
//
//                           /// My Clients Box
//                           Expanded(
//                             flex: 2,
//                             child: Container(
//                               height: 155,
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(15),
//                                   gradient: LinearGradient(
//                                       begin: Alignment.bottomCenter,
//                                       end: Alignment.topCenter,
//                                       colors: [
//                                         ColorData.color000000,
//                                         ColorData.colorF2F2F2,
//                                       ])),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   const SizedBox(
//                                     height: 12,
//                                   ),
//                                   Row(
//                                     children: [
//                                       /// Image
//                                       Container(
//                                         alignment: Alignment.center,
//                                         margin: const EdgeInsets.symmetric(
//                                           horizontal: 10,
//                                         ),
//                                         child: SvgPicture.asset(
//                                           ImageLinks.clients,
//                                           height: 25,
//                                           width: 40,
//                                         ),
//                                       ),
//                                       const SizedBox(
//                                         width: 8,
//                                       ),
//
//                                       ///My Clients Text
//                                       Container(
//                                         alignment: Alignment.center,
//                                         child: Text(
//                                           'My Clients',
//                                           style: GoogleFonts.poppins(
//                                               color: ColorData.color45413C,
//                                               fontSize: 14,
//                                               fontWeight: FontWeight.w500),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//
//                                   const Spacer(),
//
//                                   /// Clients Added and total clients
//                                   Column(
//                                     crossAxisAlignment: CrossAxisAlignment.center,
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Container(
//                                         alignment: Alignment.center,
//                                         child: Text(
//                                           data.length.toString(),
//                                           style: GoogleFonts.poppins(
//                                               color: ColorData.colorFFFFFF,
//                                               fontSize: 24,
//                                               fontWeight: FontWeight.w500),
//                                         ),
//                                       ),
//                                       Container(
//                                         width: 75,
//                                         alignment: Alignment.center,
//                                         child: Text(
//                                           StringData.totalClients,
//                                           textAlign: TextAlign.center,
//                                           overflow: TextOverflow.visible,
//                                           style: GoogleFonts.poppins(
//                                               color: ColorData.colorFFFFFF,
//                                               fontSize: 10,
//                                               fontWeight: FontWeight.w300),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const Spacer(),
//                                   Container(
//                                       alignment: Alignment.center,
//                                       child: TextButton(
//                                           onPressed: () {
//                                             Get.to(MyClients(
//                                               data: data,
//                                               channelId: channelId,
//                                             ));
//                                           },
//                                           child: Text(
//                                             'View all',
//                                             style: GoogleFonts.poppins(
//                                                 textStyle: TextStyle(
//                                                     fontWeight: FontWeight.w500,
//                                                     fontSize: 12,
//                                                     color: ColorData.colorFF6A66,
//                                                     decoration: TextDecoration
//                                                         .underline)),
//                                           )))
//                                 ],
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//
//                     // const SizedBox(height: 18),
//                     //
//                     // /// Quick Launches
//                     // Container(
//                     //   margin: const EdgeInsets.only(left: 10),
//                     //   alignment: Alignment.centerLeft,
//                     //   child: Text('Quick launches',
//                     //       style: GoogleFonts.poppins(
//                     //           textStyle: TextStyle(
//                     //               fontWeight: FontWeight.w500,
//                     //               fontSize: 20,
//                     //               color: ColorData.color1F1F1F))),
//                     // ),
//
//                     // const SizedBox(
//                     //   height: 10,
//                     // ),
//
//                     // /// Create Remainder and active plans
//                     // Container(
//                     //   margin: const EdgeInsets.symmetric(horizontal: 10),
//                     //   height: 40,
//                     //   child: ListView(
//                     //     shrinkWrap: true,
//                     //     scrollDirection: Axis.horizontal,
//                     //     children: [
//                     //       Container(
//                     //         margin: const EdgeInsets.only(right: 10),
//                     //         height: 40,
//                     //         width: 250,
//                     //         decoration: BoxDecoration(
//                     //             border: Border.all(color: Colors.black12),
//                     //             color: Colors.white,
//                     //             borderRadius: BorderRadius.circular(7)),
//                     //         child: Row(
//                     //           children: [
//                     //             const SizedBox(
//                     //               width: 10,
//                     //             ),
//                     //             SvgPicture.asset(ImageLinks.createReminders),
//                     //             // const SizedBox(
//                     //             //   width: 10,
//                     //             // ),
//                     //             TextButton(
//                     //                 onPressed: () {},
//                     //                 child: Text(
//                     //                   'Create Reminders',
//                     //                   style: GoogleFonts.poppins(
//                     //                       textStyle: TextStyle(
//                     //                           fontWeight: FontWeight.w400,
//                     //                           fontSize: 12,
//                     //                           color: ColorData.color1F1F1F)),
//                     //                 ))
//                     //           ],
//                     //         ),
//                     //       ),
//                     //       Container(
//                     //         margin: const EdgeInsets.only(right: 10),
//                     //         height: 40,
//                     //         width: 250,
//                     //         decoration: BoxDecoration(
//                     //             border: Border.all(color: Colors.black12),
//                     //             color: Colors.white,
//                     //             borderRadius: BorderRadius.circular(7)),
//                     //         child: Row(
//                     //           children: [
//                     //             const SizedBox(
//                     //               width: 10,
//                     //             ),
//                     //             SvgPicture.asset(ImageLinks.activePlans),
//                     //             // const SizedBox(
//                     //             //   width: 10,
//                     //             // ),
//                     //             TextButton(
//                     //                 onPressed: () {},
//                     //                 child: Text(
//                     //                   'Active plans',
//                     //                   style: GoogleFonts.poppins(
//                     //                       textStyle: TextStyle(
//                     //                           fontWeight: FontWeight.w400,
//                     //                           fontSize: 12,
//                     //                           color: ColorData.color1F1F1F)),
//                     //                 ))
//                     //           ],
//                     //         ),
//                     //       )
//                     //     ],
//                     //   ),
//                     // ),
//
//                     // const SizedBox(
//                     //   height: 25,
//                     // ),
//
//                     ///Upload diet & workout plan
//                     // Container(
//                     //   margin: const EdgeInsets.only(left: 10),
//                     //   height: 130,
//                     //   child: Row(
//                     //     children: [
//                     //       ///Upload diet
//                     //       Container(
//                     //         margin: const EdgeInsets.only(right: 10),
//                     //         width: 125,
//                     //         decoration: BoxDecoration(
//                     //             border: Border.all(color: Colors.black12),
//                     //             color: Colors.white,
//                     //             borderRadius: BorderRadius.circular(10)),
//                     //         child: Column(
//                     //           children: [
//                     //             const SizedBox(
//                     //               height: 10,
//                     //             ),
//                     //             SvgPicture.asset(ImageLinks.diet),
//                     //             const SizedBox(
//                     //               height: 8,
//                     //             ),
//                     //             SizedBox(
//                     //               width: 70,
//                     //               child: Text(
//                     //                 'Upload Diet plan',
//                     //                 style: GoogleFonts.poppins(
//                     //                     fontWeight: FontWeight.w400, fontSize: 12),
//                     //                 overflow: TextOverflow.visible,
//                     //                 textAlign: TextAlign.center,
//                     //               ),
//                     //             ),
//                     //             const SizedBox(
//                     //               height: 10,
//                     //             ),
//                     //             MyElevatedButton(
//                     //                 onPressed: () {},
//                     //                 height: 20,
//                     //                 width: 90,
//                     //                 borderRadius: BorderRadius.circular(30),
//                     //                 child: Row(
//                     //                   children: [
//                     //                     Text(
//                     //                       'Upload',
//                     //                       style: GoogleFonts.poppins(
//                     //                           color: ColorData.colorFFFFFF,
//                     //                           fontWeight: FontWeight.w500,
//                     //                           fontSize: 10,
//                     //                           letterSpacing: -0.3),
//                     //                     ),
//                     //                     const SizedBox(
//                     //                       width: 5,
//                     //                     ),
//                     //                     Icon(
//                     //                       Icons.file_upload_outlined,
//                     //                       size: 12,
//                     //                       color: ColorData.colorFFFFFF,
//                     //                     )
//                     //                   ],
//                     //                 ))
//                     //           ],
//                     //         ),
//                     //       ),
//                     //
//                     //       const SizedBox(
//                     //         width: 12,
//                     //       ),
//                     //
//                     //       ///Upload workout
//                     //       Container(
//                     //         margin: const EdgeInsets.only(right: 10),
//                     //         width: 125,
//                     //         decoration: BoxDecoration(
//                     //             border: Border.all(color: Colors.black12),
//                     //             color: Colors.white,
//                     //             borderRadius: BorderRadius.circular(10)),
//                     //         child: Column(
//                     //           children: [
//                     //             const SizedBox(
//                     //               height: 10,
//                     //             ),
//                     //             SvgPicture.asset(ImageLinks.workout),
//                     //             const SizedBox(
//                     //               height: 8,
//                     //             ),
//                     //             SizedBox(
//                     //               width: 90,
//                     //               child: Text(
//                     //                 'Upload Workout plan',
//                     //                 style: GoogleFonts.poppins(
//                     //                     fontWeight: FontWeight.w400, fontSize: 12),
//                     //                 overflow: TextOverflow.visible,
//                     //                 textAlign: TextAlign.center,
//                     //               ),
//                     //             ),
//                     //             const SizedBox(
//                     //               height: 10,
//                     //             ),
//                     //             MyElevatedButton(
//                     //                 onPressed: () {},
//                     //                 height: 20,
//                     //                 width: 90,
//                     //                 borderRadius: BorderRadius.circular(30),
//                     //                 child: Row(
//                     //                   children: [
//                     //                     Text(
//                     //                       'Upload',
//                     //                       style: GoogleFonts.poppins(
//                     //                           color: ColorData.colorFFFFFF,
//                     //                           fontWeight: FontWeight.w500,
//                     //                           fontSize: 10,
//                     //                           letterSpacing: -0.3),
//                     //                     ),
//                     //                     const SizedBox(
//                     //                       width: 5,
//                     //                     ),
//                     //                     Icon(
//                     //                       Icons.file_upload_outlined,
//                     //                       size: 12,
//                     //                       color: ColorData.colorFFFFFF,
//                     //                     )
//                     //                   ],
//                     //                 ))
//                     //           ],
//                     //         ),
//                     //       )
//                     //     ],
//                     //   ),
//                     // ),
//
//                     // const SizedBox(
//                     //   height: 20,
//                     // ),
//
//                     ///Refer App
//                     // Container(
//                     //   margin: const EdgeInsets.symmetric(horizontal: 10),
//                     //   width: MediaQuery.of(context).size.width,
//                     //   decoration: BoxDecoration(
//                     //       border: Border.all(color: Colors.black26),
//                     //       borderRadius: BorderRadius.circular(10),
//                     //       color: Colors.white),
//                     //   child: Row(
//                     //     children: [
//                     //       Container(
//                     //         margin: const EdgeInsets.only(
//                     //             left: 8, right: 8, top: 5, bottom: 5),
//                     //         child: SvgPicture.asset(ImageLinks.sharePeople),
//                     //       ),
//                     //       Column(
//                     //         children: [
//                     //           Text(
//                     //             'Refer the app with your friends',
//                     //             style: GoogleFonts.poppins(
//                     //                 textStyle: const TextStyle(
//                     //                   fontWeight: FontWeight.w500,
//                     //                   fontSize: 14,
//                     //                   letterSpacing: -0.3,
//                     //                 )),
//                     //           ),
//                     //           const SizedBox(height: 13),
//                     //           Align(
//                     //             alignment: Alignment.bottomRight,
//                     //             child: ElevatedButton(
//                     //                 onPressed: () {},
//                     //                 style: ElevatedButton.styleFrom(
//                     //
//                     //                     shadowColor: Colors.transparent,
//                     //                     shape: RoundedRectangleBorder(
//                     //                         borderRadius: BorderRadius.circular(20)),
//                     //                     side: BorderSide(
//                     //                       color: ColorData.color676767,
//                     //                     )),
//                     //                 child: Text(
//                     //                   'Share Now',
//                     //                   style: GoogleFonts.poppins(
//                     //                       textStyle: TextStyle(
//                     //                           fontWeight: FontWeight.w500,
//                     //                           fontSize: 14,
//                     //                           letterSpacing: -0.3,
//                     //                           color: ColorData.colorFFFFFF)),
//                     //                 )),
//                     //           )
//                     //         ],
//                     //       )
//                     //     ],
//                     //   ),
//                     // ),
//
//                     const SizedBox(height: 35),
//
//                     /// Ratings and Reviews
//                     Container(
//                       margin: const EdgeInsets.symmetric(horizontal: 10),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text('Ratings & Reviews',
//                               style: GoogleFonts.poppins(
//                                   textStyle: TextStyle(
//                                       fontWeight: FontWeight.w500,
//                                       fontSize: 20,
//                                       color: ColorData.color1F1F1F))),
//                           Container(
//                             height: 20,
//                             width: 80,
//                             alignment: Alignment.centerRight,
//                             child: ElevatedButton(
//                                 onPressed: () {
//                                   Get.to(AllRatingScreen(feedbackArray: feedbackArray,));
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                     shadowColor: Colors.transparent,
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(35)),
//                                     side: BorderSide(
//                                       color: ColorData.color676767,
//                                     )),
//                                 child: Text(
//                                   'View all',
//                                   style: GoogleFonts.poppins(
//                                       textStyle: TextStyle(
//                                           fontWeight: FontWeight.w400,
//                                           fontSize: 12,
//                                           letterSpacing: -0.3,
//                                           color: ColorData.colorFFFFFF)),
//                                 )),
//                           )
//                         ],
//                       ),
//                     ),
//
//                     const SizedBox(
//                       height: 27,
//                     ),
//
//                     Container(
//                       margin: const EdgeInsets.symmetric(horizontal: 10),
//                       child: Row(
//                         children: [
//                           Container(
//                             margin: EdgeInsets.zero,
//                             child: Column(
//                               children: [
//                                 Row(
//                                   children: [
//                                     Text(
//                                       feedData!.ratePercent.toString()??"",
//                                       style: GoogleFonts.poppins(
//                                         fontWeight: FontWeight.w500,
//                                         fontSize: 20,
//                                         color: Colors.black,
//                                       ),
//                                     ),
//                                     Icon(
//                                       Icons.star,
//                                       color: ColorData.colorFFA62F,
//                                       size: 16,
//                                     )
//                                   ],
//                                 ),
//
//                                 // const SizedBox(height: 4),
//
//                                 Row(
//                                   children: [
//                                     const SizedBox(width: 10),
//                                     Icon(
//                                       Icons.person,
//                                       size: 13,
//                                       color: ColorData.color727272,
//                                     ),
//                                     Text(
//                                       '${feedData!.rateTotalUser.toString()??""} Total',
//                                       style: GoogleFonts.poppins(
//                                           fontWeight: FontWeight.w300,
//                                           fontSize: 12,
//                                           color: ColorData.color727272,
//                                           letterSpacing: -0.48),
//                                     )
//                                   ],
//                                 )
//                               ],
//                             ),
//                           ),
//                           const Spacer(),
//                           Container(
//                             margin: EdgeInsets.zero,
//                             alignment: Alignment.centerLeft,
//                             child: Column(
//                               children: [
//                                 Padding(
//                                   padding:
//                                       const EdgeInsets.symmetric(horizontal: 2),
//                                   child: Row(
//                                     children: [
//                                       Icon(Icons.star,
//                                           color: ColorData.colorFFA62F, size: 10),
//                                       Icon(Icons.star,
//                                           color: ColorData.colorFFA62F, size: 10),
//                                       Icon(Icons.star,
//                                           color: ColorData.colorFFA62F, size: 10),
//                                       Icon(Icons.star,
//                                           color: ColorData.colorFFA62F, size: 10),
//                                       Icon(Icons.star,
//                                           color: ColorData.colorFFA62F, size: 10),
//                                       LinearPercentIndicator(
//                                         width: 100.0,
//                                         lineHeight: 3,
//                                         percent: (double.parse(feedData!.s5.toString()))/100,
//                                         progressColor: ColorData.colorFF6A66,
//                                       ),
//                                       Text(
//                                         "${feedData!.s5.toString()}",
//                                         style: GoogleFonts.roboto(
//                                             textStyle: TextStyle(
//                                                 fontSize: 9,
//                                                 fontWeight: FontWeight.w300,
//                                                 color: ColorData.color727272)),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding:
//                                       const EdgeInsets.symmetric(horizontal: 2),
//                                   child: Row(
//                                     children: [
//                                       const Icon(Icons.star,
//                                           color: Colors.transparent, size: 10),
//                                       Icon(Icons.star,
//                                           color: ColorData.colorFFA62F, size: 10),
//                                       Icon(Icons.star,
//                                           color: ColorData.colorFFA62F, size: 10),
//                                       Icon(Icons.star,
//                                           color: ColorData.colorFFA62F, size: 10),
//                                       Icon(Icons.star,
//                                           color: ColorData.colorFFA62F, size: 10),
//                                       LinearPercentIndicator(
//                                         width: 100.0,
//                                         lineHeight: 3,
//                                         percent: (double.parse(feedData!.s4.toString()))/100,
//                                         progressColor: ColorData.colorFF6A66,
//                                       ),
//                                       Text(
//                                         "${feedData!.s4.toString()}",
//                                         style: GoogleFonts.roboto(
//                                             textStyle: TextStyle(
//                                                 fontSize: 9,
//                                                 fontWeight: FontWeight.w300,
//                                                 color: ColorData.color727272)),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding:
//                                       const EdgeInsets.symmetric(horizontal: 2),
//                                   child: Row(
//                                     children: [
//                                       const Icon(Icons.star,
//                                           color: Colors.transparent, size: 10),
//                                       const Icon(Icons.star,
//                                           color: Colors.transparent, size: 10),
//                                       Icon(Icons.star,
//                                           color: ColorData.colorFFA62F, size: 10),
//                                       Icon(Icons.star,
//                                           color: ColorData.colorFFA62F, size: 10),
//                                       Icon(Icons.star,
//                                           color: ColorData.colorFFA62F, size: 10),
//                                       LinearPercentIndicator(
//                                         width: 100.0,
//                                         lineHeight: 3,
//                                         percent: (double.parse(feedData!.s3.toString()))/100,
//                                         progressColor: ColorData.colorFF6A66,
//                                       ),
//                                       Text(
//                                         "${feedData!.s3.toString()}",
//                                         style: GoogleFonts.roboto(
//                                             textStyle: TextStyle(
//                                                 fontSize: 9,
//                                                 fontWeight: FontWeight.w300,
//                                                 color: ColorData.color727272)),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding:
//                                       const EdgeInsets.symmetric(horizontal: 2),
//                                   child: Row(
//                                     children: [
//                                       const Icon(Icons.star,
//                                           color: Colors.transparent, size: 10),
//                                       const Icon(Icons.star,
//                                           color: Colors.transparent, size: 10),
//                                       const Icon(Icons.star,
//                                           color: Colors.transparent, size: 10),
//                                       Icon(Icons.star,
//                                           color: ColorData.colorFFA62F, size: 10),
//                                       Icon(Icons.star,
//                                           color: ColorData.colorFFA62F, size: 10),
//                                       LinearPercentIndicator(
//                                         width: 100.0,
//                                         lineHeight: 3,
//                                         percent: (double.parse(feedData!.s2.toString()))/100,
//                                         progressColor: ColorData.colorFF6A66,
//                                       ),
//                                       Text(
//                                         "${feedData!.s2.toString()}",
//                                         style: GoogleFonts.roboto(
//                                             textStyle: TextStyle(
//                                                 fontSize: 9,
//                                                 fontWeight: FontWeight.w300,
//                                                 color: ColorData.color727272)),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding:
//                                       const EdgeInsets.symmetric(horizontal: 2),
//                                   child: Row(
//                                     children: [
//                                       const Icon(Icons.star,
//                                           color: Colors.transparent, size: 10),
//                                       const Icon(Icons.star,
//                                           color: Colors.transparent, size: 10),
//                                       const Icon(Icons.star,
//                                           color: Colors.transparent, size: 10),
//                                       const Icon(Icons.star,
//                                           color: Colors.transparent, size: 10),
//                                       Icon(Icons.star,
//                                           color: ColorData.colorFFA62F, size: 10),
//                                       LinearPercentIndicator(
//                                         width: 100.0,
//                                         lineHeight: 3,
//                                         percent: (double.parse(feedData!.s1.toString()))/100,
//                                         progressColor: ColorData.colorFF6A66,
//                                       ),
//                                       Text(
//                                         "${feedData!.s1.toString()}",
//                                         style: GoogleFonts.roboto(
//                                             textStyle: TextStyle(
//                                                 fontSize: 9,
//                                                 fontWeight: FontWeight.w300,
//                                                 color: ColorData.color727272)),
//                                       )
//                                     ],
//                                   ),
//                                 )
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                     space(h: 20),
//                     ratingsReviews()
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }
//
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   AppBar _buildAppBar(BuildContext context) {
//     return AppBar(
//       flexibleSpace: Padding(
//           padding:
//               const EdgeInsets.only(top: 90.0, bottom: 10, left: 10, right: 10),
//           child: searchBox()),
//       elevation: 1,
//       titleSpacing: 0,
//       backgroundColor: ColorData.colorF6F6F6,
//       leading: IconButton(
//           onPressed: () {
//             _scaffoldKey.currentState?.openDrawer();
//           },
//           icon: SvgPicture.asset(ImageLinks.menu)),
//       actions: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             IconButton(
//               onPressed: () {},
//               icon: SvgPicture.asset(
//                 ImageLinks.headphone,
//                 height: 18,
//                 width: 18,
//                 color: ColorData.color45413C,
//               ),
//               padding: EdgeInsets.zero,
//               constraints: const BoxConstraints(),
//             ),
//             const SizedBox(width: 18),
//             Align(
//               child: Badge(
//                 position: badges.BadgePosition.topEnd(top: -10, end: -12),
//                 //  animationDuration: Duration(milliseconds: 300),
//                 // animationType: BadgeAnimationType.slide,
//                 badgeContent: Text(
//                   notiCount.toString(),
//                   style: const TextStyle(color: Colors.white),
//                 ),
//                 child:  IconButton(
//                   onPressed: () {
//                     Get.to(const Notification1());
//                   },
//                   icon: SvgPicture.asset(
//                     'assets/icons/bell.svg',
//                     height: 18,
//                     width: 18,
//                     color: ColorData.color45413C,
//                   ),
//                   padding: EdgeInsets.zero,
//                   constraints: const BoxConstraints(),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 18),
//             IconButton(
//               onPressed: () {},
//               icon: SvgPicture.asset(
//                 ImageLinks.share,
//                 color: ColorData.color45413C.withOpacity(0.5),
//               ),
//               padding: EdgeInsets.zero,
//               constraints: const BoxConstraints(),
//             ),
//             const SizedBox(width: 20),
//           ],
//         )
//       ],
//     );
//   }
//
//   Widget searchBox() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 10),
//       padding: EdgeInsets.zero,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border.all(
//             color: const Color.fromRGBO(84, 84, 84, 0.6), width: 0.3),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: const TextField(
//         // onChanged: (String value) =f> _runFilter(value),
//         decoration: InputDecoration(
//           contentPadding: EdgeInsets.symmetric(horizontal: 10),
//           hintStyle: TextStyle(
//             color: Colors.grey,
//           ),
//           prefixIcon: Align(
//             widthFactor: 1,
//             heightFactor: 1,
//             child: Padding(
//               padding: EdgeInsets.only(left: 5.0, top: 2),
//               child: Icon(Icons.search,
//                   color: Color.fromRGBO(84, 84, 84, 1), size: 22),
//             ),
//           ),
//           // suffixIcon: Align(
//           //   widthFactor: 1,
//           //   heightFactor: 1,
//           //   child: Padding(
//           //     padding: EdgeInsets.only(right: 12.0),
//           //     child: Icon(Icons.keyboard_voice,
//           //         color: Color.fromRGBO(84, 84, 84, 1), size: 22),
//           //   ),
//           // ),
//           prefixIconConstraints: BoxConstraints(maxHeight: 20, maxWidth: 25),
//           suffixIconConstraints: BoxConstraints(maxHeight: 20, maxWidth: 25),
//           border: InputBorder.none,
//           hintText: 'Search Clients',
//         ),
//       ),
//     );
//   }
//
//   ///Ratings & Reviews
//   Widget ratingsReviews() {
//     return Container(
//       width: Get.width,
//       color: ColorData.colorF6F6F6,
//       child: Column(
//         children: <Widget>[
//           // rowCardHeadings(StringData.ratingsReview, 7.0, 17.0, 21.0, 0.0),
//           feedbackArray.isEmpty?Container():ratingCard(),
//           //ratingCard(),
//         ],
//       ),
//     );
//   }
//
//   ///Rating & Review Card
//   Widget ratingCard() {
//     return ListView.builder(
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: feedbackArray.length,
//         shrinkWrap: true,
//         itemBuilder: (context,index){
//           return Container(
//             padding: const EdgeInsets.fromLTRB(22.0, 17.0, 22.0, 17.0),
//             child: Column(
//               children: <Widget>[
//                 Row(
//                   children: <Widget>[
//                      Expanded(
//                         flex: 1,
//                         child: CircleAvatar(
//                           radius: 30,
//                           backgroundImage: NetworkImage(feedbackArray[index].image.toString())
//                         )),
//                     space(w: 20.0),
//                     Expanded(
//                       flex: 3,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Padding(
//                             padding: const EdgeInsets.only(left: 2.5),
//                             child: SizedBox(
//                               child: CustomText(
//                                 fontSize: 16.0,
//                                 textOverflow: TextOverflow.visible,
//                                 text: "${feedbackArray[index].name.toString()}",
//                                 fontWeight: FontWeight.w500,
//                                 color: ColorData.color000000,
//                                 maxLines: 3,
//                                 fontFamily: FontData.roboto,
//                               ),
//                             ),
//                           ),
//                           space(h: 7.0),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: <Widget>[
//                               stars(double.parse(feedbackArray[index].rate.toString()), 11.0),
//                               space(w: 8.0),
//                               // CustomText(
//                               //   text: '${feedbackArray[index].rate.toString()}',
//                               //   fontFamily: FontData.roboto,
//                               //   color: ColorData.color000000,
//                               //   fontWeight: FontWeight.w300,
//                               //   fontSize: 12.0,
//                               // ),
//                               CustomText(
//                                 text: "${feedbackArray[index].createdAt.toString()}",
//                                 fontFamily: FontData.roboto,
//                                 color: ColorData.color727272,
//                                 fontWeight: FontWeight.w300,
//                                 fontSize: 12.0,
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//                 space(h: 5.0),
//                 SizedBox(
//                   child: CustomText(
//                     fontSize: 13.0,
//                     textOverflow: TextOverflow.visible,
//                     text:
//                    feedbackArray[index].feedback.toString(),
//                     fontWeight: FontWeight.w400,
//                     color: ColorData.color747474,
//                     fontFamily: FontData.poppins,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         });
//   }
//
//   ///Stars
//   Widget stars(double rating, double size) {
//     return RatingBar.builder(
//       initialRating: rating,
//       minRating: 1,
//       itemSize: size,
//       ignoreGestures: true,
//       direction: Axis.horizontal,
//       allowHalfRating: true,
//       itemCount: 5,
//       itemPadding: const EdgeInsets.symmetric(horizontal: 2.5),
//       itemBuilder: (context, _) => Icon(
//         Icons.star,
//         color: ColorData.colorFFA62F,
//       ),
//       onRatingUpdate: (rating) {
//         //print(rating);
//       },
//     );
//   }
// }
