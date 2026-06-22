import 'dart:async';

import 'package:astro_gurujii/Screens/homeScreen/Home.dart';
import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:astro_gurujii/Utilities/CustomUi.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widget/bottom_navigation_bar_custom.dart';

class OtpScreen extends StatefulWidget {
  final mobileNumber;
  final name;
  final gender;
  final dateOfBirth;
  final timeofBirth;
  final placeOfBirth;
  final email;
  final referral;
  final dailcode;
  final country;

  const OtpScreen(
      {Key? key,
      this.country,
      this.dailcode,
      this.referral,
      this.mobileNumber,
      this.name,
      this.gender,
      this.dateOfBirth,
      this.timeofBirth,
      this.placeOfBirth,
      this.email})
      : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  var userOtp = "";
  final HttpServices _httpServices = HttpServices();
  final TextEditingController _otp = TextEditingController();

  void otp_verify() async {
    var country = "";
    if (widget.dailcode == "91") {
      country = "INR";
    }
    var res = await _httpServices.otp_register_process(
        mobileNumber: widget.mobileNumber,
        otp: _otp.text,
        country: country,
        country_code: widget.dailcode);
    if (res!.status == true) {
      setState(() {
        registerApi();
      });
    }
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  void otpProcess() async {
    var country = "";
    if (widget.dailcode == "91") {
      country = "INR";
    }
    var res = await _httpServices.otp_register_process(
        mobileNumber: widget.mobileNumber,
        otp: "",
        country: country,
        country_code: widget.dailcode);
    if (res!.status == true) {
      setState(() {});
    } else {
      Fluttertoast.showToast(msg: res.message!);
    }
  }

  getCountryCode() async {
    return "INR";
    /*final response = await http.get(Uri.parse('http://ip-api.com/json'));
    Map data = jsonDecode(response.body);
    String country = data['country'];
    if(country=="India"){
      return "INR";
    }else{
      return "USD";
    }*/
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void registerApi() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    var code = await getCountryCode();
    var res = await _httpServices.user_register(
        country: code,
        country_code: widget.dailcode,
        name: widget.name,
        number: widget.mobileNumber,
        gender: widget.gender,
        email: widget.email,
        date: widget.dateOfBirth,
        time: widget.timeofBirth,
        placeOfBirth: widget.placeOfBirth,
        referral: widget.referral);
    if (res!.status == true) {
      setState(() {
        _prefs.setString('is_skip', "N");
        _prefs.setString('token', res.token!);
        _prefs.setString('name', res.results!.name ?? '');
        _prefs.setString('id', res.results!.id ?? '');
        _prefs.setString('email', res.results!.email ?? '');
        _prefs.setString('number', res.results!.number ?? '');
        _prefs.setString('gender', res.results!.gender ?? '');
        _prefs.setString('dob', res.results!.dob ?? '');
        _prefs.setString('birth_place', res.results!.birth_place ?? '');
        _prefs.setString('birth_time', res.results!.birth_time ?? '');
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => MainHomeScreenWithBottomNavigation()), (route) => false);
      });
    } else {
      Fluttertoast.showToast(msg: res.message!);
    }
  }

  late Timer _timer;
  int _start = 59;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: "OTP",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 200,
            ),
            CustomText(
              text: 'OTP sent to ${widget.mobileNumber}',
              color: otpSendColor,
            ),
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width / 1.6,
              //margin:const EdgeInsets.only(right: 30),
              child: PinCodeTextField(
                controller: _otp,
                length: 4,
                onCompleted: (value) => {},
                onChanged: (val) {},
                cursorColor: blackColor,
                //focusNode: _pinPutFocusNode,
                textStyle: TextStyle(color: whiteColor, fontSize: 20),
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
              padding: const EdgeInsets.only(left: 10, top: 30),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                (_start == 0)
                    ? InkWell(
                        onTap: () {
                          setState(() {
                            _start = 59;
                          });
                          startTimer();
                          otpProcess();
                        },
                        child: CustomText(
                          text: 'Resend OTP',
                          fontSize: 16,
                          color: blueColor,
                          fontWeight: FontWeight.w500,
                        ),
                      )
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
            const SizedBox(
              height: 50,
            ),
            CustomUi.getAppPrimaryButton('VERIFY', () {
              if (_otp.text.length == 0) {
                Fluttertoast.showToast(msg: 'Please enter Otp');
              } else {
                otp_verify();
              }
              //  Navigator.push(context, MaterialPageRoute(builder: (_)=>const Home()));
            }),
          ],
        ),
      ),
    );
  }
}
