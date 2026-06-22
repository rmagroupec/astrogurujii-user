
import 'package:astro_gurujii/Screens/OtpScreen/OtpScreen.dart';
import 'package:astro_gurujii/Screens/PlaceSearchScreen.dart';
import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Screens/WebViewerTerms.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:astro_gurujii/Utilities/CustomUi.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class SignUpPage extends StatefulWidget {
  final mobileNUmber;
  final code;
  final dialCode;
  const SignUpPage({Key? key,this.mobileNUmber,this.code,this.dialCode}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _enterName = TextEditingController();
  final TextEditingController _genderText = TextEditingController();
  final TextEditingController _mobileText = TextEditingController();
  final TextEditingController _emailText = TextEditingController();
  final TextEditingController _dateText = TextEditingController();
  final TextEditingController _timeText = TextEditingController();
  final TextEditingController _placeText = TextEditingController();
  final TextEditingController _referralText = TextEditingController();
  var termsss="";
  var privacy="";
  var aboutus="";
  String dailcode ="91";
  String code ="HI";
  void _onCountryChange(CountryCode countryCode) {
    setState(() {

      dailcode=countryCode.toString().replaceAll("+", "");
      code=countryCode.code.toString();
    });
    //print("New Country selected: " + code);
  }

  final HttpServices _httpServices=HttpServices();
  bool genderBoolean = false,
      mobileBoolean = false,
      emailBoolean = false,
      dateBoolean = false,
      timeBoolean = false,
      placeBoolean = false,
      verifyBoolean = false,
      referralBoolean=false,
      terms=false
  ;

  bool
  nameBoolean1=true,
      genderBoolean1 = false,
      mobileBoolean1 = false,
      emailBoolean1 = false,
      dateBoolean1 = false,
      timeBoolean1 = false,
      placeBoolean1 = false,
      verifyBoolean1 = false;

  String validateEmail1(String value) {
    String pattern = r'(^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return 'Please enter email';
    } else if (!regExp.hasMatch(value)) {
      return 'Email Address is not valid';
    }
    return '';
  }

  String validateEmail(String? value) {
    String pattern = r'(^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$)';
    RegExp regExp = new RegExp(pattern);
    if (value!.length == 0) {
      return 'Please enter email';
    } else if (!regExp.hasMatch(value)) {
      return 'Email Address is not valid';
    }
    return '';
  }

  String validateName(String? value) {
    if (value!.length == 0) {
      return 'Please enter your Name';
    }
    return '';
  }

  String validateRef() {
    if (false) {
      return '';
    }
    return '';
  }

  String validatePlace(String? value) {
    if (value!.length == 0) {
      return 'Please enter your place of birth';
    }
    return '';
  }

  String validateMobile(String? value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{8,14}$)';
    RegExp regExp = new RegExp(pattern);
    if (value!.length == 0) {
      return '';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return '';
  }

  void _submitForm()
  {
    if(_formKey.currentState!.validate())
    {
      _formKey.currentState!.save();
      otpRegisterProcess();
    }
    else
    {

    }
  }

  void dispose() {
    // TODO: implement dispose
    _enterName.dispose();
    _genderText.dispose();
    _emailText.dispose();
    _mobileText.dispose();
    _dateText.dispose();
    _timeText.dispose();
    _placeText.dispose();
    super.dispose();
  }


  void getSetting()async{
    var res=await _httpServices.setting();
    if(res!.status==true){
      setState(() {
        termsss=res.results!.terms_and_conditions;
        privacy=res.results!.privacy_policy;
        aboutus=res.results!.about_us;

      });
    }
    else
    {
      Fluttertoast.showToast(msg: res.message!);

    }
  }

  @override
  void initState() {
    getSetting();
    _mobileText.text=widget.mobileNUmber;
    _genderText.text="";
    setState(() {
      dailcode=widget.dialCode;
    });
    super.initState();
  }


  void otpRegisterProcess()async{
    var country="";
    if(dailcode=="91"){
      country="INR";
    }else{
      country="USD";
    }
    var  res=await _httpServices.otp_register_process(
        mobileNumber: _mobileText.text.toString(),otp: "",country: country,country_code: dailcode);
    if(res!.status==true){
      setState(() {
        //print('================'+_genderText.text);
        Navigator.push(context, MaterialPageRoute(builder: (_)=>OtpScreen(
          dailcode: dailcode,
          country: country,
          mobileNumber: _mobileText.text,
          name: _enterName.text,
          gender: _genderText.text.toString(),
          dateOfBirth: _dateText.text.toString(),
          timeofBirth: _timeText.text,
          placeOfBirth: _placeText.text,
          email: _emailText.text,
          referral:_referralText.text,
        )));
      });
    }
    else
    {
      Fluttertoast.showToast(msg: res.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/background_image.png'))
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                          )),
                      CustomText(
                        text: 'Sign Up',
                        color: blackColor,
                        fontSize: 18,
                      ),
                    ],
                  ),
                  Visibility(
                    visible: true,
                    child: Row(
                      children: [
                        CustomUi.getSignUpContainer(
                            "Enter your name", context),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Visibility(
                    visible: true,
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: SizedBox()),
                        Expanded(
                            flex: 1,
                            child: CustomUi.getEditBox(false,
                                "fg", _enterName, TextInputType.text, context,(){},validateName)),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  nameBoolean1==true?Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width / 3,
                          height: 35,
                          child: CustomUi.getAppPrimaryButton('Submit', () {

                            setState(() {
                              if(_enterName.text.length==0){
                                Fluttertoast.showToast(msg: 'Please enter name..');
                              }
                              else
                              {
                                genderBoolean=true;
                                nameBoolean1=false;
                              }

                            });
                          })),
                    ),
                  ):Container(),
                  const SizedBox(
                    height: 15,
                  ),
                  Visibility(
                    visible: genderBoolean,
                    child: Row(
                      children: [
                        CustomUi.getSignUpContainer(
                            "Select your gender", context),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
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
                                  _genderText.text = "Male";
                                  mobileBoolean=true;
                                  mobileBoolean1=true;
                                });
                              }, "male"),
                            ),
                            Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width / 3,
                              child: CustomUi.getmaleFemaleButton('Female', () {
                                setState(() {
                                  _genderText.text = "Female";
                                  mobileBoolean=true;
                                  mobileBoolean1=true;
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
                        width: MediaQuery.of(context).size.width/2,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: CustomText(text: _genderText.text.toString(),),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Visibility(
                    visible: mobileBoolean,
                    child: Align(
                        alignment: Alignment.topLeft,
                        child:CustomUi.getSignUpContainer(
                            "Enter your mobile number", context)
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Visibility(
                    visible: mobileBoolean,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Row(
                        children: [
                          Container(
                            height: 45,
                            decoration: BoxDecoration(
                                color: signupcolor,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: CountryCodePicker(
                              onChanged: _onCountryChange,
                              initialSelection: '${widget.code}',textStyle: TextStyle(color: greyColor),
                              favorite: const ['+91','HI'],
                              showCountryOnly: false,
                              showOnlyCountryWhenClosed: false,
                              alignLeft: false,
                            ),
                          ),

                          SizedBox(width: 10,),

                          CustomUi.getEditBoxMobile(
                              "fg", _mobileText, TextInputType.number, context,(){
                            setState(() {
                              emailBoolean=true;
                            });
                          },validateMobile
                          ),

                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),

                  mobileBoolean1==true ?Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: SizedBox(
                          height: 35,
                          width: MediaQuery.of(context).size.width / 3,
                          child: CustomUi.getAppPrimaryButton('Submit', () {
                            setState(() {
                              if(_mobileText.text.length==0){
                                Fluttertoast.showToast(msg: 'Please enter mobile number');
                              }
                              else{
                                emailBoolean=true;
                                mobileBoolean1=false;
                                emailBoolean1=true;
                              }

                            });
                          })),
                    ),
                  ):Container(),
                  const SizedBox(
                    height: 15,
                  ),
                  Visibility(
                    visible: emailBoolean,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: CustomUi.getSignUpContainer(
                          "Enter your Email Address", context),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Visibility(
                    visible: emailBoolean,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: CustomUi.getEditBox(false,"fg", _emailText,
                          TextInputType.emailAddress, context,(){
                            setState(() {
                              dateBoolean=true;
                            });
                          },validateEmail),
                    ),
                  ),
                  emailBoolean1==true?Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: SizedBox(
                          height: 35,
                          width: MediaQuery.of(context).size.width / 3,
                          child: CustomUi.getAppPrimaryButton('Submit', () {
                            setState(() {
                              // _formKey.currentState!.validate()
                              var s=validateEmail1(_emailText.text.toString());
                              if(s.isNotEmpty){
                                Fluttertoast.showToast(msg: s);
                              }
                              else{
                                dateBoolean=true;
                                emailBoolean1=false;
                                dateBoolean1=true;

                              }
                            });
                          })),
                    ),
                  ):Container(),
                  const SizedBox(
                    height: 15,
                  ),
                  Visibility(
                    visible: dateBoolean,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: CustomUi.getSignUpContainer(
                          "Date of birth", context),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Visibility(
                    visible: dateBoolean,
                    child: InkWell(
                      onTap: (){
                        _selectDate(context);
                      },
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width/2,
                          height: 40,
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(15)
                          ),
                          child: CustomText(text: _dateText.text.toString(),),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  dateBoolean1==true?Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: SizedBox(
                          height: 35,
                          width: MediaQuery.of(context).size.width / 3,
                          child: CustomUi.getAppPrimaryButton('Submit', () {
                            setState(() {
                              if(_dateText.text.length==0){
                                Fluttertoast.showToast(msg: 'Please select date of birth');
                              }
                              else{
                                timeBoolean=true;
                                dateBoolean1=false;
                                timeBoolean1=true;
                              }

                            });
                          })),
                    ),
                  ):Container(),

                  const SizedBox(
                    height: 15,
                  ),
                  Visibility(
                    visible: timeBoolean,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: CustomUi.getSignUpContainer(
                          "Time of birth", context),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Visibility(
                    visible: timeBoolean,
                    child: InkWell(
                      onTap: (){
                        _selectTime(context);
                      },
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width/2,
                          height: 40,
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: CustomText(text: _timeText.text.toString(),),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  timeBoolean1==true?Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: SizedBox(
                          height: 35,
                          width: MediaQuery.of(context).size.width / 3,
                          child: CustomUi.getAppPrimaryButton('Submit', () {
                            setState(() {
                              if(_timeText.text.length==0){
                                Fluttertoast.showToast(msg: 'Please select time of birth');
                              }
                              else{
                                placeBoolean=true;
                                timeBoolean1=false;
                                placeBoolean1=true;
                              }

                            });
                          })),
                    ),
                  ):Container(),

                  const SizedBox(
                    height: 15,
                  ),


                  Visibility(
                    visible: placeBoolean,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: CustomUi.getSignUpContainer(
                          "Place of birth", context),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Visibility(
                    visible: placeBoolean,
                    child: InkWell(
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PlaceSearchScreen((value){
                                  setState(() {
                                    setMPlace(value);
                                  });
                                  return value;
                                })
                            ));
                      },
                      child:Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width/2,
                          height: 40,
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: CustomText(text: _placeText.text.toString(),),
                        ),
                      ),

                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  placeBoolean1==true?Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: SizedBox(
                          height: 35,
                          width: MediaQuery.of(context).size.width / 3,
                          child: CustomUi.getAppPrimaryButton('Submit', () {
                            setState(() {
                              if(_placeText.text.length==0){
                                Fluttertoast.showToast(msg: 'Please enter place of birth');
                              }
                              else
                              {
                                verifyBoolean=true;
                                timeBoolean1=false;
                                verifyBoolean1=true;
                                placeBoolean1=false;
                                referralBoolean=true;
                                terms=true;
                              }

                            });
                          })),
                    ),
                  ):Container(),
                  Visibility(
                    visible: referralBoolean,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: CustomUi.getSignUpContainer(
                          "Referral code(Optional) ", context),
                    ),
                  ),


                  const SizedBox(
                    height: 10,
                  ),
                  Visibility(
                    visible: referralBoolean,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: CustomUi.getEditBoxRef(
                          "fg", _referralText, TextInputType.text, context,(){
                        verifyBoolean=true;
                      }),
                    ),
                  ),

                  SizedBox(height: 10,),
                  Visibility(
                    visible: terms,
                    child: Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment : MainAxisAlignment.start,
                        crossAxisAlignment : CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3)
                            ),
                            value: true, onChanged: (val){},checkColor: whiteColor,activeColor: Colors.blue,),
                          CustomText(text: 'I agree',fontSize: 13,fontWeight: FontWeight.w400,color: termsColor,),
                          InkWell(
                              onTap: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => WebViewerTerms(appbarText: "Term of Use",webUrl: termsss)));
                              },
                              child: CustomText(text: ' Term of Use',fontSize: 13,fontWeight: FontWeight.w400,color: primaryColor,)),
                          CustomText(text: ' and',fontSize: 13,fontWeight: FontWeight.w400,color: termsColor,),
                          InkWell(
                              onTap: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => WebViewerTerms(appbarText: "Privacy Policy",webUrl: privacy)));
                              },
                              child: CustomText(text: ' Privacy Policy',fontSize: 13,fontWeight: FontWeight.w400,color: primaryColor,))
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  const SizedBox(height: 40,),

                  Visibility(
                      visible: verifyBoolean1,
                      child: CustomUi.getAppPrimaryButton('VERIFY', (){
                        _submitForm();
                      })),
                  const SizedBox(height: 10,),
                ],
              ),
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
        _dateText.text= DateFormat('yyyy-MM-dd').format(selectedDate);
        // _dateText.text=outputFormat.format(outputFormat);
      });
    }
  }
  TimeOfDay selectedTime = TimeOfDay.now();

  _selectTime(BuildContext context) async {
    DateTime tempDate = DateFormat("hh:mm").parse(
        selectedTime.hour.toString() +
            ":" + selectedTime.minute.toString());
    //String datetime2 = DateFormat.Hms().format(_startDate);
    var dateFormat = DateFormat("hh:mm a");
    _timeText.text=dateFormat.format(tempDate);
      final TimeOfDay? timeOfDay = await showTimePicker(
    context: context,
    initialTime: selectedTime,
    initialEntryMode: TimePickerEntryMode.dial,
  );
    if(timeOfDay != null && timeOfDay != selectedTime)
    {
      setState(() {

        selectedTime = timeOfDay;
        DateTime tempDate = DateFormat("hh:mm").parse(
            selectedTime.hour.toString() +
                ":" + selectedTime.minute.toString());
        //String datetime2 = DateFormat.Hms().format(_startDate);
        var dateFormat = DateFormat("hh:mm a");
        _timeText.text=dateFormat.format(tempDate);
      });
    }
  }
  void setMPlace(String value) {

    setState(() {
      _placeText.text=(value.length>40)?value.substring(0,40)+"..":value;
    });
  }

}
