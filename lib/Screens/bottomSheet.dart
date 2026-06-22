
import 'package:astro_gurujii/Screens/AstroDetails/AudioCallConfirmationScreen.dart';
import 'package:astro_gurujii/Screens/Login.dart';
import 'package:astro_gurujii/Screens/MyWallet.dart';
import 'package:astro_gurujii/Screens/video_call/AudioCallScreen.dart';
import 'package:astro_gurujii/Screens/video_call/Helpers/utils.dart';
import 'package:astro_gurujii/Screens/video_call/NewVideoCallScreen.dart';
import 'package:astro_gurujii/Screens/video_call/VideoCallScreen.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Setup/app_colors.dart';
import 'WebServices/HttpServices.dart';
import 'chats_screen/ChatCallingScreen.dart';

void bottomSheet(
    String username,
    String userImage,
    String number,
    context,
    String astrologerID,
    String videoRate,
    String minCall,
    String profile,
    String currency,
    String currencyCode,
    String name,
    String userWallet,
    String callType,
    bool loading) {
  showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      isScrollControlled: true,
      isDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter mystate) {
          return Container(
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white, // Set the background color of the container
            ),
            height: MediaQuery.of(context).size.height / 1.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Astrologer & Payment Details',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.mBGColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Image.asset(
                            "assets/Icons/a_cancel.png",
                            height: 22,
                          )),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(profile),
                      radius: 40,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      name ?? '',
                      style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Times new roman'),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(setCallType(callType)),
                        Text(
                          (currency == "INR")
                              ? ' \u{20B9}$videoRate/mins'
                              : ' \u{20B9}$videoRate/mins',
                          style: TextStyle(color: primaryColor),
                        ),
                      ],
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            // border: Border.all(color: Colors.grey),
                            // color: Colors.lightGreen,
                            borderRadius: BorderRadius.circular(0)),
                        // height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Wallet Balance",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[700]),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      (currency == "INR")
                                          ? '${'\u{20B9}'} '
                                          : '${'\u{20B9}'} ',
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.grey[700]),
                                    ),
                                    Text(
                                      (currency == "INR")
                                          ? '$userWallet'
                                          : ' $userWallet',
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      child: Text(
                                    "Max Duration",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[700]),
                                  )),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Text(
                                          (currency == "INR")
                                              ? '${'\u{1F570}'} '
                                              : '${'\u{1F570}'} ',
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.grey[700]),
                                        ),
                                        Text(
                                          getMaxDuration(userWallet, videoRate),
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.w800),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: (currency == "INR")
                            ? Text(
                                "Minimum balance of 5 minutes (${'\u{20B9}'} ${getMinApunt(videoRate)}) is required to start ${setCallType(callType)} with $name ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.red.shade600, fontSize: 14))
                            : Text(
                                "Minimum balance of 5 minutes (${'\u{20B9}'} ${getMinApunt(videoRate)}) is required to start ${setCallType(callType)} with $name ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.red.shade600, fontSize: 14)),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    try {
                      mystate(() {
                        loading = false;
                      });

                      if (getcheck(userWallet, videoRate) < 5.0) {
                        mystate(() {
                          loading = true;
                        });

                        final _prefs = await SharedPreferences.getInstance();
                        if (_prefs.get("is_skip") == "Y") {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => LoginPage()),
                              (route) => false);
                        } else {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => MyWallet()));
                        }
                      } else {
                        HttpServices _httpService = HttpServices();
                        var status = true;

                        if (callType == "video") {
                          bool isPermissionGranted =
                              await handlePermissionsForCall(context);
                          if (isPermissionGranted) {
                            if (status) {
                              mystate(() {
                                status = false;
                              });

                              var res = await _httpService.call_initiate(
                                  astrologer_id: astrologerID,
                                  call_type: "video", channel_id: '');
                              if (res!.status == true) {
                                mystate(() {
                                  loading = true;
                                });
                                print("token  6546");
 print(res.agora_token);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => VideoCallScreen(
                                            channelName: res.channel_id!,
                                            name: name,
                                            profile: profile,
                                            // ✅ CRITICAL FIX: pass agora token
                                            // Without this, joinChannel uses empty ""
                                            // and Agora rejects the join silently
                                            token      : res.agora_token ?? '', )));
 
                                mystate(() {
                                  status = true;
                                });
                              } else {
                                Navigator.pop(context);
                                Fluttertoast.showToast(msg: res.message!);
                              }
                            } else {
                              mystate(() {
                                status = true;
                                loading = false;
                              });
                            }
                          }
                       } else if (callType == "audio") {
  mystate(() { loading = true; });

  // Fluttertoast.showToast(msg: "Thank You!\nYou will get a call from our astrologer shortly.");

  var res = await _httpService.call_initiate(
      astrologer_id: astrologerID, call_type: "audio", channel_id: '');

  if (res!.status == true) {
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AfterCallConnecting(
          name       : name,
          profile    : profile,
          channelName: res.channel_id!,
          callfrom   : username,
          token      : res.agora_token ?? '',  // ✅ ADD THIS
        )));
  } else {
    Fluttertoast.showToast(msg: res.message!);
  }
} else if (callType == "chat") {
                          final prefs = await SharedPreferences.getInstance();
                          String userID = prefs.getString('id').toString();
                          String channelId = userID +
                              "_" +
                              astrologerID +
                              "_" +
                              ((DateTime.now().millisecondsSinceEpoch)
                                  .toString());

                          mystate(() {
                            loading = true;
                          });

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => ChatCallingScreen(
                                        wallet: userWallet,
                                        rate: videoRate,
                                        name: name,
                                        profile: profile,
                                        astrologer_id: astrologerID,
                                        channel_id: channelId,
                                      )));
                        } else {
                          Get.snackbar("Failed",
                              "Microphone Permission Required for Calling",
                              backgroundColor: Colors.white,
                              colorText: Color(0xFF1A1E78),
                              snackPosition: SnackPosition.BOTTOM);
                        }
                      }
                    } catch (e) {
                      print("Error during onTap: $e");
                      Fluttertoast.showToast(
                          msg: "An error occurred. Please try again.");
                      mystate(() {
                        loading = false;
                      });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFC7601), Color(0xFFFC7601)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0),
                          blurRadius: 2.0,
                        ),
                      ],
                    ),
                    width: double.infinity,
                    margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                    child: loading == false
                        ? Row(
                            children: [
                              SizedBox(width: 120),
                              Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.white,
                                    )),
                              ),
                            ],
                          )
                        : Text(
                            setText(callType, userWallet, videoRate),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                  ),
                )
              ],
            ),
          );
        });
      });
}

getMinApunt(String videoRate) {
  var totalMin = 0.0;
  totalMin = double.parse(videoRate) * 5;

  return '${totalMin.toStringAsFixed(0)} ';
}

String setCallType(String callType) {
  if (callType == "chat") {
    return "Chat";
  } else if (callType == "audio") {
    return "Talk";
  } else if (callType == "video") {
    return "Video";
  }
  return '';
}

showAlertDialog(
    BuildContext context,
    var phone,
    var number,
    bool loading,
    StateSetter mystate,
    var userWallet,
    var videoRate,
    var astrologerID) async {
  HttpServices _httpService = HttpServices();
  AlertDialog alert = AlertDialog(
    title: Center(
        child: Text(
      "Call initiated!",
      style: TextStyle(
          color: blackColor, fontSize: 14, fontWeight: FontWeight.w500),
    )),
    content: SizedBox(
      height: 400,
      child: Column(
        children: [
          Text(
            "You will receive a call from",
            style: TextStyle(
                color: blackColor, fontSize: 14, fontWeight: FontWeight.w500),
          ),
          Text(
            "+918048159392",
            style: TextStyle(
                color: primaryColor, fontSize: 14, fontWeight: FontWeight.w500),
          ),
          Row(
            children: [
              Text(
                "number on your ",
                style: TextStyle(
                    color: blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                phone ?? '',
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Text(
            "number.",
            style: TextStyle(
                color: blackColor, fontSize: 14, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF000000),
                  Color(0xFF000000),
                ],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 1.0), //(x,y)
                  blurRadius: 2.0,
                ),
              ],
            ),
            width: double.infinity,
            margin: EdgeInsets.only(left: 20, right: 20),
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            child: Text(
              "Available Talk Time: " + getMaxDuration(userWallet, videoRate),
              style: TextStyle(
                  color: whiteColor, fontSize: 11, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Note: Based on the amount in your wallet, your call will be disconnected after ${getMaxDuration(userWallet, videoRate)}",
            style: TextStyle(
                color: blackColor, fontSize: 12, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Please ensure  $phone is switched on and is in network coverage area.",
            style: TextStyle(
                color: blackColor, fontSize: 12, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () async {
              Fluttertoast.showToast(
                  msg:
                      "Thank You!\nYou will get a call from our astrologer shortly.");
              var res = await _httpService.call_initiate(
                  astrologer_id: astrologerID, call_type: "audio", channel_id: '');
              if (res!.status == true) {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              } else {
                Fluttertoast.showToast(msg: res.message!);
              }
            },
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFC7601),
                    Color(0xFFFC7601),
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 2.0,
                  ),
                ],
              ),
              width: double.infinity,
              margin: EdgeInsets.only(left: 20, right: 20),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: loading == false
                  ? Row(
                      children: [
                        SizedBox(
                          width: 120,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                              )),
                        ),
                      ],
                    )
                  : Center(
                      child: Text(
                        "OK",
                        style: TextStyle(
                            color: whiteColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
            ),
          ),
        ],
      ),
    ),
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

double getcheck(String userWallet, String videoRate) {
  var totalMin = 0.0;
  totalMin = double.parse(userWallet) / double.parse(videoRate);

  return totalMin;
}

String getMaxDuration(String userWallet, String videoRate) {
  var totalMin = 0.0;
  totalMin = double.parse(userWallet) / double.parse(videoRate);

  return '${totalMin.toStringAsFixed(0)} min';
}

String setText(callType, String userWallet, String videoRate) {
  var totalMin = 0.0;
  totalMin = double.parse(userWallet) / double.parse(videoRate);
  if (callType == "video") {
    if (totalMin < 5) {
      return "Recharge Now";
    }
    return "Call Now";
  } else if (callType == "chat") {
    if (totalMin < 5) {
      return "Recharge Now";
    }
    return "Chat Now";
  } else if (callType == "audio") {
    if (totalMin < 5) {
      return "Recharge Now";
    }
    return "Call Now";
  }
  return "Call Now";
}

Future<void> callApi() async {}
