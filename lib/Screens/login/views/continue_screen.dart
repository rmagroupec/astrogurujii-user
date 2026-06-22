import 'dart:async';

import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Setup/app_colors.dart';
import '../../../Setup/strings.dart';
import '../../WebViewerTerms.dart';
import 'login_view.dart';

class ContinueScreen extends StatefulWidget {


  @override
  State<ContinueScreen> createState() => _ContinueScreenState();
}

class _ContinueScreenState extends State<ContinueScreen> {
  late Timer _timer;
  double _rotation = 0.0;
  double _rotationb = 0.0;
  final double _rotationSpeed = 0.05; // Adjust this value to change rotation speed
  var terms = "https://admin.astrogurujii.com/links/termandcondition";
  var privacy = "https://admin.astrogurujii.com/links/privacypolicy";
  @override
  void initState() {
    super.initState();
    _startRotation();
  }

  @override
  void dispose() {
    _stopRotation();
    super.dispose();
  }

  void _startRotation() {
    _timer = Timer.periodic(Duration(milliseconds: 90), (_) {
      setState(() {
        _rotation += _rotationSpeed;
        _rotationb -= _rotationSpeed;
      });
    });
  }

  void _stopRotation() {
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(

        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/icon/splash_bg_screen.png"),fit: BoxFit.fill)

        ),
        child: Column(
          children: [
            SizedBox(
              height: Get.height*0.06,
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Transform.rotate(
                  angle: _rotation,
                  child: Image.asset("assets/d_icons/outer_weel.png",  height: Get.height*0.6,), // Replace with your image path
                ),
                Transform.rotate(
                  angle:_rotationb,
                    child: Image.asset("assets/d_icons/blank_sun.png", height: Get.height*0.15,)
                ),


                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Image.asset("assets/d_icons/weel_inside_logo.png", height: Get.height*0.032,),
                ),

                Positioned(
                  bottom: 20,
                    right: 10,
                    left: 10,
                    child: Image.asset("assets/icon/sloke_img.png", height: Get.height*0.08,)
                ),
              ],
            ),
            SizedBox(
              height: 0,
            ),
            CustomText(text: "Get solutions for everything with astrology",color: Colors.black54, fontSize: 14,fontWeight: FontWeight.normal,),
            SizedBox(
              height: 10,
            ),
            CustomText(text: "Change your life with",color: Colors.black, fontSize: 21,fontWeight: FontWeight.w600,),
            SizedBox(
              height: 10,
            ),
            Image.asset("assets/images/name_astro_guruji.png",width: Get.width*0.6,),
            Padding(
              padding: const EdgeInsets.only(top: 20,left: 20,right: 20),
              child: ElevatedButton(

                style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 55),
                   
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),


                    )

                ),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginView()),
                          (Route<dynamic> route) => false);
                  // Add your button press logic here
                },

                child: Text('Continue with mobile number',style: TextStyle(color: Color(0xFFFF5200),fontSize: 16,fontWeight: FontWeight.w500),),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
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
                    color: Colors.white,
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
                      child: Text("Terms of Use",style: TextStyle(color: Colors.white,fontSize:12,decoration: TextDecoration.underline),) /*CustomText(
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
                    text: " &  ",
                    align: TextAlign.center,
                    fontSize: 12.0,
                    overflow: TextOverflow.visible,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
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
                      child:Text("Privacy Policy",style: TextStyle(color: Colors.white,fontSize:12,decoration: TextDecoration.underline),) /*CustomText(
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

           


          ],
        ),
      ),
    );
  }
}
