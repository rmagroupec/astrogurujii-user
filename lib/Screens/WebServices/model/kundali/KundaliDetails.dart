
import 'package:astro_gurujii/Screens/TalkAstrologer/TalkAstrologers.dart';
import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Screens/WebServices/model/kundali/KundaliChartsModel.dart';
import 'package:astro_gurujii/Screens/WebServices/model/kundali/model/antarDashaModel.dart';

import 'package:astro_gurujii/Screens/WebServices/model/major_vdasha/Vdasha.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_widgets/glassmorphism_widgets.dart';
import 'package:intl/intl.dart';

import '../../api_helper.dart';
import 'doshaDesignNew.dart';
// import 'model/antarDashaModel!.dart';
import 'model/modelNew.dart';

class KundaliDetailsN extends StatefulWidget {
  var name;
  var place;
  var id;

  var year;
  var month;
  var day;
  var hour;
  var min;
  var lat;
  var lon;

  KundaliNew? res;
  KundaliDetailsN(
      {this.res,
        this.name,
        this.place,
        this.id,
        this.year,
        this.month,
        this.day,
        this.hour,
        this.min,
        this.lat,
        this.lon});

  @override
  State<StatefulWidget> createState() {
    return KundaliDetailsNState();
  }
}

class KundaliDetailsNState extends State<KundaliDetailsN> {
  late TabController _tabController;
  HttpServices _httpService = HttpServices();
  List<Vdasha> vdasha1 = [];
  List<Vdasha> vdasha2 = [];
  List<Vdasha> vdasha3 = [];
  List<Vdasha> vdasha4 = [];

  String? c_vdasha1 = "";
  String? c_vdasha2 = "";
  String? c_vdasha3 = "";
  String? c_vdasha4 = "";

  String? showDasha = "1";
  Message? message;
  var d1 = "";
  var d9 = "";
  var moon = "";
  var kp_chalit = "";
  var sun = "";
  @override
  void initState() {
    mahaDashaApi();
    antarDashaApi();
    // getMajorVdashaApi1();
    createChart();
    super.initState();
  }

  String? convertDateString(String? dateString) {
    // Define the input date format
    DateFormat inputFormat = DateFormat('EEE MMM dd yyyy');
    // Define the output date format
    DateFormat outputFormat = DateFormat('dd/MM/yyyy');

    // Parse the input date string? to a DateTime object
    DateTime dateTime = inputFormat.parse(dateString!);

    // Format the DateTime object to the desired output format
    String? formattedDate = outputFormat.format(dateTime);

    return formattedDate;
  }

  Future<void> createChart() async {
    var res = await _httpService.kundaliNewChart(
      year: widget.year,
      month: widget.month,
      day: widget.day,
      hour: widget.hour,
      min: widget.min,
      lat: widget.lat,
      lon: widget.lon,
      tzone: "5.5", name: '', planetColor: '', signColor: '', lineColor: '', chartType: '',
    );
    if (res!.status != null) {
      setState(() {
        d1 = res.message!.d1.toString();
        d9 = res.message!.d9.toString();
        moon = res.message!.moon!.toString();
        sun = res.message!.sun.toString();
        kp_chalit = res.message!.kp_chalit.toString();

        print("Sun image===>>> ${sun}");

      });
    } else {}
  }

  // Future<void> getMajorVdashaApi1() async {
  //   var res = await _httpService.major_vdasha(id: widget.id);
  //   if (res!.status) {
  //     setState(() {
  //       vdasha1 = res!.vdasha;
  //       setState(() {
  //         showDasha = "1";
  //       });
  //     });
  //   } else {
  //     Fluttertoast.showToast(msg: "Something went wrong");
  //   }
  // }

  Future<void> getMajorVdashaApi2(String? md) async {
    var res = await _httpService.sub_vdasha(id: widget.id, md: md!);
    if (res!.status ==true) {
      setState(() {
        vdasha2 = res!.vdasha!;
        setState(() {
          showDasha = "12";
        });
      });
    } else {
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }

  bool dashaBool=false;

  List<String?> mahadashaList=[];
  List<String?> mahadashaDateList=[];
  Future<void> mahaDashaApi() async {
    var res = await _httpService.mahaDashaApiFun(
        dob:"${widget.day}/${widget.month}/${widget.year}" ,
        lat:widget.lat.toString() ,
        lon: widget.lon.toString(),
        tob: "${widget.hour}:${widget.min}"
    );
    if (res!.status == true) {
      setState(() {
        mahadashaList = res!.data!.mahadasha!;
        mahadashaDateList = res!.data!.mahadashaOrder!;

      });

      print("mahadashaList ===>> ${mahadashaList}");
      print("mahadashaDateList ===>> ${mahadashaDateList}");
    } else {
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }


  ///antar dasha
  List<String?> antardashaList=[];
  List<String?> antarDashaDateList=[];
  AntarDashaModel? antarDashaModel;
  Future<void> antarDashaApi() async {
    var res = await _httpService.antarDashaApiFun(
        dob:"${widget.day}/${widget.month}/${widget.year}" ,
        lat:widget.lat.toString() ,
        lon: widget.lon.toString(),
        tob: "${widget.hour}:${widget.min}"
    );
    if (res!.status == true) {
      setState(() {

        antarDashaModel=res;
      });


    } else {
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }




  Future<void> getMajorVdashaApi3(String? md, String? ad) async {
    var res = await _httpService.sub_sub_vdasha(id: widget.id, md: md!, ad: ad!);
    if (res!.status == true) {
      setState(() {
        vdasha3 = res!.vdasha!;
        setState(() {
          showDasha = "123";
        });
      });
    } else {
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }

  Future<void> getMajorVdashaApi4(String? md, String? ad, String? pd) async {
    var res = await _httpService.sub_sub_sub_vdasha(
        id: widget.id, md: md!, ad: ad!, pd: pd!);
    if (res!.status == true) {
      setState(() {
        vdasha4 = res!.vdasha!;
        setState(() {
          showDasha = "1234";
        });
      });
    } else {
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Container(
        color: whiteColor,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.black, //change your color here
            ),
            title: Text(
              "Kundli Details",
              style: TextStyle(color: blackColor),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: primaryColor,
                    child: TabBar(
                      isScrollable: true,
                      labelStyle: Theme.of(context).tabBarTheme.labelStyle,
                      unselectedLabelStyle:
                      Theme.of(context).tabBarTheme.unselectedLabelStyle,
                      indicatorColor: Colors.black,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.black,
                      tabs: const [
                        Tab(
                          text: "Basic Details",
                        ),
                        Tab(
                          text: "Planets",
                        ),
                        Tab(
                          text: "Charts",
                        ),
                        Tab(
                          text: "Dasha",
                        ),
                        Tab(
                          text: "Dosha",
                        ),

                        /* Tab(
                          text: "Free Report",
                        ),*/
                      ],
                    ),
                  ),
                  Container(
                    child: Expanded(
                      child: Container(
                        height: Get.height,
                        child: TabBarView(
                            physics: NeverScrollableScrollPhysics(),
                            children: [
                              basicView(),
                              kundaliView(),
                              chartView(),
                              dashaBool==false? mahaaDashaSection():antarDashaSection(),
                              DoshaScreen(res: widget.res!,)


                              /* ,
                              vimshottari_DashaView(),*/
                              //basicView()
                            ]),
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8, bottom: 8, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => TalkAstrologer(
                                      appBarName: "Chat with Astrologer",
                                      chatKey: "on",
                                      talkKey: "",
                                      skill_id: "",
                                      videoKey: "",
                                      callType: "chat",
                                    )));
                          },
                          child: GlassContainer(
                            linearGradient: LinearGradient(
                              colors: [
                                Color(0xFFff9401),
                                Color(0xFFff9401),
                              ],
                            ),
                            height: 50,
                            alignment: Alignment.centerLeft,
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Icon(Icons.error,color: whiteColor,),
                                SvgPicture.asset(
                                  'assets/images/chat_icon.svg',
                                  width: 18,
                                  height: 18,
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                CustomText(
                                  text: 'Chat to Astrologer',
                                  color: whiteColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => TalkAstrologer(
                                        appBarName:
                                        "Video Call with Astrologer",
                                        chatKey: "",
                                        videoKey: "on",
                                        skill_id: "",
                                        talkKey: "",
                                        callType: "video")));
                            /*  Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => TalkAstrologer(
                                          appBarName: "Talk with Astrologer",
                                          chatKey: "",
                                          talkKey: "on",
                                          videoKey: "",
                                          callType: "audio",
                                          expert_astro: "on")));*/

                            /* Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => ShoppingMall()));*/
                          },
                          child: GlassContainer(
                            linearGradient: LinearGradient(
                              colors: [
                                Color(0xFFff9401),
                                Color(0xFFff9401),
                              ],
                            ),
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/call_icon.svg',
                                  width: 18,
                                  height: 18,
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                CustomText(
                                  text: 'Video Call with Astrologer',
                                  color: whiteColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget basicView() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10)),
                height: 50,
                child: Center(
                    child: CustomText(
                      text: 'Birth Details',
                      color: blackColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      align: TextAlign.start,
                    ))),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Column(
                children: [
                  Container(
                    height: 50,
                    color: lightYellow,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: CustomText(
                                text: 'Name',
                                color: blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 7,
                            child: CustomText(
                              text: widget.name.toString(),
                              color: blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ))
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    color: whiteColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: CustomText(
                                text: 'Date',
                                color: blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 7,
                            child: CustomText(
                              text: widget.day.toString() +
                                  "/" +
                                  widget.month.toString() +
                                  "/" +
                                  widget.year.toString(),
                              color: blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ))
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    color: lightYellow,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: CustomText(
                                text: 'Time',
                                color: blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 7,
                            child: CustomText(
                              text:
                              '${widget.hour.toString()}:${widget.min.toString()}',
                              color: blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ))
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    color: whiteColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: CustomText(
                                text: 'Place',
                                color: blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 7,
                            child: CustomText(
                              text: widget.place.toString(),
                              color: blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ))
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    color: lightYellow,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: CustomText(
                                text: 'Latitude',
                                color: blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 7,
                            child: CustomText(
                              text: widget.lat.toString(),
                              color: blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ))
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    color: whiteColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: CustomText(
                                text: 'Longitude',
                                color: blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 7,
                            child: CustomText(
                              text: widget.lon.toString(),
                              color: blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ))
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    color: lightYellow,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: CustomText(
                                text: 'Timezone',
                                color: blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 7,
                            child: CustomText(
                              text: "5.5".toString(),
                              color: blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ))
                      ],
                    ),
                  ),
                  /*Container(
                    height: 50,
                    color: whiteColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: CustomText(
                                text: 'Sunrise',
                                color: blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 7,
                            child: CustomText(
                              text: widget.res!.birth_data[0].sunrise,
                              color: blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ))
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    color: lightYellow,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: CustomText(
                                text: 'Sunset',
                                color: blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 7,
                            child: CustomText(
                              text: widget.res!.birth_data[0].sunset,
                              color: blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ))
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    color: whiteColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: CustomText(
                                text: 'Ayanamsha',
                                color: blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 7,
                            child: CustomText(
                              text:
                                  widget.res!.birth_data[0].ayanamsha.toString(),
                              color: blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ))
                      ],
                    ),
                  ),*/
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10)),
                height: 50,
                child: Center(
                    child: CustomText(
                      text: 'Dosha',
                      color: whiteColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      align: TextAlign.start,
                    ))),
          ),


          /// dosh Type
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Column(
                children: [
                  Container(
                    height: 50,
                    color: lightYellow,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: CustomText(
                                text: 'Mangal Dosh',
                                color: blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 7,
                            child: CustomText(
                              text: isManglik(
                                  widget.res!.dosha!.mangalDosh!.isDoshaPresent!),
                              color: blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Column(
                children: [
                  Container(
                    height: 50,
                    color: lightYellow,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: CustomText(
                                text: 'Kaalsarp Dosh',
                                color: blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 7,
                            child: CustomText(
                              text: isKaalSarpdosh(
                                  widget.res!.dosha!.kaalsarpDosh!.isDoshaPresent!),
                              color: blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),





          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10)),
                height: 50,
                child: Center(
                    child: CustomText(
                      text: 'Manglik Dosh',
                      color: whiteColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      align: TextAlign.start,
                    ))),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Column(
                children: [
                  Container(
                    height: 50,
                    color: lightYellow,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: CustomText(
                                text: 'Manglik by Mars',
                                color: blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 7,
                            child: CustomText(
                              text: isManglikMars(
                                  widget.res!.dosha!.manglikDosh!.manglikByMars!),
                              color: blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Column(
                children: [
                  Container(
                    height: 50,
                    color: lightYellow,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: CustomText(
                                text: 'Manglik by Saturn',
                                color: blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 7,
                            child: CustomText(
                              text: ismanglikBySaturn(
                                  widget.res!.dosha!.manglikDosh!.manglikBySaturn!),
                              color: blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Column(
                children: [
                  Container(
                    height: 50,
                    color: lightYellow,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: CustomText(
                                text: 'Manglik by Rahuketu',
                                color: blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 7,
                            child: CustomText(
                              text: ismanglikByRahuketu(widget
                                  .res!.dosha!.manglikDosh!.manglikByRahuketu!),
                              color: blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10)),
                height: 50,
                child: Center(
                    child: CustomText(
                      text: 'Mahadasha',
                      color: whiteColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      align: TextAlign.start,
                    ))),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Column(
                children: [
                  Container(
                    height: 50,
                    color: lightYellow,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: CustomText(
                                text: 'Start Year',
                                color: blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 7,
                            child: CustomText(
                              text: widget.res!.dasha!.mahaDasha!.startYear!
                                  .toString(),
                              color: blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Column(
                children: [
                  Container(
                    height: 50,
                    color: lightYellow,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: CustomText(
                                text: 'Dasha Start Date',
                                color: blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 7,
                            child: CustomText(
                              text: widget.res!.dasha!.mahaDasha!.dashaStartDate!
                                  .toString(),
                              color: blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Column(
                children: [
                  Container(
                    height: 50,
                    color: lightYellow,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: CustomText(
                                text: 'Dasha remaining at birth',
                                color: blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 7,
                            child: CustomText(
                              text: widget
                                  .res!.dasha!.mahaDasha!.dashaRemainingAtBirth!
                                  .toString(),
                              color: blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          /* Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Column(
                children: [
                  Container(
                    height: 50,
                    color: lightYellow,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: CustomText(
                                text: 'Varna',
                                color: blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 7,
                            child: CustomText(
                              text: widget.res!.astro_details[0].varna,
                              color: blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ))
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    color: whiteColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: CustomText(
                                text: 'Vashya',
                                color: blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 7,
                            child: CustomText(
                              text: widget.res!.astro_details[0].vashya,
                              color: blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ))
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    color: lightYellow,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: CustomText(
                                text: 'Yoni',
                                color: blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 7,
                            child: CustomText(
                              text: widget.res!.astro_details[0].yoni,
                              color: blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ))
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    color: whiteColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: CustomText(
                                text: 'Gan',
                                color: blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 7,
                            child: CustomText(
                              text: widget.res!.astro_details[0].gan,
                              color: blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ))
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    color: lightYellow,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: CustomText(
                                text: 'Nadi',
                                color: blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 7,
                            child: CustomText(
                              text: widget.res!.astro_details[0].nadi,
                              color: blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ))
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    color: whiteColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: CustomText(
                                text: 'Sign',
                                color: blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 7,
                            child: CustomText(
                              text: widget.res!.astro_details[0].sign,
                              color: blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ))
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    color: lightYellow,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: CustomText(
                                text: 'Sign Lord',
                                color: blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 7,
                            child: CustomText(
                              text: widget.res!.astro_details[0].signLord,
                              color: blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ))
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    color: whiteColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: CustomText(
                                text: 'Nakshatra-Charan',
                                color: blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 7,
                            child: CustomText(
                              text:
                                  widget.res!.astro_details[0].charan.toString(),
                              color: blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ))
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    color: lightYellow,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: CustomText(
                                text: 'Yog',
                                color: blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 7,
                            child: CustomText(
                              text: widget.res!.astro_details[0].yog,
                              color: blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ))
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    color: whiteColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: CustomText(
                                text: 'Karan',
                                color: blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 7,
                            child: CustomText(
                              text: widget.res!.astro_details[0].karan,
                              color: blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ))
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    color: lightYellow,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: CustomText(
                                text: 'Tithi',
                                color: blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 7,
                            child: CustomText(
                              text: widget.res!.astro_details[0].tithi,
                              color: blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ))
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    color: whiteColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: CustomText(
                                text: 'Yunja',
                                color: blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 7,
                            child: CustomText(
                              text: widget.res!.astro_details[0].yunja,
                              color: blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ))
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    color: lightYellow,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: CustomText(
                                text: 'Tatva',
                                color: blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 7,
                            child: CustomText(
                              text: widget.res!.astro_details[0].tatva,
                              color: blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ))
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    color: whiteColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: CustomText(
                                text: 'Name alphabet',
                                color: blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 7,
                            child: CustomText(
                              text: widget.res!.astro_details[0].name_alphabet,
                              color: blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ))
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    color: lightYellow,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: CustomText(
                                text: 'Paya',
                                color: blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 7,
                            child: CustomText(
                              text: widget.res!.astro_details[0].paya,
                              color: blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),*/
          Container(
            height: 50,
          )
        ],
      ),
    );
  }

  final _api=ApiBaseHelper();

  Widget chartView() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomText(
              text: 'CHALIT CHART',
              color: blackColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(_api.aPPmAINuRL + d1,height: 300,),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomText(
              text: 'D1 CHART',
              color: blackColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(_api.aPPmAINuRL + d9,height: 300),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomText(
              text: 'MOON CHART',
              color: blackColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(_api.aPPmAINuRL + moon ,height: 300),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomText(
              text: 'Sun CHART',
              color: blackColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: Image.network(_api.aPPmAINuRL + sun ,height: 300),
           ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomText(
              text: 'kp_chalit CHART',
              color: blackColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),

           Padding(
             padding: const EdgeInsets.all(8.0),
             child: Image.network(_api.aPPmAINuRL + kp_chalit,height: 300),
           ),

          SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }

  Widget mahaaDashaSection(){
    return ListView(
      children: [
        SizedBox(height: 10,),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(text: "Vimshottari Maha Dasha",
              color: Colors.black,
              fontWeight: FontWeight.bold,fontSize: 15,),


          ],
        ),

        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: mahadashaList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                switch (index) {
                  case 0: antardashaList=antarDashaModel!.data.antardashas[0];
                  antarDashaDateList=antarDashaModel!.data.antardashaOrder[0];

                  break;
                  case 1:
                    antardashaList=antarDashaModel!.data.antardashas[1];
                    antarDashaDateList=antarDashaModel!.data.antardashaOrder[1];
                    break;

                  case 2: antardashaList=antarDashaModel!.data.antardashas[2];
                  antarDashaDateList=antarDashaModel!.data.antardashaOrder[2];
                  break;


                  case 3: antardashaList=antarDashaModel!.data.antardashas[3];
                  antarDashaDateList=antarDashaModel!.data.antardashaOrder[3];
                  break;

                  case 4: antardashaList=antarDashaModel!.data.antardashas[4];
                  antarDashaDateList=antarDashaModel!.data.antardashaOrder[4];
                  break;


                  case 5: antardashaList=antarDashaModel!.data.antardashas[5];
                  antarDashaDateList=antarDashaModel!.data.antardashaOrder[5];
                  break;

                  case 6: antardashaList=antarDashaModel!.data.antardashas[6];
                  antarDashaDateList=antarDashaModel!.data.antardashaOrder[6];
                  break;

                  case 7: antardashaList=antarDashaModel!.data.antardashas[7];
                  antarDashaDateList=antarDashaModel!.data.antardashaOrder[7];
                  break;

                  case 8: antardashaList=antarDashaModel!.data.antardashas[8];
                  antarDashaDateList=antarDashaModel!.data.antardashaOrder[8];
                  break;



                  default:
                  // Default statements
                }

                setState(() {
                  dashaBool=true;

                });


              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(text: "${mahadashaList[index]}",
                            color: Colors.black,
                            fontWeight: FontWeight.bold,fontSize: 15,),

                          // CustomText(text: "${mahadashaDateList[index]}",
                          CustomText(text: convertDateString(mahadashaDateList[index])!,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,fontSize: 15,),


                        ],),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8,right: 8),
                      child: Container(height: 1,width: double.infinity,
                        color: Colors.grey.shade300,
                      ),
                    )
                  ],
                ),
              ),
            );
          },),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: primaryColor
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomText(text: "Note : Dates shown are dasha ending dates.Please tap any row to show Antar Dasha",
                color: Colors.white,

              ),
            ),
          ),
        )



      ],);

  }

  Widget antarDashaSection(){
    return ListView(
      children: [
        SizedBox(height: 10,),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(text: "Vimshottari Antar Dasha",
              color: Colors.black,
              fontWeight: FontWeight.bold,fontSize: 15,),


          ],
        ),

        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: antardashaList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {

              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(text: "${antardashaList[index]}",
                            color: Colors.black,
                            fontWeight: FontWeight.bold,fontSize: 15,),


                          // CustomText(text: "${antarDashaDateList[index]}",
                          CustomText(text: convertDateString(antarDashaDateList[index])!,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,fontSize: 15,),


                        ],),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8,right: 8),
                      child: Container(height: 1,width: double.infinity,
                        color: Colors.grey.shade300,
                      ),
                    )
                  ],
                ),
              ),
            );
          },),
        SizedBox(height: 10,),

        InkWell(
          onTap: (){
            setState(() {
              dashaBool=false;

            });
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                width: double.infinity,
                height: 45,
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(6)
                ),
                child: Center(child: CustomText(text: "BACK",
                  color: Colors.white,
                  fontSize: 14,fontWeight: FontWeight.bold,))),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: primaryColor
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomText(text: "Note : Dates shown are dasha ending dates.Please tap any row to show Antar Dasha",
                color: Colors.white,

              ),
            ),
          ),
        )

      ],);

  }

  Widget kundaliView() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10)),
                height: 50,
                child: Center(
                    child: CustomText(
                      text: 'Planets',
                      color: whiteColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      align: TextAlign.start,
                    ))),
          ),
          table(),
          tabl2(),
          tabl3(),
          tabl4(),
          tabl5(),
          tabl6(),
          tabl7(),
          tabl8(),
          tabl9(),
          Container(
            height: 100,
          )
        ],
      ),
    );
  }

  Widget table() {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text('Name',
                  style: TextStyle(
                    color: Colors.orange,
                  )),
            ),
            DataColumn(
                label: Text('Local Degree',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Rasi no',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Zodiac',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('House',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Nakshatra',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Nakshatra Lord',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Nakshatra Pada',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Nakshatra No',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Zodiac Lord',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Lord Status',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
          ],
          rows: List.generate(1, (index) {
            return DataRow(cells: [
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget.res!.horoscopeKundali!.planetDetails!.ascendant!
                          .fullName!))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                    text: widget.res!.horoscopeKundali!.planetDetails!.ascendant!
                        .localDegree!
                        .toString(),
                    align: TextAlign.center,
                  ))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.ascendant!.rasiNo
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.ascendant!.zodiac
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.ascendant!.house
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget.res!.horoscopeKundali!.planetDetails!.ascendant!
                          .nakshatra
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                    text: widget.res!.horoscopeKundali!.planetDetails!.ascendant!
                        .nakshatraLord
                        .toString(),
                    align: TextAlign.center,
                  ))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget.res!.horoscopeKundali!.planetDetails!.ascendant!
                          .nakshatraPada
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget.res!.horoscopeKundali!.planetDetails!.ascendant!
                          .nakshatraNo
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget.res!.horoscopeKundali!.planetDetails!.ascendant!
                          .zodiacLord
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget.res!.horoscopeKundali!.planetDetails!.ascendant!
                          .lordStatus
                          .toString(),
                      align: TextAlign.center))),
            ]);
          }),
        ),
      ),
    );
  }

  Widget tabl2() {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text('Name',
                  style: TextStyle(
                    color: Colors.orange,
                  )),
            ),
            DataColumn(
                label: Text('Local Degree',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Rasi no',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Zodiac',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('House',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Nakshatra',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Nakshatra Lord',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Nakshatra Pada',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Nakshatra No',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Zodiac Lord',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Lord Status',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
          ],
          rows: List.generate(
            1,
                (index) {
              return DataRow(cells: [
                DataCell(Container(
                    alignment: Alignment.center,
                    child: CustomText(
                        text: widget
                            .res!.horoscopeKundali!.planetDetails!.sun!.fullName!))),
                DataCell(Container(
                    alignment: Alignment.center,
                    child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.sun!.localDegree
                          .toString(),
                      align: TextAlign.center,
                    ))),
                DataCell(Container(
                    alignment: Alignment.center,
                    child: CustomText(
                        text: widget
                            .res!.horoscopeKundali!.planetDetails!.sun!.rasiNo
                            .toString(),
                        align: TextAlign.center))),
                DataCell(Container(
                    alignment: Alignment.center,
                    child: CustomText(
                        text: widget
                            .res!.horoscopeKundali!.planetDetails!.sun!.zodiac
                            .toString(),
                        align: TextAlign.center))),
                DataCell(Container(
                    alignment: Alignment.center,
                    child: CustomText(
                        text: widget
                            .res!.horoscopeKundali!.planetDetails!.sun!.house
                            .toString(),
                        align: TextAlign.center))),
                DataCell(Container(
                    alignment: Alignment.center,
                    child: CustomText(
                        text: widget
                            .res!.horoscopeKundali!.planetDetails!.sun!.nakshatra
                            .toString(),
                        align: TextAlign.center))),
                DataCell(Container(
                    alignment: Alignment.center,
                    child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.sun!.nakshatraLord
                          .toString(),
                      align: TextAlign.center,
                    ))),
                DataCell(Container(
                    alignment: Alignment.center,
                    child: CustomText(
                        text: widget.res!.horoscopeKundali!.planetDetails!.sun!
                            .nakshatraPada
                            .toString(),
                        align: TextAlign.center))),
                DataCell(Container(
                    alignment: Alignment.center,
                    child: CustomText(
                        text: widget
                            .res!.horoscopeKundali!.planetDetails!.sun!.nakshatraNo
                            .toString(),
                        align: TextAlign.center))),
                DataCell(Container(
                    alignment: Alignment.center,
                    child: CustomText(
                        text: widget
                            .res!.horoscopeKundali!.planetDetails!.sun!.zodiacLord
                            .toString(),
                        align: TextAlign.center))),
                DataCell(Container(
                    alignment: Alignment.center,
                    child: CustomText(
                        text: widget
                            .res!.horoscopeKundali!.planetDetails!.sun!.lordStatus
                            .toString(),
                        align: TextAlign.center))),
              ]);
            },
          ),
        ),
      ),
    );
  }

  Widget tabl3() {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text('Name',
                  style: TextStyle(
                    color: Colors.orange,
                  )),
            ),
            DataColumn(
                label: Text('Local Degree',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Rasi no',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Zodiac',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('House',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Nakshatra',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Nakshatra Lord',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Nakshatra Pada',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Nakshatra No',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Zodiac Lord',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Lord Status',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
          ],
          rows: List.generate(1, (index) {
            return DataRow(cells: [
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.moon!.fullName.toString()))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                    text: widget
                        .res!.horoscopeKundali!.planetDetails!.moon!.localDegree
                        .toString(),
                    align: TextAlign.center,
                  ))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.moon!.rasiNo
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.moon!.zodiac
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget.res!.horoscopeKundali!.planetDetails!.moon!.house
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.moon!.nakshatra
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                    text: widget
                        .res!.horoscopeKundali!.planetDetails!.moon!.nakshatraLord
                        .toString(),
                    align: TextAlign.center,
                  ))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.moon!.nakshatraPada
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.moon!.nakshatraNo
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.moon!.zodiacLord
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.moon!.lordStatus
                          .toString(),
                      align: TextAlign.center))),
            ]);
          }),
        ),
      ),
    );
  }

  Widget tabl4() {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text('Name',
                  style: TextStyle(
                    color: Colors.orange,
                  )),
            ),
            DataColumn(
                label: Text('Local Degree',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Rasi no',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Zodiac',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('House',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Nakshatra',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Nakshatra Lord',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Nakshatra Pada',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Nakshatra No',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Zodiac Lord',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Lord Status',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
          ],
          rows: List.generate(1, (index) {
            return DataRow(cells: [
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.mars!.fullName.toString()))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                    text: widget
                        .res!.horoscopeKundali!.planetDetails!.mars!.localDegree
                        .toString(),
                    align: TextAlign.center,
                  ))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.mars!.rasiNo
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.mars!.zodiac
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget.res!.horoscopeKundali!.planetDetails!.mars!.house
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.mars!.nakshatra
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                    text: widget
                        .res!.horoscopeKundali!.planetDetails!.mars!.nakshatraLord
                        .toString(),
                    align: TextAlign.center,
                  ))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.mars!.nakshatraPada
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.mars!.nakshatraNo
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.mars!.zodiacLord
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.mars!.lordStatus
                          .toString(),
                      align: TextAlign.center))),
            ]);
          }),
        ),
      ),
    );
  }

  Widget tabl5() {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text('Name',
                  style: TextStyle(
                    color: Colors.orange,
                  )),
            ),
            DataColumn(
                label: Text('Local Degree',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Rasi no',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Zodiac',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('House',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Nakshatra',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Nakshatra Lord',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Nakshatra Pada',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Nakshatra No',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Zodiac Lord',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Lord Status',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
          ],
          rows: List.generate(1, (index) {
            return DataRow(cells: [
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget.res!.horoscopeKundali!.planetDetails!.mercury!
                          .fullName.toString()))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                    text: widget
                        .res!.horoscopeKundali!.planetDetails!.mercury!.localDegree
                        .toString(),
                    align: TextAlign.center,
                  ))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.mercury!.rasiNo
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.mercury!.zodiac
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.mercury!.house
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.mercury!.nakshatra
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                    text: widget.res!.horoscopeKundali!.planetDetails!.mercury!
                        .nakshatraLord
                        .toString(),
                    align: TextAlign.center,
                  ))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget.res!.horoscopeKundali!.planetDetails!.mercury!
                          .nakshatraPada
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget.res!.horoscopeKundali!.planetDetails!.mercury!
                          .nakshatraNo
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.mercury!.zodiacLord
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.mercury!.lordStatus
                          .toString(),
                      align: TextAlign.center))),
            ]);
          }),
        ),
      ),
    );
  }

  Widget tabl6() {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text('Name',
                  style: TextStyle(
                    color: Colors.orange,
                  )),
            ),
            DataColumn(
                label: Text('Local Degree',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Rasi no',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Zodiac',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('House',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Nakshatra',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Nakshatra Lord',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Nakshatra Pada',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Nakshatra No',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Zodiac Lord',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Lord Status',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
          ],
          rows: List.generate(1, (index) {
            return DataRow(cells: [
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget.res!.horoscopeKundali!.planetDetails!.jupiter!
                          .fullName.toString()))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                    text: widget
                        .res!.horoscopeKundali!.planetDetails!.jupiter!.localDegree
                        .toString(),
                    align: TextAlign.center,
                  ))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.jupiter!.rasiNo
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.jupiter!.zodiac
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.jupiter!.house
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.jupiter!.nakshatra
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                    text: widget.res!.horoscopeKundali!.planetDetails!.jupiter!
                        .nakshatraLord
                        .toString(),
                    align: TextAlign.center,
                  ))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget.res!.horoscopeKundali!.planetDetails!.jupiter!
                          .nakshatraPada
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget.res!.horoscopeKundali!.planetDetails!.jupiter!
                          .nakshatraNo
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.jupiter!.zodiacLord
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.jupiter!.lordStatus
                          .toString(),
                      align: TextAlign.center))),
            ]);
          }),
        ),
      ),
    );
  }

  Widget tabl7() {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text('Name',
                  style: TextStyle(
                    color: Colors.orange,
                  )),
            ),
            DataColumn(
                label: Text('Local Degree',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Rasi no',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Zodiac',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('House',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Nakshatra',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Nakshatra Lord',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Nakshatra Pada',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Nakshatra No',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Zodiac Lord',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Lord Status',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
          ],
          rows: List.generate(1, (index) {
            return DataRow(cells: [
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.venus!.fullName.toString()))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                    text: widget
                        .res!.horoscopeKundali!.planetDetails!.venus!.localDegree
                        .toString(),
                    align: TextAlign.center,
                  ))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.venus!.rasiNo
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.venus!.zodiac
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.venus!.house
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.venus!.nakshatra
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                    text: widget
                        .res!.horoscopeKundali!.planetDetails!.venus!.nakshatraLord
                        .toString(),
                    align: TextAlign.center,
                  ))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget.res!.horoscopeKundali!.planetDetails!.venus!
                          .nakshatraPada
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.venus!.nakshatraNo
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.venus!.zodiacLord
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.venus!.lordStatus
                          .toString(),
                      align: TextAlign.center))),
            ]);
          }),
        ),
      ),
    );
  }

  Widget tabl8() {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text('Name',
                  style: TextStyle(
                    color: Colors.orange,
                  )),
            ),
            DataColumn(
                label: Text('Local Degree',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Rasi no',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Zodiac',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('House',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Nakshatra',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Nakshatra Lord',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Nakshatra Pada',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Nakshatra No',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Zodiac Lord',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Lord Status',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
          ],
          rows: List.generate(1, (index) {
            return DataRow(cells: [
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget.res!.horoscopeKundali!.planetDetails!.saturn!
                          .fullName.toString()))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                    text: widget
                        .res!.horoscopeKundali!.planetDetails!.saturn!.localDegree
                        .toString(),
                    align: TextAlign.center,
                  ))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.saturn!.rasiNo
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.saturn!.zodiac
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.saturn!.house
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.saturn!.nakshatra
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                    text: widget
                        .res!.horoscopeKundali!.planetDetails!.saturn!.nakshatraLord
                        .toString(),
                    align: TextAlign.center,
                  ))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget.res!.horoscopeKundali!.planetDetails!.saturn!
                          .nakshatraPada
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.saturn!.nakshatraNo
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.saturn!.zodiacLord
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.saturn!.lordStatus
                          .toString(),
                      align: TextAlign.center))),
            ]);
          }),
        ),
      ),
    );
  }

  Widget tabl9() {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text('Name',
                  style: TextStyle(
                    color: Colors.orange,
                  )),
            ),
            DataColumn(
                label: Text('Local Degree',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Rasi no',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Zodiac',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('House',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Nakshatra',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Nakshatra Lord',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Nakshatra Pada',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Nakshatra No',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Zodiac Lord',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
            DataColumn(
                label: Text('Lord Status',
                    style: TextStyle(
                      color: Colors.orange,
                    ))),
          ],
          rows: List.generate(1, (index) {
            return DataRow(cells: [
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.rahu!.fullName.toString()))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                    text: widget
                        .res!.horoscopeKundali!.planetDetails!.rahu!.localDegree
                        .toString(),
                    align: TextAlign.center,
                  ))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.rahu!.rasiNo
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.rahu!.zodiac
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget.res!.horoscopeKundali!.planetDetails!.rahu!.house
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.rahu!.nakshatra
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                    text: widget
                        .res!.horoscopeKundali!.planetDetails!.rahu!.nakshatraLord
                        .toString(),
                    align: TextAlign.center,
                  ))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.rahu!.nakshatraPada
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.rahu!.nakshatraNo
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.rahu!.zodiacLord
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.rahu!.lordStatus
                          .toString(),
                      align: TextAlign.center))),
            ]);
          }),
        ),
      ),
    );
  }

  Widget tabl10() {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Local Degree')),
            DataColumn(label: Text('Rasi no')),
            DataColumn(label: Text('Zodiac')),
            DataColumn(label: Text('House')),
            DataColumn(label: Text('Nakshatra')),
            DataColumn(label: Text('Nakshatra Lord')),
            DataColumn(label: Text('Nakshatra Pada')),
            DataColumn(label: Text('Nakshatra No')),
            DataColumn(label: Text('Zodiac Lord')),
            DataColumn(label: Text('Lord Status')),
          ],
          rows: List.generate(1, (index) {
            return DataRow(cells: [
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.ketu!.fullName.toString()))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                    text: widget
                        .res!.horoscopeKundali!.planetDetails!.ketu!.localDegree
                        .toString(),
                    align: TextAlign.center,
                  ))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.ketu!.rasiNo
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.ketu!.zodiac
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget.res!.horoscopeKundali!.planetDetails!.ketu!.house
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.ketu!.nakshatra
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                    text: widget
                        .res!.horoscopeKundali!.planetDetails!.ketu!.nakshatraLord
                        .toString(),
                    align: TextAlign.center,
                  ))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.ketu!.nakshatraPada
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.ketu!.nakshatraNo
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.ketu!.zodiacLord
                          .toString(),
                      align: TextAlign.center))),
              DataCell(Container(
                  alignment: Alignment.center,
                  child: CustomText(
                      text: widget
                          .res!.horoscopeKundali!.planetDetails!.ketu!.lordStatus
                          .toString(),
                      align: TextAlign.center))),
            ]);
          }),
        ),
      ),
    );
  }

  Widget vimshottari_DashaView() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: ListView(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  // getMajorVdashaApi1();
                  setState(() {
                    showDasha = "1";
                  });
                },
                child: Container(
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(10)),
                    height: 30,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: Center(
                          child: CustomText(
                            text: 'Mahadasha',
                            color: whiteColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            align: TextAlign.start,
                          )),
                    )),
              ),
              InkWell(
                onTap: () {
                  if (showDasha == "123") {
                    getMajorVdashaApi2(c_vdasha1);
                    setState(() {
                      showDasha = "12";
                    });
                  }
                },
                child: Container(
                    decoration: BoxDecoration(
                        color: showColor2(),
                        borderRadius: BorderRadius.circular(10)),
                    height: 30,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: Center(
                          child: CustomText(
                            text: 'Antardasha',
                            color: whiteColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            align: TextAlign.start,
                          )),
                    )),
              ),
              InkWell(
                onTap: () {
                  if (showDasha == "1234") {
                    getMajorVdashaApi3(c_vdasha1, c_vdasha2);
                    setState(() {
                      showDasha = "123";
                    });
                  }
                },
                child: Container(
                    decoration: BoxDecoration(
                        color: showColor3(),
                        borderRadius: BorderRadius.circular(10)),
                    height: 30,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: Center(
                          child: CustomText(
                            text: 'Pratyantardasha',
                            color: whiteColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            align: TextAlign.start,
                          )),
                    )),
              ),
              InkWell(
                onTap: () {},
                child: Container(
                    decoration: BoxDecoration(
                        color: showColor4(),
                        borderRadius: BorderRadius.circular(10)),
                    height: 30,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: Center(
                          child: CustomText(
                            text: 'Sookshmadasha',
                            color: whiteColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            align: TextAlign.start,
                          )),
                    )),
              ),
            ],
          ),
          (showDasha == "1") ? Vdashatable(vdasha1) : Container(),
          (showDasha == "12") ? Vdashatable(vdasha2) : Container(),
          (showDasha == "123") ? Vdashatable(vdasha3) : Container(),
          (showDasha == "1234") ? Vdashatable(vdasha4) : Container()
        ],
      ),
    );
  }

  Widget Vdashatable(List<Vdasha> vdasha) {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          showCheckboxColumn: false,
          columns: [
            DataColumn(label: Text('Planet')),
            DataColumn(label: Text('Start Date')),
            DataColumn(label: Text('End Date')),
            DataColumn(label: Text('')),
          ],
          rows: List.generate(vdasha.length, (index) {
            final a1 = vdasha[index].planet;
            final a2 = vdasha[index].start;
            final a3 = vdasha[index].end;
            return DataRow(
                onSelectChanged: (bool? selected) {
                  if (selected == true) {
                    if (showDasha == "1") {
                      getMajorVdashaApi2(vdasha[index].planet);
                      c_vdasha1 = vdasha[index].planet;
                    } else if (showDasha == "12") {
                      getMajorVdashaApi3(c_vdasha1, vdasha[index].planet);
                      c_vdasha2 = vdasha[index].planet;
                    } else if (showDasha == "123") {
                      c_vdasha3 = vdasha[index].planet;
                      getMajorVdashaApi4(
                          c_vdasha1, c_vdasha2, vdasha[index].planet);
                    }
                  }
                },
                cells: [
                  DataCell(Container(
                      alignment: Alignment.center,
                      child: CustomText(text: a1!))),
                  DataCell(Container(
                      alignment: Alignment.center,
                      child: CustomText(
                        text: a2!,
                        align: TextAlign.center,
                      ))),
                  DataCell(Container(
                      alignment: Alignment.center,
                      child: CustomText(text: a3!, align: TextAlign.center))),
                  DataCell(Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(30)),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: Colors.grey,
                        size: 15,
                      ))),
                ]);
          }),
        ),
      ),
    );
  }

  showColor2() {
    if (showDasha == "12") {
      return primaryColor;
    } else if (showDasha == "123") {
      return primaryColor;
    } else if (showDasha == "1234") {
      return primaryColor;
    } else {
      return greyColor12;
    }
  }

  showColor3() {
    if (showDasha == "123") {
      return blackColor;
    } else if (showDasha == "1234") {
      return primaryColor;
    } else {
      return greyColor12;
    }
  }

  showColor4() {
    if (showDasha == "1234") {
      return primaryColor;
    } else {
      return greyColor12;
    }
  }

  isManglik(bool isDoshaPresent) {
    if (isDoshaPresent) {
      return "Yes";
    } else {
      return "No";
    }
  }

  isKaalSarpdosh(bool isDoshaPresent) {
    if (isDoshaPresent) {
      return "Yes";
    } else {
      return "No";
    }
  }

  isManglikMars(bool manglikByMars) {
    if (manglikByMars) {
      return "Yes";
    } else {
      return "No";
    }
  }

  ismanglikBySaturn(bool manglikBySaturn) {
    if (manglikBySaturn) {
      return "Yes";
    } else {
      return "No";
    }
  }

  ismanglikByRahuketu(bool manglikByRahuketu) {
    if (manglikByRahuketu) {
      return "Yes";
    } else {
      return "No";
    }
  }
}

class PlanetDetails {
  String? Name;
  String? Local_Degree;
  String? Rasi_no;
  String? Zodiac;
  String? House;
  String? Nakshatra;
  String? Nakshatra_Lord;
  String? Nakshatra_Pada;
  String? Nakshatra_No;
  String? Zodiac_Lord;
  String? Lord_Status;

  PlanetDetails(
      {this.Name,
        this.Local_Degree,
        this.Rasi_no,
        this.Zodiac,
        this.House,
        this.Lord_Status,
        this.Nakshatra,
        this.Nakshatra_Lord,
        this.Nakshatra_No,
        this.Nakshatra_Pada,
        this.Zodiac_Lord});
}
