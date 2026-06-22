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
  //var terms = "https://api.astrogurujii.com/links/termandcondition";
  //var privacy = "https://api.astrogurujii.com/links/privacypolicy";

  var terms = "https://admin.astrogurujii.com/links/termandcondition";
  var privacy = "https://admin.astrogurujii.com/links/privacypolicy";
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // flutterWebviewPlugin.goBack();
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
       /* body: Stack(
          children: [
            ///AppIcon
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  SizedBox(
                    height: Get.height * 0.07,
                  ),
                  Image.asset(
                    AppImages.loginj,
                    height: Get.height * 0.2,
                  ),
                ],
              ),
              // child: SvgPicture.asset(
              //   AppImages.logins,
              //   // AppImages.splashLogo,
              // ),
            ),

            ///LoginNow
            Column(
              children: [
                SizedBox(
                  height: Get.height / 2.5,
                ),
                Container(
                  height: Get.height - (Get.height / 2.5),
                  decoration: const BoxDecoration(
                      color: AppColors.textWhite,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30),
                      )),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 20, 0, 10),
                        alignment: Alignment.centerLeft,
                        child: CustomText(
                          text: Strings.loginNow,
                          fontSize: 20.0,
                          overflow: TextOverflow.visible,
                          fontWeight: FontWeight.w700,
                          color: AppColors.color191919,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                        alignment: Alignment.centerLeft,
                        child: CustomText(
                          text: Strings.loginNowSubHeading,
                          fontSize: 12.0,
                          overflow: TextOverflow.visible,
                          fontWeight: FontWeight.w400,
                          color: AppColors.grey2,
                        ),
                      ),

                      ///Number Text Form Field
                      Container(
                        height: 52.0,
                        margin: const EdgeInsets.only(
                            left: 20.0, right: 20.0, bottom: 16),
                        // padding: EdgeInsets.only(top: 9.5, left: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                              color: AppColors.appthemeColor, width: 2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // CustomText(
                            //   text: Strings.mobileNumber.toUpperCase(),
                            //     align: TextAlign.start,
                            //     color: AppColors.grey2,
                            //     fontSize: 10,
                            //     fontWeight: FontWeight.w500,
                            // ),
                            Container(
                              // color: Colors.black,
                              child: TextFormField(
                                controller: controller.mobileNumberController,
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
                                  return controller.validateMobile(val ?? '');
                                },
                                cursorColor: AppColors.appthemeColor,
                                showCursor: false,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14.0,
                                    color: AppColors.grey1),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  prefix: CustomText(
                                    text: '+91 | ',
                                    align: TextAlign.start,
                                    color: AppColors.grey1,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  filled: false,
                                  //hintText: Strings.mobileNumber,
                                  labelText: Strings.mobileNumber.toUpperCase(),
                                  labelStyle: const TextStyle(
                                      color: AppColors.grey2,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500),
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(10, 5, 5, 5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      ///Button
                      Obx(() {
                        return AppButton(
                          isLoading: controller.loading.value,
                          backgroundColor: controller.buttonColor.value == false
                              ? AppColors.grey3
                              // : AppColors.purpleColor,
                              : AppColors.appthemeColor,
                          onPressed: () => controller.generateOtp(),
                          height: 48,
                          title: Strings.login_button,
                          textStyle:
                              const TextStyle(color: AppColors.textWhite),
                        );
                      }),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
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
                              color: AppColors.grey2,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => WebViewerTerms(
                                            appbarText: "Terms & Conditions",
                                            webUrl: terms)));
                              },
                              child: CustomText(
                                text: " Terms of Service",
                                align: TextAlign.center,
                                fontSize: 11.0,
                                overflow: TextOverflow.visible,
                                fontWeight: FontWeight.w400,
                                // color: AppColors.purpleColor,
                                color: AppColors.appthemeColor,
                              ),
                            ),
                            CustomText(
                              text: "& ",
                              align: TextAlign.center,
                              fontSize: 11.0,
                              overflow: TextOverflow.visible,
                              fontWeight: FontWeight.w400,
                              color: AppColors.grey2,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => WebViewerTerms(
                                            appbarText: "Privacy Policy",
                                            webUrl: privacy)));
                              },
                              child: CustomText(
                                text: "Privacy Policy",
                                align: TextAlign.center,
                                fontSize: 11.0,
                                overflow: TextOverflow.visible,
                                fontWeight: FontWeight.w400,
                                color: AppColors.appthemeColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),*/

        body: ListView(
          children: [
            Container(
              // height: Get.height*1,
              color: Colors.white,
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        color: Colors.white,
                        height: Get.height * 0.35,
                        child: Image.asset(AppImages.loginj, height: Get.height*0.05,
                          width: Get.width*0.6,),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10,right: 10),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFC796),
                         gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFFFFC796), // #FFC796
                              Color(0xFFF7903A),],

                          ),

                        ),
                        height: Get.height * 0.613,
                        child: Column(
                          children: [
                            SizedBox(
                              height: Get.height*0.1,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 20,right: 20),
                              height: Get.height*0.064,
                              // color: Colors.black,
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
                                    padding: const EdgeInsets.only(top: 10,left: 10,bottom: 10),
                                    child: Image.asset(AppImages.indian_flag_icon),
                                  ),
                                 SizedBox(
                                   width: 8,
                                 ),
                                 CustomText(text: "IN +91",fontSize: 18, fontWeight: FontWeight.w400,),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10,left: 2,bottom: 10),
                                    child: Image.asset("assets/d_icons/down_arrow.png",width: 18,),
                                  ),

                                  SizedBox(
                                    width: 5,
                                  ),
                                 SizedBox(
                                   width: Get.width*0.45,
                                   child: TextFormField(
                                      controller: controller.mobileNumberController,
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
                                        return controller.validateMobile(val ?? '');
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
                                       // labelText: Strings.mobileNumber.toUpperCase(),
                                        labelStyle: const TextStyle(
                                            color: AppColors.grey2,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500),
                                        //contentPadding: const EdgeInsets.fromLTRB(20, 20, 5, 5),
                                      ),
                                    ),
                                 ),
                                ],
                              ),
                            ),

                            SizedBox(
                              height: Get.height*0.04,
                            ),

                            Obx(() {
                              return AppButtonIcon(
                                cornerRadius: 15,
                                trailingIcon: Padding(
                                  padding: const EdgeInsets.only(right: 10,left: 0),
                                  child: Icon(Icons.arrow_forward_rounded),
                                ),
                                height: Get.height*0.06,
                                isLoading: controller.loading.value,
                                backgroundColor: controller.buttonColor.value == false
                                    ? AppColors.grey3
                                // : AppColors.purpleColor,
                                    : AppColors.appthemeColor,
                                onPressed: () => controller.generateOtp(),
                                title: "    GET OTP",
                                textStyle:
                                const TextStyle(color: AppColors.textWhite),
                              );
                            }),


                            Container(
                              margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                              alignment: Alignment.centerLeft,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
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
                                                  builder: (ctx) => WebViewerTerms(
                                                      appbarText: "Terms of use",
                                                      webUrl: terms)));
                                        },
                                        child: Text("Terms of Use",style: TextStyle(color: Colors.white,fontSize:14,decoration: TextDecoration.underline,fontWeight: FontWeight.w700),) /*CustomText(
                                          text: " Terms of Service",
                                          align: TextAlign.center,
                                          fontSize: 11.0,
                                          overflow: TextOverflow.visible,
                                          fontWeight: FontWeight.w400,
                                          // color: AppColors.purpleColor,
                                          color: AppColors.textWhite,

                                        ),*/
                                      ),
                                      CustomText(
                                        text: " and",
                                        align: TextAlign.center,
                                        fontSize: 14.0,
                                        overflow: TextOverflow.visible,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.textBlack,
                                      ),

                                    ],
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (ctx) => WebViewerTerms(
                                                    appbarText: "Privacy Policy",
                                                    webUrl: privacy)));
                                      },
                                      child:Text("Privacy Policy",style: TextStyle(color: Colors.white,fontSize:14,decoration: TextDecoration.underline,fontWeight:FontWeight.w700),) /*CustomText(
                                      text: "Privacy Policy",
                                      align: TextAlign.center,
                                      fontSize: 11.0,
                                      overflow: TextOverflow.visible,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.appthemeColor,
                                    ),*/
                                  ),
                                ],
                              ),
                            ),



                            SizedBox(
                              height: Get.height*0.085,
                            ),

                            Padding(
                              padding: const EdgeInsets.only(left: 10,right: 10),
                              child: Divider(
                                thickness: 2,
                                color: Colors.black,
                              ),
                            ),

                          /*  Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width:Get.width*0.43,
                                  child: Divider(
                                    thickness: 2,
                                    color: Colors.black,
                                  ),
                                ),
                                Text("Or",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),),
                                SizedBox(
                                  width:Get.width*0.43,
                                  child: Divider(
                                    thickness: 2,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),*/

                            Padding(
                              padding:  EdgeInsets.only(top: Get.height*0.06),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                          width: Get.width*0.2,
                                          height: Get.height*0.06,
                                          child: Image.asset(AppImages.private_icon)),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(Strings.Private,textAlign:TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 12),)

                                    ],
                                  ),
                                  SizedBox(
                                    height: Get.height*0.1,
                                    child: VerticalDivider(
                                      thickness: 2,
                                      color: Colors.white,

                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                          width: Get.width*0.2,
                                          height: Get.height*0.06,
                                          child: Image.asset(AppImages.verified_icon)),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(Strings.Verified,textAlign:TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 12),)

                                    ],
                                  ),
                                  SizedBox(
                                    height: Get.height*0.1,
                                    child: VerticalDivider(
                                      thickness: 2,
                                      color: Colors.white,

                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                          width: Get.width*0.2,
                                          height: Get.height*0.06,
                                          child: Image.asset(AppImages.secure_icon)),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(Strings.Secure,textAlign:TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 12),)

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
              top: Get.height*0.326,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.only(left: 40,right: 40,top: 10,bottom: 10),
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
