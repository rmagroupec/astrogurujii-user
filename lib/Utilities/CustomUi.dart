import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:flutter/material.dart';

class CustomUi {
  static Widget getAppPrimaryButton(String text, Function onButtonPressed) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            textStyle: TextStyle(fontFamily: MyFonts.regular),
         
            fixedSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              text,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        onPressed: () {
          onButtonPressed();
        },
      ),
    );
  }

  static Widget getmaleFemaleButton(String text, Function onButtonPressed, String male) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            textStyle: TextStyle(fontFamily: MyFonts.regular),
       
            fixedSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            male == "male"
                ? Image.asset(
                    'assets/images/male_icon.png',
                    color: whiteColor,
                    width: 18,
                    height: 18,
                  )
                : Image.asset(
                    'assets/images/female_icon.png',
                    color: whiteColor,
                    width: 18,
                    height: 18,
                  ),
            Text(
              text,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        onPressed: () {
          onButtonPressed();
        },
      ),
    );
  }

  static Widget getAppBorderButton(String text, Function onButtonPressed) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: InkWell(
        onTap: () {
          onButtonPressed();
        },
        child: Container(
          height: 53,
          decoration: BoxDecoration(
              border: Border.all(color: blueColor), borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                text,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: blueColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget getEditBox(
      bool readOnly,
      String hint,
      TextEditingController controller,
      TextInputType textInputType,
      BuildContext context,
      Function onCompleted,
      FormFieldValidator<String?> validate) {
    return Container(
        height: 53,
        width: MediaQuery.of(context).size.width / 2,
        child: TextFormField(
          readOnly: readOnly,
          onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
          keyboardType: textInputType,
          controller: controller,
          validator: validate,
          // onChanged: (val){
          //   if(val !=null){
          //     onCompleted();
          //   }
          // },
          decoration: InputDecoration(
            hintText: "",
            filled: true,
            contentPadding: EdgeInsets.only(left: 10),
            fillColor: Colors.grey[200],
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: signupgreycolor, width: 1.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: signupgreycolor, width: 1.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: signupgreycolor, width: 1.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ));
  }

  static Widget getEditBoxRef(String hint, TextEditingController controller,
      TextInputType textInputType, BuildContext context, Function onCompleted) {
    return Container(
        height: 53,
        width: MediaQuery.of(context).size.width / 2,
        child: TextFormField(
          keyboardType: textInputType,
          onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
          controller: controller,
          // onChanged: (val){
          //   if(val !=null){
          //     onCompleted();
          //   }
          // },
          decoration: InputDecoration(
            hintText: "",
            filled: true,
            contentPadding: EdgeInsets.only(left: 10),
            fillColor: Colors.grey[200],
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: signupgreycolor, width: 1.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: signupgreycolor, width: 1.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: signupgreycolor, width: 1.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ));
  }

  static Widget getSignUpContainer(String text, BuildContext context) {
    return Wrap(
      direction: Axis.vertical,
      spacing: 10,
      children: [
        Container(
          height: 40,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(color: signupcolor, borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 20),
            child: CustomText(
              text: text,
              color: blueColor,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  static Widget getEditBoxMobile(
      String hint,
      TextEditingController controller,
      TextInputType textInputType,
      BuildContext context,
      Function onCompleted,
      FormFieldValidator<String?> validate) {
    return Container(
        height: 53,
        width: MediaQuery.of(context).size.width / 2,
        child: TextFormField(
          keyboardType: textInputType,
          onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
          controller: controller,
          validator: validate,
          decoration: InputDecoration(
            hintText: "",
            filled: true,
            counter: Offstage(),
            contentPadding: EdgeInsets.only(left: 10),
            fillColor: Colors.grey[200],
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: signupgreycolor, width: 1.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: signupgreycolor, width: 1.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: signupgreycolor, width: 1.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ));
  }


  static Widget getAppFollowButton(String text, Function onButtonPressed) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(

            side: BorderSide(width:1, color:greyColor12),
            textStyle: TextStyle(fontFamily: MyFonts.regular),
         
            fixedSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              text,
              style:
              const TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.black),
            ),
          ],
        ),
        onPressed: () {
          onButtonPressed();
        },
      ),
    );
  }


  static Widget getAppChatButton(String text, Function onButtonPressed) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            side: BorderSide(width:1, color:primaryColor),
            textStyle: TextStyle(fontFamily: MyFonts.regular),
            
            fixedSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              text,
              style:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ],
        ),
        onPressed: () {
          onButtonPressed();
        },
      ),
    );
  }
}
