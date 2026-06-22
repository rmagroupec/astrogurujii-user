import 'dart:async';

import 'package:astro_gurujii/Screens/homeScreen/Home.dart';
import 'package:astro_gurujii/Screens/Login.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';


class IntroductionPage extends StatefulWidget {
  const IntroductionPage({Key? key}) : super(key: key);

  @override
  _IntroductionPageState createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  int _currentSlide = 0;
  List<Widget> _bannerSliders = [];
  List<String>  imgList = [
    'assets/login/introPage1.png',
    'assets/login/introPage2.png',
  ];

  @override
  void initState() {
    // TODO: implement initState
   // _bannerSliders=imgList.length;
    startTime();
    super.initState();
  }

  Future<void> navigationPage() async {
     var _prefs = await SharedPreferences.getInstance();
     String  _userId = _prefs.getString('token')??'';
     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginPage()), (Route<dynamic> route) => false);
    // if(_userId != null && _userId != '')
    // {
    //   Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>Home()));
    // }
    // else
    // {
    //    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginPage()), (Route<dynamic> route) => false);
    //
    // }
  }

  startTime() async {
    var _duration =  Duration(seconds:5);
    return  Timer(_duration, navigationPage);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(height: 50,),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 250,
            child: CarouselSlider(
              items: imgList.map((e) =>
                  Image.asset(e)
              //     Container(
              //   height: 250,
              //   decoration: BoxDecoration(
              //     image: DecorationImage(
              //       fit: BoxFit.cover,
              //       image: AssetImage(e)
              //     )
              //   ),
              // )
              ).toList(),
              options: CarouselOptions(
                  initialPage: 0,
                  viewportFraction: 1,
                  enableInfiniteScroll: false,
               //   scrollPhysics: const NeverScrollableScrollPhysics(),
                  autoPlay: true,
                  aspectRatio: 1.2,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentSlide = index;
                    });
                  }),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imgList.map((url) {
              int index = imgList.indexOf(url);
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentSlide == index
                      ? primaryColor
                      : Color.fromRGBO(0, 0, 0, 0.4),
                ),
              );
            }).toList(),
          ),
          SvgPicture.asset('assets/login/login_around.svg',color:primaryColor,width: MediaQuery.of(context).size.width,height: 150,),
         // SvgPicture.asset('assets/login/astro_push.svg',width: MediaQuery.of(context).size.width,height: 150,),
        ],
      ),
    );
  }
}
