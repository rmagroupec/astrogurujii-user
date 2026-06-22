
import 'package:astro_gurujii/Screens/Models/profileModel.dart';
import 'package:astro_gurujii/Screens/PlaceSearchScreen.dart';
import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Screens/bottomSheet.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:astro_gurujii/Utilities/CustomRichText.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudiontakeForm extends StatefulWidget {
  final String wallet;
  final String rate;
  final String name;
  final String profile;
  final String astrologer_id;
  final String numberAstro;
  AudiontakeForm(
      {required this.numberAstro,
     required this.wallet,
     required this.rate,
    required  this.name,
    required  this.profile,
    required  this.astrologer_id});
  @override
  _CreateUserState createState() => _CreateUserState();
}

class _CreateUserState extends State<AudiontakeForm> {
  int gender1 = 0;
  HttpServices _httpService = HttpServices();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _dob = TextEditingController();
  final TextEditingController _time = TextEditingController();
  final TextEditingController _placeOfBirth = TextEditingController();
  var day;
  var month;
  var year;
  var hh;
  var mm;
  bool? isLoading;
  String userId1 = "";
  String genderName = "Male";
  bool is_loading = true;
  bool m_dateStatus = false;
  bool m_tiemStatus = false;
  bool m_placeStatus = false;
  var latitude;
  var longitude;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  validate() async {
    if (_dob.text.length == 0) {
      setState(() {
        m_dateStatus = true;
      });
    } else {
      setState(() {
        m_dateStatus = false;
      });
    }

    if (_time.text.length == 0) {
      setState(() {
        m_tiemStatus = true;
      });
    } else {
      setState(() {
        m_tiemStatus = false;
      });
    }
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      String userID = prefs.getString('id').toString();
      String channel_id = userID +
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

      var phone = prefs.getString("number");
      showAlertDialog(context, phone, widget.numberAstro, widget.wallet,
          widget.rate, widget.astrologer_id, kundli.toString());

      /* Navigator.push(
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
                    channel_id: channel_id,
                  )));*/
    }
  }

  showAlertDialog(BuildContext context, var phone, var number, var userWallet,
      var video_rate, var astrologerID, var kundli) async {
    HttpServices _httpService = HttpServices();
    // set up the button
    BuildContext dialogContext;
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Center(
          child: Text(
        "Call initiated!",
        style: TextStyle(
            color: blackColor, fontSize: 14, fontWeight: FontWeight.w500),
      )),
      content: Container(
        height: 400,
        child: Column(
          children: [
            Text(
              "You will receive a call from",
              style: TextStyle(
                  color: blackColor, fontSize: 14, fontWeight: FontWeight.w500),
            ),
            Text(
              "+918048159392",
              style: TextStyle(
                  color: primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
            Row(
              children: [
                Text(
                  "number on your ",
                  style: TextStyle(
                      color: blackColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  phone ?? '',
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Text(
              "number.",
              style: TextStyle(
                  color: blackColor, fontSize: 14, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF000000),
                    Color(0xFF000000),
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
              width: double.infinity,
              margin: EdgeInsets.only(left: 20, right: 20),
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
              child: Text(
                "Available Talk Time: " +
                    getMaxDuration(userWallet, video_rate),
                style: TextStyle(
                    color: whiteColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Note: Based on the amount in your wallet, your call will be disconnected after ${getMaxDuration(userWallet, video_rate)}",
              style: TextStyle(
                  color: blackColor, fontSize: 12, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Please ensure  ${phone} is switched on and is in network coverage area.",
              style: TextStyle(
                  color: blackColor, fontSize: 12, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () async {
                Fluttertoast.showToast(
                    msg:
                        "Thank You!\nYou will get a call from our astrologer shortly.");
                var res = await _httpService.call_initiate(
                    astrologer_id: astrologerID,
                    call_type: "audio",
                    kundli: kundli, channel_id: '');
                if (res!.status == true) {
                  Navigator.of(context).pop();
                } else {
                  Fluttertoast.showToast(msg: res.message!);
                }
              },
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFFC7601),
                      Color(0xFFFC7601),
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
                width: double.infinity,
                margin: EdgeInsets.only(left: 20, right: 20),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: Center(
                  child: Text(
                    "OK",
                    style: TextStyle(
                        color: whiteColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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
        is_loading = false;
        if (profileResults!.gender!.length > 0) {
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
    // TODO: implement initState
    getProfile();
    super.initState();
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
          "Call Intake Form",
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
        /*actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.menu,color: Colors.black,))
        ],*/
      ),
      /* appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Chat Intake Form"),
      ),*/
      body: is_loading
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
                                        // genderSwitch(gender);
                                        profileResults!.gender = "Male";
                                        //  print("Gender is :${data.gender}");
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
                                        //  genderSwitch(gender);
                                        profileResults!.gender = "Female";
                                        //  print("Gender is :${data.gender}");
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
                                  validator: MultiValidator([
                                    RequiredValidator(
                                        errorText: "Birth place Required"),
                                    MaxLengthValidator(30,
                                        errorText: "Enter Valid Birth place"),
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
                                height: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Align(
                          alignment: Alignment.topLeft,
                          child: CustomText(
                            text:
                                'Note: If you want to change the details please edit the above form.',
                            align: TextAlign.start,
                            color: primaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )),
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
                              'Start Call with ${widget.name}',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
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
        _dob.text = DateFormat('yyyy-MM-dd').format(selectedDate);
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
