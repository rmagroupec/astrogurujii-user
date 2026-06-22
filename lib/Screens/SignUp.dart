import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Utilities/CustomText.dart';
import '../Utilities/CustomUi.dart';
import 'OtpScreen/OtpScreen.dart';
import 'WebServices/HttpServices.dart';

class SignUp extends StatefulWidget {
  final mobileNUmber;
  final code;
  final dialCode;
  const SignUp({Key? key, this.mobileNUmber, this.code, this.dialCode}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();

}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController enterName = TextEditingController();
  final TextEditingController genderText = TextEditingController();
  final TextEditingController _mobileText = TextEditingController();
  final TextEditingController _emailText = TextEditingController();
  final TextEditingController dateText = TextEditingController();
  final TextEditingController timeText = TextEditingController();
  final TextEditingController _placeText = TextEditingController();
  final TextEditingController _referralText = TextEditingController();
  bool genderBoolean = false, mobileBoolean = false, mobileBoolean1 = false;
  final HttpServices _httpServices = HttpServices();
  String dailcode = "91";
  String code = "HI";

  String? validateName(String value) {
    if (value.length == 0) {
      return 'Please enter your Name';
    }
    return null;
  }

  @override
  void initState() {
    _mobileText.text = widget.mobileNUmber;
    genderText.text = "";
    setState(() {
      dailcode = widget.dialCode;
    });
    super.initState();
  }

  void otpRegisterProcess() async {
    var country = "";
    if (dailcode == "91") {
      country = "INR";
    } else {
      country = "USD";
    }
    var res = await _httpServices.otp_register_process(
        mobileNumber: _mobileText.text.toString(),
        otp: "",
        country: country,
        country_code: dailcode);
    if (res!.status == true) {
      setState(() {
        //print('================'+_genderText.text);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => OtpScreen(
                      dailcode: dailcode,
                      country: country,
                      mobileNumber: _mobileText.text,
                      name: enterName.text,
                      gender: genderText.text.toString(),
                      dateOfBirth: dateText.text.toString(),
                      timeofBirth: timeText.text,
                      placeOfBirth: _placeText.text,
                      email: _emailText.text,
                      referral: _referralText.text,
                    )));
      });
    } else {
      Fluttertoast.showToast(msg: res.message.toString());
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: 430,
          decoration: BoxDecoration(
            /* borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),*/
            color: Colors.black.withOpacity(0.6),
          ),
          child: Container(
            height: 400,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Skip',
                            style: TextStyle(
                              color: Color(0xFF878383),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: enterName,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty || value == 0) {
                          return 'Please enter name..';
                        }
                      },
                    ),
                    TextFormField(
                      controller: dateText,
                      decoration: InputDecoration(
                        labelText: 'Date of birth',
                        suffixIcon: Icon(Icons.calendar_month_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      keyboardType: TextInputType.datetime,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty || value == 0) {
                          return 'Please enter date..';
                        }
                      },
                    ),
                    TextFormField(
                      controller: timeText,
                      decoration: InputDecoration(
                        labelText: 'Time of birth',
                        suffixIcon: Icon(Icons.watch_later_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      keyboardType: TextInputType.datetime,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty || value == 0) {
                          return 'Please enter time..';
                        }
                      },
                    ),
                    TextFormField(
                      controller: _placeText,
                      decoration: InputDecoration(
                        labelText: 'Place of birth',
                        prefixIcon: Icon(Icons.location_on_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value!.isEmpty || value == 0) {
                          return 'Please enter place..';
                        }
                      },
                    ),
                    Row(
                      children: [
                        Text(
                          'Gender',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Visibility(
                          visible: genderBoolean,
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width / 3,
                                    height: 40,
                                    child: CustomUi.getmaleFemaleButton('Male', () {
                                      setState(() {
                                        genderText.text = "Male";
                                        mobileBoolean = true;
                                        mobileBoolean1 = true;
                                      });
                                    }, "male"),
                                  ),
                                  Container(
                                    height: 40,
                                    width: MediaQuery.of(context).size.width / 3,
                                    child: CustomUi.getmaleFemaleButton('Female', () {
                                      setState(() {
                                        genderText.text = "Female";
                                        mobileBoolean = true;
                                        mobileBoolean1 = true;
                                      });
                                    }, "female"),
                                  ),
                                ],
                              )),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Visibility(
                          visible: genderBoolean,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width / 2,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
                              child: CustomText(
                                text: genderText.text.toString(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          otpRegisterProcess();
                        }
                      },
                      child: Text(
                        'Submit',
                        style:
                            TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: blackColor),
                      ),
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(300, 50),
                          shadowColor: yellow,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
