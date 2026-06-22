// ignore_for_file: prefer_const_constructors

import 'package:astro_gurujii/Screens/SignDetailsScreen.dart';
import 'package:astro_gurujii/Screens/WebServices/model/kundali/KundaliFormScreen.dart';
import 'package:astro_gurujii/Screens/basic_numerology/NumerologyScreen.dart';
import 'package:astro_gurujii/Screens/match_details/KundliMatchingDetails.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AstroTalk extends StatefulWidget {
  const AstroTalk({Key? key}) : super(key: key);

  @override
  _AstroTalkState createState() => _AstroTalkState();
}

class _AstroTalkState extends State<AstroTalk> {
  List<String> astroIcons = [
    "assets/images/daily_horoscaop.png",
    "assets/images/free_kundali_icon.png",
    "assets/images/kundali_metching_icon.png",
    "assets/images/icon_number_logy.png",
    // "assets/images/report.svg"
  ];
  List<String> astroText = [
    "Daily\nHoroscope",
    "Free\nKundli",
    "Kundli\nMatching",
    "Numero\n-logy",
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) => SignDetailsScreen(
                          imageUrl: "assets/images/astrologer6.png",
                          title: "Aries",
                          index_api: "1", isLoading: false,
                      )));
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
                  CustomText(
                      text: astroText[0],
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      align: TextAlign.center),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {

              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => KundaliFormScreenN(id: '', price: '',)));

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
                    height: 72,
                    width: 72,
                  ),
                  CustomText(
                      text: astroText[1],
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      align: TextAlign.center),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => KundliMatchingDetails()));
            },
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              //  alignment: Alignment.topCenter,
              //   width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Image.asset(
                    astroIcons[2],
                    height: 70,
                    width: 70,
                  ),
                  CustomText(
                      text: astroText[2],
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      align: TextAlign.center),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => NumerologyScreen()));
            },
            child: Container(
              padding: EdgeInsets.only(left: 5, right: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              //  alignment: Alignment.topCenter,
              //   width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    astroIcons[3],
                    height: 70,
                    width: 70,
                  ),
                  CustomText(
                      text: astroText[3],
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      align: TextAlign.center),
                ],
              ),
            ),
          ),
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
