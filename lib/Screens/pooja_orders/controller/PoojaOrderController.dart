import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../WebServices/HttpServices.dart';
import '../model/PoojaBookingsModel.dart';
import '../model/view_details_model.dart';

class PoojaOrderController extends GetxController{

  final nameController= TextEditingController();
  final gotraController= TextEditingController();
  final purposeOfController= TextEditingController();
  final placeController= TextEditingController();
  final whatsappNumberController= TextEditingController();
  final courierAddressControler= TextEditingController();
  final emailController= TextEditingController();

  PoojaBookingsModel ? poojaBookingsModel;
  ViewDetailsModel ? viewDetailsModel;

  RxBool  loading=false.obs;

  RxBool canJoin=false.obs;
  RxString messageJoin="".obs;

  final _api =HttpServices();

  onSubmit(String pujaBookingId){
    print("nameController===>>> ${nameController.text}");
    print("gotraController===>>> ${gotraController.text}");
    print("purposeOfController===>>> ${purposeOfController.text}");
    print("PoojaId===>>> ${pujaBookingId}");



     addDetailsApi(pujaBookingId);
   }




   void addDetailsApi(String ? pujaBookingId){
    

      _api.addDetailApi(

          gotra:gotraController.text.toString() ,
          name: nameController.text.toString() ,
          pujaBookingId: pujaBookingId.toString(),
          purposeOfPooja:purposeOfController.text.toString(),
          courierAddress: courierAddressControler.text.toString(),
        email:emailController.text.toString(),
        place: placeController.text.toString(),
        whatsappNumber: whatsappNumberController.text.toString()

      ).then((value) {

        print("valueee--------->>> $value");

        Fluttertoast.showToast(
            msg: value['message'].toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );

      }).onError((error, stackTrace) {

        print("Error in addDetailsApi=========>>> ${error}");
        print("Error in addDetailsApi=========>>> ${stackTrace}");
      });

   }

   void poojaBookingApi(){
     loading.value=true;
       _api.poojaBookingListApi().then((value) {

       if(value!.status==true){
        poojaBookingsModel=value;
        loading.value=false;

        update();

      }

      }).onError((error, stackTrace) {
        print("Error in poojaBookingApi======>> $error}");
        print("Error in poojaBookingApi--stackTrace======>> $stackTrace}");

       });

   }

  void viewDetailsApi(String ? pujaBookingId){

     _api.viewDetailsFunApi(pujaBookingId).then((value) {

       viewDetailsModel=value;
       update();
    }).onError((error, stackTrace) {


      print("Error in poojaBookingApi======>> $error}");
      print("Error in poojaBookingApi--stackTrace======>> $stackTrace}");

    });






  }



  void joinLive(String ?puja_id) async{

  await  _api.joinLiveFun(puja_id: puja_id.toString()).then((value) {

      canJoin.value=value['status'];
      messageJoin.value=value['message'].toString();
      update();

    }).onError((error, stackTrace) {
      print("Error in joinLive===========>>> $error");
      print("Error in joinLive stackTrace===========>>> $stackTrace");

    });
  }


  void leaveLive(String ?puja_id){
    _api.leaveLiveFun(puja_id: puja_id.toString()).then((value) {

       Fluttertoast.showToast(msg: value['message'].toString());

    }).onError((error, stackTrace) {
      print("Error in leaveLive===========>>> $error");
      print("Error in leaveLive stackTrace===========>>> $stackTrace");

    });

  }
}

void showInsufficientBalanceDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Alert'),
        content: Text('Insufficient Balance'),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
