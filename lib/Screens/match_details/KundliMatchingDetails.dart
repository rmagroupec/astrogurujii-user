
import 'package:astro_gurujii/Screens/PlaceSearchScreen.dart';
import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Screens/match_details/MachingDetailsScreen.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:astro_gurujii/Utilities/CustomRichText.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';

class KundliMatchingDetails extends StatefulWidget {
  final String? id;
  final String? price;
  KundliMatchingDetails({this.id, this.price});
  @override
  _CreateUserState createState() => _CreateUserState();
}

class _CreateUserState extends State<KundliMatchingDetails> {
  HttpServices _httpService = HttpServices();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _dob = TextEditingController();
  final TextEditingController _time = TextEditingController();
  final TextEditingController _placeOfBirth = TextEditingController();

  final TextEditingController _firstNameControllerGirls =
  TextEditingController();
  final TextEditingController _dobGirls = TextEditingController();
  final TextEditingController _timeGirls = TextEditingController();
  final TextEditingController _placeOfBirthGirls = TextEditingController();
  var day;
  var month;
  var year;
  var hh;
  var mm;

  var f_day;
  var f_month;
  var f_year;
  var f_hh;
  var f_mm;
  bool? isLoading;
  String userId1 = "";

  bool m_dateStatus = false;
  bool m_tiemStatus = false;
  bool f_dateStatus = false;
  bool f_tineStatus = false;
  bool m_placeStatus = false;
  bool f_placeStatus = false;
  bool statusGlobal = true;

  var m_placeBirth = "";

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  validate() async {
    if (_dob.text.length == 0) {
      setState(() {
        m_dateStatus = true;
        statusGlobal = false;
      });
    } else {
      setState(() {
        m_dateStatus = false;
        statusGlobal = true;
      });
    }

    if (_time.text.length == 0) {
      setState(() {
        m_tiemStatus = true;
        statusGlobal = false;
      });
    } else {
      setState(() {
        m_tiemStatus = false;
        statusGlobal = true;
      });
    }

    if (_dobGirls.text.length == 0) {
      setState(() {
        f_dateStatus = true;
        statusGlobal = false;
      });
    } else {
      setState(() {
        f_dateStatus = false;
        statusGlobal = true;
      });
    }

    if (_timeGirls.text.length == 0) {
      setState(() {
        f_tineStatus = true;
        statusGlobal = false;
      });
    } else {
      setState(() {
        f_tineStatus = false;
        statusGlobal = true;
      });
    }
    if (_formKey.currentState!.validate()) {
      _createUser();
    }
  }

  var m_latitude = "";
  var m_longitude = "";
  var f_latitude = "";
  var f_longitude = "";
  void checkLocation() async {
    var res =
    await _httpService.geo_details(place: _placeOfBirth.text.toString());
    if (res!.geonames != null) {
      setState(() {
        if (res.geonames!.length > 0) {
          if (res.geonames![0].place_name == "Try nearby city or district!") {
            setState(() {
              m_placeStatus = false;
            });
          } else {
            m_latitude = res.geonames![0].latitude.toString();
            m_longitude = res.geonames![0].longitude.toString();
            statusGlobal = true;

            //_createUser(res.geonames[0].latitude.toString(),res.geonames[0].longitude.toString());
          }
        }

        // _createUser();
      });
    }
  }

  void checkLocationGirls() async {
    var res =
    await _httpService.geo_details(place: _placeOfBirth.text.toString());
    if (res!.geonames != null) {
      setState(() {
        if (res.geonames!.length > 0) {
          if (res.geonames![0].place_name == "Try nearby city or district!") {
            setState(() {
              f_placeStatus = false;
            });
          } else {
            f_latitude = res.geonames![0].latitude.toString();
            f_longitude = res.geonames![0].longitude.toString();
            statusGlobal = true;

            //_createUser(res.geonames[0].latitude.toString(),res.geonames[0].longitude.toString());
          }
        }

        // _createUser();
      });
    } else {}
  }

  _createUser() async {
    setState(() {
      isLoading = true;
    });

    var res = await _httpService.get_ashtakoot_match(
      name: _firstNameController.text,
      year: year.toString(),
      month: month.toString(),
      day: day.toString(),
      hour: hh.toString(),
      min: mm.toString(),
      lat: m_latitude,
      lon: m_longitude,
      tzone: "5.5",
      f_name: _firstNameControllerGirls.text,
      f_year: f_year.toString(),
      f_month: f_month.toString(),
      f_day: f_day.toString(),
      f_hour: f_hh.toString(),
      f_min: f_mm.toString(),
      f_lat: f_latitude,
      f_lon: f_longitude,
      f_tzone: "5.5",
    );
    if (res!.status ==true) {
      Fluttertoast.showToast(msg: res.message);
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MachingDetailsScreen(
                res: res,
                m_name: _firstNameController.text.toString(),
                f_name: _firstNameControllerGirls.text.toString(),
              )));
    } else {
      print("SigUp fAILED");
    }
    setState(() {
      isLoading = false;
    });
  }

  final dateFormat = DateFormat("dd-MM-yyyy");
  final timeFormat = DateFormat("HH:mm");
  DateTime currentVale = DateTime.now();

  var _currentSelectedValue;
  var _genderSelectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Kundli Matching"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Align(
                            alignment: Alignment.center,
                            child: CustomText(
                              text: '${"Boy's Details"}',
                              align: TextAlign.center,
                              color: blackColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                            alignment: Alignment.topLeft,
                            child: CustomRichText(
                              text: 'Name',
                              align: TextAlign.start,
                              color: blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            )),
                        Container(
                          height: 40,
                          margin: EdgeInsets.only(top: 10),
                          child: TextFormField(
                            validator: MultiValidator([
                              RequiredValidator(errorText: "Name Required"),
                              MaxLengthValidator(30,
                                  errorText: "Enter Valid First Name"),
                              MinLengthValidator(2,
                                  errorText:
                                  "Name should be minimum 3 character"),
                            ]),
                            controller: _firstNameController,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: greyColor1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: greyColor1),
                              ),
                              labelStyle: TextStyle(color: greyColor1),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                            alignment: Alignment.topLeft,
                            child: CustomRichText(
                              text: 'Birth Date',
                              align: TextAlign.start,
                              color: blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            _selectDate(context);
                          },
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              width: MediaQuery.of(context).size.width,
                              height: 40,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey)),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: CustomText(
                                  text: _dob.text.toString(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        (m_dateStatus)
                            ? Align(
                            alignment: Alignment.topLeft,
                            child: CustomText(
                              text: 'Please select birth date',
                              align: TextAlign.start,
                              color: redColor,
                              fontSize: 11,
                              fontWeight: FontWeight.normal,
                            ))
                            : SizedBox(),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                            alignment: Alignment.topLeft,
                            child: CustomRichText(
                              text: 'Birth Time',
                              align: TextAlign.start,
                              color: blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            _selectTime(context);
                          },
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              width: MediaQuery.of(context).size.width,
                              height: 40,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey)),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: CustomText(
                                  text: _time.text.toString(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        (m_tiemStatus)
                            ? Align(
                            alignment: Alignment.topLeft,
                            child: CustomText(
                              text: 'Please select birth time',
                              align: TextAlign.start,
                              color: redColor,
                              fontSize: 11,
                              fontWeight: FontWeight.normal,
                            ))
                            : SizedBox(),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                            alignment: Alignment.topLeft,
                            child: CustomRichText(
                              text: 'Birth Place',
                              align: TextAlign.start,
                              color: blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            )),
                        Container(
                          height: 40,
                          margin: EdgeInsets.only(top: 10),
                          child: TextFormField(
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PlaceSearchScreen((value) {
                                            setState(() {
                                              setMPlace(value);
                                            });
                                            return value;
                                          })));
                            },
                            validator: MultiValidator([
                              RequiredValidator(
                                  errorText: "Birth place Required"),
                              MinLengthValidator(2,
                                  errorText:
                                  "Birth place be minimum 2 character"),
                            ]),
                            readOnly: true,
                            controller: _placeOfBirth,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: greyColor1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: greyColor1),
                              ),
                              labelStyle: TextStyle(color: greyColor1),
                            ),
                          ),
                        ),
                        (m_placeStatus)
                            ? Align(
                            alignment: Alignment.topLeft,
                            child: CustomText(
                              text: 'Try nearby city or district!',
                              align: TextAlign.start,
                              color: redColor,
                              fontSize: 11,
                              fontWeight: FontWeight.normal,
                            ))
                            : SizedBox(),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Align(
                            alignment: Alignment.center,
                            child: CustomText(
                              text: '${"Girl's Details"}',
                              align: TextAlign.center,
                              color: blackColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                            alignment: Alignment.topLeft,
                            child: CustomRichText(
                              text: 'Name',
                              align: TextAlign.start,
                              color: blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            )),
                        Container(
                          height: 40,
                          margin: EdgeInsets.only(top: 10),
                          child: TextFormField(
                            validator: MultiValidator([
                              RequiredValidator(errorText: "Name Required"),
                              MaxLengthValidator(30,
                                  errorText: "Enter Valid First Name"),
                              MinLengthValidator(2,
                                  errorText:
                                  "Name should be minimum 3 character"),
                            ]),
                            controller: _firstNameControllerGirls,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: greyColor1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: greyColor1),
                              ),
                              labelStyle: TextStyle(color: greyColor1),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                            alignment: Alignment.topLeft,
                            child: CustomRichText(
                              text: 'Birth Date',
                              align: TextAlign.start,
                              color: blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            _selectDateGirls(context);
                          },
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              width: MediaQuery.of(context).size.width,
                              height: 40,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey)),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: CustomText(
                                  text: _dobGirls.text.toString(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        (f_dateStatus)
                            ? Align(
                            alignment: Alignment.topLeft,
                            child: CustomText(
                              text: 'Please select birth date',
                              align: TextAlign.start,
                              color: redColor,
                              fontSize: 11,
                              fontWeight: FontWeight.normal,
                            ))
                            : SizedBox(),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                            alignment: Alignment.topLeft,
                            child: CustomRichText(
                              text: 'Birth time',
                              align: TextAlign.start,
                              color: blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            _selectTimeGirls(context);
                          },
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              width: MediaQuery.of(context).size.width,
                              height: 40,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey)),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: CustomText(
                                  text: _timeGirls.text.toString(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        (f_tineStatus)
                            ? Align(
                            alignment: Alignment.topLeft,
                            child: CustomText(
                              text: 'Please select birth time',
                              align: TextAlign.start,
                              color: redColor,
                              fontSize: 11,
                              fontWeight: FontWeight.normal,
                            ))
                            : SizedBox(),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                            alignment: Alignment.topLeft,
                            child: CustomRichText(
                              text: 'Birth Place',
                              align: TextAlign.start,
                              color: blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            )),
                        Container(
                          height: 40,
                          margin: EdgeInsets.only(top: 10),
                          child: TextFormField(
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PlaceSearchScreen((value) {
                                            setState(() {
                                              setFPlace(value);
                                            });
                                            return value;
                                          })));
                            },
                            validator: MultiValidator([
                              RequiredValidator(
                                  errorText: "Birth place Required"),
                              MinLengthValidator(2,
                                  errorText:
                                  "Birth place be minimum 2 character"),
                            ]),
                            controller: _placeOfBirthGirls,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: greyColor1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: greyColor1),
                              ),
                              labelStyle: TextStyle(color: greyColor1),
                            ),
                          ),
                        ),
                        (f_placeStatus)
                            ? Align(
                            alignment: Alignment.topLeft,
                            child: CustomText(
                              text: 'Try nearby city or district!',
                              align: TextAlign.start,
                              color: redColor,
                              fontSize: 11,
                              fontWeight: FontWeight.normal,
                            ))
                            : SizedBox(),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    validate();
                  },
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 95),
                    child: Text(
                      "Match Horoscope",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          primaryColor,
                          primaryColor,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 2.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
   final DateTime? picked = await showDatePicker(
  context: context,
  initialDate: selectedDate,
  firstDate: DateTime(1900, 8),
  lastDate: DateTime.now(),
);
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        day = selectedDate.day;
        month = selectedDate.month;
        year = selectedDate.year;
        _dob.text = DateFormat('yyyy-MM-dd').format(selectedDate);
        // _dob.text=outputFormat.format(outputFormat);
      });
    }
  }

  Future<void> _selectDateGirls(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
  context: context,
  initialDate: selectedDate,
  firstDate: DateTime(1900, 8),
  lastDate: DateTime.now(),
);
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        f_day = selectedDate.day;
        f_month = selectedDate.month;
        f_year = selectedDate.year;
        _dobGirls.text = DateFormat('yyyy-MM-dd').format(selectedDate);
        // _dob.text=outputFormat.format(outputFormat);
      });
    }
  }

  TimeOfDay selectedTime = TimeOfDay.now();

  _selectTime(BuildContext context) async {
    DateTime tempDate = DateFormat("hh:mm").parse(
        selectedTime.hour.toString() + ":" + selectedTime.minute.toString());
    //String datetime2 = DateFormat.Hms().format(_startDate);
    var dateFormat = DateFormat("hh:mm a");
    _time.text = dateFormat.format(tempDate);
     final TimeOfDay? timeOfDay = await showTimePicker(
    context: context,
    initialTime: selectedTime,
    initialEntryMode: TimePickerEntryMode.dial,
  );
    setState(() {
      selectedTime = timeOfDay!;

      DateTime tempDate = DateFormat("hh:mm").parse(
          selectedTime.hour.toString() + ":" + selectedTime.minute.toString());
      //String datetime2 = DateFormat.Hms().format(_startDate);
      var dateFormat = DateFormat("hh:mm");
      hh = tempDate.hour.toString();
      mm = tempDate.minute.toString();
      _time.text = dateFormat.format(tempDate);
    });
    if (timeOfDay != null && timeOfDay != selectedTime) {}
  }

  _selectTimeGirls(BuildContext context) async {
    DateTime tempDate = DateFormat("hh:mm").parse(
        selectedTime.hour.toString() + ":" + selectedTime.minute.toString());
    //String datetime2 = DateFormat.Hms().format(_startDate);
    var dateFormat = DateFormat("hh:mm a");
    _timeGirls.text = dateFormat.format(tempDate);
    final TimeOfDay? timeOfDay = await showTimePicker(
    context: context,
    initialTime: selectedTime,
    initialEntryMode: TimePickerEntryMode.dial,
  );
    setState(() {
      selectedTime = timeOfDay!;

      DateTime tempDate = DateFormat("hh:mm").parse(
          selectedTime.hour.toString() + ":" + selectedTime.minute.toString());
      //String datetime2 = DateFormat.Hms().format(_startDate);
      var dateFormat = DateFormat("hh:mm");
      f_hh = tempDate.hour.toString();
      f_mm = tempDate.minute.toString();
      _timeGirls.text = dateFormat.format(tempDate);
    });
    if (timeOfDay != null && timeOfDay != selectedTime) {}
  }

  void setMPlace(String value) {
    getLatidudeM(value.toString());
    setState(() {
      _placeOfBirth.text =
      (value.length > 40) ? value.substring(0, 40) + ".." : value;
    });
  }

  void setFPlace(String value) {
    getLatidudeF(value.toString());
    setState(() {
      _placeOfBirthGirls.text =
      (value.length > 40) ? value.substring(0, 40) + ".." : value;
    });
  }

  Future<void> getLatidudeM(String address) async {
    var res = await _httpService.geocode(place: address);
    setState(() {
      m_latitude = res!.lat.toString();
      m_longitude = res.lng.toString();
    });
  }

  Future<void> getLatidudeF(String address) async {
    var res = await _httpService.geocode(place: address);
    setState(() {
      f_latitude = res!.lat.toString();
      f_longitude = res.lng.toString();
    });
  }
}
