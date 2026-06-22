import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Setup/SetUp.dart';

class LanguageChangeScreen extends StatefulWidget {


  @override
  State<LanguageChangeScreen> createState() => _LanguageChangeScreenState();
}

class _LanguageChangeScreenState extends State<LanguageChangeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: whiteColor, //change your color here
        ),
        title: Text("Select Your Language", style: TextStyle(color: whiteColor)),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
          Image.asset("assets/icon/icon_english.png",width: Get.width*0.4,),
          Image.asset("assets/icon/icon_hindi.png",width: Get.width*0.4,),
        ],),
      ),
    );
  }
}
