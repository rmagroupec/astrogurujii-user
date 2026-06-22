
import 'package:astro_gurujii/Screens/ExportAstrologers/ExpertAstrologer.dart';
import 'package:astro_gurujii/Screens/MatchingDetails.dart';
import 'package:astro_gurujii/Screens/Models/HomeDataModel.dart';
import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Screens/match_details/model/MatchingDetails.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
//import 'package:syncfusion_flutter_gauges/gauges.dart';

class MachingDetailsScreen extends StatefulWidget {
  MatchMaking? res;
  final m_name;
  final f_name;
  MachingDetailsScreen({this.res, this.m_name, this.f_name});

  @override
  State<StatefulWidget> createState() {
    return MachingDetailsScreenState();
  }
}

class MachingDetailsScreenState extends State<MachingDetailsScreen> {
  final HttpServices _httpServices = HttpServices();
  List<Astrologer> astroData = [];
  @override
  void initState() {
    homeApi();
    super.initState();
  }

  void homeApi() async {
    var res = await _httpServices.home_data();
    if (res!.status == true) {
      setState(() {
        astroData = res!.astrologer!;
      });
    } else {
      Fluttertoast.showToast(msg: res!.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text("Kundli Matching"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              CustomText(
                text: '${"Compatibility Score"}',
                align: TextAlign.center,
                color: blackColor,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              Center(child: meter()),
              SizedBox(
                height: 50,
              ),
              CustomText(
                text: '${"Details"}',
                align: TextAlign.center,
                color: blackColor,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: card1,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 2.0,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Compatibility",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    "(Varna)",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                              CustomText(
                                text: '${widget.res!.data!.varna!.description}',
                                align: TextAlign.center,
                                color: blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: circularGraph(
                            value: getPercentahe(
                                widget.res!.data!.varna!.varna.toString(),
                                widget.res!.data!.varna!.fullScore.toString()),
                            strokeWidth: 9,
                            color: circle1,
                            title:
                            '${widget.res!.data!.varna!.varna}/${widget.res!.data!.varna!.fullScore}'),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: card2,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 2.0,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Love",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    "(Bhakut)",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: CustomText(
                                    text:
                                    '${widget.res!.data!.bhakoot!.description}',
                                    align: TextAlign.center,
                                    color: blackColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  )),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: circularGraph(
                            value: getPercentahe(
                                widget.res!.data!.bhakoot!.bhakoot.toString(),
                                widget.res!.data!.bhakoot!.fullScore.toString()),
                            strokeWidth: 9,
                            color: circle2,
                            title:
                            '${widget.res!.data!.bhakoot!.bhakoot}/${widget.res!.data!.bhakoot!.fullScore}'),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: card3,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 2.0,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Mental Compatibility",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    "(Maitri)",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: CustomText(
                                    text:
                                    '${widget.res!.data!.grahamaitri!.description}',
                                    align: TextAlign.center,
                                    color: blackColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  )),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: circularGraph(
                            value: getPercentahe(
                                widget.res!.data!.grahamaitri!.grahamaitri
                                    .toString(),
                                widget.res!.data!.grahamaitri!.fullScore
                                    .toString()),
                            strokeWidth: 9,
                            color: circle3,
                            title:
                            '${widget.res!.data!.grahamaitri!.grahamaitri}/${widget.res!.data!.grahamaitri!.fullScore}'),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: card4,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 2.0,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Health",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    "(Nadi)",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: CustomText(
                                    text: '${widget.res!.data!.nadi!.description}',
                                    align: TextAlign.center,
                                    color: blackColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  )),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: circularGraph(
                            value: getPercentahe(
                                widget.res!.data!.nadi!.nadi.toString(),
                                widget.res!.data!.nadi!.fullScore.toString()),
                            strokeWidth: 9,
                            color: circle4,
                            title:
                            '${widget.res!.data!.nadi!.nadi}/${widget.res!.data!.nadi!.fullScore}'),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: card5,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 2.0,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Dominance",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    "(Vashya)",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: CustomText(
                                    text:
                                    '${widget.res!.data!.vasya!.description}',
                                    align: TextAlign.center,
                                    color: blackColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  )),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: circularGraph(
                            value: getPercentahe(
                                widget.res!.data!.vasya!.vasya!.toString(),
                                widget.res!.data!.vasya!.fullScore.toString()),
                            strokeWidth: 9,
                            color: circle5,
                            title:
                            '${widget.res!.data!.vasya!.vasya}/${widget.res!.data!.vasya!.fullScore}'),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: card6,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 2.0,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Temperament",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    "(Gana)",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: CustomText(
                                    text: '${widget.res!.data!.gana!.description}',
                                    align: TextAlign.center,
                                    color: blackColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  )),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: circularGraph(
                            value: getPercentahe(
                                widget.res!.data!.gana!.gana!.toString(),
                                widget.res!.data!.gana!.fullScore.toString()),
                            strokeWidth: 9,
                            color: circle6,
                            title:
                            '${widget.res!.data!.gana!.gana}/${widget.res!.data!.gana!.fullScore}'),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: card7,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 2.0,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Destiny",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    "(Tara)",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: CustomText(
                                    text: '${widget.res!.data!.gana!.description}',
                                    align: TextAlign.center,
                                    color: blackColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  )),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: circularGraph(
                            value: getPercentahe(
                                widget.res!.data!.gana!.gana!.toString(),
                                widget.res!.data!.gana!.fullScore.toString()),
                            strokeWidth: 9,
                            color: circle7,
                            title:
                            '${widget.res!.data!.gana!.gana}/${widget.res!.data!.gana!.fullScore}'),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: card8,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 2.0,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Destiny",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    "(Tara)",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: CustomText(
                                    text: '${widget.res!.data!.tara!.description}',
                                    align: TextAlign.center,
                                    color: blackColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  )),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: circularGraph(
                            value: getPercentahe(
                                widget.res!.data!.gana!.gana!.toString(),
                                widget.res!.data!.gana!.fullScore.toString()),
                            strokeWidth: 9,
                            color: circle8,
                            title:
                            '${widget.res!.data!.gana!.gana}/${widget.res!.data!.gana!.fullScore}'),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: card9,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 2.0,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Physical Compatibility",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    "(Yoni)",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: CustomText(
                                    text: '${widget.res!.data!.yoni!.description}',
                                    align: TextAlign.center,
                                    color: blackColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  )),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: circularGraph(
                            value: getPercentahe(
                                widget.res!.data!.yoni!.yoni!.toString(),
                                widget.res!.data!.yoni!.fullScore.toString()),
                            strokeWidth: 9,
                            color: circle9,
                            title:
                            '${widget.res!.data!.yoni!.yoni}/${widget.res!.data!.yoni!.fullScore}'),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              // SizedBox(
              //   child: ExpertAstrologer(
              //     screenType: "",
              //     data: astroData,
              //   ),
              // ),
            ],
          ),
        ));
  }

  Widget meter() {
    return SizedBox(
      height: 200,
      child: SfRadialGauge(
        enableLoadingAnimation: true,
        animationDuration: 4500,
        axes: <RadialAxis>[
          RadialAxis(
            startAngle: 180,
            endAngle: 0,
            interval: 5,
            canScaleToFit: true,
            minimum: 1,
            maximum: 36,
            pointers: <GaugePointer>[
              NeedlePointer(
                value: double.parse(widget.res!.data!.score.toString()),
                enableAnimation: true,
                animationType: AnimationType.slowMiddle,
              ),
            ],
            ranges: <GaugeRange>[
              GaugeRange(
                startValue: 0,
                endValue: 6,
                color: Color1,
                endWidth: 25,
                startWidth: 25,
              ),
              GaugeRange(
                startValue: 6,
                endValue: 12,
                color: Color2,
                endWidth: 25,
                startWidth: 25,
              ),
              GaugeRange(
                startValue: 12,
                endValue: 18,
                color: Color3,
                endWidth: 25,
                startWidth: 25,
              ),
              GaugeRange(
                startValue: 18,
                endValue: 24,
                color: Color4,
                endWidth: 25,
                startWidth: 25,
              ),
              GaugeRange(
                startValue: 24,
                endValue: 30,
                color: Color5,
                endWidth: 25,
                startWidth: 25,
              ),
              GaugeRange(
                  startValue: 30,
                  endValue: 36,
                  color: Color6,
                  endWidth: 25,
                  startWidth: 25),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                widget: CustomText(
                  text: "${widget.res!.data!.score.toString()}" +
                      "/${36.toString()}",
                  color: blackColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                positionFactor: 0.5,
                angle: 90,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget circularGraph(
      {double? value, Color? color, double? strokeWidth, String? title}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 80,
          width: 80,
          child: CircularProgressIndicator(
            value: value,
            valueColor: AlwaysStoppedAnimation<Color>(color!),
            strokeWidth: strokeWidth,
            backgroundColor: greyColor.withOpacity(0.2),
          ),
        ),
        CustomText(
          text: title!,
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: blackColor,
          align: TextAlign.center,
        ),
      ],
    );
  }

  getPercentahe(String part, String total) {
    double percentage = (double.parse(part) / double.parse(total));
    return percentage;
  }
}
