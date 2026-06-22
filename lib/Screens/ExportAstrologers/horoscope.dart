import 'package:astro_gurujii/Screens/SignDetailsScreen.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:flutter/material.dart';

class Horoscope extends StatefulWidget {
  const Horoscope({Key? key}) : super(key: key);

  @override
  _HoroscopeState createState() => _HoroscopeState();
}

class _HoroscopeState extends State<Horoscope> {
  List<String> images = [
    "assets/images/astrologer6.png",
    "assets/images/astrologer3.png",
    "assets/images/astrologer4.png",
    "assets/images/astrologer11.png",
    "assets/images/astrologer7.png",
    "assets/images/astrologer8.png",
    "assets/images/astrologer2.png",
    "assets/images/astrologer10.png",
    "assets/images/astrologer5.png",
    "assets/images/astrologer9.png",
    "assets/images/astrologer12.png",
    "assets/images/astrologer1.png",
  ];
  List<String> text = [
    "Aries",
    "Taurus",
    "Gemini",
    "Cancer",
    "Leo",
    "Virgo",
    "Libra",
    "Scorpio",
    "Sagittarius",
    "Capricorn",
    "Aquarius",
    "Pisces"
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height*0.19,
        child: ListView.builder(
            itemCount: images.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 3),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => SignDetailsScreen(
                                imageUrl: images[index], title: text[index], index_api: '', isLoading: false,)));
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 10,left: 5,right: 5,bottom: 10),
                    padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white, // Container background color
                      borderRadius: BorderRadius.circular(20), // Optional: Round corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4), // Shadow color
                          spreadRadius: 1, // Spread radius
                          blurRadius: 1, // Blur radius
                          offset: Offset(0, 2), // Offset in x and y direction
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage(images[index]),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: CustomText(
                            text: text[index],
                            fontSize: 16,
                            color: Colors.black,

                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }));
  }
}
