import 'package:astro_gurujii/Screens/pooja_orders/controller/PoojaOrderController.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Setup/SetUp.dart';
import '../../../Setup/app_colors.dart';
import '../../../Utilities/valdationFunctions.dart';

class AddDetails extends StatefulWidget {
  final String poojaBookingId;
  const AddDetails(this.poojaBookingId);

  @override
  State<AddDetails> createState() => _AddDetailsState();
}

class _AddDetailsState extends State<AddDetails> {

  PoojaOrderController screenController=Get.put(PoojaOrderController());



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        iconTheme: IconThemeData(
          color: whiteColor, //change your color here
        ),
        backgroundColor: primaryColor,
        title: Text(
          "Add Details",
          style: TextStyle(color: whiteColor),
        ),


      ),

        body:
        GetBuilder<PoojaOrderController>(
          init: PoojaOrderController(),
          builder: (controllerr) {
          return    SingleChildScrollView(
            child: Column(
              children: [

                SizedBox(height: 20,),
              customTextFormFiled(
                  controller:controllerr.nameController,
                  hintText: "Enter Full your Name",
               ),

                SizedBox(height: 8,),
                customTextFormFiled(
                  controller:controllerr.gotraController,
                  hintText: "Enter your Gotra",
                 ),

                SizedBox(height: 8,),

                customTextFormFiled(
                  controller:controllerr.purposeOfController,
                  hintText: "Enter Purpose of Pooja",
                ),

                SizedBox(height: 8,),

                customTextFormFiled(
                  controller:controllerr.placeController,
                  hintText: "Enter your Place"
                ),
                SizedBox(height: 8,),

                customTextFormFiled(
                  controller:controllerr.emailController,
                  hintText: "Enter your Email",
                ),
                SizedBox(height: 8,),

                customTextFormFiled(
                  controller:controllerr.whatsappNumberController,
                  hintText: "Enter your Whatsapp Number",
                ),
                SizedBox(height: 8,),

                customTextFormFiled(
                  controller:controllerr.courierAddressControler,
                  hintText: "Enter your Courier Address",
                ),


                SizedBox(height: 8,),

               InkWell(
                 onTap: (){

                   controllerr.onSubmit(widget.poojaBookingId.toString());

                   Navigator.pop(context);

                 },
                 child: Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Container(

                     decoration: BoxDecoration(
                       color: AppColors.primaryOrange,
                       borderRadius: BorderRadius.circular(15),

                     ),
                     height: 50,
                     width: double.infinity,
                     child: Center(
                       child: CustomText(text: "Submit",
                       color: whiteColor,
                         fontSize: 18,
                       ),
                     ),
                   ),
                 ),
               )
              ],),
          );
        },)

    );
  }
  Widget customTextFormFiled(
      {
        TextEditingController ?  controller,
        String ? hintText,
        bool ? isRead,
        final String? Function(String?)? validator
      }
      ){

    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 4,
              offset: Offset(0, 0),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 5,
              offset: Offset(0, 0),
              spreadRadius: 0,
            ),
          ],
          borderRadius:
          BorderRadius.circular(10),
        ),
        child: TextFormField(

          readOnly: isRead??false,
          controller: controller,
          decoration: InputDecoration(
              hintText: hintText,
              // suffixIcon: IconButton(onPressed: (){
              //
              // },
              //
              //     icon: num==3?Container():
              // Image.asset("assets/images/EditIconNew.png",
              //   fit: BoxFit.fill,
              //   height: 20,width: 20,)),
               contentPadding: EdgeInsets.only(left: 13),
              border: InputBorder.none,
              hintStyle: TextStyle(color: blackColor)
          ),
        ),
      ),
    );

  }

}
