
import 'package:astro_gurujii/Screens/Login.dart';
import 'package:astro_gurujii/Screens/Models/profileModel.dart';
import 'package:astro_gurujii/Screens/MyWallet.dart';
import 'package:astro_gurujii/Screens/PlaceSearchScreen.dart';
import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:astro_gurujii/Utilities/CustomRichText.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportIntakeForm extends StatefulWidget {
  static const String reportIntakeForm = "/ReportIntakeForm ";
  final String astroId;
  final String amount;
  final String report_id;
  ReportIntakeForm({required this.amount, required this.astroId,required this.report_id});

  @override
  _ReportIntakeFormState createState() => _ReportIntakeFormState();
}

class _ReportIntakeFormState extends State<ReportIntakeForm> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _gender = TextEditingController();
  final TextEditingController _dob = TextEditingController();
  final TextEditingController _time = TextEditingController();
  final TextEditingController _placeOfBirth = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _maritialStatus =
      TextEditingController(); //unused//
  final TextEditingController _occupation = TextEditingController();
  final TextEditingController _anyComment = TextEditingController();
  HttpServices _httpService = HttpServices();
  bool is_loading = true;
  bool _isLoading = true;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /*PickResult selectedPlace;
  static final kInitialPosition = LatLng(-33.8567844, 151.213108);
*/
  final dateFormat = DateFormat("dd-MM-yyyy");
  final timeFormat = DateFormat("HH:mm");
  DateTime currentVale = DateTime.now();

  Future<void> getDataApi() async {
    final prefs = await SharedPreferences.getInstance();
    var res = await _httpService.report_form_add(
        astro_id: widget.astroId,
        report_type: widget.report_id,
        name: _firstNameController.text,
        last_name: _lastNameController.text,
        number: _phoneNumber.text,
        gender: genderName,
        dob: _dob.text,
        tob: _time.text,
        pob: _placeOfBirth.text,
        address: _address.text,
        marital_status: _maritialStatus.text,
        occupation: _occupation.text,
        ans_language: "English",
        any_comments: _anyComment.text,
        amount: widget.amount,
        month: "",
        is_payment_done: "YES");
    if (res!.result == true) {
      setState(() {
        _isLoading = false;
        showAlertDialog(context, res.message!);
      });
    } else {
      _isLoading = false;
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }

  Future<void> setValues() async {
    final _prefs = await SharedPreferences.getInstance();
    _firstNameController.text = _prefs.get("name").toString();
    _gender.text = _prefs.get("gender").toString();
    _dob.text = _prefs.get("dob").toString();
    _time.text = _prefs.get("birth_time").toString();
    _placeOfBirth.text = _prefs.get("birth_place").toString();
    _phoneNumber.text = _prefs.get("phone").toString();
  }

/*  validate() {

    if (_formKey.currentState.validate()) {
      if(_dob.text.length == 0 ||
          _time.text.length == 0 ||
          _placeOfBirth.text.length == 0 ||
          _gender.text.length==0 ||
          _maritialStatus.text.length==0)
      {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Please fill input fields'),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: primaryColor,
                        ),

                        onPressed: ()
                        {
                          Navigator.pop(context);
                        },
                        child: Text("Ok"),
                      )
                    ],
                  )

                ],
              ),
            )
        );
      }
      else
      {
        if(double.parse(wallet)<double.parse(widget.amount)){
          Navigator.push(
              context, MaterialPageRoute(builder: (ctx) => MyWallet()));
        }else{
          getDataApi();
        }

      }
    }
  }*/

  var _currencies = [
    "Single",
    "Married",
    "Divorced",
    "Separated",
    "Windowed",
  ];

  var _currentSelectedValue;

  @override
  void initState() {
    setValues();
    getProfile();
    super.initState();
  }

  String wallet = "0.0";
  String currency = '';
  String currencySign = "";
  String genderName = "Male";
  ProfileResults? profileResults;
  void getProfile() async {
    var res = await _httpService.profile_api();
    if (res!.status == true) {
      setState(() {
        profileResults = res.results;
        wallet = res.results!.wallet.toString();
        currency = res.results!.currency.toString();
        if (profileResults!.gender!.length > 0) {
          genderName = profileResults!.gender!;
        }
        if (currency == "USD") {
          setState(() {
            currencySign = "\u{20B9}";
          });
        } else {
          setState(() {
            currencySign = "\u{20B9}";
          });
        }
        is_loading = false;
      });
    } else {
      Fluttertoast.showToast(msg: res.message!);
    }
  }

  bool m_dateStatus = false;
  bool m_tiemStatus = false;
  bool m_placeStatus = false;
  bool m_occupation = false;
  bool marital_status = false;
  bool is_validate = false;
  var latitude;
  var longitude;

  validate() async {
    if (_dob.text.length == 0) {
      setState(() {
        m_dateStatus = true;
        is_validate = false;
      });
    } else {
      setState(() {
        m_dateStatus = false;
        is_validate = true;
      });
    }

    if (_time.text.length == 0) {
      setState(() {
        m_tiemStatus = true;
        is_validate = false;
      });
    } else {
      setState(() {
        m_tiemStatus = false;
        is_validate = true;
      });
    }

    if (_occupation.text.length == 0) {
      setState(() {
        m_occupation = true;
        is_validate = false;
      });
    } else {
      setState(() {
        m_occupation = false;
        is_validate = true;
      });
    }

    if (_maritialStatus.text.length == 0) {
      setState(() {
        marital_status = true;
        is_validate = false;
      });
    } else {
      setState(() {
        marital_status = false;
        is_validate = true;
      });
    }

    if (_formKey.currentState!.validate() && is_validate == true) {
      if (double.parse(wallet) < double.parse(widget.amount)) {
        final _prefs = await SharedPreferences.getInstance();
        if (_prefs.get("is_skip") == "Y") {
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (_) => LoginPage()), (route) => false);
        } else {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => MyWallet()));
        }
      } else {
        getDataApi();
      }
    }
  }

  int gender1 = 0;

  @override
  Widget build(BuildContext context) {
    final focus = FocusNode();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Report Intake Form"),
      ),
      body: is_loading
          ? Center(
              child: Lottie.asset(
              'assets/profile/loader.json',
            ))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
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
                                                fontWeight: FontWeight.w500),
                                          )
                                        : Text(
                                            'Male',
                                            style: TextStyle(
                                                color: Color(0xFF6F6F6F),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
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
                                                fontWeight: FontWeight.w500),
                                          )
                                        : Text(
                                            'Female',
                                            style: TextStyle(
                                                color: Color(0xFF6F6F6F),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
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

                          /* Container(
                      margin: EdgeInsets.only(top: 10),
                      child: TextFormField(
                        controller: _address,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(blueGreyColor)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(blueGreyColor)),
                          ),
                          labelStyle: TextStyle(color: Color(blueGreyColor)),
                          labelText: "Enter Address",
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),*/
                          SizedBox(
                            height: 15,
                          ),
                          Align(
                              alignment: Alignment.topLeft,
                              child: CustomRichText(
                                text: 'Occupation',
                                align: TextAlign.start,
                                color: blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              )),
                          Container(
                            height: 40,
                            margin: EdgeInsets.only(top: 15),
                            child: TextFormField(
                              controller: _occupation,
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
                          (m_occupation)
                              ? Align(
                                  alignment: Alignment.topLeft,
                                  child: CustomText(
                                    text: 'Please enter occupation',
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
                                text: 'Marital status',
                                align: TextAlign.start,
                                color: blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              )),
                          SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            height: 40,
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: whiteColor,
                                border: Border.all(color: greyColor),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _currentSelectedValue,
                                    isDense: true,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _currentSelectedValue = newValue;
                                        //print(_currentSelectedValue);
                                        _maritialStatus.text =
                                            _currentSelectedValue;
                                        //state.didChange(newValue);
                                      });
                                    },
                                    items: _currencies.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          (marital_status)
                              ? Align(
                                  alignment: Alignment.topLeft,
                                  child: CustomText(
                                    text: 'Please select marital status',
                                    align: TextAlign.start,
                                    color: redColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.normal,
                                  ))
                              : SizedBox(),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: TextFormField(
                              controller: _anyComment,
                              decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(blueGreyColor)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(blueGreyColor)),
                                  ),
                                  labelStyle:
                                      TextStyle(color: Color(blueGreyColor)),
                                  labelText: "Any comments",
                                  hintText: "Enter your comment here"),
                              keyboardType: TextInputType.multiline,
                              maxLines: 4,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              validate();
                            },
                            child: Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(top: 20, bottom: 20),
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 95),
                              child: Text(
                                "SUBMIT",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                                textAlign: TextAlign.center,
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
                ],
              ),
            ),
    );
  }

  showAlertDialog(BuildContext context, String message) async {
    // set up the button
    BuildContext dialogContext;
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Column(
        children: [
          Image.asset(
            "assets/login/login_icon.png",
            height: 80,
          ),
          SizedBox(
            height: 10,
          ),
          Center(child: Text("Thank you")),
        ],
      ),
      content: Container(
        height: 200,
        child: Column(
          children: [
            Text(
              message,
              style: TextStyle(
                  color: blackColor,
                  fontSize: 14,
                  fontWeight: FontWeight.normal),
            ),
            SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: () async {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFFC7601),
                      Color(0xFFFC7601),
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
