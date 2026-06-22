import 'package:astro_gurujii/Screens/TalkAstrologer/TalkAstrologers.dart';
import 'package:astro_gurujii/Screens/controllers/home_page_logic.dart';
import 'package:astro_gurujii/Screens/panchange/PanchangeScreen.dart';
import 'package:astro_gurujii/Screens/poojaScreen/ui/poojaScreen.dart';
import 'package:astro_gurujii/Screens/torat/TarotFormScreen.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mall/ShoppingMall.dart';

class AstroOtherServices extends StatefulWidget {
  const AstroOtherServices({Key? key}) : super(key: key);

  @override
  _AstroTalkState createState() => _AstroTalkState();
}

class _AstroTalkState extends State<AstroOtherServices> {
  final controllerHomePageLogic = Get.put(HomePageLogic());
  List<String> astroIcons = [
    "assets/images/icon_pooja.png",
    "assets/images/tarote_reading_icon.png",
    "assets/images/icon_panchang.png",
    "assets/images/icon_mall.png",
    // "assets/images/report.svg"
  ];
  List<String> astroText = [
    "Pooja\n",
    "Tarot\nReading",
    "Panchang\n",
    "Astro\nMall",
  ];

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => PoojaScreen(),));

            },
            child: Container(
              padding: EdgeInsets.only(left: 13, right: 5, bottom: 5, top: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Image.asset(
                    astroIcons[0],
                    height: 70,
                    width: 70,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  CustomText(
                      text: astroText[0],
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      maxLines: 2,
                      align: TextAlign.center),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => PanchangeScreen()));
            },
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Image.asset(
                    astroIcons[2],
                    height: 72,
                    width: 72,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  CustomText(
                      text: astroText[2],
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      maxLines: 2,
                      align: TextAlign.center),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (ctx) => TarotFormScreen()));

            },
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Image.asset(
                    astroIcons[1],
                    height: 70,
                    width: 70,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  CustomText(
                      text: astroText[1] + "\n    ",
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      maxLines: 2,
                      align: TextAlign.center),
                ],
              ),
            ),
          ),


          InkWell(
            onTap: () {


              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) =>
                          ShoppingMall()));
              /*  Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => TalkAstrologer(
                            astroList: controllerHomePageLogic.astroListVoice,
                            appBarName: "Chat with Astrologer",
                            chatKey: "on",
                            talkKey: "",
                            videoKey: "",
                            screen: "home",
                            skill_id: "",
                            callType: "chat",
                          )));*/
            },
            child: Container(
              padding: EdgeInsets.only(left: 5, right: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Image.asset(
                        astroIcons[3],
                        height: 70,
                        width: 70,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      CustomText(
                          text: astroText[3] + "\n    ",
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                          maxLines: 2,
                          align: TextAlign.center),
                    ],
                  ),

                  // Positioned(
                  //   right: 0,
                  //   left: 0,
                  //   bottom: 40,
                  //   child: Container(
                  //     padding: EdgeInsets.symmetric(
                  //         horizontal: 4, vertical: 4),
                  //     decoration: BoxDecoration(
                  //       color: Colors.red,
                  //       borderRadius: BorderRadius.circular(5),
                  //     ),
                  //     child: Text(
                  //       'coming soon',
                  //       textAlign: TextAlign.center,
                  //       style: TextStyle(
                  //         fontSize: 8,
                  //         color: Colors.white,
                  //         fontWeight: FontWeight.w500,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  var userStaus = "";
  Future<void> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userStaus = prefs.get("is_skip").toString();
    });
  }
}
