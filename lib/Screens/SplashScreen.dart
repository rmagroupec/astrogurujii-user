import 'dart:async';
import 'dart:convert';

import 'package:astro_gurujii/Screens/homeScreen/Home.dart';
import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Screens/login/views/continue_screen.dart';
import 'package:astro_gurujii/Screens/login/views/login_view.dart';
import 'package:astro_gurujii/Setup/app_images.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../widget/bottom_navigation_bar_custom.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final HttpServices _httpServices = HttpServices();
  // final controllerHomePageLogic = Get.put(HomePageLogic());
  @override
  void initState() {
    _getfcmToken();
    startTime();
    super.initState();
  }

  Future<void> _getfcmToken() async {
    final FirebaseMessaging _fcm = FirebaseMessaging.instance;
    final token = await _fcm.getToken();
    print("fcm token${token}");
    //deviceTokentoSendNotification.value = token.toString();
    //print("____DEVICE TOKEN --->${token}");
    final _prefs = await SharedPreferences.getInstance();
    _prefs.setString('deviceToken', token.toString());
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size);
    return Scaffold(
      body: Container(
        height: Get.height,
        // decoration: const BoxDecoration(
        //     gradient: LinearGradient(colors: [
        //   // Color.fromRGBO(255, 221, 181, 1),
        //   Color.fromRGBO(252, 155, 4, 1),
        //   // Color.fromRGBO(255, 249, 237, 1),
        //   Color.fromRGBO(143, 40, 34, 1),
        // ])),
        child: Center(
          child: Image.asset(
            AppImages.splashGuruLogo,
            height: Get.height,
            width: Get.width,
            fit: BoxFit.fill,
          ),
          // child: SvgPicture.asset(
          //   // AppImages.splashLogo,
          //   AppImages.splashGuruLogoS,
          //   height: 200,
          // ),
        ),
      ),
    );
  }

  startTime() async {
    var _duration = const Duration(seconds: 1);
    return Timer(_duration, navigationPage);
  }

  Future<void> navigationPage() async {
    var _prefs = await SharedPreferences.getInstance();
    String _userId = _prefs.getString('token') ?? '';
    if (_userId != null && _userId != '') {
      callAli();
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => ContinueScreen()),
          (Route<dynamic> route) => false);
    }
  }

  Future<void> callAli() async {
    var code = await getCountryCode();
    var res = await _httpServices.currency_update(currency: code);
    try {
      if (res!.status == true) {
        try {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) =>  MainHomeScreenWithBottomNavigation()),
              (Route<dynamic> route) => false);
        } catch (e) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) =>  MainHomeScreenWithBottomNavigation()),
              (Route<dynamic> route) => false);
        }
      } else {
        Fluttertoast.showToast(msg: res.message!);
      }
    } catch (e) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) =>  MainHomeScreenWithBottomNavigation()),
          (Route<dynamic> route) => false);
    }
  }

  getCountryCode() async {
    return "INR";
    final response = await http.get(Uri.parse('http://ip-api.com/json'));
    Map data = jsonDecode(response.body);
    String country = data['country'];
    if (country == "India") {
      return "INR";
    } else {
      return "INR";
    }
  }
}
