// //@dart=2.0
// // ignore_for_file: avoid_function_literals_in_foreach_calls, prefer_const_constructors, prefer_const_literals_to_create_immutables

// import 'dart:async';
// import 'dart:developer';

// import 'package:agora_rtc_engine/rtc_engine.dart';
// import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
// import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;

// import 'package:astro_gurujii/Screens/homeScreen/Home.dart';
// import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
// import 'package:astro_gurujii/Screens/video_call/Controllers/agora_controller.dart';
// import 'package:astro_gurujii/widget/bottom_navigation_bar_custom.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:quiver/async.dart';
// import 'package:screen/screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:signal_strength_indicator/signal_strength_indicator.dart';

// import '../../Setup/SetUp.dart';
// import 'Helpers/utils.dart';

// class VideoCallScreen extends StatefulWidget {
//   final String channelName;
//   final String name;
//   final String profile;

//   VideoCallScreen({this.channelName, this.name, this.profile});
//   @override
//   VideoCallScreenState createState() => VideoCallScreenState();
// }

// class VideoCallScreenState extends State<VideoCallScreen> {
//   static final _users = <int>[];
//   final _infoStrings = <String>[];
//   HttpServices _httpService = HttpServices();
//   // UserJoined Bool
//   bool isSomeOneJoinedCall = false;
//   final AgoraController agoraController = Get.put(AgoraController());
//   String messageTitle = "Empty";
//   String notificationAlert = "alert";

//   int networkQuality = 3;
//   Color networkQualityBarColor = Colors.green;
//   bool status = true;
//   Timer timer;
//   Timer timeree;
//   Timer meetingTimer;
//   var meetingDurationTxt = "00:00".obs;
//   var mins = 0;
//   int meetingDuration = 0;

//   RtcEngine _engine;

//   @override
//   void setState(fn) {
//     try {
//       if (mounted) {
//         super.setState(fn);
//       }
//     } catch (e) {}
//   }

//   Future<void> getChangeConnectionApi(String status) async {
//     /*print("======================================================" +
//         "jhjhjhjhjhjhjhjhjhjhjhjhjhjhjh");*/
//     var res = await _httpService.change_connection_request_status(
//         channel_id: widget.channelName, status: status);
//     if (res.status) {
//       setState(() {
//         if (status == "end_user") {
//           show(context);
//         } else {
//           Navigator.pop(context);
//         }
//       });
//     } else {
//       Fluttertoast.showToast(msg: "Something went wrong");
//     }
//   }

//   Future<void> callAliForRaiting(double rating_point, String text) async {
//     var res = await _httpService.add_rating(
//         channel_id: widget.channelName,
//         rating: rating_point.toString(),
//         review: text ?? "Good");
//     if (res.status == true) {
//       setState(() {
//         Navigator.pop(context); // Close dialog
//         Navigator.pushReplacement(
//             context, MaterialPageRoute(builder: (context) => MainHomeScreenWithBottomNavigation()));
//       });
//     } else {
//       Fluttertoast.showToast(msg: "Something went wrong");
//     }
//   }

//   @override
//   void dispose() {
//     // print("\n============ ON DISPOSE ===============\n");
//     super.dispose();

//     if (agoraController.meetingTimer != null) {
//       agoraController.meetingTimer.cancel();
//     }
//     // clear users
//     _users.clear();
//     // destroy Agora sdk
//     _engine.leaveChannel();
//     _engine.destroy();
//     timeree.cancel();
//   }
//    fetchUserProfile() async{
//     final pref = await SharedPreferences.getInstance();
//      setState(() {
//       name = pref.getString("name");
//      });
//   }
// String name ="";

//   @override
//   void initState() {
//     // initialize agora sdk
//     startTimer();
//     startMeetingTimer();
//     initAgoraRTC();
//     fetchUserProfile();
//     timeree =
//         Timer.periodic(Duration(seconds: 2), (Timer t) => checkForNewStatus());
//     Screen.keepOn(true);
//     super.initState();

//     FirebaseMessaging.instance.getInitialMessage().then((message) {
//       if (message != null) {
//         //print("===========" + message.toString());
//       }
//     });

//     ///when app is open
//     FirebaseMessaging.onMessage.listen((message) {
//       //print(FirebaseMessaging.onMessage.listen);
//       print("====================fffffffffff=====================" +
//           message.data.toString());
//       print("====================fffffffffff=====================" +
//           message.data["type"].toString());
//       messageTitle = message.data["notification_type"].toString();

//       if (messageTitle == "end_astro") {
//         try {
//           /* _users.clear();
//           // destroy Agora sdk
//           AgoraRtcEngine.leaveChannel();
//           AgoraRtcEngine.destroy();
//           meetingTimer.cancel();
//           show(context);*/
//         } catch (e) {}
//       }
//       if (messageTitle == "reject_astro") {
//         try {
//           timeree.cancel();
//           _users.clear();
//           // destroy Agora sdk
//           _engine.leaveChannel();
//           _engine.destroy();
//           meetingTimer.cancel();
//           Navigator.pop(context);
//         } catch (e) {}
//       }
//       if (messageTitle == "end_user") {
//         try {
//           timeree.cancel();
//           /* _users.clear();
//           // destroy Agora sdk
//           AgoraRtcEngine.leaveChannel();
//           AgoraRtcEngine.destroy();
//           meetingTimer.cancel();
//           show(context);*/
//         } catch (e) {}
//       }
//     });
//   }

//   Future<void> checkForNewStatus() async {
//     var res =
//         await _httpService.call_initiate_status(channel_id: widget.channelName);
//     if (res.status == true) {
//       if (res.results.status == "accept_astro") {
//         if (sub != null) {
//           sub.cancel();
//         }
//       } else if (res.results.status == "reject_astro") {
//         if (timeree != null) {
//           timeree.cancel();
//         }
//         if (sub != null) {
//           sub.cancel();
//         }
//         Navigator.pop(context);
//       } else if (res.results.status == "end_astro") {
//         if (timeree != null) {
//           timeree.cancel();
//         }
//         if (sub != null) {
//           sub.cancel();
//         }
//         try {
//           _users.clear();
//           _engine.leaveChannel();
//           _engine.destroy();
//           meetingTimer.cancel();
//           show(context);
//         } catch (e) {}
//       }
//     } else {
//       //  EndChatWebservice();
//     }
//   }

//   Future<void> initAgoraRTC() async {
//     if (getAgoraAppId().isEmpty) {
//       Get.snackbar("", "Agora APP_ID Is Not Valid");
//       return;
//     }

//     await _initAgoraRtcEngine();
//     _addAgoraEventHandlers();
//     await _engine.enableWebSdkInteroperability(true);
//     //await AgoraRtcEngine.setChannelProfile(ChannelProfile.Communication);
//     await _engine.setParameters(
//         '''{\"che.video.lowBitRateStreamParameter\":{\"width\":640,\"height\":360,\"frameRate\":30,\"bitRate\":800}}''');
//     await _engine.joinChannel(null, widget.channelName, null, 0);
//   }

//   Future<void> _initAgoraRtcEngine() async {
//     _engine =  await RtcEngine.create(getAgoraAppId());
//     await _engine.enableVideo();
//     await _engine.setDefaultAudioRouteToSpeakerphone(true);
//     await _engine.setEnableSpeakerphone(true);
//     final isSpeakerOn = await _engine.isSpeakerphoneEnabled();
//   print('Speakerphone enabled: $isSpeakerOn');

//   }

//   /// agora event handlers
//   void _addAgoraEventHandlers() {

//     // AgoraRtcEngine.onNetworkQuality = (int uid, int txQuality, int rxQuality) {
//     //   setState(() {
//     //     networkQuality = getNetworkQuality(txQuality);
//     //     networkQualityBarColor = getNetworkQualityBarColor(txQuality);
//     //   });
//     // };
//     //






//     _engine?.setEventHandler(RtcEngineEventHandler(
//       error: (code) {
//         setState(() {
//           final info = 'onError: $code';
//           _infoStrings.add(info);
//         });
//       },
//       joinChannelSuccess: (channel, uid, elapsed) {
//         log('------>>>>> joinChannelSuccess ${uid}');
//         setState(() {
//           final info = 'onJoinChannel: $channel, uid: $uid';
//           _infoStrings.add(info);
//         });
//       },
//       leaveChannel: (stats) {
//         log('------>>>>> leaveChannel ${stats.userCount}');

//         setState(() {
//           _infoStrings.add('onLeaveChannel');
//           _users.clear();
//         });
//       },
//       userJoined: (uid, elapsed) {
//         print("======================================");
//         print("             User Joined              ");
//         print("======================================");
//         agoraController.startMeetingTimer();
//         /* if (agoraController.meetingTimer != null) {
//         if (!agoraController.meetingTimer.isActive) {
//           agoraController.startMeetingTimer();
//         }
//       } else {
//         agoraController.startMeetingTimer();
//       }
// */
//         isSomeOneJoinedCall = true;

//         setState(() {
//           final info = 'userJoined: $uid';
//           _infoStrings.add(info);

//           _users.add(uid);
//         });
//       },
//       userOffline: (uid, reason) {
//         log('------>>>>> userOffline ${uid}');
//         // CustomFlutterToast.showToast(
//         //     message: "Live Sessiofffn Ended", backgroundColor: Colors.black);

//         setState(() {
//           final info = 'userOffline: $uid';
//           _infoStrings.add(info);
//           _users.remove(uid);
//         });
//       },
//       firstRemoteVideoFrame: (uid, width, height, elapsed) {
//         log('------>>>>> firstRemoteVideoFrame ${uid}');

//         setState(() {
//           final info = 'firstRemoteVideo: $uid ${width}x $height';
//           _infoStrings.add(info);
//         });
//       },

//       networkQuality: (uid, txQuality, rxQuality) {
//           // setState(() {
//           //   networkQuality = getNetworkQuality(txQuality);
//           //   networkQualityBarColor = getNetworkQualityBarColor(txQuality);
//           // });
//         print('Network Quality - uid: $uid, txQuality: $txQuality, rxQuality: $rxQuality');
//       },
//     ));




//   }

//   List<Widget> _getRenderViews() {
//     final List<StatefulWidget> list = [];
//     list.add(RtcLocalView.SurfaceView());
//     _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(
//       uid: uid,
//       channelId: widget.channelName,
//     )));
//     setState(() {});
//     return list;
//   }

//   Widget _videoView(view) {
//     return Expanded(child: Container(child: view));
//   }

//   Widget _expandedVideoRow(List<Widget> views) {
//     final wrappedViews = views.map<Widget>(_videoView).toList();
//     return Expanded(
//       child: Row(
//         children: wrappedViews,
//       ),
//     );
//   }

//   Widget buildJoinUserUI() {
//     final views = _getRenderViews();
//     print('djawewj=====' + isSomeOneJoinedCall.toString());
//     if (isSomeOneJoinedCall) {
//       setState(() {
//         if (status) {
//           status = false;
//           meetingDurationTxt = "00:00".obs;
//           meetingDuration = 0;
//         }
//       });
//     }

//     switch (views.length) {
//       case 1:
//         return Container(
//             child: Column(
//           children: <Widget>[_videoView(views[0])],
//         ));
//       case 2:
//         return new Container(
//             width: Get.width,
//             height: Get.height,
            
//             child: new Stack(
//               children: <Widget>[
//                 Align(
//                   alignment: Alignment.topLeft,
//                   child: Column(
//                     children: <Widget>[
//                       _expandedVideoRow([views[1]]),
//                     ],
//                   ),
//                 ),
//                 Align(
//                     alignment: Alignment.topRight,
//                     child: Container(
//                         decoration: BoxDecoration(
//                           border: Border.all(
//                             width: 5,
//                             color: Colors.white38,
//                           ),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         margin: const EdgeInsets.fromLTRB(15, 40, 10, 15),
//                         width: 110,
//                         height: 140,
//                         child: Column(
//                           // mainAxisSize: MainAxisSize.min,
//                           children: <Widget>[
//                             GetBuilder<AgoraController>(builder: (_) { return _.muteVideo ? Expanded( child: Container(color: Colors.black,)) :  _expandedVideoRow([views[0]]);}),
//                              Container(
//                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                                decoration: BoxDecoration(
//                                  color: Colors.black54,
//                                  borderRadius: BorderRadius.circular(4),
//                                ),
//                                child: Row(
//                                  children: [
//                                    Icon(Icons.person, color: Colors.white,size: 16,),
//                                    SizedBox(width: 5,),
//                                    Text(
//                                      '${name}', // Your desired label
//                                      style: TextStyle(
//                                        color: Colors.white,
//                                        fontSize: 9,
//                                        fontWeight: FontWeight.w500,
//                                      ),
//                                    ),
//                                  ],
//                                ),
//                              ),
                         
//                           ],
//                         )))
//               ],
//             ));
//       case 3:
//         return Container(
//             child: Column(
//           children: <Widget>[
//             _expandedVideoRow(views.sublist(0, 2)),
//             _expandedVideoRow(views.sublist(2, 3))
//           ],
//         ));
//       case 4:
//         return Container(
//             child: Column(
//           children: <Widget>[
//             _expandedVideoRow(views.sublist(0, 2)),
//             _expandedVideoRow(views.sublist(2, 4))
//           ],
//         ));
//       default:
//     }
//     return Container();
//   }

//   void onCallEnd(BuildContext context) async {
//     if (isSomeOneJoinedCall) {
//       getChangeConnectionApi("end_user");
//     } else {
//       getChangeConnectionApi("disconnect_user");
//     }
//     meetingTimer.cancel();
//     if (agoraController.meetingTimer != null) {
//       if (agoraController.meetingTimer.isActive) {
//         agoraController.meetingTimer.cancel();
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final mediaQuery = MediaQuery.of(context);
//     final height = mediaQuery.size.height;
//     final width = mediaQuery.size.width;

//     // Base size according to your Figma / design
//     const baseWidth = 423.5;
//     const baseHeight = 929.8;

//     // Scaling factors
//     final scaleWidth = width / baseWidth;
//     final scaleHeight = height / baseHeight;
//     final scaleText = (scaleWidth + scaleHeight) / 2;
//     return WillPopScope(
//       onWillPop: () {
//         return;
//       },
//       child: Scaffold(
//         body: Stack(
//           children: [
//             Positioned.fill(
              
//               child: buildJoinUserUI()),

//             Positioned.fill(
//               child: Image.asset(
//                 'assets/icon/4.png',
//                 fit: BoxFit.fill,
//               ),
//             ),
            

//             buildNormalVideoUI(),
//             // buildNormalVideoUI(),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 height: scaleHeight * 111,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     GetBuilder<AgoraController>(
//                       builder: (_) {
//                         return Container(
//                           height: scaleHeight * 83.68,
//                           width: width,
//                           margin: EdgeInsets.symmetric(horizontal: scaleWidth * 15,),
//                           decoration: BoxDecoration(
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black12,
//                                 blurRadius: scaleHeight * 10,
//                                 offset: Offset(0, -scaleHeight * 10),
//                               ),
//                             ],
//                           ),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   _buildControlButton(
//                                     icon: _.hands
//                                         ? "assets/astro/SVG_Volume.svg"
//                                         : "assets/astro/SVG_Volume_Mute.svg",
//                                     onPressed: () {
//                                       agoraController.toggleAudioRoute(engine: _engine);
//                                     },
//                                     iconColor: _.hands ? Colors.white : Colors.red,
                                   
//                                   ),
//                                   _buildControlButton(
//                                     icon: _.muted
//                                         ? "assets/astro/SVG_MicMute.svg"
//                                         : "assets/astro/SVG_Mic.svg",
//                                     onPressed: () {
//                                       agoraController.onToggleMuteAudio(engine: _engine);
//                                     },
//                                     iconColor: _.muted ? Colors.red : Colors.white,
                                   
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                     SizedBox(height: scaleHeight * 5),
//                     (_users.isEmpty && status)
//                         ? Text(
//                             'Video Call Connecting..',
//                             style: TextStyle(color: Colors.white, fontSize: scaleText * 12),
//                           )
//                         : Text(
//                             'Video Call Connected',
//                             style: TextStyle(color: Colors.white, fontSize: scaleText * 12),
//                           ),
//                           SizedBox(height: scaleHeight * 5),
//                   ],
//                 ),
//               ),
//             ),
//            ],
//         ),
      
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//         floatingActionButton: Padding(
//           padding: EdgeInsets.only(bottom: scaleHeight * 60),
//           child: FloatingActionButton(
//             backgroundColor: Color(0xFFcd2a2a),
//             onPressed: () {
//               onCallEnd(context);
//             },
//             child: SvgPicture.asset(
//               "assets/astro/call_disconnect.svg",
//               width: scaleWidth * 40,
//               height: scaleWidth * 40,
//             ),
//           ),
//         ),
      
//       ),
//     );
//   }

// Widget _buildControlButton({
//     String icon,
//     VoidCallback onPressed,
//     Color iconColor = Colors.white,
//   }) {
//     return RawMaterialButton(
//       padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
//       onPressed: onPressed,
//       shape: CircleBorder(),
//       // padding: EdgeInsets.all(11),
//       // fillColor: Colors.white30,
//       child: SvgPicture.asset(icon, height:50, width: 50,),
//       constraints: BoxConstraints(),
//       elevation: 5,
//     );
//   }
//   Widget buildNormalVideoUI() {
//     return SizedBox(
//       height: Get.height,
//       child: Stack(
//         children: <Widget>[
//           // buildJoinUserUI(),
//           (_users.length == 0 && status)
//               ?  Align(
//   alignment: Alignment.center,
//   child: Container(
//     width: 201,
//     height: 201,
//     decoration: BoxDecoration(
//       shape: BoxShape.circle,
//       border: Border.all(width: 2, color: whiteColor),
//     ),
//     child: Stack(
//       alignment: Alignment.bottomCenter,
//       children: [
//         // Circular image
//         ClipOval(
//           child: CachedNetworkImage(
//             imageUrl: widget.profile,
//             width: 201,
//             height: 201,
//             fit: BoxFit.cover,
//           ),
//         ),

//         // Black overlay with name + time
//         ClipOval(
//           child: Container(
//             width: 201,
//             height: 201,
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(vertical: 10),
//               decoration: const BoxDecoration(
//                 color: Colors.black87,
//                 borderRadius: BorderRadius.vertical(
//                   bottom: Radius.circular(100), // matches circular shape
//                 ),
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     widget.name,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w600,
//                       fontSize: 14,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     "$meetingDurationTxtCount", // Or widget.time
//                     style: const TextStyle(
//                       color: Colors.white70,
//                       fontWeight: FontWeight.w400,
//                       fontSize: 12,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     ),
//   ),
// )
//               : Container(),
//           // Align(
//           //   alignment: Alignment.topLeft,
//           //   child: Container(
//           //     margin: const EdgeInsets.only(left: 10, top: 30),
//           //     child: ElevatedButton(
//           //       //minWidth: 40,
//           //       //height: 50,

//           //       onPressed: () {
//           //         showDialog(
//           //           context: context,
//           //           builder: (BuildContext context) {
//           //             return AlertDialog(
//           //               title: Text("End Call"),
//           //               content: Text("Are you sure you want to end the video call?"),
//           //               actions: [
//           //                 TextButton(
//           //                   onPressed: () {
//           //                     // Close the dialog
//           //                     Navigator.of(context).pop();
//           //                   },
//           //                   child: Text("No"),
//           //                 ),
//           //                 TextButton(
//           //                   onPressed: () {
//           //                     // End the call if 'Yes' is clicked
//           //                     if (agoraController.meetingTimer != null) {
//           //                       agoraController.meetingTimer.cancel();
//           //                     }
//           //                     _engine.leaveChannel();
//           //                     _engine.destroy();
//           //                     Navigator.of(context).pop(); // Close the dialog
//           //                     onCallEnd(context); // Perform the action to end the call
//           //                   },
//           //                   child: Text("Yes"),
//           //                 ),
//           //               ],
//           //             );
//           //           },
//           //         );
//           //       },

//           //       // onPressed: () {
//           //       //   if (agoraController.meetingTimer != null) {
//           //       //     agoraController.meetingTimer.cancel();
//           //       //   }
//           //       //   AgoraRtcEngine.leaveChannel();
//           //       //   AgoraRtcEngine.destroy();
//           //       //   onCallEnd(context);
//           //       // },
//           //       child: Icon(
//           //         Icons.arrow_back_outlined,
//           //         color: Colors.white,
//           //         size: 24.0,
//           //       ),
//           //       /*shape: RoundedRectangleBorder(
//           //           borderRadius: BorderRadius.circular(6)),
//           //       color: Colors.white38,*/
//           //     ),
//           //   ),
//           // ),
          
//            Positioned(
//               bottom: MediaQuery.of(context).size.height/8.6,
//               child: Container(
//                 margin: EdgeInsets.symmetric(horizontal: 12),
//                 width: MediaQuery.of(context).size.width,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
//                       decoration: BoxDecoration(
//                         color: blackColor.withOpacity(0.7),
//                         borderRadius: BorderRadius.circular(10),
                        
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Container(height: 5,width: 5,decoration: BoxDecoration(color: whiteColor, borderRadius: BorderRadius.circular(10)),),
//                               SizedBox(width: 5,),
//                               Text(
//                               "${widget.name}",
//                                 style: TextStyle(
//                                   fontSize: 11,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(width: 8),
//                           Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Container(height: 5,width: 5,decoration: BoxDecoration(color: redColor, borderRadius: BorderRadius.circular(10)),),
//                               SizedBox(width: 5,),
//                               Text(
//                                 "${meetingDurationTxt.value}",
//                                 style: TextStyle(
//                                   fontSize: 11,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       width: MediaQuery.of(context).size.width/2.07,
//                       padding: EdgeInsets.only(left: 20,),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           GetBuilder<AgoraController>(builder: (_) {
//                            return _buildControlButton(
//                       icon: _.backCamera 
//                           ? "assets/astro/camera_back.svg"
//                           : "assets/astro/camera_back.svg",
//                       onPressed: () {
//                         agoraController.onSwitchCamera(engine: _engine);
//                       },
//                       iconColor: _.backCamera ? Colors.red : Colors.white,
//                     );
//                             // return RawMaterialButton(
//                             //   onPressed: (){
//                             //     agoraController.onSwitchCamera(engine: _engine);
//                             //   },
//                             //   shape: CircleBorder(),
//                             //   // fillColor: Colors.grey.withOpacity(0.2),
//                             //   // padding: EdgeInsets.all(12),
//                             //   child: _.backCamera ? SvgPicture.asset("assets/astro/camera_back.svg", height: 50,width: 50,) :SvgPicture.asset("assets/astro/camera_back.svg", height: 50,width: 50,),
//                             //     elevation: 4,
//                             // );
//                           }),
//                           GetBuilder<AgoraController>(builder: (_) {
//                         return  _buildControlButton(
//                       icon: _.muteVideo 
//                           ? "assets/astro/svg_video_off.svg"
//                           : "assets/astro/SVG_videoOn.svg",
//                       onPressed: () {
//                         agoraController.onToggleMuteVideo(engine: _engine);
//                       },
//                       iconColor: _.muteVideo ? Colors.red : Colors.white,
//                     );
//                       }),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//            ],
//       ),
//     );
//   }

//   void addLogToList(String info) {
//     //print(info);
//     setState(() {
//       _infoStrings.insert(0, info);
//     });
//   }

//   int getNetworkQuality(int txQuality) {
//     switch (txQuality) {
//       case 0:
//         return 2;
//         break;
//       case 1:
//         return 4;
//         break;
//       case 2:
//         return 3;
//         break;
//       case 3:
//         return 2;
//         break;
//       case 4:
//         return 1;
//         break;
//       case 4:
//         return 0;
//         break;
//     }
//     return 0;
//   }

//   Color getNetworkQualityBarColor(int txQuality) {
//     switch (txQuality) {
//       case 0:
//         return Colors.green;
//         break;
//       case 1:
//         return Colors.green;
//         break;
//       case 2:
//         return Colors.yellow;
//         break;
//       case 3:
//         return Colors.redAccent;
//         break;
//       case 4:
//         return Colors.red;
//         break;
//       case 4:
//         return Colors.red;
//         break;
//     }
//     return Colors.yellow;
//   }

//   double rating_point = 0.0;

//   TextEditingController review_controler = new TextEditingController();
//   show(BuildContext context) {
//     return showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           insetPadding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//           content: StatefulBuilder(
//             // You need this, notice the parameters below:
//             builder: (BuildContext context, StateSetter setState) {
//               return Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Please rate your experience',
//                     style: TextStyle(
//                         color: Colors.black, fontWeight: FontWeight.w500),
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   RatingBar.builder(
//                       itemSize: 30,
//                       glowColor: Color(0xfff19425),
//                       initialRating: rating_point,
//                       itemBuilder: (context, _) {
//                         return Icon(
//                           Icons.star,
//                           color: Color(0xfff19425),
//                         );
//                       },
//                       onRatingUpdate: (rating) {
//                         setState(() {
//                           rating_point = rating;
//                         });
//                       }),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Text(
//                     'Additional comments',
//                     style: TextStyle(
//                         color: Colors.black, fontWeight: FontWeight.w500),
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Container(
//                     width: MediaQuery.of(context).size.width,
//                     height: 120,
//                     decoration: BoxDecoration(
//                       color: Colors.grey.withOpacity(0.5),
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                     padding: EdgeInsets.only(left: 10, bottom: 5),
//                     child: TextFormField(
//                       controller: review_controler,
//                       textInputAction: TextInputAction.newline,
//                       keyboardType: TextInputType.multiline,
//                       minLines: null,
//                       maxLines:
//                           null, // If this is null, there is no limit to the number of lines, and the text container will start with enough vertical space for one line and automatically grow to accommodate additional lines as they are entered.
//                       expands: true,
//                       decoration: InputDecoration(
//                           border: InputBorder.none,
//                           hintText: "Review Here",
//                           hintStyle: TextStyle(
//                               color: Colors.black,
//                               fontWeight: FontWeight.w500)),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   InkWell(
//                     onTap: () {
//                       setState(() {
//                         if (rating_point < 1) {
//                           Fluttertoast.showToast(
//                               msg: "Please give your valuable feedback");
//                         } else {
//                           Navigator.pop(context);
//                           callAliForRaiting(
//                               rating_point, review_controler.text);
//                         }
//                       });
//                     },
//                     child: Container(
//                         height: 45,
//                         width: MediaQuery.of(context).size.width,
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [
//                               Color(0xffFC7601),
//                               Color(0xffFC7601),
//                             ],
//                           ),
//                           borderRadius: BorderRadius.circular(20),
//                           //  color:Color(0xFFff8542),
//                         ),
//                         child: Text(
//                           "SUBMIT",
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 14,
//                               fontWeight: FontWeight.w700),
//                         )),
//                   ),
//                 ],
//               );
//             },
//           ),
//         );
//       },
//     );
//   }

//   void startMeetingTimer() {
//     meetingTimer = Timer.periodic(
//       const Duration(seconds: 1),
//       (meetingTimer) {
//         int min = (meetingDuration ~/ 60);
//         int sec = (meetingDuration % 60).toInt();

//         meetingDurationTxt.value = min.toString() + ":" + sec.toString() + "";

//         if (checkNoSignleDigit(min)) {
//           meetingDurationTxt.value =
//               "0" + min.toString() + ":" + sec.toString() + "";
//         }
//         if (checkNoSignleDigit(sec)) {
//           if (checkNoSignleDigit(min)) {
//             meetingDurationTxt.value =
//                 "0" + min.toString() + ":0" + sec.toString() + "";
//           } else {
//             meetingDurationTxt.value =
//                 min.toString() + ":0" + sec.toString() + "";
//           }
//         }
//         setState(() {
//           mins = min;
//           meetingDuration = meetingDuration + 1;
//         });
//       },
//     );
//   }

//   int _start = 119;
//   int meetingDurationCount = 119;
//   var meetingDurationTxtCount = "00:00".obs;
//   var sub;
//   void startTimer() {
//     CountdownTimer countDownTimer = new CountdownTimer(
//       new Duration(seconds: _start),
//       new Duration(seconds: 1),
//     );

//     sub = countDownTimer.listen(null);
//     sub.onData((duration) {
//       setState(() {
//         int min = (meetingDurationCount ~/ 60);
//         int sec = (meetingDurationCount % 60).toInt();

//         meetingDurationTxtCount.value =
//             min.toString() + ":" + sec.toString() + "";

//         if (checkNoSignleDigit(min)) {
//           meetingDurationTxtCount.value =
//               "0" + min.toString() + ":" + sec.toString() + "";
//         }
//         if (checkNoSignleDigit(sec)) {
//           if (checkNoSignleDigit(min)) {
//             meetingDurationTxtCount.value =
//                 "0" + min.toString() + ":0" + sec.toString() + "";
//           } else {
//             meetingDurationTxtCount.value =
//                 min.toString() + ":0" + sec.toString() + "";
//           }
//         }
//         setState(() {
//           mins = min;
//           meetingDurationCount = meetingDurationCount - 1;
//           if (meetingDurationCount == 0.0) {}
//         });
//       });
//     });

//     sub.onDone(() {
//       //print("Done");
//       getChangeConnectionApi("disconnect_user");
//       sub.cancel();
//     });
//   }
// }
