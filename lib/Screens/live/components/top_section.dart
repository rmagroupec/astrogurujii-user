import 'dart:async';
import 'dart:developer';


import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:astro_gurujii/Screens/Models/GetLiveUser.dart';
import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Screens/live/components/reportAstro.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../Setup/SetUp.dart';
import '../../../Utilities/CustomText.dart';
import '../../AstroDetails/AstroDetails.dart';
import '../../Models/AstroDetailsModel.dart';
import '../../pooja_orders/controller/PoojaOrderController.dart';

class TopSection extends StatefulWidget {
  final String name;
  final String screenType;
  final RtcEngine agoraEngine;

  var astroid;
  var id;
  final String astroImage;
  final List<String> numberOfuserJoin;
  TopSection(
      {this.astroid,
      this.id,
      required this.name,
      required this.astroImage,
      required this.numberOfuserJoin, required this.screenType, required this.agoraEngine});

  @override
  State<TopSection> createState() => _TopSectionState();
}

class _TopSectionState extends State<TopSection> {
  final HttpServices _httpServices = HttpServices();
  List<Results> data = [];
  inFun() {
    print("dfdgf");
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('dfdgfGot a message whilst in the foreground!');
      print('dfdgfMessage data: ${message.data}');

      if (message.notification != null) {
        print(
            'dfdgfMessage also contained a notification: ${message.notification}');
      }
    });
  }

  void callFollowApi() async {
    var res = await _httpServices.follow_astro(id: widget.astroid);
    if (res!.status == true) {
      setState(() {
        Fluttertoast.showToast(msg: res.message!);
        astroDetailsApi();
      });
    } else {
      Fluttertoast.showToast(msg: res.message!);
    }
  }

  void astroDetailsApi() async {
    var res = await _httpServices.astrologer_details(id: widget.astroid);
    if (res!.status! == true) {
      setState(() {
        data = res.results!;
      });
    }
  }

  List<Users>? users = [];
  var usersCount;

  void get_live_users_count() async {

    await _httpServices.get_live_users_count(id: widget.id).then((value) {
      if (value['success'] == true) {
        // setState(() {
        // users = res.data!.users!;
        // usersCount = res.data?.usersCount;
        usersCount = value['data']['usersCount'].toString();
        print("UserCount for live----------->>> $usersCount");
        // });
      }

    }).onError((error, stackTrace) {
      log("Error in get_live_users_count----->>> $error");
      log("Error in get_live_users_count----->>> $stackTrace");


    });

  }

  void get_live_users_count_forPooja() async {


    await _httpServices.get_live_users_count_forPooja(id: widget.id).then((value) {
      if (value['success'] == true) {
        // setState(() {
        // users = res.data!.users!;
        // usersCount = res.data?.usersCount;
        usersCount = value['data']['usersCount'].toString();
        print("UserCount for pojja ----------->>> $usersCount");
        // });
      }

    }).onError((error, stackTrace) {
      log("Error in get_live_users_count_forPooja----->>> $error");
      log("Error in get_live_users_count_forPooja----->>> $stackTrace");


    });

  }
  // void get_live_users_count() async {
  //   var res = await _httpServices.get_live_users_count(id: widget.id);
  //   if (res!.success! == true) {
  //     setState(() {
  //       users = res.data!.users!;
  //       usersCount = res.data?.usersCount;
  //     });
  //   }
  // }

  late Timer timer;
  late Timer meetingTimer;
  void startMeetingTimer() {
    meetingTimer = Timer.periodic(
      const Duration(seconds: 10),
          (meetingTimer) {

        if(widget.screenType=="home"){
          print("count from home");
          get_live_users_count();

        }else if(widget.screenType=="pooja"){
          print("count from pooja");

          get_live_users_count_forPooja();
        }

      },
    );
  }

  // void startMeetingTimer() {
  //   meetingTimer = Timer.periodic(
  //     const Duration(seconds: 10),
  //     (meetingTimer) {
  //       get_live_users_count();
  //     },
  //   );
  // }

  @override
  void initState() {
    inFun();
    astroDetailsApi();
    // get_live_users_count();
    if(widget.screenType=="home"){
      print("count from home");
      get_live_users_count();

    }else if(widget.screenType=="pooja"){
      print("count from pooja");

      get_live_users_count_forPooja();
    }
    startMeetingTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
     double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: MediaQuery.of(context).size.height * 0.20,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.3), // Transparent black at the top
            Color.fromRGBO(0, 0, 0, 0), // Fully transparent at the bottom
          ],
        ),
      ),
      child: 
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: Get.width,
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    height: height/13.28,
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: ShapeDecoration(
                      color: Colors.black.withOpacity(0.41999998688697815),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(width/14.13),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {

                            Navigator.push(context, MaterialPageRoute(builder: (context) => AstroDetails(
                              astroLogerName: widget.name,
                              categoryId:widget.astroid ,

                            ),));

                          },
                          child: Row(
                            children: [

                              ClipOval(

                                child: Image.network(widget.astroImage,fit: BoxFit.fill,
                                  width: width/7.06,
                                  height: height/15.5,
                                ),
                              ),
                              // Container(
                              //   width: 60,
                              //   height: 60,
                              //   decoration: BoxDecoration(
                              //     shape: BoxShape.circle,
                              //     image: DecorationImage(
                              //       image: NetworkImage(widget.astroImage),
                              //       // AssetImage(
                              //       //     "assets/Icons/profile_icon.png"),
                              //       fit: BoxFit.fill,
                              //     ),
                              //   ),
                              // ),
                              SizedBox(
                                width: width/42.4,
                              ),
                              Column(

                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                   child:
                                     Text(
                                      "${widget.name}" ,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: width/26.5,
                                        fontFamily: 'Segoe UI',
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: -0.24,
                                      ),
                                     )
                                  ),
                                  SizedBox(
                                    height: height/232.5,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        width: width/26.5,
                                        height: height/58.25,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                "assets/Icons/profile_icon.png"),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Text(
                                        usersCount.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: width/35.33,
                                          fontFamily: 'Segoe UI',
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: -0.24,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            callFollowApi();
                          },
                          child: Container(
                            width: width/5.3,
                            height: height/31,
                            decoration: ShapeDecoration(
                              gradient: LinearGradient(
                                begin: Alignment(0.00, -1.00),
                                end: Alignment(0, 1),
                                colors: [Color(0xFFDD9750), Color(0xFFEE4262)],
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(width/14.62),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                // state.getLiveRoomData!.data!.isFollowed
                                //     .toString() ==
                                //     "false"
                                //     ?
                                (data.length > 0)
                                    ? (data[0].is_Follow!.toString() == "0")
                                    ? "Follow me +"
                                    : "Followed"
                                    : "Follow me +",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: width/26.3,
                                  fontFamily: 'Segoe UI',
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: -0.24,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      onCallEnd(context,widget.id.toString());
                    },
                    child: Container(
                      padding: EdgeInsets.all(7),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1)),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: width/17.66,
                      ),

                      // Container(
                      //   width: 15,
                      //   height: 15,
                      //   padding: EdgeInsets.all(7),
                      //   decoration: BoxDecoration(
                      //     image: DecorationImage(
                      //       image: AssetImage(
                      //           "assets/Icons/profile_icon.png"),
                      //       fit: BoxFit.fill,
                      //     ),
                      //   ),
                      // )
                    ),
                  )
                ],
              ),
            )
          ],
        ),
        InkWell(
          onTap: (){
            _showMyDialog(context,widget.astroid.toString());
        },
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Image.asset("assets/images/reporticonAstro.png",
              height: 40,width: 40,fit: BoxFit.fill,),
          ),
        )

      ],)
    );
  }

  void onCallEnd(BuildContext context, String pujaId) async {
    // print('uid====' + _users.toString());
    // _users.clear();
    // destroy Agora sdk
    if(widget.screenType=="home"){
      leaveLiveForHomeScreen(live_id: pujaId);

      widget.agoraEngine.leaveChannel();
      widget.agoraEngine.release();
      Navigator.pop(context);

    }else if(widget.screenType=="pooja"){

      PoojaOrderController screenController=Get.put(PoojaOrderController());
      screenController.leaveLive(pujaId);

      widget.agoraEngine.leaveChannel();
      widget.agoraEngine.release();
      Navigator.pop(context);
    }




  }

  void leaveLiveForHomeScreen({String ? live_id}){
    _httpServices.leaveLiveForHome(live_id: live_id).then((value) {
      Fluttertoast.showToast(msg: value['message'].toString());


    }).onError((error, stackTrace) {
      print("Error in Home leaveLive===========>>> $error");
      print("Error in  Home leaveLive stackTrace===========>>> $stackTrace");
    });

    // _api.leaveLiveFun(puja_id: puja_id.toString()).then((value) {
    //
    //   Fluttertoast.showToast(msg: value['message'].toString());
    //
    // }).onError((error, stackTrace) {
    //   print("Error in Home leaveLive===========>>> $error");
    //   print("Error in  Home leaveLive stackTrace===========>>> $stackTrace");
    //
    // });

  }


  Future<void> _showMyDialog(BuildContext context, String astroId) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return ReportDialog(astroId);
      },
    );
  }


  // Future<void> _showMyDialog(BuildContext context, ) async {
  //   return showDialog<void>(
  //     context: context,
  //     // barrierDismissible: false, // User must tap button to dismiss
  //     builder: (BuildContext context) {
  //       return  Dialog(
  //
  //         child:
  //         Container(
  //           child: SingleChildScrollView(
  //               child: Column(children: [
  //
  //
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //
  //                     SizedBox(width: 1,),
  //
  //
  //                     CustomText(
  //                       text: "Report",
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 18,
  //                     ),
  //                     InkWell(
  //                         onTap: (){
  //                           Navigator.pop(context);
  //
  //                         },
  //                         child: Image.asset("assets/images/cancelImage.png",height: 30,width: 30,))
  //
  //                   ],),
  //
  //             Column(
  //               children: <Widget>[
  //                 ListTile(
  //                   title: const Text('Unprofessional Behaviour'),
  //                   leading: Radio<ReportOption>(
  //                     value: ReportOption.unprofessionalBehaviour,
  //                     groupValue: _selectedOption,
  //                     onChanged: (ReportOption? value) {
  //                       setState(() {
  //                         _selectedOption = value;
  //                       });
  //                     },
  //                   ),
  //                 ),
  //                 ListTile(
  //                   title: const Text('Abusive Content/Harmful'),
  //                   leading: Radio<ReportOption>(
  //                     value: ReportOption.abusiveContent,
  //                     groupValue: _selectedOption,
  //                     onChanged: (ReportOption? value) {
  //                       setState(() {
  //                         _selectedOption = value;
  //                       });
  //                     },
  //                   ),
  //                 ),
  //                 ListTile(
  //                   title: const Text('Misguidance'),
  //                   leading: Radio<ReportOption>(
  //                     value: ReportOption.misguidance,
  //                     groupValue: _selectedOption,
  //                     onChanged: (ReportOption? value) {
  //                       setState(() {
  //                         _selectedOption = value;
  //                       });
  //                     },
  //                   ),
  //                 ),
  //                 ListTile(
  //                   title: const Text('Others'),
  //                   leading: Radio<ReportOption>(
  //                     value: ReportOption.others,
  //                     groupValue: _selectedOption,
  //                     onChanged: (ReportOption? value) {
  //                       setState(() {
  //                         _selectedOption = value;
  //                       });
  //                     },
  //                   ),
  //                 ),
  //               ],
  //             ),
  //
  //                 SizedBox(height: 10,),
  //
  //                 Padding(
  //                   padding: const EdgeInsets.all(8.0),
  //                   child: Container(
  //                     height: 100,
  //                     decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(10),
  //                         border: Border.all(color: Colors.grey,)
  //                     ),
  //                     width: double.infinity,
  //                     child: TextFormField(
  //
  //
  //                       decoration: InputDecoration(
  //                         hintText: "Write your reason....",
  //                         contentPadding: EdgeInsets.only(left: 20),
  //                         border: InputBorder.none,
  //
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 SizedBox(height: 10,),
  //
  //                 InkWell(
  //                   onTap: (){
  //                     Navigator.pop(context);
  //                   },
  //                   child: Container(
  //                     height: 40,
  //                     width: 100,
  //                     decoration: BoxDecoration(
  //                         color: primaryColor,
  //                         borderRadius: BorderRadius.circular(10)
  //                     ),
  //                     child: Center(
  //                       child: CustomText(
  //                         text: "Submit",
  //                         fontWeight: FontWeight.bold,
  //                         fontSize: 14,
  //                         color: CupertinoColors.white,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 SizedBox(height: 10,),
  //               ],)
  //           ),
  //         ),
  //
  //
  //
  //
  //
  //
  //       );
  //     },
  //   );
  // }

}



