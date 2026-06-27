import 'package:astro_gurujii/Screens/login/controllers/login_controller.dart';
import 'package:astro_gurujii/Screens/otp/controllers/otp_controller.dart';
import 'package:astro_gurujii/Screens/routes/app_pages.dart';
import 'package:astro_gurujii/Setup/app_colors.dart';
import 'package:astro_gurujii/Setup/app_images.dart';
import 'package:astro_gurujii/Setup/buttons/app_button.dart';
import 'package:astro_gurujii/Setup/strings.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../WebViewerTerms.dart';

class OTPView extends GetView<OtpController> {
  final loginController = Get.put(LoginController());

  var terms = "https://admin.astrogurujii.com/links/termandcondition";
  var privacy = "https://admin.astrogurujii.com/links/privacypolicy";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: AppColors.pechOrage,
              padding: EdgeInsets.only(top: 50),
              child: Column(
                children: [
                  Center(
                    child: Image.asset(
                      AppImages.circular_image_icon,
                      width: Get.width * 0.7,
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.05,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Center(
                          child: SizedBox(
                            width: Get.width * 0.25,
                            child: Divider(
                              thickness: 2,
                              color: AppColors.pechOrage,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        _buildOTPForm(context),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOTPForm(BuildContext appContext) {
    return Container(
      height: Get.height * 0.6,
      decoration: BoxDecoration(
        color: AppColors.textWhite,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          /// Verify text
          _buildVerifyText(),

          const SizedBox(height: 10),

          /// OTP sent to row
          _buildRowText(),

          /// Enter OTP label
          _buildEnterOTPText(),

          /// OTP Fields
          _buildOTPFields(appContext),

          /// Resend OTP Timer
          Obx(() {
            return _buildResendOTPTimer();
          }),

          const SizedBox(height: 15),

          /// Resend options (shown when timer hits 0)
          Obx(() {
            return (controller.start.value == 0)
                ? _buildResendOptions()
                : const SizedBox();
          }),

          const SizedBox(height: 15),

          /// Submit Button — wrapped in Obx so buttonColor change updates the color
          Obx(() {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: AppButton(
      isLoading: controller.loading.value,
      cornerRadius: 30,
      height: 55,
      backgroundColor: controller.buttonColor.value
          ? AppColors.appthemeColor
          : AppColors.grey3,
      onPressed: () => controller.verifyOtp(),
      title: Strings.otpButton,
    ),
  );
}),

          /// Terms & Privacy
          Container(
            margin: EdgeInsets.only(top: Get.height * 0.06),
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: Strings.acceptTnC,
                  align: TextAlign.center,
                  fontSize: 11.0,
                  overflow: TextOverflow.visible,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        appContext,
                        MaterialPageRoute(
                            builder: (ctx) => WebViewerTerms(
                                appbarText: "Terms of use",
                                webUrl: terms)));
                  },
                  child: Text(
                    "Terms of Use",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 11,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                CustomText(
                  text: " &  ",
                  align: TextAlign.center,
                  fontSize: 11.0,
                  overflow: TextOverflow.visible,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        appContext,
                        MaterialPageRoute(
                            builder: (ctx) => WebViewerTerms(
                                appbarText: "Privacy Policy",
                                webUrl: privacy)));
                  },
                  child: Text(
                    " Privacy Policy",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 11,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerifyText() {
    return Container(
      margin: const EdgeInsets.fromLTRB(30, 10, 0, 0),
      alignment: Alignment.centerLeft,
      child: CustomText(
        text: Strings.verifyOTP,
        fontSize: 20.0,
        overflow: TextOverflow.visible,
        fontWeight: FontWeight.w600,
        color: AppColors.color191919,
      ),
    );
  }

  Widget _buildRowText() {
    return Container(
      margin: EdgeInsets.fromLTRB(30, 10, 0, 0),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          CustomText(
            text: "${Strings.otpSentTo} +91",
            fontWeight: FontWeight.w400,
            color: Colors.black54,
            fontSize: 16,
          ),
          CustomText(
            text: " ${controller.mobile.value}",
            fontWeight: FontWeight.w600,
            color: AppColors.appthemeColor,
            fontSize: 16,
          ),
          const SizedBox(width: 5),
          InkWell(
            onTap: () {
              try {
                controller.start.value = 30;
                controller.startTimer(false);
                Get.toNamed(Routes.LOGIN);
              } catch (e) {
                Get.toNamed(Routes.LOGIN);
              }
            },
            child: const Icon(
              Icons.edit,
              size: 20,
              color: AppColors.appthemeColor,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildEnterOTPText() {
    return Container(
      margin: const EdgeInsets.fromLTRB(30, 20, 0, 0),
      alignment: Alignment.centerLeft,
      child: CustomText(
        text: Strings.enterOTP,
        fontSize: 20.0,
        overflow: TextOverflow.visible,
        fontWeight: FontWeight.w900,
        color: AppColors.orangeColor,
      ),
    );
  }

  Widget _buildOTPFields(BuildContext appContext) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 0),
      padding: const EdgeInsets.only(left: 10, right: 10),
      color: AppColors.textWhite,
      child: Padding(
        padding: const EdgeInsets.only(top: 0, left: 10, right: 10),
        child: PinCodeTextField(
          controller: controller.otpController,
          appContext: appContext,
          length: 4,
          onChanged: (val) {
            if (val.length < 4) {
              controller.buttonColor.value = false;
            } else {
              controller.buttonColor.value = true;
            }
          },
          pinTheme: PinTheme(
            borderWidth: 1.5,
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(8),
            fieldHeight: 58,
            fieldWidth: 58,
            selectedFillColor: AppColors.textWhite,
            disabledColor: AppColors.textWhite,
            inactiveFillColor: AppColors.textWhite,
            selectedColor: AppColors.appthemeColor,
            activeFillColor: AppColors.textWhite,
            activeColor: AppColors.appthemeColor,
            inactiveColor: AppColors.grey3,
          ),
          cursorColor: AppColors.appthemeColor,
          textStyle: const TextStyle(color: AppColors.textBlack, fontSize: 24),
          enableActiveFill: true,
          enablePinAutofill: true,
          keyboardType: TextInputType.number,
          autoFocus: true,
        ),
      ),
    );
  }

  Widget _buildResendOTPTimer() {
    return Container(
      margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          (controller.start.value == 0)
              ? Row(
                  children: [
                    InkWell(
                      onTap: () {
                        // loginController.generateOtp();
                        // controller.start.value = 30;
                        // controller.startTimer();
                      },
                      child: CustomText(
                        text: Strings.resendVia,
                        align: TextAlign.center,
                        fontSize: 12.0,
                        overflow: TextOverflow.visible,
                        fontWeight: FontWeight.w500,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                )
              : const SizedBox(),
          const SizedBox(width: 5),
          (controller.start.value > 0)
              ? CustomText(
                  text:
                      "${Strings.resendIn} ${controller.start.value} ${Strings.sec}",
                  align: TextAlign.center,
                  fontSize: 12.0,
                  overflow: TextOverflow.visible,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textBlack,
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  Widget _buildVerifyAndProceedButton() {
    return AppButton(
      isLoading: controller.loading.value,
      cornerRadius: 30,
      height: 55,
      backgroundColor: controller.buttonColor.value == false
          ? AppColors.grey3
          : AppColors.appthemeColor,
      onPressed: () => controller.verifyOtp(),
      title: Strings.otpButton,
    );
  }

  Widget _buildResendOptions() {
    return InkWell(
      onTap: () {
        loginController.generateOtp();
        controller.start.value = 30;
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(12, 5, 12, 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.appthemeColor, width: 1.8),
        ),
        child: Text(
          'SMS',
          style: TextStyle(
            color: AppColors.appthemeColor,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}