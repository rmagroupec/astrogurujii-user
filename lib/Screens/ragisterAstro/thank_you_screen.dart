import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../Setup/app_colors.dart';

class ThankYouScreen extends StatefulWidget {

  @override
  State<ThankYouScreen> createState() => _ThankYouScreenState();

}

class _ThankYouScreenState extends State<ThankYouScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
             
          Image.asset("assets/icon/thank_you_screen.png",width: 180,height: 180,),
          SizedBox(
            height: 20,
          ),
          CustomText(text: "Thank you",color: Colors.black,fontSize: 24,fontWeight: FontWeight.bold,),
          CustomText(text: "Our team will contact you shortly",color: Colors.black,fontSize: 18,fontWeight: FontWeight.w500,),

          Padding(
            padding: const EdgeInsets.all(40),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 55),
                 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),


                  )

              ),
              onPressed: () {
                  Get.back();
              },

              child: Text('Continue to Home',style: TextStyle(color: AppColors.orangeColor,fontSize: 18,fontWeight: FontWeight.w700),),
            ),
          ),



        ],
      ),
    );
  }
}
