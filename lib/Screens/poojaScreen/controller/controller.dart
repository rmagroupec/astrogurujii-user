import 'dart:async';
import 'dart:developer';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tcard/tcard.dart';
import 'package:translator/translator.dart';

import '../../../Setup/SetUp.dart';
import '../../WebServices/HttpServices.dart';
import '../../mall/OrderSuccessFullScreen.dart';
import '../../pooja_orders/ui/pooja_order_list_screen.dart';
import '../model/poojDetailsModel.dart';
import '../model/poojaBookingResponse.dart';
import '../model/poojaListingModel.dart';

class PoojaController extends GetxController {
  CarouselController carouselController = CarouselController();

  ScrollController scrollController = ScrollController();

  TCardController tCardController = TCardController();
  RxInt carouselIndex = 0.obs;

  RxInt selectedIndex = 0.obs;

  // Timer? timer;

  PoojaModel? poojaModel;

  PoojaDetailModel? poojaDetailModel;

  final HttpServices _httpServices = HttpServices();

  RxBool poojaListingLoading = false.obs;
  RxBool poojaDetailsLoading = false.obs;
  RxBool bookPoojaLoading = false.obs;

  //  DateTime endTime = DateTime.now().add(Duration(days: 4, hours: 23, minutes: 3)); // Set the end time

  DateTime? endTime;

  List<Color> colorList = [
    Colors.red.withOpacity(0.7),
    Colors.green.withOpacity(0.7),
    Colors.blue.withOpacity(0.7),
    Colors.yellow.withOpacity(0.7),
    Colors.orange.withOpacity(0.7),
    Colors.purple.withOpacity(0.7),
    Colors.purple.withOpacity(0.7),
  ];

  // void startTimer() {
  //   log("end time====>> $endTime ");
  //   const oneSec = Duration(seconds: 1);
  //   timer = Timer.periodic(oneSec, (Timer timer) {
  //     DateTime now = DateTime.now();
  //     if (endTime!.isBefore(now)) {
  //       timer.cancel();
  //       // You can perform actions here when the countdown reaches zero
  //       // For example, show a message or execute a function
  //     } else {
  //       update();
  //     }
  //   });
  // }

  String getRemainingTime() {
    Duration remaining = endTime!.difference(DateTime.now());

    int days = remaining.inDays;
    int hours = remaining.inHours.remainder(24);
    int minutes = remaining.inMinutes.remainder(60);
    int seconds = remaining.inSeconds.remainder(60);

    return '$days days $hours hours $minutes mins $seconds seconds';
  }

  TextEditingController searchController= TextEditingController();
  void poojaListingApi() async {
    // if (poojaModel == null) {
    //   poojaListingLoading.value = true;
    // } else {
    //   poojaListingLoading.value = false;
    // }

    poojaListingLoading.value = true;

    var data={
      "search":searchController.text.toString()
    };

    final response = await _httpServices.poojaListingApi(data);
    poojaModel=response;



      poojaListingLoading.value = false;
      update();



  }

  void poojaDetailsApi(String instaId) async {
    poojaDetailsLoading.value = true;
    poojaDetailModel = await _httpServices.poojaDetailsApi(instaId);
    // await translateModel();
    print(poojaDetailModel!.data!.packages);
    poojaDetailsLoading.value = false;
    update();
  }

  // void poojaDetailsApi(String instaId) async {
  //   // if (poojaDetailModel == null) {
  //   //   poojaDetailsLoading.value = true;
  //   // } else {
  //   //   poojaDetailsLoading.value = false;
  //   // }
  //
  //   poojaDetailsLoading.value = true;
  //   poojaDetailModel = await _httpServices.poojaDetailsApi(instaId);
  //
  //
  //   // endTime = DateTime.parse(poojaDetailModel!.data!.pujaDate.toString());
  //
  //   // log("endDate from api====>>> $endTime");
  //   poojaDetailsLoading.value = false;
  //   update();
  // }

  PoojaBookResponseModel ? poojaBookResponseModel;

  BuildContext ? context;

  contextSetFun(BuildContext context){
   this. context=context;
   update();
  }


  RxBool onlinePaymentStatus=false.obs;




 Future<void>  bookPoojaApi(
      {String? packagePrice,
      String? packageType,
      String? poojaId,
      String? poojaDate,
      String? userId,
      String? payment_mode,
      BuildContext? contextbook}) async {

    // contextSetFun(contextbook!);
    double roundedPackagePrice = double.parse(packagePrice.toString());

    var response = await _httpServices.bookPooja(
        packagePrice: roundedPackagePrice.ceil().toString(),
        packageType: packageType,
        poojaId: poojaId,
        poojaDate: poojaDate,
        userId: userId,
        payment_mode: payment_mode.toString(),
        context: contextbook);



    if (response?.status == true) {

      if(payment_mode=="wallet"){




         log("pooja book from wallet");

         // showAnimatedAlertDialog(context!,response!.message.toString());

        Fluttertoast.showToast(
            msg: response!.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);

      }else if(payment_mode=="razorpay"){



        log("pooja book from Razorpay");

        poojaBookResponseModel=response!;
        openCheckout( poojaBookResponseModel!.orderId.toString());



        update();

        // Fluttertoast.showToast(
        //     msg: response.message.toString(),
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.CENTER,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.red,
        //     textColor: Colors.white,
        //     fontSize: 16.0);
      }

    } else {
      Fluttertoast.showToast(
          msg: response!.message.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

    }


    update();
  }


  int  bannerIndex=0;

  valueChange(int index){

    bannerIndex=index;
    update();

  }


  int  bannerIndexForPoojaListing=0;

  valueChangeForPoojaListing(int index){

    bannerIndexForPoojaListing=index;
    update();

  }


   final translator = GoogleTranslator();
  bool _isEnglishToHindi = true;

  void toggleLanguage() {

      _isEnglishToHindi = !_isEnglishToHindi;

      translateModel();
       update();

    }


  Future<void> translateModel() async {
    if (poojaDetailModel != null) {

       if (poojaDetailModel?.data?.title != null) {
         print("title before convert=======>>>  ${poojaDetailModel?.data?.title}");
        final translatedTitle = await translator.translate(
          poojaDetailModel!.data!.title!,
          from: _isEnglishToHindi ? 'hi' : 'en',
          to: _isEnglishToHindi ? 'en' : 'hi',
        );
        poojaDetailModel!.data!.title = translatedTitle.text;
         print("title After convert=======>>>  ${poojaDetailModel?.data?.title}");


       }

       if (poojaDetailModel?.data?.purposeOfPooja != null) {
         print("purposeOfPooja before convert =======>>>  ${poojaDetailModel?.data?.purposeOfPooja}");
         final translatedTitle = await translator.translate(
           poojaDetailModel!.data!.purposeOfPooja!,
           from: _isEnglishToHindi ? 'hi' : 'en',
           to: _isEnglishToHindi ? 'en' : 'hi',
         );
         poojaDetailModel!.data!.purposeOfPooja = translatedTitle.text;
         print("purposeOfPooja After convert=======>>>  ${poojaDetailModel?.data?.purposeOfPooja}");


       }


       if (poojaDetailModel?.data?.mandirName != null) {
         print("mandirName before convert =======>>>  ${poojaDetailModel?.data?.mandirName}");
         final translatedTitle = await translator.translate(
           poojaDetailModel!.data!.mandirName!,
           from: _isEnglishToHindi ? 'hi' : 'en',
           to: _isEnglishToHindi ? 'en' : 'hi',
         );
         poojaDetailModel!.data!.mandirName = translatedTitle.text;
         print("mandirName After convert=======>>>  ${poojaDetailModel?.data?.mandirName}");


       }



       if (poojaDetailModel?.data?.aboutPuja != null) {
         print("aboutPuja before convert =======>>>  ${poojaDetailModel?.data?.aboutPuja}");
         final translatedTitle = await translator.translate(
           poojaDetailModel!.data!.aboutPuja!,
           from: _isEnglishToHindi ? 'hi' : 'en',
           to: _isEnglishToHindi ? 'en' : 'hi',
         );
         poojaDetailModel!.data!.aboutPuja = translatedTitle.text;
         print("aboutPuja After convert=======>>>  ${poojaDetailModel?.data?.aboutPuja}");


       }

       if (poojaDetailModel?.data?.aboutTempalDescription != null) {
         print("aboutTempalDescription before convert =======>>>  ${poojaDetailModel?.data?.aboutTempalDescription}");
         final translatedTitle = await translator.translate(
           poojaDetailModel!.data!.aboutTempalDescription!,
           from: _isEnglishToHindi ? 'hi' : 'en',
           to: _isEnglishToHindi ? 'en' : 'hi',
         );
         poojaDetailModel!.data!.aboutTempalDescription = translatedTitle.text;
         print("aboutTempalDescription After convert=======>>>  ${poojaDetailModel?.data?.aboutTempalDescription}");


       }


       /// Faq
       if(poojaDetailModel?.data?.faq != null){
         for(int i=0;i<poojaDetailModel!.data!.faq!.length;i++){

            final translatedTitle = await translator.translate(
             poojaDetailModel!.data!.faq![i].question!,
             from: _isEnglishToHindi ? 'hi' : 'en',
             to: _isEnglishToHindi ? 'en' : 'hi',
           );
           poojaDetailModel!.data!.faq![i].question = translatedTitle.text;


         }

       }


       if(poojaDetailModel?.data?.faq != null){
         for(int i=0;i<poojaDetailModel!.data!.faq!.length;i++){

           final translatedTitle = await translator.translate(
             poojaDetailModel!.data!.faq![i].answer!,
             from: _isEnglishToHindi ? 'hi' : 'en',
             to: _isEnglishToHindi ? 'en' : 'hi',
           );
           poojaDetailModel!.data!.faq![i].answer = translatedTitle.text;


         }

       }


       /// benifits

       // if(poojaDetailModel?.data?.benifits != null){
       //   for(int i=0;i<poojaDetailModel!.data!.benifits!.length;i++){
       //
       //     final translatedTitle = await translator.translate(
       //       poojaDetailModel!.data!.benifits![i].title!,
       //       from: _isEnglishToHindi ? 'hi' : 'en',
       //       to: _isEnglishToHindi ? 'en' : 'hi',
       //     );
       //     poojaDetailModel!.data!.benifits![i].title = translatedTitle.text;
       //
       //   }
       //
       // }
       //
       //
       // if(poojaDetailModel?.data?.benifits != null){
       //   for(int i=0;i<poojaDetailModel!.data!.benifits!.length;i++){
       //
       //     final translatedTitle = await translator.translate(
       //       poojaDetailModel!.data!.benifits![i].description!,
       //       from: _isEnglishToHindi ? 'hi' : 'en',
       //       to: _isEnglishToHindi ? 'en' : 'hi',
       //     );
       //     poojaDetailModel!.data!.benifits![i].description = translatedTitle.text;
       //
       //   }
       //
       // }

      update();
      // Add more fields here as needed
    }
  }

  Razorpay ? razorpay;


  void showAnimatedAlertDialog(BuildContext context, String message) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (context, animation1, animation2) {
        return SizedBox();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          ),
          child: FadeTransition(
            opacity: animation,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Column(
                children: [
                  SizedBox(height: 10),
                  Center(child: Text("Thank you")),
                ],
              ),
              content: Container(
                height: 200,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      message,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: 30),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        // Navigator.of(context).pushAndRemoveUntil(
                        //   MaterialPageRoute(builder: (context) => Home()),
                        //       (Route<dynamic> route) => false,
                        // );
                      },
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFFC7601),
                              Color(0xFFFC7601),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 1.0), //(x,y)
                              blurRadius: 2.0,
                            ),
                          ],
                        ),
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Center(
                          child: Text(
                            "OK",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 300),
    );
  }



  void openCheckout(String  orderId) async {

    final _prefs = await SharedPreferences.getInstance();

    var options = {
      'key': razorPayTxnKey,
      // 'amount': amount,
      'currency': "INR",
      // 'image':'assets/images/AstroGurijiIcon.png',
      'image':'https://admin.astrogurujii.com/logo/app_logo.png',

      // 'name': _prefs.getString("name"),
      'name':"ASTROGURUJII",

      'description': "ASTROGURUJII",
      'order_id': orderId.toString(),
      'prefill': {
        'contact': _prefs.getString("phone"),
        'email': _prefs.getString("email")
      }
    };

    try {
      razorpay!.open(options);
    } catch (e) {
      // debugPrint(e.toString());
    }
  }
  void handlePaymentSuccess(PaymentSuccessResponse response) {

    Future.delayed(Duration.zero, () {
      Navigator.push(
          context!,
          MaterialPageRoute(builder: (context) => OrderSuccessFullScreen())
      );

      print("Payment Done");


    });


    // Navigator.push(
    //     context!,
    //     MaterialPageRoute(
    //         builder: (BuildContext context) => OrderSuccessFullScreen()));
  }

  void handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg:
        "Your payment for ASTROGURUJII was not completed. Any amount if debited will be added in your wallet or refunded within 2-3 days",
        timeInSecForIosWeb: 10);
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg:
        "Your payment for ASTROGURUJII was not completed. Any amount if debited will be added in your wallet or refunded within 2-3 days",
        timeInSecForIosWeb: 10);
  }

}

