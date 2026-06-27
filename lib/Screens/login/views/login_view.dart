import 'package:astro_gurujii/Screens/WebViewerTerms.dart';
import 'package:astro_gurujii/Setup/app_colors.dart';
import 'package:astro_gurujii/Setup/app_images.dart';
import 'package:astro_gurujii/Setup/strings.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../Setup/buttons/app_button.dart';
import '../../../Setup/buttons/app_button_icon.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  final controller = Get.put(LoginController());
  LoginView({Key? key}) : super(key: key);
  String countyCode = "91";
  bool newUser = false;

  var terms = "https://admin.astrogurujii.com/links/termandcondition";
  var privacy = "https://admin.astrogurujii.com/links/privacypolicy";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: ListView(
          children: [
            Container(
              color: Colors.white,
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        color: Colors.white,
                        height: Get.height * 0.35,
                        child: Image.asset(
                          AppImages.loginj,
                          height: Get.height * 0.05,
                          width: Get.width * 0.6,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFC796),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFFFFC796),
                              Color(0xFFF7903A),
                            ],
                          ),
                        ),
                        height: Get.height * 0.613,
                        child: Column(
                          children: [
                            SizedBox(
                              height: Get.height * 0.1,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 20, right: 20),
                              height: Get.height * 0.064,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, left: 10, bottom: 10),
                                    child: Image.asset(
                                      AppImages.indian_flag_icon,
                                      width: 20,
                                      height: 14,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  CustomText(
                                    text: "IN +91",
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, left: 2, bottom: 10),
                                    child: Image.asset(
                                      "assets/d_icons/down_arrow.png",
                                      width: 18,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  SizedBox(
                                    width: Get.width * 0.45,
                                    child: TextFormField(
                                      controller:
                                          controller.mobileNumberController,
                                      onChanged: (n) {
                                        if (n.length == 10) {
                                          controller.buttonColor.value = true;
                                        } else {
                                          controller.buttonColor.value = false;
                                        }
                                      },
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(10),
                                      ],
                                      validator: (val) {
                                        return controller
                                            .validateMobile(val ?? '');
                                      },
                                      cursorColor: AppColors.appthemeColor,
                                      showCursor: false,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18.0,
                                          color: AppColors.grey1),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        filled: false,
                                        hintText: "Phone number",
                                        labelStyle: const TextStyle(
                                            color: AppColors.grey2,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: Get.height * 0.04,
                            ),
                            Obx(() {
                              return AppButtonIcon(
                                cornerRadius: 15,
                                trailingIcon: Padding(
                                  padding: const EdgeInsets.only(
                                      right: 10, left: 0),
                                  child: Icon(Icons.arrow_forward_rounded),
                                ),
                                height: Get.height * 0.06,
                                isLoading: controller.loading.value,
                                backgroundColor:
                                    controller.buttonColor.value == false
                                        ? AppColors.grey3
                                        : AppColors.appthemeColor,
                                onPressed: () => controller.generateOtp(),
                                title: "    GET OTP",
                                textStyle: const TextStyle(
                                    color: AppColors.textWhite),
                              );
                            }),
                            Container(
                              margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                              alignment: Alignment.centerLeft,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CustomText(
                                        text: Strings.acceptTnC,
                                        align: TextAlign.center,
                                        fontSize: 14.0,
                                        overflow: TextOverflow.visible,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.textBlack,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (ctx) =>
                                                      WebViewerTerms(
                                                          appbarText:
                                                              "Terms of use",
                                                          webUrl: terms)));
                                        },
                                        child: CustomText(
                                          text: "Terms of Service",
                                          align: TextAlign.center,
                                          fontSize: 14.0,
                                          overflow: TextOverflow.visible,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.appthemeColor,
                                        ),
                                      ),
                                      CustomText(
                                        text: "& ",
                                        align: TextAlign.center,
                                        fontSize: 14.0,
                                        overflow: TextOverflow.visible,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.textBlack,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (ctx) =>
                                                      WebViewerTerms(
                                                          appbarText:
                                                              "Privacy Policy",
                                                          webUrl: privacy)));
                                        },
                                        child: CustomText(
                                          text: "Privacy Policy",
                                          align: TextAlign.center,
                                          fontSize: 14.0,
                                          overflow: TextOverflow.visible,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.appthemeColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(top: Get.height * 0.06),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                          width: Get.width * 0.2,
                                          height: Get.height * 0.06,
                                          child: Image.asset(
                                              AppImages.private_icon)),
                                      SizedBox(height: 5),
                                      Text(
                                        Strings.Private,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: Get.height * 0.1,
                                    child: VerticalDivider(
                                      thickness: 2,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                          width: Get.width * 0.2,
                                          height: Get.height * 0.06,
                                          child: Image.asset(
                                              AppImages.verified_icon)),
                                      SizedBox(height: 5),
                                      Text(
                                        Strings.Verified,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: Get.height * 0.1,
                                    child: VerticalDivider(
                                      thickness: 2,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                          width: Get.width * 0.2,
                                          height: Get.height * 0.06,
                                          child: Image.asset(
                                              AppImages.secure_icon)),
                                      SizedBox(height: 5),
                                      Text(
                                        Strings.Secure,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: Get.height * 0.326,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 40, right: 40, top: 10, bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.orange,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        child: Text(
                          'First Chat with Astrology is FREE!',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}