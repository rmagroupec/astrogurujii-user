import 'package:astro_gurujii/Screens/homeScreen/Home.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:astro_gurujii/widget/bottom_navigation_bar_custom.dart';
import 'package:flutter/material.dart';

class WalletPaymentSuccessScreen extends StatelessWidget {

  static const String orderSuccessScreen = "orderSuccessScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:
            [
              Image.asset("assets/images/checkoutgif.gif",height: 350,),
              Container(
                margin: EdgeInsets.only(top: 40),
                child: Text("Your payment is successfully.",style: TextStyle(fontSize: 24,fontWeight: FontWeight.w400),),

              ),
             
              InkWell(
                onTap: () {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>MainHomeScreenWithBottomNavigation()), (route) => false);
                },
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 50,left: 20,right: 20),
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 25),
                  child: Text(
                    "Expore App",
                    style: TextStyle(color: Colors.white, fontSize: 18,fontWeight: FontWeight.w500),
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


            ],
          ),
        ),
      ),
    );
  }
}
