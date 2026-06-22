
import 'package:astro_gurujii/Screens/Models/profileModel.dart';
import 'package:astro_gurujii/Screens/PlaceSearchScreen.dart';
import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Screens/chats_screen/ChatCallingScreen.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:astro_gurujii/Setup/app_colors.dart';
import 'package:astro_gurujii/Utilities/CustomRichText.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';



class ChatIntakeForm extends StatefulWidget {
  final String wallet;
  final String rate;
  final String name;
  final String profile;
  final String astrologer_id;
  ChatIntakeForm(
      {required this.wallet, required this.rate, required this.name, required this.profile, required this.astrologer_id});
  @override
  _CreateUserState createState() => _CreateUserState();
}

class _CreateUserState extends State<ChatIntakeForm> {
  int gender1 = 0;
  final HttpServices _httpService = HttpServices();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _dob = TextEditingController();
  final TextEditingController _time = TextEditingController();
  final TextEditingController _placeOfBirth = TextEditingController();
  var day;
  var month;
  var year;
  var hh;
  var mm;
  String userId1 = "";
  String genderName = "Male";
  bool isLoading = true;
  bool mDateStatus = false;
  bool mTiemStatus = false;
  bool mPlaceStatus = false;
  var latitude;
  var longitude;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  // For Date Picker
 Future<void> _selectDate(BuildContext context) async {
  DatePicker.showDatePicker(
    context,
    showTitleActions: true,
    minTime: DateTime(1800, 8),
    maxTime: DateTime.now(),
    currentTime: selectedDate,
    locale: LocaleType.en,
    onConfirm: (DateTime date) {
      setState(() {
        selectedDate = date;
        _dob.text = DateFormat('dd-MM-yyyy').format(date);
        day = date.day;
        month = date.month;
        year = date.year;
      });
    },
    // theme: DatePickerTheme(
    //   backgroundColor: Colors.white,
    //   headerColor: AppColors.textWhite,
    //   itemStyle: TextStyle(
    //     color: AppColors.orangeColor,
    //     fontWeight: FontWeight.bold,
    //     fontSize: 18,
    //   ),
    //   doneStyle: TextStyle(
    //     color: AppColors.orangeColor,
    //     fontSize: 16,
    //   ),
    //   cancelStyle: TextStyle(
    //     color: Colors.red,
    //     fontSize: 16,
    //   ),
    // ),
  );
}

// For Time Picker
  _selectTime(BuildContext context) async {
    DatePicker.showTimePicker(
      context,
      showTitleActions: true,
      onConfirm: (time) {
        setState(() {
          selectedTime = TimeOfDay(hour: time.hour, minute: time.minute);
          var dateFormat = DateFormat("hh:mm a");
          _time.text = dateFormat.format(
              DateTime(0, 0, 0, selectedTime.hour, selectedTime.minute));
        });
      },
      currentTime: DateTime(0, 0, 0, selectedTime.hour, selectedTime.minute),
      locale: LocaleType.en,
      // theme: DatePickerTheme(
      //   backgroundColor: Colors.white, // Background color of the picker
      //   headerColor: AppColors.textWhite, // Header background color
      //   itemStyle: TextStyle(
      //     color: AppColors.orangeColor, // Text color of the items
      //     fontWeight: FontWeight.bold,
      //     fontSize: 18,
      //   ),
      //   doneStyle: TextStyle(
      //     color: AppColors.orangeColor, // Done button color
      //     fontSize: 16,
      //   ),
      //   cancelStyle: TextStyle(
      //     color: Colors.red, // Cancel button color
      //     fontSize: 16,
      //   ),
      // ),
    );
  }

//For place picker
  void setMPlace(String value) {
    getLatidudeM(value.toString());
    setState(() {
      _placeOfBirth.text =
          (value.length > 40) ? value.substring(0, 40) + ".." : value;
    });
  }

  Future<void> getLatidudeM(String address) async {
    var res = await _httpService.geocode(place: address);
    setState(() {
      latitude = res!.lat.toString();
      longitude = res.lng.toString();
    });
  }

  validate() async {
    if (_dob.text.isEmpty) {
      setState(() {
        mDateStatus = true;
      });
    } else {
      setState(() {
        mDateStatus = false;
      });
    }

    if (_time.text.isEmpty) {
      setState(() {
        mTiemStatus = true;
      });
    } else {
      setState(() {
        mTiemStatus = false;
      });
    }

    if (_placeOfBirth.text.isNotEmpty) {
      if (_formKey.currentState!.validate()) {
        final prefs = await SharedPreferences.getInstance();
        String userID = prefs.getString('id').toString();
        String channelId = userID +
            "_" +
            widget.astrologer_id +
            "_" +
            ((DateTime.now().millisecondsSinceEpoch).toString());

        Kundli kundli = Kundli(
            gender: genderName,
            name: _firstNameController.text.toString(),
            yy: year.toString(),
            mm: month.toString(),
            dd: day.toString(),
            hh_time: hh.toString(),
            mm_time: mm.toString(),
            latitude: latitude.toString(),
            longitude: longitude.toString(),
            place: _placeOfBirth.text);
        final _prefs = await SharedPreferences.getInstance();
        _prefs.setString('name', _firstNameController.text.toString());
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) => ChatCallingScreen(
                      kundali: kundli.toString(),
                      wallet: widget.wallet,
                      rate: widget.rate,
                      place: _placeOfBirth.text,
                      tob: _time.text,
                      dob: _dob.text,
                      gender: profileResults!.gender,
                      name: _firstNameController.text,
                      astroName: widget.name,
                      profile: widget.profile,
                      astrologer_id: widget.astrologer_id,
                      channel_id: channelId,
                    )));
      }
    } else {
      Fluttertoast.showToast(msg: "Place of birth is required");
    }
  }

  final HttpServices _httpServices = HttpServices();
  ProfileResults? profileResults;

  void getProfile() async {
    var res = await _httpServices.profile_api();
    if (res!.status == true) {
      setState(() {
        profileResults = res.results;
        _firstNameController.text = profileResults!.name!;
        _placeOfBirth.text = profileResults!.pob!;
        _dob.text = profileResults!.dob!;
        _time.text = profileResults!.tob!;
        isLoading = false;
        if (profileResults!.gender!.isNotEmpty) {
          genderName = profileResults!.gender!;
        }
        if (_placeOfBirth.text.isNotEmpty) {
          setMPlace(_placeOfBirth.text.toString());
        }
        if (_dob.text.isNotEmpty) {
          var values = _dob.text
              .split("-")
              .map((x) => x.trim())
              .where((element) => element.isNotEmpty)
              .toList();
          year = values[0];
          month = values[1];
          day = values[2];
        }

        if (res.tob.isNotEmpty) {
          var values = res.tob
              .toString()
              .split(":")
              .map((x) => x.trim())
              .where((element) => element.isNotEmpty)
              .toList();
          hh = values[0];
          mm = values[1];
        }
      });
    } else {
      Fluttertoast.showToast(msg: res.message!);
    }
  }

  @override
  void initState() {
    getProfile();
    super.initState();
  }

  final dateFormat = DateFormat("dd-MM-yyyy");
  final timeFormat = DateFormat("HH:mm");
  DateTime currentVale = DateTime.now();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            )),
        elevation: 4,
        title: Text(
          "Chat Intake Form",
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
      ),
      body: isLoading
          ? Center(
              child: Lottie.asset(
              'assets/profile/loader.json',
            ))
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
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
                                margin: EdgeInsets.only(top: 15),
                                child: TextFormField(
                                  validator: MultiValidator([
                                    RequiredValidator(
                                        errorText: "Name Required"),
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
                                height: 15,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CustomText(
                                        text: "Gender",
                                        fontWeight: FontWeight.w400,
                                        fontSize: 18,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        gender1 = 0;
                                        profileResults!.gender = "Male";
                                        genderName = profileResults!.gender!;
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        profileResults!.gender!.toLowerCase() ==
                                                "Male".toLowerCase()
                                            ? Text(
                                                'Male',
                                                style: TextStyle(
                                                    color: Color(0xFF6F6F6F),
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )
                                            : Text(
                                                'Male',
                                                style: TextStyle(
                                                    color: Color(0xFF6F6F6F),
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        profileResults!.gender!.toLowerCase() ==
                                                "Male".toLowerCase()
                                            ? Icon(
                                                Icons.radio_button_checked,
                                                color: blueColor,
                                                size: 20,
                                              )
                                            : Icon(
                                                Icons.radio_button_off_sharp,
                                                size: 20,
                                              ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        gender1 = 1;
                                        profileResults!.gender = "Female";
                                        genderName = profileResults!.gender!;
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        profileResults!.gender == "Female"
                                            ? Text(
                                                'Female',
                                                style: TextStyle(
                                                    color: Color(0xFF6F6F6F),
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )
                                            : Text(
                                                'Female',
                                                style: TextStyle(
                                                    color: Color(0xFF6F6F6F),
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        profileResults!.gender == "Female"
                                            ? Icon(
                                                Icons.radio_button_checked,
                                                color: blueColor,
                                                size: 20,
                                              )
                                            : Icon(
                                                Icons.radio_button_off_sharp,
                                                size: 20,
                                              ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
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
                                height: 15,
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
                              (mDateStatus)
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
                                height: 15,
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
                                height: 15,
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
                              (mTiemStatus)
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
                                height: 15,
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
                                margin: EdgeInsets.only(top: 15),
                                child: TextFormField(
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

                                  // validator: MultiValidator([
                                  //   RequiredValidator(
                                  //       errorText: "Birth place Required"),
                                  //   MaxLengthValidator(30,
                                  //       errorText: "Enter Valid Birth place"),
                                  //   MinLengthValidator(2,
                                  //       errorText:
                                  //           "Birth place be minimum 2 character"),
                                  // ]),

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
                              (mPlaceStatus)
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
                                height: 15,
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
                          height: 45,
                          width: double.infinity,
                          margin: EdgeInsets.only(top: 60, bottom: 20),
                          child: Center(
                            child: Text(
                              'Start chat with ${widget.name}',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                primaryColor,
                                primaryColor,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(30),
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
}

class Kundli {
  var name;
  var gender;
  var yy;
  var mm;
  var dd;
  var hh_time;
  var mm_time;
  var latitude;
  var longitude;
  var place;

  Kundli(
      {this.gender,
      this.name,
      this.yy,
      this.mm,
      this.dd,
      this.hh_time,
      this.mm_time,
      this.latitude,
      this.longitude,
      this.place});

  @override
  String toString() {
    return '{"name": "$name","gender": "$gender", "yy": "$yy", "mm": "$mm", "dd": "$dd", "hh_time": "$hh_time", "mm_time": "$mm_time", "latitude": "$latitude", "longitude": "$longitude", "place": "$place"}';
  }
}
