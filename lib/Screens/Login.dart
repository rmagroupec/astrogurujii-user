import 'dart:async';

import 'package:astro_gurujii/Screens/homeScreen/Home.dart';
import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Screens/WebViewerTerms.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:astro_gurujii/Utilities/CustomUi.dart';
import 'package:astro_gurujii/main.dart';
import 'package:astro_gurujii/widget/bottom_navigation_bar_custom.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_messaging_platform_interface/firebase_messaging_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late KeyboardVisibilityController _keyboardVisibilityController;
  late Stream<bool> _keyboardVisibilityStream;
  final TextEditingController _mobileController = TextEditingController();
  bool _isOtp = false;
  bool _isLoading = true;
  //  StateSetter ?_setSetter;
  final HttpServices _httpServices = HttpServices();
  final TextEditingController _otp = TextEditingController();
  double otp_size = 800;
  String dailcode = "91";
  String code = "IN";
  var terms = "";
  var privacy = "";
  var aboutus = "";
  void _onCountryChange(CountryCode countryCode) {
    setState(() {
      dailcode = countryCode.toString().replaceAll("+", "");
      code = countryCode.code.toString();
      //print('==================='+code);
    });
  }

  Future<void> requestNotificationPermission() async {
    var status = await Permission.notification.status;
    if (!status.isGranted) {
      await Permission.notification.request();
    }
  }
  
  @override
  void dispose() {
    _mobileController.dispose();
    _otp.dispose();
    _timer.cancel();
    super.dispose();
  }

  checkMobileNumber(BuildContext context, StateSetter updateState) {
    if (validateMobile(_mobileController.text)) {
      updateState(() {
        _isLoading = true;
        checkMobileNumberApi(updateState);
      });
    }
  }

  ///timer
  late Timer _timer;
  int _start = 59;
  void startTimer(StateSetter updateState) {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          updateState(() {
            timer.cancel();
          });
        } else {
          updateState(() {
            _start--;
          });
        }
      },
    );
  }

  ///country code api
  getCountryCode() async {
    return "INR";
    /*final response = await http.get(Uri.parse('http://ip-api.com/json'));
    Map data = jsonDecode(response.body);
    String country = data['country'];
    if (country == "India") {
      return "INR";
    } else {
      return "USD";
    }*/
  }

  ///skip login api
  void callSkipLoginApi() async {
    final _prefs = await SharedPreferences.getInstance();
    var code = await getCountryCode();
    var res = await _httpServices.skipe_login(country: "INR");
    if (res!.status == true) {
      _prefs.setString('is_skip', "Y");
      _prefs.setString('token', res.token!);
      _prefs.setString('name', res.results![0].name!);
      _prefs.setString('id', res.results![0].id!);
      _prefs.setString('email', res.results![0].email!);
      _prefs.setString('number', res.results![0].number!);
      _prefs.setString('gender', res.results![0].gender!);
      _prefs.setString('dob', res.results![0].dob!);
      _prefs.setString('birth_place', res.results![0].birth_place!);
      _prefs.setString('birth_time', res.results![0].birth_time!);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) =>  MainHomeScreenWithBottomNavigation()),
          (Route<dynamic> route) => false);
    }
  }

  ///call setting api
  void getSetting() async {
    var res = await _httpServices.setting();
    if (res!.status == true) {
      setState(() {
        terms = res.results!.terms_and_conditions;
        privacy = res.results!.privacy_policy;
        aboutus = res.results!.about_us;
      });
    } else {}
  }

  @override
  void initState() {
          requestNotificationPermission();
            _getFCMToken();
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? androidNotification = message.notification?.android;
      if (notification != null && androidNotification != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(channel.id, channel.name,
                    channelDescription: channel.description,
                    color: Colors.white,
                    
                    playSound: true,
                    icon: '@mipmap/ic_launcher')));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("new message");
      RemoteNotification? notification = message.notification;
      AndroidNotification? androidNotification = message.notification?.android;
      if (notification != null && androidNotification != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                  title: Text(notification.title!),
                  content: SingleChildScrollView(
                    child: Column(children: [Text(notification.body!)]),
                  ));
            });
      }
    });
   
    getSetting();
    _keyboardVisibilityController = KeyboardVisibilityController();
    _keyboardVisibilityStream = _keyboardVisibilityController.onChange;
    _keyboardVisibilityStream.listen((visible) {
        if (_isOtp) {
          setState(() {
            if (visible) {
              otp_size = 900;
            } else {
              otp_size = 800;
            }
          });
        }
        //print(visible);
      },
    );
    super.initState();
  }


  String? _fcmToken = "";

    Future<void> _getFCMToken() async {
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      // Get the token for the device
      String? token = await messaging.getToken();

      setState(() {
        _fcmToken = token;
      });

      print('FCM Token: $token');
    }
  /// check mobile number api
  void checkMobileNumberApi(StateSetter updateState) async {
    var country = "";
    if (dailcode == "91") {
      country = "INR";
    } else {
      country = "INR";
    }
    var res = await _httpServices.check_number(
      mobileNumber: _mobileController.text,
      country_code: dailcode,
      country: country,
      otp: "",
      type: "",
    );
    if (res!.status == true) {
      updateState(() {
        _isOtp = true;
        startTimer(updateState);

        /*   if (res.type == "register") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => SignUpPage(
                      mobileNUmber: _mobileController.text, code: code, dialCode: dailcode)));
        } else if (res.type == "login") {
          updateState(() {
            _isOtp = true;
            startTimer(updateState);
          });
        }*/
      });
    } else {
      Fluttertoast.showToast(msg: res.message!);
    }
  }

  /// send otp api
  void otpProcess() async {
    //print(_mobileController.text.toString());
    var country = "";
    if (dailcode == "91") {
      country = "INR";
    } else {
      country = "INR";
    }
    var res = await _httpServices.check_number(
        mobileNumber: _mobileController.text,
        country: country,
        otp: "",
        type: "",
        country_code: dailcode);
    if (res!.status == true) {}
  }

  ///validate number
  bool validateMobile(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{8,14}$)';
    RegExp regExp = RegExp(pattern);
    if (value.length == 0) {
      Fluttertoast.showToast(msg: 'Please Enter Mobile Number');
      return false;
    } else if (!regExp.hasMatch(value)) {
      Fluttertoast.showToast(msg: 'Please Enter Correct Mobile Number');
      return false;
    }
    return true;
  }

  ///call login api
  void loginApi(StateSetter updateState) async {
    var country = "";
    if (dailcode == "91") {
      country = "INR";
    } else {
      country = "INR";
    }
    final _prefs = await SharedPreferences.getInstance();
    var res = await _httpServices.check_number(
      mobileNumber: _mobileController.text,
      otp: _otp.text,
      country_code: dailcode,
      country: country,
      type: "",
    );
    if (res!.status == true) {
      updateState(() {
        _prefs.setString('is_skip', "N");
        _prefs.setString('token', res.token!);
        _prefs.setString('name', res.results!.name!);
        _prefs.setString('id', res.results!.id!);
        _prefs.setString('email', res.results!.email!);
        _prefs.setString('number', res.results!.number!);
        _prefs.setString('gender', res.results!.gender!);
        _prefs.setString('dob', res.results!.dob!);
        _prefs.setString('birth_place', res.results!.birthPlace!);
        _prefs.setString('birth_time', res.results!.birthTime!);
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => MainHomeScreenWithBottomNavigation()), (route) => false);
      });
    } else {
      Fluttertoast.showToast(msg: res.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 150,
          ),
          /* Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  callSkipLoginApi();
                },
                child: Container(
                    width: 70,
                    child: Text(
                      "Skip",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'PoppinsRegular'),
                    )),
              ),
            ),
          ),*/
          const SizedBox(
            height: 10,
          ),
          Image.asset(
            'assets/login/app_icon.png',
            width: MediaQuery.of(context).size.width,
            height: 150,
          ),
          SvgPicture.asset(
            'assets/login/login_around.svg',
            width: MediaQuery.of(context).size.width,
            color: primaryColor,
            height: 150,
          ),
          const SizedBox(
            height: 30,
          ),
          CustomUi.getAppPrimaryButton('LOGIN WITH OTP', () {
            showModalBottomSheet(
                elevation: 5,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        topLeft: Radius.circular(15))),
                context: context,
                isScrollControlled: true,
                builder: (builder) => bottomSheet());
          }),
          /*  const SizedBox(height: 30,),
          CustomUi.getAppBorderButton('SIGN UP',(){
          print("jkgkhkghhfg");
          Navigator.push(context, MaterialPageRoute(builder: (_)=>const SignUpPage(mobileNUmber: "",dialCode:"91",code: "IN",)));
          }),
*/
          /* const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: Divider(
                  thickness: 1,
                  color: greyColor,
                )),
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Text(
                    "Login with",
                    style: TextStyle(
                        color: greyColor,
                        fontSize: 10.0,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'PoppinsRegular'),
                  ),
                ),
                Expanded(
                    child: Divider(
                  thickness: 1,
                  color: greyColor,
                )),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              InkWell(
                onTap: () {
                  // _fbLogin(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 2.0,
                      ),
                    ],
                  ),
                  width: 50,
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.asset(
                        "assets/login/facebook.png",
                        fit: BoxFit.cover,
                        width: 25,
                        height: 25,
                      ),
                      */ /*const  Text("Facebook",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 14),)*/ /*
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  //_googleSignIn(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 2.0,
                      ),
                    ],
                  ),
                  height: 50,
                  width: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.asset(
                        "assets/login/google.png",
                        fit: BoxFit.cover,
                        width: 25,
                        height: 25,
                      ),
                      */ /*const    Text("Google",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 14),)*/ /*
                    ],
                  ),
                ),
              ),
            ],
          ),*/
        ],
      ),
    );
  }

  /// bottom sheet for login
  Widget bottomSheet() {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setSetter) {
      return Container(
        height: _isOtp == true ? otp_size : 800,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  height: 55.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: greyColor, width: 1),
                  ),
                  child: Row(
                    children: [
                      CountryCodePicker(
                        onChanged: _onCountryChange,
                        initialSelection: 'IN',
                        textStyle: TextStyle(color: greyColor),
                        favorite: const ['+91', 'HI'],
                        showCountryOnly: false,
                        showOnlyCountryWhenClosed: false,
                        alignLeft: false,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _mobileController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: TextStyle(color: blackColor),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Mobile Number',
                            hintStyle: TextStyle(
                                color: Color(0xFFAFAFAF),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                fontFamily: "PoppinsRegular"),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                CustomUi.getAppPrimaryButton('SEND OTP', () {
                  setSetter(() {
                    if (_isOtp) {
                      setState(() {
                        checkMobileNumber(context, setSetter);
                      });
                    } else {
                      setState(() {
                        checkMobileNumber(context, setSetter);
                      });
                    }
                  });
                }),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3)),
                      value: true,
                      onChanged: (val) {},
                      checkColor: whiteColor,
                      activeColor: Colors.blue,
                    ),
                    CustomText(
                      text: 'I agree',
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: termsColor,
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => WebViewerTerms(
                                      appbarText: "Term of Use",
                                      webUrl: terms)));
                        },
                        child: CustomText(
                          text: ' Term of Use',
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: primaryColor,
                        )),
                    CustomText(
                      text: ' and',
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: termsColor,
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => WebViewerTerms(
                                      appbarText: "Privacy Policy",
                                      webUrl: privacy)));
                        },
                        child: CustomText(
                          text: ' Privacy Policy',
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: primaryColor,
                        ))
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            _isOtp == true
                ? Column(
                    children: [
                      Center(
                        child: Container(
                            child: CustomText(
                          text: 'OTP sent to ${_mobileController.text}',
                          color: otpSendColor,
                        )),
                      ),
                      Center(
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.only(right: 70, left: 70),
                          child: PinCodeTextField(
                            controller: _otp,
                            length: 4,
                            onCompleted: (value) => {},
                            onChanged: (val) {
                              // if(userOtp.length==4){
                              //   callVeryfiAPI();
                              // }
                            },
                            cursorColor: blackColor,
                            //focusNode: _pinPutFocusNode,
                            textStyle:
                                TextStyle(color: whiteColor, fontSize: 20),
                            backgroundColor: whiteColor,
                            enableActiveFill: true,
                            enablePinAutofill: true,
                            // boxShadows: [
                            //   BoxShadow(
                            //     offset: Offset(0, 0),
                            //     color: greyColor,
                            //     //  blurRadius:5,
                            //   )
                            // ],
                            keyboardType: TextInputType.number,
                            autoFocus: false,
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(7),
                              fieldHeight: 60,
                              fieldWidth: 50,
                              selectedFillColor: whiteColor,
                              disabledColor: whiteColor,
                              inactiveFillColor: greyColor,
                              selectedColor: greyColor,
                              activeFillColor: primaryColor,
                              activeColor: whiteColor,
                              inactiveColor: Colors.transparent,
                            ),
                            appContext: context,
                          ),
                          //   height: 100,
                          // margin: EdgeInsets.only(left: 32),
                          padding: const EdgeInsets.only(left: 10, top: 10),
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            (_start == 0)
                                ? InkWell(
                                    onTap: () {
                                      setSetter(() {
                                        _start = 59;
                                      });
                                      startTimer(setSetter);
                                      otpProcess();
                                    },
                                    child: CustomText(
                                      text: 'Resend OTP',
                                      fontSize: 16,
                                      color: blueColor,
                                      fontWeight: FontWeight.w500,
                                    ))
                                : SizedBox(),
                            const SizedBox(
                              width: 5,
                            ),
                            (_start > 0)
                                ? CustomText(
                                    text: 'available in ${_start} sec',
                                    fontSize: 14,
                                    color: greyColor,
                                    fontWeight: FontWeight.w400,
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomUi.getAppPrimaryButton('VERIFY', () {
                        if (_otp.text.length == 0) {
                          Fluttertoast.showToast(msg: 'Please enter otp');
                        } else {
                          loginApi(setSetter);
                        }
                      }),
                    ],
                  )
                : Container()
          ],
        ),
      );
    });
  }
}
