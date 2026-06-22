
import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
 import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AstroTalk/newhoroscopeDesign.dart';

class SignDetailsScreen extends StatefulWidget {
  static const String signDetailScreen = "/signDetailScreen";

  final String imageUrl;
  String title;
  String index_api;
  bool isLoading;
  SignDetailsScreen({Key? key, required this.imageUrl, required this.title, required this.index_api, required this.isLoading});

  @override
  _SignDetailsScreenState createState() => _SignDetailsScreenState();
}

class _SignDetailsScreenState extends State<SignDetailsScreen> {

  final DateTime _currentDate = DateTime.now();
  HttpServices _httpService = HttpServices();
  String physique = "";
  String finances = "";
  String relationship = "";
  String career = "";
  String travel = "";
  String family = "";
  String friends = "";
  String health = "";
  String totalScore = "";

  var luck = '';
  String current_date = "",
      description = "",
      compatibility = "",
      mood = "",
      color = "",
      lucky_number = "",
      lucky_time = "";
  bool _isLoading = true;
  @override
  void initState() {
    callAli();
    super.initState();
  }

  String type = "2";

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
  String date = "";
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
  List<String> indexes = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12"
  ];

  callWebService(String date) async {
    setState(() {
      _isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    var res = await _httpService.get_daily_sun_horoscopea(
        sign: widget.index_api, date: date);
    if (res.status == true) {
      setState(() {
        current_date = "Today";
        physique = res.data!.horoscope!.botResponse!.physique!.splitResponse!;
        finances = res.data!.horoscope!.botResponse!.finances!.splitResponse!;
        relationship =
            res.data!.horoscope!.botResponse!.relationship!.splitResponse!;
        career = res.data!.horoscope!.botResponse!.career!.splitResponse!;
        travel = res.data!.horoscope!.botResponse!.travel!.splitResponse!;
        family = res.data!.horoscope!.botResponse!.family!.splitResponse!;
        friends = res.data!.horoscope!.botResponse!.friends!.splitResponse!;
        health = res.data!.horoscope!.botResponse!.health!.splitResponse!;
        totalScore = res.data!.horoscope!.botResponse!.totalScore!.splitResponse!;
        color = res.data!.horoscope!.luckyColor!;
        lucky_number = res.data!.horoscope!.luckyNumber.toString();
      });
    } else {
      _isLoading = false;
      //print("Profile Api Not Working");
      return;
    }
    setState(() {
      _isLoading = false;
    });
  }

  callWebServicenew() async {
    final prefs = await SharedPreferences.getInstance();
    var res = await _httpService.get_daily_sun_horoscopea(
        sign: widget.index_api, date: date);
    if (res.status == true) {
      setState(() {
        current_date = "Today";
        physique = res.data!.horoscope!.botResponse!.physique!.splitResponse!;
        finances = res.data!.horoscope!.botResponse!.finances!.splitResponse!;
        relationship =
            res.data!.horoscope!.botResponse!.relationship!.splitResponse!;
        career = res.data!.horoscope!.botResponse!.career!.splitResponse!;
        travel = res.data!.horoscope!.botResponse!.travel!.splitResponse!;
        family = res.data!.horoscope!.botResponse!.family!.splitResponse!;
        friends = res.data!.horoscope!.botResponse!.friends!.splitResponse!;
        health = res.data!.horoscope!.botResponse!.health!.splitResponse!;
        totalScore = res.data!.horoscope!.botResponse!.totalScore!.splitResponse!;
        color = res.data!.horoscope!.luckyColor!;
        lucky_number = res.data!.horoscope!.luckyNumber.toString();
      });
    } else {
      //print("Profile Api Not Working");
      return;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String _formattedDate = DateFormat.yMMMd().format(_currentDate);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: whiteColor, //change your color here
        ),
        backgroundColor: blueColor,
        title: Text(
          "${widget.title}",
          style: TextStyle(color: whiteColor),
        ),
      ),
      body: Container(
        child: _isLoading
            ? Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        )
            : Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              /*Container(
                margin: EdgeInsets.only(top: 20),
                alignment: Alignment.center,
                child: Text(current_date??'',
                  style: TextStyle(
                    fontSize: 18,
                      color: blueColor, fontWeight: FontWeight.w500),
                ),
              ),*/

              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        type = "1";
                        final f = new DateFormat('dd/MM/yyyy');
                        date = f
                            .format(DateTime.now()
                            .subtract(Duration(days: 1)))
                            .toString();
                        callWebService(date);
                      });
                    },
                    child: Container(
                      width: 100,
                      margin: EdgeInsets.only(left: 10, right: 5),
                      alignment: Alignment.center,
                      height: 35,
                      decoration: BoxDecoration(
                          color: (type == "1")
                              ? blueColor
                              : Color(0xFFCED0FB),
                          border: Border.all(color: Color(0xFFE0E0E0)),
                          borderRadius: BorderRadius.circular(20)),
                      child: CustomText(
                        text: "Yesterday",
                        color: (type == "1") ? whiteColor : blackColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        type = "2";
                        final f = new DateFormat('dd/MM/yyyy');
                        date = f.format(DateTime.now()).toString();
                        callWebService(date);
                      });
                    },
                    child: Container(
                      width: 100,
                      margin: EdgeInsets.only(left: 10, right: 5),
                      alignment: Alignment.center,
                      height: 35,
                      decoration: BoxDecoration(
                          color: (type == "2")
                              ? blueColor
                              : Color(0xFFCED0FB),
                          border: Border.all(color: Color(0xFFE0E0E0)),
                          borderRadius: BorderRadius.circular(20)),
                      child: CustomText(
                        text: "Today",
                        color: type == "2" ? whiteColor : blackColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        type = "3";
                        final f = new DateFormat('dd/MM/yyyy');
                        date = f
                            .format(DateTime.now().add(Duration(days: 1)))
                            .toString();
                        callWebService(date);
                      });
                    },
                    child: Container(
                      width: 100,
                      margin: EdgeInsets.only(left: 10, right: 5),
                      alignment: Alignment.center,
                      height: 35,
                      decoration: BoxDecoration(
                          color: (type == "3")
                              ? blueColor
                              : Color(0xFFCED0FB),
                          border: Border.all(color: Color(0xFFE0E0E0)),
                          borderRadius: BorderRadius.circular(20)),
                      child: CustomText(
                        text: "Tomorrow",
                        color: type == "3" ? whiteColor : blackColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              GridView.builder(
                itemCount: images.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical, // GridView doesn't typically scroll horizontally
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Set the number of columns in the grid
                  // mainAxisSpacing: 10.0, // Space between rows
                  crossAxisSpacing: 10.0, // Space between columns
                  childAspectRatio: 1, // Adjust as needed for the desired cell shape
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        widget.title = text[index];
                        widget.index_api = indexes[index];
                        //
                        //  callWebServicenew();

                      });


                      Navigator.push(context, MaterialPageRoute(builder: (context) => HoroscopeScreen(sign: widget.index_api, date: date),));


                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: text[index].contains(widget.title)
                              ? Colors.blue
                              : Colors.white,
                          radius: 33.0,
                          child: CircleAvatar(
                            backgroundImage: AssetImage(images[index]),
                            radius: 30.0,
                          ),
                        ),
                        CustomText(
                          text: text[index],
                          color: blackLightcolor,
                        )
                      ],
                    ),
                  );
                },
              ),
              SizedBox(
                height: 10,
              ),

              // hide old design
              // Text(
              //   "Physique" ?? '',
              //   style: TextStyle(
              //       color: blackColor,
              //       fontSize: 20,
              //       fontWeight: FontWeight.w500),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // Container(
              //   margin: EdgeInsets.symmetric(horizontal: 10),
              //   child: CustomText(
              //     text: physique!.toString(),
              //     color: blackColor,
              //     fontWeight: FontWeight.normal,
              //     fontSize: 14,
              //   ),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // Text(
              //   "Finances" ?? '',
              //   style: TextStyle(
              //       color: blackColor,
              //       fontSize: 20,
              //       fontWeight: FontWeight.w500),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // Container(
              //   margin: EdgeInsets.symmetric(horizontal: 10),
              //   child: CustomText(
              //     text: finances.toString(),
              //     color: blackColor,
              //     fontWeight: FontWeight.normal,
              //     fontSize: 14,
              //   ),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // Text(
              //   "Relationship" ?? '',
              //   style: TextStyle(
              //       color: blackColor,
              //       fontSize: 20,
              //       fontWeight: FontWeight.w500),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // Container(
              //   margin: EdgeInsets.symmetric(horizontal: 10),
              //   child: CustomText(
              //     text: relationship.toString(),
              //     color: blackColor,
              //     fontWeight: FontWeight.normal,
              //     fontSize: 14,
              //   ),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // Text(
              //   "Career" ?? '',
              //   style: TextStyle(
              //       color: blackColor,
              //       fontSize: 20,
              //       fontWeight: FontWeight.w500),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // Container(
              //   margin: EdgeInsets.symmetric(horizontal: 10),
              //   child: CustomText(
              //     text: career.toString(),
              //     color: blackColor,
              //     fontWeight: FontWeight.normal,
              //     fontSize: 14,
              //   ),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // Text(
              //   "Travel" ?? '',
              //   style: TextStyle(
              //       color: blackColor,
              //       fontSize: 20,
              //       fontWeight: FontWeight.w500),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // Container(
              //   margin: EdgeInsets.symmetric(horizontal: 10),
              //   child: CustomText(
              //     text: travel.toString(),
              //     color: blackColor,
              //     fontWeight: FontWeight.normal,
              //     fontSize: 14,
              //   ),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // Text(
              //   "Family" ?? '',
              //   style: TextStyle(
              //       color: blackColor,
              //       fontSize: 20,
              //       fontWeight: FontWeight.w500),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // Container(
              //   margin: EdgeInsets.symmetric(horizontal: 10),
              //   child: CustomText(
              //     text: family.toString(),
              //     color: blackColor,
              //     fontWeight: FontWeight.normal,
              //     fontSize: 14,
              //   ),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              //
              // ///
              // Text(
              //   "Friends" ?? '',
              //   style: TextStyle(
              //       color: blackColor,
              //       fontSize: 20,
              //       fontWeight: FontWeight.w500),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // Container(
              //   margin: EdgeInsets.symmetric(horizontal: 10),
              //   child: CustomText(
              //     text: friends.toString(),
              //     color: blackColor,
              //     fontWeight: FontWeight.normal,
              //     fontSize: 14,
              //   ),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              //
              // ///
              // Text(
              //   "Health" ?? '',
              //   style: TextStyle(
              //       color: blackColor,
              //       fontSize: 20,
              //       fontWeight: FontWeight.w500),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // Container(
              //   margin: EdgeInsets.symmetric(horizontal: 10),
              //   child: CustomText(
              //     text: health.toString(),
              //     color: blackColor,
              //     fontWeight: FontWeight.normal,
              //     fontSize: 14,
              //   ),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              //
              // ///
              // Text(
              //   "Conclusion" ?? '',
              //   style: TextStyle(
              //       color: blackColor,
              //       fontSize: 20,
              //       fontWeight: FontWeight.w500),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // Container(
              //   margin: EdgeInsets.symmetric(horizontal: 10),
              //   child: CustomText(
              //     text: totalScore.toString(),
              //     color: blackColor,
              //     fontWeight: FontWeight.normal,
              //     fontSize: 14,
              //   ),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              //
              // CustomText(
              //   text: "Lucky Color:  " +
              //       color
              //           .toString()
              //           .replaceAll("[", "")
              //           .replaceAll("]", "replace"),
              //   color: blackColor,
              //   fontWeight: FontWeight.normal,
              //   fontSize: 18,
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // CustomText(
              //   text: "Lucky Number:  " +
              //       lucky_number
              //           .toString()
              //           .replaceAll("[", "")
              //           .replaceAll("]", ""),
              //   color: blackColor,
              //   fontWeight: FontWeight.normal,
              //   fontSize: 18,
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              /// end old code



              /*CustomText(
                      text: luck.trim().toString(),
                      color: blackColor,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),*/
              /*  CustomText(
                      text: luck[1].trim().toString(),
                      color: blackColor,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                    CustomText(
                      text: luck[2].trim().toString(),
                      color: blackColor,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomText(
                      text: luck[3].trim().toString(),
                      color: blackColor,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                    CustomText(
                      text: luck[4].trim().toString(),
                      color: blackColor,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                    CustomText(
                      text: luck[5].trim().toString(),
                      color: blackColor,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),*/
            ],
          ),
        ),
      ),
    );
  }

  void callAli() async {
    setState(() {
      final f = new DateFormat('dd/MM/yyyy');
      date = f.format(DateTime.now()).toString();
      callWebService(date);
    });
  }
}
