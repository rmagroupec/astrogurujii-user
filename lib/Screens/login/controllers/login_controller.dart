import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Screens/otp/controllers/otp_controller.dart';
import 'package:astro_gurujii/Screens/routes/app_pages.dart';
import 'package:astro_gurujii/Setup/app_colors.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  //TODO: Implement LoginController
  final buttonColor = false.obs;
  final loading = false.obs;
  final mobileNumberController = TextEditingController();
  final HttpServices httpClient = HttpServices();
  final controller = Get.put(OtpController());

  String validateMobile(String value) {
    String pattern = r'^[6-9]\d{9}$';
    RegExp regExp = RegExp(pattern);
    if (value.length != 10) {
      Fluttertoast.showToast(msg: "Mobile Number must be of 10 digit");
      return 'Mobile Number must be of 10 digit';
    } else if (!regExp.hasMatch(value)) {
      Fluttertoast.showToast(msg: "Invalid Mobile Number");
      return 'Invalid Mobile Number';
    } else {
      return '';
    }
  }

  @override
  void onInit() {
    super.onInit();
    _getfcmToken();
  }

  Future<void> _getfcmToken() async {
    final FirebaseMessaging _fcm = FirebaseMessaging.instance;
    final token = await _fcm.getToken();

    final _prefs = await SharedPreferences.getInstance();
    _prefs.setString('deviceToken', token.toString());
    print('==================' + token.toString());
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    mobileNumberController.clear();
  }

  @override
  void dispose() {
    mobileNumberController.dispose();
    super.dispose();
  }

  void generateOtp() async {
    if (validateMobile(mobileNumberController.text) == '') {
      try {
        loading.value = true;
        final _prefs = await SharedPreferences.getInstance();
        final res = await httpClient.check_number(
          mobileNumber: mobileNumberController.text,
          otp: "",
          country_code: 'INR',
          country: "",
          type: "",
        );
        if (res!.status == true) {
          controller.mobile.value = mobileNumberController.text;

          _prefs.setString('mobile_number', controller.mobile.value.toString());
          loading.value = false;
          controller.startTimer(true);
          Get.toNamed(Routes.OTP);
        } else {
          loading.value = false;
          showAlertDialog(res.message!);
        }
      } finally {
        //  _loadingController.isLoading = false;
      }
    }
  }

  showAlertDialog(var message) {
    Get.dialog(
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Material(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        "Alert!",
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      //Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              child: const Text(
                                'OK',
                              ),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(0, 45),
                               
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                Get.back();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    /*Get.defaultDialog(
        title: 'Alert!!',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 30.0,
            ),
            CustomText(
              text: message */ /*"20%\nOFF"*/ /*,
              color: AppColors.textBlack,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            )
          ],
        ),
        radius: 10.0);*/
  }
}
