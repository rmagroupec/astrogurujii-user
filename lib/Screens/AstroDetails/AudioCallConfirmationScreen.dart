import 'dart:async';
import 'dart:math';

import 'package:astro_gurujii/Screens/homeScreen/Home.dart';
import 'package:astro_gurujii/Screens/poojaScreen/ui/poojaDetailScreen.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:astro_gurujii/Setup/app_colors.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../Setup/app_images.dart';
import '../../Utilities/CustomText.dart';
import '../../widget/bottom_navigation_bar_custom.dart';

class AudioCallConfirmationScreen extends StatefulWidget {
  String us_name;
  String us_image;
  String astrologerID;
  String video_rate;
  String min_call;
  String profile;
  String currency;
  String currency_code;
  String name;
  String userWallet;
  String call_type;
  AudioCallConfirmationScreen(
      {Key? key,
      required this.astrologerID,
      required this.video_rate,
      required this.min_call,
      required this.profile,
      required this.currency,
      required this.currency_code,
      required this.name,
      required this.userWallet,
      required this.call_type,
      required this.us_image,
      required this.us_name});

  @override
  State<AudioCallConfirmationScreen> createState() =>
      _AudioCallConfirmationScreenState();
}

class _AudioCallConfirmationScreenState
    extends State<AudioCallConfirmationScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    print(height);
    print(width);
    return Stack(
      children: [
        // Background image
        Positioned.fill(
          child: Image.asset(
            'assets/astro/Full-BG.jpg', // Make sure this path is correct and in pubspec.yaml
            fit: BoxFit.cover,
          ),
        ),

        Scaffold(
          backgroundColor: Colors.transparent,
          body: SizedBox(
            height: height,
            width: width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 15.55),
              height: height/10.32,
              width: width/2.7,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image:
                          AssetImage('assets/image/astro-logo-apbar.png'))),
            ),
            SizedBox(
              height: height / 40.66,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: width /28.235, // 5% of screen width
          vertical: height /62, ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(width/42.35),
                  color: Colors.white,
                  border: Border.all(
                      color: primaryColor.withOpacity(0.4), width: 1)),
              margin: EdgeInsets.symmetric(vertical: height/117.25, horizontal: width/52.93),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        height: height / 15.6,
                        width: width / 7.2,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(width/8.47),
                            border: Border.all(color: AppColors.orangeColor),
                            image: DecorationImage(
                                image: NetworkImage(widget.us_image),
                                fit: BoxFit.cover)),
                      ),
                      SizedBox(
                        height: height/116.25,
                      ),
                      SizedBox(
                          width: width / 5.14,
                          child: Text(
                            widget.us_name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: AppColors.mBGColor,
                                fontSize: width/30.25,
                                fontWeight: FontWeight.w400),
                          ))
                    ],
                  ),
                  SizedBox(
                    width: width / 2.12,
                    child: Column(
                      children: [
                        Container(
                          height: height/10.32,
              width: width/4.7,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/call+_connect.png"),
                                  fit: BoxFit.cover)),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: height/310, horizontal: width/42.35),
                          decoration: BoxDecoration(
                              color: blackColor.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(width/42.35)),
                          child: Text(
                            "CALL CONNECTING...",
                            style: TextStyle(
                                color: whiteColor,
                                fontWeight: FontWeight.w600,
                                fontSize: width/30.25,),
                          ),
                        )
                      ],
                    ),
                  ),
                 
                  Column(
                    children: [
                      Container(
                        height: height / 15.6,
                        width: width / 7.2,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(width/8.47),
                            border: Border.all(color: AppColors.orangeColor),
                            image: DecorationImage(
                                image: NetworkImage(widget.profile),
                                fit: BoxFit.cover)),
                      ),
                      SizedBox(
                        height: height/116.25,
                      ),
                      SizedBox(
                          width: width / 5.14,
                          child: Text(
                            widget.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: AppColors.mBGColor,
                                fontSize: width/30.25,
                                fontWeight: FontWeight.w400),
                          ))
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height/29.06,
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: width/21.17),
                child: Column(
                  children: [
                    Text(
                      "${widget.name} will be calling you in next ",
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: TextStyle(
                          color: AppColors.textBlack,
                          fontSize: width/30.25,
                          fontWeight: FontWeight.w800),
                    ),
                    Text(
                      "01:30 Minutes ",
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: TextStyle(
                          color: AppColors.textBlack,
                          fontSize: width/30.25,
                          fontWeight: FontWeight.w800),
                    ),
                  ],
                )),
            SizedBox(
              height: height/46.5,
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: width/21.17),
                child: Column(
                  children: [
                    Text(
                      "Please receive the call from",
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: TextStyle(
                          color: Colors.grey[700],
                          fontSize:width/30.25,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "+91 8069838240 ",
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: width/30.25,
                          fontWeight: FontWeight.w800),
                    ),
                  ],
                )),
            SizedBox(
              height: height / 60.3,
            ),
            Center(child: TimerCallScreen()),
            SizedBox(
              height: height / 60.3,
            ),
            Transform.rotate(
              angle: pi,
              child: Container(
                height: height/4.65,
                width: width/2.11,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/image/9VkLvoX5rp-unscreen.gif"))),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: width/42.35),
              height: height / 27.44,
              width: width / 3.2,
              decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.red,
                  ),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(width/52.935)),
              child: Center(
                child: Text(
                  "CALL RECEIVE",
                  style: TextStyle(
                      fontSize: width/28.23,
                      color: Colors.red,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: height/46.175,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MainHomeScreenWithBottomNavigation()));
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: width/42.35),
                height: height / 27.44,
                width: width / 2.9,
                decoration: BoxDecoration(
                    color: AppColors.orangeColor,
                    borderRadius: BorderRadius.circular(width/16.94)),
                child: Center(
                  child: Text(
                    "Explore Now",
                    style: TextStyle(
                        fontSize: width/28.23,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height/46.175,
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: width/21.175),
                child: Column(
                  children: [
                    Text(
                      "While you wait for ${widget.name}, you may check the other features of Pooja, Astro Mall & Astrologer",
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: TextStyle(
                          color: Colors.grey[700],
                          fontSize:  width/32.23,
                          fontWeight: FontWeight.w500),
                    ),
                    // Text("+91 8069838240 ",textAlign: TextAlign.center, maxLines: 2, style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.w800),),
                  ],
                )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TimerCallScreen extends StatefulWidget {
  // final String datetime;
  const TimerCallScreen({Key? key}) : super(key: key);
  @override
  _TimerCallScreenState createState() => _TimerCallScreenState();
}

class _TimerCallScreenState extends State<TimerCallScreen> {
  late ValueNotifier<Duration> durationNotifier;
  Timer? timer;

  // Initial countdown duration, you can customize this.
  late Duration countdownDuration;

  @override
  void initState() {
    super.initState();
    // final targetDateTime = DateTime.parse(widget.datetime);
    // print(widget.datetime);
    // Initialize the countdown duration
    countdownDuration = _getTimeDifference();

    // Create the ValueNotifier with the initial countdown duration
    durationNotifier = ValueNotifier<Duration>(countdownDuration);

    // Start the timer
    startTimer();
  }

  //  static const Duration countdownDuration = Duration(days: 10,hours:0,minutes: 0, seconds: 10);
  // final ValueNotifier<Duration> durationNotifier =
  // ValueNotifier<Duration>(countdownDuration);
  // Timer? timer;
  // @override
  // void initState() {
  //   super.initState();
  //   final targetDateTime = DateTime.parse(widget.datetime);
  //   setState(() {
  //     countdownDuration = _getTimeDifference(targetDateTime);
  //   });
  //   startTimer();
  // }
  @override
  void dispose() {
    timer?.cancel();
    durationNotifier.dispose();
    super.dispose();
  }

  Duration _getTimeDifference() {
    // final now = DateTime.now();
    // final difference = targetDateTime.isAfter(now) ? targetDateTime.difference(now) : Duration.zero;
    Duration fixedDuration = Duration(minutes: 1, seconds: 30);
    return fixedDuration;
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  void addTime() {
    final seconds = durationNotifier.value.inSeconds - 1;
    if (seconds < 0) {
      timer?.cancel();
// Handle end of timer here
// //       showEndMessage();
//       Navigator.of(context).pop();
      Navigator.of(context).pop();
    } else {
      durationNotifier.value = Duration(seconds: seconds);
    }
  }

  void showEndMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Timer Ended"),
          content: const Text("The timer has ended."),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height =  MediaQuery.of(context).size.height;
    return Container(
      width: MediaQuery.of(context).size.width,
      // color: Colors.red,
      child: ValueListenableBuilder<Duration>(
        valueListenable: durationNotifier,
        builder: (context, duration, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // SizedBox(height: 6,),
              // CustomText(text: "Puja Starts in", fontWeight: FontWeight.w300, color: AppColors.orangeColor,),
              SizedBox(
                height: height/116.25,
              ),
              Container(
                  padding: EdgeInsets.symmetric(vertical: height/186, horizontal: width/84.7),
                  width: MediaQuery.of(context).size.width / 3.2,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: blackColor),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(width/42.35)),
                  child: Column(
                    children: [
                      Text(
                        "Time Running",
                        style: TextStyle(
                            fontSize:
                                width / 30.64),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          buildTime(duration),
                          Text(
                            "Minutes",
                            style: TextStyle(fontSize: width / 30.64),
                          ),
                        ],
                      ),
                    ],
                  )),
              // if (duration.inSeconds <= 0) // Show "END" when timer is zero or less
              //   const Padding(
              //     padding: EdgeInsets.only(top: 20.0),
              //     child: Text(
              //       "END",
              //       style: TextStyle(
              //         color: Colors.white,
              //         fontSize: 10,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //   ),
            ],
          );
        },
      ),
    );
  }

  Future<bool> _onWillPop() async {
    timer?.cancel();
    Navigator.of(context).pop();
    return true;
  }

  Widget buildTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildTimeColumn(minutes, "Mins"),
        buildTimeColumn(seconds, "Secs", isLast: true),
      ],
    );
  }

  Widget buildTimeColumn(String time, String label, {bool isLast = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            buildDigit(time[0]),
            buildDigit(time[1]),
            if (!isLast) buildTimeSeparator(),
          ],
        ),
        // buildLabel(label),
      ],
    );
  }

  Widget buildDigit(String digit) {
     double width = MediaQuery.of(context).size.width;
    double height =  MediaQuery.of(context).size.height;
    return Container(
      padding:  EdgeInsets.symmetric(horizontal: width/423.5, vertical: height/965),
      margin: const EdgeInsets.symmetric(horizontal: 0),
      child: ClipRect(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          switchInCurve: Curves.easeOutExpo,
          switchOutCurve: Curves.easeInExpo,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return Stack(
              children: <Widget>[
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -1),
                    end: const Offset(0, 1),
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  )),
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                ),
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -1),
                    end: const Offset(0, 0),
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.bounceIn,
                  )),
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                ),
              ],
            );
          },
          child: Text(
            digit,
            key: ValueKey<String>(digit),
            style:  TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.mBGColor,
              fontSize: width/ 30.64
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLabel(String label) {
     double width = MediaQuery.of(context).size.width;
    double height =  MediaQuery.of(context).size.height;
    return Text(
      label,
      style:  TextStyle(
        color: AppColors.mBGColor,
        fontSize:  width/ 30.64,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget buildTimeSeparator() {
    double width = MediaQuery.of(context).size.width;
    double height =  MediaQuery.of(context).size.height;
    return  Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.0),
      child: Text(
        ":",
        style: TextStyle(
          color: AppColors.orangeColor,
          fontWeight: FontWeight.bold,
          fontSize:  width/ 30.64,
        ),
      ),
    );
  }
}
