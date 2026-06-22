import 'dart:developer';

import 'package:astro_gurujii/Screens/ragisterAstro/thank_you_screen.dart';
import 'package:astro_gurujii/Setup/app_colors.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Setup/SetUp.dart';
import '../WebServices/HttpServices.dart';

class RagisterAstro extends StatefulWidget {



  @override
  State<RagisterAstro> createState() => _RagisterAstroState();
}

class _RagisterAstroState extends State<RagisterAstro> {
  final _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  String _emailError ="";
  String astroStatus ="";
  String astroMsg ="";
  bool isFormShow =true;

  var _formKey = GlobalKey<FormState>();

  launchURL(String toMailId, String subject, String body) async {
    var url = 'mailto:$toMailId?subject=$subject&body=$body';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  late HttpServices _httpService;
  @override
  void initState() {
    _httpService = HttpServices();
    getAstroStatus();

    super.initState();
  }


  //HttpServices _httpService = HttpServices();
  bool _isLoading=false;
  Future requestAstro(String name,String number,String email,String qulification,String experience) async {
    try{
      _isLoading=true;
      var res = await _httpService.registerAstro(name: name, number: number, email: email, qulification: qulification, experience: experience);
      log("model==>>$res");
      if(res!.status==true){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => ThankYouScreen()));
      }else{
        Fluttertoast.showToast(msg: res.message.toString());
      }
      setState(() {

      });
    }finally{
      setState(() {
        _isLoading=false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: whiteColor, //change your color here
        ),
        title: Text("Enquiry Astrologer", style: TextStyle(color: whiteColor)),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 20,right: 20),
          child:isFormShow?
          Column(
            children: [
              SizedBox(
                height: Get.height*0.4,
              ),
              Center(child: CustomText(text: astroMsg))
            ],
          ):
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  "Name",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.black54),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(

                  border: Border.all(
    color: Color(0xFFFDF7F7)
    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 1.0,
                      ),
                    ],
                    color: Color(0xFFFDF7F7),
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    validator: MultiValidator([
                      RequiredValidator(errorText: "Required"),
                      MaxLengthValidator(27,
                          errorText: "Invalid Name"),
                      MinLengthValidator(3,
                          errorText: "Invalid Name"),
                    ]),
                    controller: _nameController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter Full Name Here",
                        hintStyle: TextStyle(fontSize: 13)),
                  ),
                ),
              ),


              Container(
                margin: EdgeInsets.only(top: 20),
                child: Row(
                  children: [
                    Text(
                      "Email",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.black54),
                    ),

                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Color(0xFFFDF7F7)
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 1.0,
                      ),
                    ],
                    color: Color(0xFFFDF7F7),
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    validator: MultiValidator([
                      RequiredValidator(errorText: "Required"),
                      EmailValidator(errorText: "Invalid Email"),
                    ]),
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter Your Email ID",
                        hintStyle: TextStyle(fontSize: 13)),
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.only(top: 20),
                child: Row(
                  children: [
                    Text(
                      "Phone Number",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.black54),
                    ),

                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Color(0xFFFDF7F7)
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 1.0,
                      ),
                    ],
                    color: Color(0xFFFDF7F7),
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    validator: MultiValidator([
                      RequiredValidator(errorText: "Required"),
                      MaxLengthValidator(10,
                          errorText: "Invalid Phone Number"),

                    ]),
                    maxLength: 10,
                    controller: _mobileController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      counterText: "",
                        border: InputBorder.none,
                        hintText: "Enter Your Phone Number",
                        hintStyle: TextStyle(fontSize: 13)),
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.only(top: 20),
                child: Row(
                  children: [
                    Text(
                      "Qualification",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.black54),
                    ),

                  ],
                ),
              ),
          Container(
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
                border: Border.all(
                    color: Color(0xFFFDF7F7)
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 1.0,
                  ),
                ],
                color: Color(0xFFFDF7F7),
                borderRadius: BorderRadius.circular(10)),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                controller: _educationController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    counterText: "",
                    border: InputBorder.none,
                    hintText: "Enter Your Qualification",
                    hintStyle: TextStyle(fontSize: 13)),
              ),
            ),
          ),

              Container(
                margin: EdgeInsets.only(top: 20),
                child: Row(
                  children: [
                    Text(
                      "Experience",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.black54),
                    ),

                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Color(0xFFFDF7F7)
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 1.0,
                      ),
                    ],
                    color: Color(0xFFFDF7F7),
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    controller: _experienceController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        counterText: "",
                        border: InputBorder.none,
                        hintText: "Enter Your Experience",
                        hintStyle: TextStyle(fontSize: 13)),
                  ),
                ),
              ),
          SizedBox(
            height: 50,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 55),
            
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),

            )

            ),
            onPressed: () {
              if(isValid()){
                requestAstro(_nameController.text.trim().toString(), _mobileController.text.trim().toString(), _emailController.text.trim().toString(), _educationController.text.trim().toString(), _experienceController.text.trim().toString());
              }
            },
            child: _isLoading?CircularProgressIndicator(color: Colors.white,):Text('Submit',style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w700),),
          ),


            ],
          ),

        ),
      ),
    );
  }
 bool isValid(){
    String name =_nameController.text.trim().toString();
    String mobile =_mobileController.text.trim().toString();
    String email =_emailController.text.trim().toString();
    String qualification =_educationController.text.trim().toString();
    String experience =_experienceController.text.trim().toString();

    if(name.isEmpty){
      Fluttertoast.showToast(msg: "Enter your Name");
      return false;
    }

    if(email.isEmpty){
      Fluttertoast.showToast(msg: "Enter your email");
      return false;
    }

    if(!_validateEmail(email)){
      Fluttertoast.showToast(msg: "Enter your  valid email");
      return false;
    }

    if(mobile.isEmpty){
      Fluttertoast.showToast(msg: "Enter your mobile number");
      return false;
    }

    if(!_validateMobile(mobile)){
      Fluttertoast.showToast(msg: "Enter your  valid mobile number");
      return false;
    }

    if(qualification.isEmpty){
      Fluttertoast.showToast(msg: "Enter your Qualification");
      return false;
    }

    if(experience.isEmpty){
      Fluttertoast.showToast(msg: "Enter your Experience");
      return false;
    }

   return true;
  }

  bool _validateMobile(String value) {
    String pattern = r'^[0-9]{10}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(value);
  }

  bool _validateEmail(String value) {
    String pattern =
        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'; // Regular expression for email validation
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(value);
  }

  Future<void> getAstroStatus() async {
    try{
    //  _isLoading=true;
      var res = await _httpService.getAstroStatus();
      if(res!.status==true){
        setState(() {
      //    _isLoading=false;
          isFormShow =true;
          astroStatus =res.data!.status.toString();
          log(astroStatus);
          switch(astroStatus){
            case "Request Sent":
              astroMsg ="You have already request for astrologer";
              break;
            case "Selected":
              astroMsg ="Your request for astrologer is selected";
              break;
            case "Rejected":
              astroMsg ="Your request for astrologer is rejected";
              break;
            case "Hold":
              astroMsg ="Your request for astrologer is on Hold";
              break;
          }

        });
      }else{
        isFormShow =false;
      }

      setState(() {

      });
    }finally{
      setState(() {
       // _isLoading=false;
      });
    }

  }




}

