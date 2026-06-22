import 'dart:developer';

import 'package:astro_gurujii/Screens/poojaScreen/ui/poojaDetailScreen.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:astro_gurujii/Utilities/banner_loader.dart';
import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Setup/SetUp.dart';
import '../../../Setup/app_colors.dart';
import '../../HelpUs.dart';
import '../../Login.dart';
import '../../Models/last_call_list/LastCallListModel.dart';
import '../../MyWallet.dart';
import '../../Profile/ProfileScreen.dart';
import '../../TalkAstrologer/TalkAstrologers.dart';
import '../../WebServices/HttpServices.dart';
import '../../WebViewerTerms.dart';
import '../../controllers/home_page_logic.dart';
import '../../language/language_change_screen.dart';
import '../../mall/MyOrderListSideScreen.dart';
import '../../pooja_orders/ui/pooja_order_list_screen.dart';
import '../../ragisterAstro/ragister_astro.dart';
import '../../transection_screen/TransactionHistory.dart';
import '../controller/controller.dart';

class ReviewAndCheckout extends StatefulWidget {
 final List<String> bannerList;
 final String poojaName;
 final String purposeOfPooja;
 final String templeName;
 final String date;
 final String onlyDate;
 final String onlyMonth;
 final String packageName;
 final String packageAmount;
 final String userId;

  const ReviewAndCheckout({
     required this.bannerList,
    required this.poojaName,
    required  this.purposeOfPooja,
    required  this.templeName,
    required  this.date,
    required  this.packageName,
    required  this.userId,
    required this.onlyDate, required this.onlyMonth,
    required   this.packageAmount});

  @override
  State<ReviewAndCheckout> createState() => _ReviewAndCheckoutState();
}

class _ReviewAndCheckoutState extends State<ReviewAndCheckout> {

  PoojaController screenController = Get.put(PoojaController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    screenController. razorpay = Razorpay();
    screenController. razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, screenController.handlePaymentSuccess);
    screenController. razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, screenController.handlePaymentError);
    screenController. razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, screenController.handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(

      appBar: AppBar(
          elevation: 1,
          iconTheme: IconThemeData(
            color: whiteColor, //change your color here
          ),
          backgroundColor: AppColors.orangeColor,
          foregroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            "Review & Checkout",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [

            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: InkWell(
                  onTap: () {
                    _openWhatsAppLink("8891110523");

                  },
                  child: Image.asset("assets/images/whatsapp.png",height: 22,width: 22,)),
            ),

          ]

      ),

      body: SafeArea(
        child: _isloading == true ? Center(child: CircularProgressIndicator(color: AppColors.orangeColor,),) :SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              SizedBox(height: 10,),
              _poojaImagesCarusel(),

              SizedBox(height: 10,),

              _titleAndDateSection(context),
              SizedBox(height: 10,),


              Row(children: [
                Icon(Icons.temple_hindu_outlined,size: 20,),
                SizedBox(width: 10,),
                Text("${screenController.poojaDetailModel!.data!.mandirName}",
                style: TextStyle(fontFamily: 'Times new roman'),
                ),
              ],),

              SizedBox(height: 5,),
              Row(children: [
                Icon(Icons.calendar_today,size: 20,),
                SizedBox(width: 10,),
                Text("${widget.onlyDate} ${widget.onlyMonth} 2025",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontFamily: 'Times New Roman',
                      fontWeight: FontWeight.w500),
                ),
              ],),
              // SizedBox(height: 6,),
              // CustomText(text: "${widget.onlyDate} ${widget.onlyMonth} 2025", fontWeight: FontWeight.w300,),
              SizedBox(
                height: 15,
              ),

              // noOfPeopleBookedPooja(screenController),
              // SizedBox(height: 5,),
              // SizedBox(height: 5,),

                          TimerScreen(datetime: screenController.poojaDetailModel!.data!.pujaDate.toString()),

                            // Text("${widget.date}"),

                            SizedBox(width: 10,),





                            // Icon(Icons.error_outline,size: 18),
       // SizedBox(height: 10,),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Column(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //       CustomText(text: "Package ",
              //         color: Colors.grey,
              //         fontSize: 15,
              //       ),
              //     SizedBox(height: 5,),
              //       CustomText(text: "${widget.packageName}",
              //         color: Colors.black,
              //         fontWeight: FontWeight.bold,
              //         fontSize: 16,
              //       ),
              //
              //     ],),
              //
              //     Column(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     crossAxisAlignment: CrossAxisAlignment.end,
              //     children: [
              //       // CustomText(text: "Total Amount ",
              //       //   color: Colors.grey,
              //       //   fontSize: 16,
              //       // ),
              //       // SizedBox(height: 5,),
              //       // CustomText(text: "₹ ${widget.packageAmount}",
              //       //   color: Colors.black,
              //       //   fontWeight: FontWeight.bold,
              //       //   fontSize: 16,
              //       // ),
              //     ],
              //   ),
              //
              //
              // ],),


              SizedBox(height: 20,),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey[300]!, width: 1)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Payment Summary',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.mBGColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_down_outlined)
                      ],
                    ),

                    SizedBox(height: 15,),

                    Container(

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            _buildSummaryRow('Package Type', '${widget.packageName}',isTotal: true),
                          _buildSummaryRow('Puja Plan', '₹ ${widget.packageAmount}.00'),
                          // Divider(),
                          _buildSummaryRow('GST (18%)', '₹${gstCalculate(widget.packageAmount)} %'),
                          SizedBox(height: 3),
                          Divider(),
                          SizedBox(height: 3),
                          _buildSummaryRow('Total', '₹ ${total?.toStringAsFixed(2)}', isTotal: true),
                        ],),

                    )

                  ],
                ),
              ),
              SizedBox(height: 20,),
              Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey[300]!, width: 1)),
child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [

    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Payment Options',
          style: TextStyle(
            fontSize: 18,
            color: AppColors.mBGColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Icon(Icons.keyboard_arrow_down_outlined)
      ],
    ),

    SizedBox(height: 15,),

    Container(

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          _selectPaymentOption("Online Payment", 1),
          _selectPaymentOption("From Wallet", 2),

          // // _buildSummaryRow('Package Type', '${widget.packageName}',isTotal: true),
          // _buildSummaryRow('Puja Plan', '₹ ${widget.packageAmount}.00'),
          // // Divider(),
          // _buildSummaryRow('GST (18%)', '₹${gstCalculate(widget.packageAmount)} %'),
          // SizedBox(height: 3),
          // Divider(),
          // SizedBox(height: 3),
          // _buildSummaryRow('Total', '₹ ${total?.toStringAsFixed(2)}', isTotal: true),
        ],),

    )

  ],
),
          )],),
          ),
        ),
      ),

      bottomNavigationBar:
      Material(
        elevation: 30,
        child: Container(
          // color: Colors.white,

          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Color(0xFFFBFBFB),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            shadows: [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 10,
                offset: Offset(0, 0),
                spreadRadius: 0,
              )
            ],
          ),
          height: 65,
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  CustomText(text: "Total Amount"),
                  SizedBox(height: 7,),
                  CustomText(text: "₹ ${total?.toStringAsFixed(2)}",color: primaryColor,
                  fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),


                ],),
              ),


              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () async {
                    showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          backgroundColor: Colors.transparent,
                          child: Container(
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                            height: 200,
                            width: double.infinity,
                            padding: EdgeInsets.all(12),
                            child: Column(
                              children: [
                                 Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Confirm Payment', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, fontFamily: 'Times new roman'),),
                                    IconButton(onPressed: (){

                                      Navigator.pop(context, false);
                                    }, icon: Icon(Icons.close, size: 30,))
                                  ],
                                ),
                                 SizedBox(height: 10,),
                                 Text(
                                    'Are you sure you wish to proceed with the payment? Please review the details before confirming.', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),),
                                // actionsAlignment: MainAxisAlignment.spaceEvenly,
                                SizedBox(height: 20,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children:[
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context, false);
                                    },
                                    child: Container(
                                      // margin: EdgeInsets.all(10),
                                      height: 40,
                                      width: 110,
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.black, width: 2),
                                          borderRadius: BorderRadius.circular(10)),
                                      child: Center(
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(


                                    onTap: () {
                                      Navigator.pop(context);
                                      makePayment(_selectedValue);
                                      // _showWalletOptions(context);
                                    },
                                    child: Container(
                                      // margin: EdgeInsets.all(10),
                                      height: 40,
                                      width: 110,
                                      decoration: BoxDecoration(
                                          color: AppColors.orangeColor,
                                          // border: Border.all(color: appTheme, width: 2),
                                          borderRadius: BorderRadius.circular(10)),
                                      child: Center(
                                        child: Text(
                                          'Yes',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // TextButton(
                                  //   onPressed: () {
                                  //     SystemNavigator.pop();
                                  //     //  Navigator.pop(context, true);
                                  //   },
                                  //   child: const Text(''),
                                  // ),
                                ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );







                    // final SharedPreferences _prefs = await SharedPreferences.getInstance();

                    //String ?userId= _prefs.getString("id");

                    //    log("packagePrice========>>>>>>>${ screenController.poojaDetailModel!.data!.packages![index].packagePrice}");
                    // log("packageType========>>>>>>>${ screenController.poojaDetailModel!.data!.packages![index].packageType}");
                    // log("sId========>>>>>>>${ screenController.poojaDetailModel!.data!.sId}");
                    // log("pujaDate========>>>>>>>${ screenController.poojaDetailModel!.data!.pujaDate}");
                    // log("userId========>>>>>>>${ userId}");
                  },
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: CustomText(
                        text: "Make Payment",
                        color: Colors.white,
                      ))),
                ),
              ),

            ],
          ),
        ),
      ),

    );
  }

bool _isloading = false;
  Future<void> makePayment(int selectedPaymentOptions) async {
    setState(() {
      _isloading = true;
    });
    if (selectedPaymentOptions == 2){
      await getProfile();


      if (walletAmount == "0" || int.parse(walletAmount) < double.parse(total.toString())) {
        print("wallet balance is less============>>>  ");

        Fluttertoast.showToast(msg: "wallet balance is low please recharge");
        setState(() {
          _isloading = false;
        });
        Future.delayed(Duration.zero, () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyWallet())
          );
        });
        print("goining to wallet screen");

      }

      else {

        try {
          await screenController.bookPoojaApi(
            payment_mode: "wallet",
            userId: widget.userId.toString(),
            poojaId: screenController.poojaDetailModel!.data!.sId.toString(),
            packageType: widget.packageName,
            packagePrice: total.toString(),
            poojaDate: screenController.poojaDetailModel!.data!.pujaDate.toString(),
            contextbook: context,
          );
          setState(() {
            _isloading = false;
          });
          Future.delayed(Duration.zero, () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PoojaOrderList())
            );
          });

          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => PoojaOrderList()),
          // );
        } catch (e) {
          setState(() {
            _isloading = false;
          });
          Fluttertoast.showToast(
            msg: "An error occurred: ${e.toString()}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }


        // screenController.bookPoojaApi(
        //   payment_mode: "wallet",
        //     userId: widget.userId.toString(),
        //     poojaId: screenController
        //         .poojaDetailModel!.data!.sId
        //         .toString(),
        //     packageType: widget.packageName,
        //     packagePrice: total.toString(),
        //     poojaDate: screenController
        //         .poojaDetailModel!.data!.pujaDate
        //         .toString(),
        //     contextbook: context).then((value) {
        //
        //   Future.delayed(Duration.zero, () {
        //     Navigator.push(
        //         context,
        //         MaterialPageRoute(builder: (context) => PoojaOrderList())
        //     );
        //   });
        // });

      }

      // }


    }
    else if (selectedPaymentOptions == 1){
      try{

        await  screenController.bookPoojaApi(
            payment_mode: "razorpay",
            userId: widget.userId.toString(),
            poojaId: screenController
                .poojaDetailModel!.data!.sId
                .toString(),
            packageType: widget.packageName,
            packagePrice: total.toString(),
            poojaDate: screenController
                .poojaDetailModel!.data!.pujaDate
                .toString(),

            contextbook: context);

        // Future.delayed(Duration.zero, () {
        //   Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => PoojaOrderList())
        //   );
        // });



        setState(() {
          _isloading = false;
        });
      }catch (e){
        setState(() {
          _isloading = false;
        });
        Fluttertoast.showToast(
          msg: "An error occurred: ${e.toString()}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );

      }

    }
  }

  void _showWalletOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Wallet',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              ListTile(
                leading: Icon(Icons.account_balance_wallet),
                title: Text('From App Wallet'),
                onTap: () async{

                  // final _prefs = await SharedPreferences.getInstance();
                  // if (_prefs.get("is_skip") == "Y") {
                  //
                  //   Navigator.pushAndRemoveUntil(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (_) => LoginPage()),
                  //           (route) => false);
                  //
                  // } else {
                  //
                     await getProfile();


                    if (walletAmount == "0" || int.parse(walletAmount) < double.parse(total.toString())) {
                     print("wallet balance is less============>>>  ");

                     Fluttertoast.showToast(msg: "wallet balance is low please recharge");

                     Future.delayed(Duration.zero, () {
                       Navigator.push(
                           context,
                           MaterialPageRoute(builder: (context) => MyWallet())
                       );
                     });
                     print("goining to wallet screen");

                    }

                    else {

                      try {
                        await screenController.bookPoojaApi(
                          payment_mode: "wallet",
                          userId: widget.userId.toString(),
                          poojaId: screenController.poojaDetailModel!.data!.sId.toString(),
                          packageType: widget.packageName,
                          packagePrice: total.toString(),
                          poojaDate: screenController.poojaDetailModel!.data!.pujaDate.toString(),
                          contextbook: context,
                        );

                        Future.delayed(Duration.zero, () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PoojaOrderList())
                          );
                        });

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => PoojaOrderList()),
                        // );
                      } catch (e) {
                        Fluttertoast.showToast(
                          msg: "An error occurred: ${e.toString()}",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                        );
                      }


                      // screenController.bookPoojaApi(
                      //   payment_mode: "wallet",
                      //     userId: widget.userId.toString(),
                      //     poojaId: screenController
                      //         .poojaDetailModel!.data!.sId
                      //         .toString(),
                      //     packageType: widget.packageName,
                      //     packagePrice: total.toString(),
                      //     poojaDate: screenController
                      //         .poojaDetailModel!.data!.pujaDate
                      //         .toString(),
                      //     contextbook: context).then((value) {
                      //
                      //   Future.delayed(Duration.zero, () {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(builder: (context) => PoojaOrderList())
                      //     );
                      //   });
                      // });

                    }

                  // }


                  Navigator.pop(context);
                  // Handle External Wallet selection logic here
                 },

              ),

              ListTile(
                onTap: () async {

                  try{

                    await  screenController.bookPoojaApi(
                        payment_mode: "razorpay",
                        userId: widget.userId.toString(),
                        poojaId: screenController
                            .poojaDetailModel!.data!.sId
                            .toString(),
                        packageType: widget.packageName,
                        packagePrice: total.toString(),
                        poojaDate: screenController
                            .poojaDetailModel!.data!.pujaDate
                            .toString(),

                        contextbook: context);

                    // Future.delayed(Duration.zero, () {
                    //   Navigator.push(
                    //       context,
                    //       MaterialPageRoute(builder: (context) => PoojaOrderList())
                    //   );
                    // });




                  }catch (e){

                    Fluttertoast.showToast(
                      msg: "An error occurred: ${e.toString()}",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );

                  }




                },
                leading: Icon(Icons.wallet_membership),
                title: Text('From External Wallet'),
              ),

            ],
          ),
        );
      },
    );
  }

  Widget _poojaImagesCarusel() {

    return

      screenController.poojaDetailModel!.data!.bannerImages!.isEmpty?Container():
      GetBuilder<PoojaController>(
        init: PoojaController(),
        builder: (controller) {
          return Column(children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 140,
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 16/9,
                viewportFraction: 1,

                onPageChanged: (index, reason) {
                  controller.valueChange(index);
                },
              ),
              items: screenController.poojaDetailModel!.data!.bannerImages!.map((imageUrl) {
                return ShimmerImageLoader(image: imageUrl.toString(),);
                //   Builder(
                //   builder: (BuildContext context) {
                //     return ClipRRect(
                //       borderRadius: BorderRadius.only(
                //         topRight: Radius.circular(8),
                //         topLeft: Radius.circular(8),
                //         bottomRight: Radius.circular(8),
                //         bottomLeft: Radius.circular(8),
                //       ),
                //       child: Image.network(
                //         imageUrl.toString(),
                //
                //         filterQuality:FilterQuality.high,
                //         errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                //           return Shimmer.fromColors(
                //             baseColor: Colors.grey[300]!,
                //             highlightColor: Colors.grey[100]!,
                //             child: Padding(
                //               padding: const EdgeInsets.all(10.0),
                //               child: Column(
                //                 children: [
                //                   Container(
                //                     height: 200,
                //                     width: double.infinity,
                //                     decoration: BoxDecoration(
                //                       gradient: LinearGradient(
                //                         begin: Alignment.centerLeft,
                //                         end: Alignment.centerRight,
                //                         colors: [
                //                           Colors.grey[300]!,
                //                           Colors.grey[100]!,
                //                           Colors.grey[300]!,
                //                         ],
                //                         stops: const [0.0, 0.5, 1.0],
                //                       ),
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //             ),
                //           );
                //         },
                //         fit: BoxFit.fill,
                //         height: 200,
                //         width: double.infinity,
                //       ),
                //     );
                //   },
                // );
              }).toList(),


            ),
            SizedBox(height: 10,),
            CarouselIndicator(
              height: 7,
              width: 7,
              activeColor: primaryColor,
              color: Colors.grey,
              count: screenController.poojaDetailModel!.data!.bannerImages!.length,
              index: controller.bannerIndex,
            ),
          ],);
        },);



  }

  Widget _titleAndDateSection(BuildContext context) {
    var temp = screenController.poojaDetailModel!.data;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                width: Get.width * 0.8,
                child: Text(
                  // "Sri Lalitha Tripurasundari Mahayagya Sri Lalitha Tripurasundari Mahayagya",
                  temp!.title.toString(),
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Lato'),
                )),
            // Column(
            //   children: [
            //     Container(
            //       decoration: BoxDecoration(
            //           shape: BoxShape.circle,
            //           border: Border.all(color: Colors.grey, width: 1)),
            //       child: Padding(
            //         padding: const EdgeInsets.all(10.0),
            //         child: Text(
            //           //"6",
            //           widget.onlyDate.toString(),
            //           style: TextStyle(color: Colors.grey, fontSize: 12),
            //         ),
            //       ),
            //     ),
            //     Text(
            //       // "Dec",
            //       widget.onlyMonth.toString(),
            //       style: TextStyle(color: Colors.grey, fontSize: 12),
            //     ),
            //   ],
            // ),
          ],
        ),
        SizedBox(height: 5,),
        Text(
          //"Sri Lalitha Tripurasundari Mahayagya Sri Lalitha Tripurasundari Mahayagya",
          temp.purposeOfPooja??"",
textAlign: TextAlign.justify,
          style: TextStyle(fontSize: 14, color: primaryColor),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String title, String amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isTotal ? 17 : 14,
              fontWeight: isTotal ? FontWeight.w800 : FontWeight.normal,
              color: Colors.grey[700],
            ),
          ),
          Text(
             amount, // Try parsing to double and format, fallback to original if parsing fails
            style: TextStyle(
              fontSize: isTotal ? 17 : 14,
              fontWeight: isTotal ? FontWeight.w800 : FontWeight.normal,
              color: isTotal ? Colors.black : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
  int _selectedValue = 1;

  // Method to handle radio button changes
  void _handleRadioValueChanged(int? value) {
    setState(() {
      _selectedValue = value!;
    });
  }
  Widget _selectPaymentOption(String title, int selectedOptions){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child:
      ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(title, style: TextStyle(
          fontSize:  17,
          fontWeight: FontWeight.w800 ,
          color: Colors.grey[700],
        ),),
        trailing: Row(
          mainAxisSize: MainAxisSize.min, // Ensure the row takes only as much width as needed
          children: <Widget>[
            SizedBox(width: 10), // Add horizontal space between the title and radio button
            Radio<int>(
              value: selectedOptions,
              groupValue: _selectedValue,
              onChanged: _handleRadioValueChanged,
              activeColor: AppColors.orangeColor,
            ),
          ],
        ),
      ),
    );
    
  }


  void _openWhatsAppLink(String? phone) async {
    var code = "+91";
    code = code.replaceAll("+", "");
    var url = "https://wa.me/$code$phone?text=${"Hello, this is from AstroGurujii"}";

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Could not launch $url";
    }
  }

  final HttpServices _httpServices = HttpServices();

  var wallet = "";
  String walletAmount = "";
  String currency = "";
  Future getProfile() async {
    var res = await _httpServices.profile_api();
    if (res!.status == true) {
      setState(() {
        //currency = res.results.currency.toString();
        currency = "INR";
        //wallet = setWallet(res.results.wallet.toString(), "INR",
        // res.results.wallet_usd.toString());
        walletAmount = res.results!.wallet.toString();
        log("amount==>> " + wallet + "==>>" + walletAmount);
      });
    } else {
      Fluttertoast.showToast(msg: res.message!);
      //_refreshController.refreshCompleted();
    }
  }

  String setWallet(String wallet, String currency, String usdWallet) {
    if (currency == "USD") {
      return "${usdWallet}";
    } else {
      return "${wallet}";
    }
  }


  double ?total;
  String gstCalculate(String amount){

    double a=double.parse(amount.toString());
    double gstAmount=a*18/100;
    total= gstAmount+double.parse(amount.toString());

    return gstAmount.toString();
  }

}
