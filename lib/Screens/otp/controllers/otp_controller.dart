import 'dart:async';

import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Screens/routes/app_pages.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../otp_model.dart';

class OtpController extends GetxController {
  final buttonColor = false.obs;
  final loading = false.obs;
  final callKey = false.obs;
  final wAKey = false.obs;
  final smsKey = false.obs;
  final otpController = TextEditingController();

  final mobile = ''.obs;
  var start = 30.obs;
  var newUSer = false.obs;
  var userName = ''.obs;
  final HttpServices httpClient = HttpServices();

  var data = VerifyData();
  @override
  onInit() async {
    super.onInit();
    final _prefs = await SharedPreferences.getInstance();
    mobile.value = _prefs.getString('mobile_number').toString();
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  late Timer timer;

  void startTimer(bool isStart) {
    if (isStart) {
      const oneSec = Duration(seconds: 1);
      timer = Timer.periodic(
        Duration(seconds: 1),
            (Timer timer) {
          if (start.value == 0) {
            timer.cancel();
            update();
          } else {
            start.value--;
            update();
          }
        },
      );
    } else {
      timer.cancel();
      start.value = 30;
      update();
    }
  }

  void verifyOtp() async {
    try {
      if (otpController.text.isEmpty) {
        Get.snackbar("", "",
            titleText: CustomText(
              text: "Please enter otp..",
            ));
      } else if (otpController.text.length < 4) {
        Get.snackbar("", "",
            titleText: CustomText(
              text: "Otp must be of 4 digits..",
            ));
      } else {
        loading.value = true;
        final _prefs = await SharedPreferences.getInstance();
        final res = await httpClient.check_number(
          mobileNumber: _prefs.getString("mobile_number").toString(),
          country: "country",
          country_code: "",
          type: "",
          otp: otpController.text,
        );
        if (res!.status == true) {
          _prefs.setString('is_skip', "N");
          _prefs.setString('token', res.token!);
          _prefs.setString('name', res.results!.name!);
          _prefs.setString('id', res.results!.id!);
          _prefs.setString('email', res.results!.email!);
          _prefs.setString('number', res.results!.number!);
          _prefs.setString('gender', res.results!.gender!);
          _prefs.setString('dob', res.results!.dob!);
          _prefs.setString('birth_place', res.results!.birthPlace!);
          _prefs.setString('birth_time', res.results!.birthTime!);

          Get.offAllNamed(Routes.BOTTOM);
        } else {
          loading.value = false;
          Get.snackbar("", "",
              titleText: CustomText(
                text: res.message!,
              ));
        }
      }
    } catch (e) {
      loading.value = false;
      Get.snackbar("", "",
          titleText: CustomText(
            text: e.toString(),
          ));
    } finally {
      loading.value = false;
    }
  }
}
