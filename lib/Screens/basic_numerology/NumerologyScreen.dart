
import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import 'model/BasicNumerologyModel.dart';

class NumerologyScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NumerologyScreenState();
  }
}

class NumerologyScreenState extends State<NumerologyScreen> {
  bool _isLoading = true;
  HttpServices _httpService = HttpServices();
  Data? data;
  Future<void> getMajorVdashaApi1(String yy, String mm, String dd) async {
    var res = await _httpService.basic_numerology(year: yy, month: mm, day: dd);
    if (res!.status == true) {
      setState(() {
        _isLoading = false;
        data = res.data;
      });
    } else {
      _isLoading = false;
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }

  void callAli() async {
    setState(() {
      final f = new DateFormat('yyyy-MM-dd');
      var date = f.format(DateTime.now()).toString();
      final split = date.split('-');
      final Map<int, String> values = {
        for (int i = 0; i < split.length; i++) i: split[i]
      };
      getMajorVdashaApi1(
          values[0].toString(), values[1].toString(), values[2].toString());
    });
  }

  @override
  void initState() {
    callAli();
    super.initState();
  }

  var day;
  var month;
  var year;
  var hh;
  var mm;
  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
  context: context,
  initialDate: selectedDate,
  initialEntryMode: DatePickerEntryMode.calendarOnly,
  firstDate: DateTime(1980, 8),
  lastDate: DateTime.now(),
);
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        day = selectedDate.day;
        month = selectedDate.month;
        year = selectedDate.year;

        getMajorVdashaApi1(year.toString(), month.toString(), day.toString());
        // _dob.text=outputFormat.format(outputFormat);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: whiteColor, //change your color here
        ),
        backgroundColor: primaryColor,
        title: Text(
          "Basic Numerology",
          style: TextStyle(color: whiteColor),
        ),
        actions: [
          IconButton(
              onPressed: () {
                _selectDate(context);
              },
              icon: Icon(
                Icons.calendar_month,
                color: Colors.white,
              ))
        ],
      ),
      body: _isLoading
          ? Center(
          child: Lottie.asset(
            'assets/profile/loader.json',
          ))
          : SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              numeroReport(),
              personalityReport(),
              /*, numeroFavTime(), numeroPlaceVastu()*/
              attitudeReport(),
              /*, numeroFavTime(), numeroPlaceVastu()*/
              characterReport(),
              /*, numeroFavTime(), numeroPlaceVastu()*/
              soulReport(),
              /*, numeroFavTime(), numeroPlaceVastu()*/
              agendaReport(),
              /*, numeroFavTime(), numeroPlaceVastu()*/
              purposeReport() /*, numeroFavTime(), numeroPlaceVastu()*/
            ],
          )),
    );
  }

  Widget numeroReport() {
    return Column(
      children: [
        Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                CustomText(
                  text: '${data!.destiny!.title}',
                  color: blackColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  align: TextAlign.start,
                ),
                SizedBox(
                  height: 10,
                ),
                CustomText(
                  text: '${data!.destiny!.title} Number: ' +
                      '${data!.destiny!.number}',
                  color: blackColor,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  align: TextAlign.start,
                ),
                SizedBox(
                  height: 10,
                ),
                CustomText(
                  text: '${data!.destiny!.description}',
                  color: blackColor,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  align: TextAlign.start,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget personalityReport() {
    return Column(
      children: [
        Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                CustomText(
                  text: '${data!.personality!.title}',
                  color: blackColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  align: TextAlign.start,
                ),
                SizedBox(
                  height: 10,
                ),
                CustomText(
                  text: '${data!.personality!.title} Number:' +
                      '${data!.personality!.number}',
                  color: blackColor,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  align: TextAlign.start,
                ),
                SizedBox(
                  height: 10,
                ),
                CustomText(
                  text: '${data!.personality!.description}',
                  color: blackColor,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  align: TextAlign.start,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget attitudeReport() {
    return Column(
      children: [
        Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                CustomText(
                  text: '${data!.attitude!.title}',
                  color: blackColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  align: TextAlign.start,
                ),
                SizedBox(
                  height: 10,
                ),
                CustomText(
                  text: '${data!.attitude!.title} Number:' +
                      '${data!.attitude!.number}',
                  color: blackColor,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  align: TextAlign.start,
                ),
                SizedBox(
                  height: 10,
                ),
                CustomText(
                  text: '${data!.attitude!.description}',
                  color: blackColor,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  align: TextAlign.start,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget characterReport() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                CustomText(
                  text: '${data!.character!.title}',
                  color: blackColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  align: TextAlign.start,
                ),
                SizedBox(
                  height: 10,
                ),
                CustomText(
                  text: '${data!.character!.title} Number:' +
                      '${data!.character!.number}',
                  color: blackColor,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  align: TextAlign.start,
                ),
                SizedBox(
                  height: 10,
                ),
                CustomText(
                  text: '${data!.character!.description}',
                  color: blackColor,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  align: TextAlign.start,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget soulReport() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                CustomText(
                  text: '${data!.soul!.title}',
                  color: blackColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  align: TextAlign.start,
                ),
                SizedBox(
                  height: 10,
                ),
                CustomText(
                  text: '${data!.soul!.title} Number:' + '${data!.soul!.number}',
                  color: blackColor,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  align: TextAlign.start,
                ),
                SizedBox(
                  height: 10,
                ),
                CustomText(
                  text: '${data!.soul!.description}',
                  color: blackColor,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  align: TextAlign.start,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget agendaReport() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                CustomText(
                  text: '${data!.agenda!.title}',
                  color: blackColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  align: TextAlign.start,
                ),
                SizedBox(
                  height: 10,
                ),
                CustomText(
                  text:
                  '${data!.agenda!.title} Number:' + '${data!.agenda!.number}',
                  color: blackColor,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  align: TextAlign.start,
                ),
                SizedBox(
                  height: 10,
                ),
                CustomText(
                  text: '${data!.agenda!.description}',
                  color: blackColor,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  align: TextAlign.start,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget purposeReport() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                CustomText(
                  text: '${data!.purpose!.title}',
                  color: blackColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  align: TextAlign.start,
                ),
                SizedBox(
                  height: 10,
                ),
                CustomText(
                  text: '${data!.purpose!.title} Number:' +
                      '${data!.purpose!.number}',
                  color: blackColor,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  align: TextAlign.start,
                ),
                SizedBox(
                  height: 10,
                ),
                CustomText(
                  text: '${data!.purpose!.description}',
                  color: blackColor,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  align: TextAlign.start,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

/*Widget numeroPlaceVastu() {
    return Column(
      children: [
        Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                CustomText(
                  text: 'Numero Place Vastu',
                  color: blackColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  align: TextAlign.start,
                ),
                SizedBox(
                  height: 10,
                ),
                CustomText(
                  text: '${numero_place_vastu.title}',
                  color: blackColor,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  align: TextAlign.start,
                ),
                SizedBox(
                  height: 10,
                ),
                CustomText(
                  text: '${numero_place_vastu.description}',
                  color: blackColor,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  align: TextAlign.start,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget numeroFavTime() {
    return Column(
      children: [
        Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                CustomText(
                  text: 'Numero Fav Time',
                  color: blackColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  align: TextAlign.start,
                ),
                SizedBox(
                  height: 10,
                ),
                CustomText(
                  text: '${numero_fav_time.title}',
                  color: blackColor,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  align: TextAlign.start,
                ),
                SizedBox(
                  height: 10,
                ),
                CustomText(
                  text: '${numero_fav_time.description}',
                  color: blackColor,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  align: TextAlign.start,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget kundaliView() {
    return Column(
      children: [
        Container(
          color: card1,
          height: 40,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CustomText(
                    text: 'Name',
                    color: blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    align: TextAlign.start,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: CustomText(
                    text: '${numeroTable.name}',
                    color: blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    align: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          color: card2,
          height: 40,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CustomText(
                    text: 'Date',
                    color: blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    align: TextAlign.start,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: CustomText(
                    text: '${numeroTable.date}',
                    color: blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    align: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          color: card3,
          height: 40,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CustomText(
                    text: 'Destiny Number',
                    color: blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    align: TextAlign.start,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: CustomText(
                    text: '${numeroTable.destiny_number}',
                    color: blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    align: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          color: card4,
          height: 40,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CustomText(
                    text: 'Radical Number',
                    color: blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    align: TextAlign.start,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: CustomText(
                    text: '${numeroTable.radical_number}',
                    color: blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    align: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          color: card5,
          height: 40,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CustomText(
                    text: 'Name Number',
                    color: blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    align: TextAlign.start,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: CustomText(
                    text: '${numeroTable.name_number}',
                    color: blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    align: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          color: card6,
          height: 40,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CustomText(
                    text: 'Evil Num',
                    color: blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    align: TextAlign.start,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: CustomText(
                    text: '${numeroTable.evil_num}',
                    color: blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    align: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          color: card7,
          height: 40,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CustomText(
                    text: 'Fav Color',
                    color: blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    align: TextAlign.start,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: CustomText(
                    text: '${numeroTable.fav_color}',
                    color: blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    align: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          color: card8,
          height: 40,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CustomText(
                    text: 'Fav Day',
                    color: blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    align: TextAlign.start,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: CustomText(
                    text: '${numeroTable.fav_day}',
                    color: blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    align: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          color: card9,
          height: 40,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CustomText(
                    text: 'Fav God',
                    color: blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    align: TextAlign.start,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: CustomText(
                    text: '${numeroTable.fav_god}',
                    color: blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    align: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          color: card1,
          height: 40,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CustomText(
                    text: 'Fav Mantra',
                    color: blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    align: TextAlign.start,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: CustomText(
                    text: '${numeroTable.fav_mantra}',
                    color: blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    align: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          color: card2,
          height: 40,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CustomText(
                    text: 'Fav Metal',
                    color: blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    align: TextAlign.start,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: CustomText(
                    text: '${numeroTable.fav_metal}',
                    color: blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    align: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          color: card3,
          height: 40,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CustomText(
                    text: 'Fav Stone',
                    color: blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    align: TextAlign.start,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: CustomText(
                    text: '${numeroTable.fav_stone}',
                    color: blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    align: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          color: card4,
          height: 40,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CustomText(
                    text: 'Fav Substone',
                    color: blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    align: TextAlign.start,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: CustomText(
                    text: '${numeroTable.fav_substone}',
                    color: blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    align: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          color: card5,
          height: 40,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CustomText(
                    text: 'Friendly Num',
                    color: blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    align: TextAlign.start,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: CustomText(
                    text: '${numeroTable.friendly_num}',
                    color: blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    align: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          color: card6,
          height: 40,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CustomText(
                    text: 'Neutral Num',
                    color: blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    align: TextAlign.start,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: CustomText(
                    text: '${numeroTable.neutral_num}',
                    color: blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    align: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          color: card7,
          height: 40,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CustomText(
                    text: 'Radical Num',
                    color: blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    align: TextAlign.start,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: CustomText(
                    text: '${numeroTable.fav_god}',
                    color: blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    align: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          color: card8,
          height: 40,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CustomText(
                    text: 'Radical Ruler',
                    color: blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    align: TextAlign.start,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: CustomText(
                    text: '${numeroTable.radical_ruler}',
                    color: blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    align: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }*/
}
