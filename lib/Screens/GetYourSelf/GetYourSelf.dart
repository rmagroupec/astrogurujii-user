 import 'package:astro_gurujii/Screens/basic_numerology/NumerologyScreen.dart';
import 'package:astro_gurujii/Screens/match_details/KundliMatchingDetails.dart';
import 'package:astro_gurujii/Screens/panchange/PanchangeScreen.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../WebServices/model/kundali/KundaliFormScreen.dart';

class GetYourSelf extends StatefulWidget {
  const GetYourSelf({Key? key}) : super(key: key);

  @override
  _GetYourSelfState createState() => _GetYourSelfState();
}

class _GetYourSelfState extends State<GetYourSelf> {
  List<String>icons = [
    "assets/images/match1.png",
    "assets/images/kundli1.png",
    "assets/images/nurology.png",
    "assets/images/panchange.png",
    /*"assets/images/match3.png",*/
  ];

  List<String>title = [
    "1",
    "2",
    "3",
    "4",
    /*"5",*/
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 160,
        child: CarouselSlider(
          options: CarouselOptions(
              autoPlay: false,
              height: 160.0),
          items: icons.asMap().entries.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return InkWell(
                  onTap: (){
                    if(i.value=="assets/images/match1.png"){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>KundliMatchingDetails()));
                    }else if(i.value=="assets/images/nurology.png"){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>NumerologyScreen()));
                    }
                    else if(i.value=="assets/images/kundli1.png"){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>KundaliFormScreenN(id: '', price: '',)));
                    }
                    else if(i.value=="assets/images/panchange.png"){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>PanchangeScreen()));
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration:  BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        image:  DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(i.value)
                        )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15,top: 10,),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: CustomText(text: '',color: whiteColor,fontWeight: FontWeight.w600,fontSize: 16,),
                      ),
                    ),

                  ),
                );
              },
            );
          }).toList(),
        )
    );
  }
}
