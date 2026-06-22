
import 'dart:convert';

import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:astro_gurujii/Setup/app_colors.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:url_launcher/url_launcher.dart';

import 'WebServices/HttpServices.dart';

class HelpUs extends StatefulWidget {
  @override
  _HelpUsState createState() => _HelpUsState();
}

class _HelpUsState extends State<HelpUs> {
  final _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  String? _emailError;

  var _formKey = GlobalKey<FormState>();

  launchURL(String toMailId, String subject, String body) async {
    var url = 'mailto:$toMailId?subject=$subject&body=$body';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  final _api = HttpServices();

  Future<void> validate({required String subject, required String message}) async {

      // await launchURL('info@astrogurujii.com', '$subject', '$message');


      var response=await _api.quickContact(
        name: _nameController.text.trim().toString(),
        email: _emailController.text.trim().toString(),
        message: _messageController.text.trim().toString(),
        subject: _subjectController.text.trim().toString()
      );
      // Map jsonResponse = json.decode(response);
      // if(jsonResponse["status"]==true){

        Fluttertoast.showToast(msg: "Submitted Successfully");
        // Fluttertoast.showToast(msg: "Submit");
      controllerClear();
      // else{
      //    Fluttertoast.showToast(msg: jsonResponse["message"].toString());
      // }
        

  }


  controllerClear(){
    _nameController.clear();
    _emailController.clear();
    _messageController.clear();
    _subjectController.clear();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: whiteColor, //change your color here
        ),
        title: Text("Customer care Support", style: TextStyle(color: whiteColor)),
        backgroundColor: primaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          /*child: Column(
            children: [
              *//* InkWell(
                onTap: () {
                  launch("tel:07353921010");
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: whiteColor,
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.call,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Call us Our Team is ready to help you",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    trailing: ClipOval(
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.all(3),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black,
                            size: 15,
                          )),
                    ),
                  ),
                ),
              ),
              Container(margin: EdgeInsets.symmetric(horizontal: 20),child: Divider(color: Colors.white,thickness: 1,)),
              InkWell(
                onTap: () {
                  launch("tel:+91 9315832979");
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: whiteColor,
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.call,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Call us Our Team is ready to help you",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    trailing: ClipOval(
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.all(3),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black,
                            size: 15,
                          )),
                    ),
                  ),
                ),
              ),
              Container(margin: EdgeInsets.symmetric(horizontal: 20),child: Divider(color: Colors.white,thickness: 1,)),*//*
              InkWell(
                onTap: () {
                  launch("tel:+91 81728 88061");
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(),
                  child: ListTile(
                    leading: Icon(
                      Icons.call,
                      color: Colors.black,
                    ),
                    title: Text(
                      "Call us Our Team is ready to help you",
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    trailing: ClipOval(
                      child: Container(
                          decoration: BoxDecoration(
                            color: primaryColor,
                          ),
                          padding: EdgeInsets.all(3),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 15,
                          )),
                    ),
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(
                    color: Colors.grey,
                    thickness: 1,
                  )),
              InkWell(
                onTap: () {
                  launch("mailto:info@astrogurujii.com");
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: whiteColor,
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.email_outlined,
                      color: Colors.black,
                    ),
                    title: Text(
                      "Email us, Our team is ready to help you",
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    trailing: ClipOval(
                      child: Container(
                          decoration: BoxDecoration(
                            color: primaryColor,
                          ),
                          padding: EdgeInsets.all(3),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 15,
                          )),
                    ),
                  ),
                ),
              ),
              *//* Container(margin: EdgeInsets.symmetric(horizontal: 20),child: Divider(color: Colors.white,thickness: 1,)),
              InkWell(
                onTap: () {
                  launch("https://wa.me/+919999999999");
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 5),
                  padding: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: whiteColor,
                  ),
                  child: ListTile(
                    leading: Image.asset("Assets/Icons/h_whatsapp.png",height: 30,),
                    title: Text(
                      "Call us Our Team is ready to help you",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    trailing: ClipOval(
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.all(3),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black,
                            size: 15,
                          )),
                    ),
                  ),
                ),
              ),*//*
              *//*Container(margin: EdgeInsets.symmetric(horizontal: 20),child: Divider(color: Colors.grey,thickness: 1,)),
              InkWell(
                onTap: () {
                  launch("tel:+91 9315832979");
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(

                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.call,
                      color: Colors.black,
                    ),
                    title: Text(
                      "Call us Our Team is ready to help you",
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    trailing: ClipOval(
                      child: Container(
                          decoration: BoxDecoration(
                            color: primaryColor,
                          ),
                          padding: EdgeInsets.all(3),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 15,
                          )),
                    ),
                  ),
                ),
              ),
              Container(margin: EdgeInsets.symmetric(horizontal: 20),child: Divider(color: Colors.grey,thickness: 1,)),*//*
              Container(
                margin: EdgeInsets.only(top: 5),
                decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Form(
                  key: _formKey,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                            alignment: Alignment.center,
                            child: Container(
                                child: Text(
                              "QUICK CONTACT",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: primaryColor),
                            ))),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text(
                            "Name",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.black),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 1.0), //(x,y)
                                  blurRadius: 4.0,
                                ),
                              ],
                              color: Colors.white,
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
                          margin: EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              Text(
                                "Email",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.black),
                              ),
                              Text(
                                "*",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 1.0), //(x,y)
                                  blurRadius: 4.0,
                                ),
                              ],
                              color: Colors.white,
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
                                  errorText: _emailError,
                                  border: InputBorder.none,
                                  hintText: "Enter Email Address",
                                  hintStyle: TextStyle(fontSize: 13)),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text(
                            "Subject",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                color: Colors.black),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 1.0), //(x,y)
                                  blurRadius: 4.0,
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: TextFormField(
                              validator: MaxLengthValidator(30,
                                  errorText: "Invalid Subject"),
                              controller: _subjectController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Subject",
                                  hintStyle: TextStyle(fontSize: 13)),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              Text(
                                "Message",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    color: Colors.black),
                              ),
                              Text(
                                "*",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 100,
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 1.0), //(x,y)
                                  blurRadius: 4.0,
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: TextFormField(
                              validator: MultiValidator([
                                RequiredValidator(errorText: "Required"),
                              ]),
                              controller: _messageController,
                              keyboardType: TextInputType.multiline,
                              maxLines: 5,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Typing...",
                                  hintStyle: TextStyle(fontSize: 13)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    validate(
                        subject: _subjectController.text,
                        message: _messageController.text);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 25, bottom: 25),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 95),
                    child: Text(
                      "Send",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    decoration: BoxDecoration(
                      color: blueColor,
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
              ),
            ],
          ),*/
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  launch("tel:+91 8881110523");
                },
                child: Container(
                  padding: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                  margin: EdgeInsets.only(left: 10,right: 10,top: 20),
                  decoration: BoxDecoration(
                    color: Colors.white, // Container background color
                    borderRadius: BorderRadius.circular(10), // Optional: Round corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // Shadow color
                        spreadRadius: 2, // Spread radius
                        blurRadius: 2, // Blur radius
                        offset: Offset(0, 3), // Offset in x and y direction
                      ),
                    ],
                  ),
                  child: Row(

                    children: [
                      Container(
                        width: 45,
                          height: 45,
                          child: Image.asset("assets/icon/call_contact_icon.png")),
                      SizedBox(
                        width: 10,
                      ),
                      CustomText(text: "Call us our Team is ready to help you",color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500)

                    ],
                  ),
                ),
              ),

              InkWell(
                onTap: () {
                  launch("mailto:info@astrogurujii.com");
                },
                child: Container(
                  padding: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                  margin: EdgeInsets.only(left: 10,right: 10,top: 20),
                  decoration: BoxDecoration(
                    color: Colors.white, // Container background color
                    borderRadius: BorderRadius.circular(10), // Optional: Round corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // Shadow color
                        spreadRadius: 2, // Spread radius
                        blurRadius: 2, // Blur radius
                        offset: Offset(0, 3), // Offset in x and y direction
                      ),
                    ],
                  ),
                  child: Row(

                    children: [
                      Container(
                          width: 45,
                          height: 45,
                          child: Image.asset("assets/icon/mail_contact_icon.png")),
                      SizedBox(
                        width: 10,
                      ),
                      CustomText(text: "Mail us our Team is ready to help you",color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500)

                    ],


                  ),
                ),
              ),

              InkWell(
                onTap: () {
                  launch("https://wa.me/+918881110523");
                },
                child: Container(
                  padding: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                  margin: EdgeInsets.only(left: 10,right: 10,top: 20),
                  decoration: BoxDecoration(
                    color: Colors.white, // Container background color
                    borderRadius: BorderRadius.circular(10), // Optional: Round corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // Shadow color
                        spreadRadius: 2, // Spread radius
                        blurRadius: 2, // Blur radius
                        offset: Offset(0, 3), // Offset in x and y direction
                      ),
                    ],
                  ),
                  child: Row(

                    children: [
                      Container(
                          width: 45,
                          height: 45,
                          child: Image.asset("assets/icon/whatsapp_contact_icon.png")),
                      SizedBox(
                        width: 10,
                      ),
                      CustomText(text: "WhatsApp us our Team is ready to help you",color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500)

                    ],
                  ),
                ),
              ),

              SizedBox(
                height: 50,
              ),

              CustomText(text: "Quick Contact",color: AppColors.orangeColor,fontSize: 25,fontWeight: FontWeight.w600,),
              SizedBox(
                height: 30,
              ),

              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFE9E9E9),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                padding: EdgeInsets.only(left: 10,right: 10,top: 20,bottom: 30),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 1.0), //(x,y)
                              blurRadius: 4.0,
                            ),
                          ],
                          color: Colors.white,
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

                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 1.0), //(x,y)
                              blurRadius: 4.0,
                            ),
                          ],
                          color: Colors.white,
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
                              errorText: _emailError,
                              border: InputBorder.none,
                              hintText: "Enter Your Email here",
                              hintStyle: TextStyle(fontSize: 13)),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 1.0), //(x,y)
                              blurRadius: 4.0,
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          validator: MaxLengthValidator(30,
                              errorText: "Invalid Subject"),
                          controller: _subjectController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter Your Subject here",
                              hintStyle: TextStyle(fontSize: 13)),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    Container(
                      height: 100,
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 1.0), //(x,y)
                              blurRadius: 4.0,
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          validator: MultiValidator([
                            RequiredValidator(errorText: "Required"),
                          ]),
                          controller: _messageController,
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Type your message here",
                              hintStyle: TextStyle(fontSize: 13)),
                        ),
                      ),
                    ),

                    Align(
                      alignment: Alignment.center,
                      child: InkWell(
                        onTap: () {
                          validate(
                              subject: _subjectController.text,
                              message: _messageController.text);
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 25, bottom: 25),
                          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 95),
                          child: Text(
                            "Submit",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          decoration: BoxDecoration(
                            color: blueColor,
                            borderRadius: BorderRadius.circular(50),
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
                    ),
                  ],
                ),

              )
            ],
          ),
        ),
      ),
    );
  }
}
