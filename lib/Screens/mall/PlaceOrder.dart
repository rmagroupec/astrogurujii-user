
import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Screens/mall/OrderSuccessFullScreen.dart';
import 'package:astro_gurujii/Screens/mall/Products.dart';
import 'package:astro_gurujii/Screens/mall/model/cart_list/Result.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:astro_gurujii/Setup/app_colors.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'all_coupons_screen.dart';
import 'model/all_coupon_model.dart';
import 'model/apply_coupanCode_model.dart';

class PlaceOrder extends StatefulWidget {
  String? address_id;
  String? selected_address;

  PlaceOrder({this.address_id, this.selected_address});

  @override
  _PlaceOrderState createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {
  final TextEditingController couponController = TextEditingController();
  bool _isLoading = false;
  String? userId1 = '';
  String? addressName = "",
      mobile = "",
      name = "",
      locality = "",
      type = "",
      pincode = "";
  int _value2 = 1;
  double delivery_charges = 0.0;
  double discount = 0.0;
  double gst = 0.0;
  double item_total = 0.0;
  double actual_total = 0.0;
  String? message;
  double paying_amount = 0.0;
  double appliedCoupan = 0.0;
  String? mode = "Online";
  String? _razorPayTxnId = "";
  HttpServices _httpService = HttpServices();
  String? reffer_id = "";
  List<Result> cart_list = [];

  Future<void> getCardDetails() async {
    var res = await _httpService.cart_list(product_id: '');
    if (res!.status ==true) {
      setState(() {
        _isLoading = false;
        cart_list = res.results!;
        delivery_charges = double.parse(res.delivery_charges!);
        discount = double.parse(res.saving!);
        gst = double.parse(res.gst!);
        item_total = double.parse(res.item_total!);
        actual_total = double.parse(res.mrp!);
        paying_amount = double.parse(res.paying_amount!);

        print("paying_amount=======>>>> ${paying_amount}");
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Future<void> callOrderPlaceAPI({String? paymentType}) async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //
  //   var res = await _httpService.checkout(
  //       address_id: widget.address_id,
  //       payment_mode: paymentType,
  //       coupan_amount: couponDiscount ?? "0",
  //       coupan_code: couponController.text.toString(),
  //       delivery_date: "");
  //
  //   if (res['status']==true) {
  //     setState(() {
  //       _isLoading = false;
  //       if (paymentType == "COD") {
  //         print("COD=====================");
  //         Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //                 builder: (BuildContext context) => OrderSuccessFullScreen()));
  //       } else if (paymentType == "Online") {
  //         // String? orderId=res.results.razorpayOrderId.toString();
  //         String? orderId = res["results"]["razorpay_order_id"].toString();
  //         print("OrderID is ====>>> ${orderId}");
  //         print("Online=====================");
  //
  //         openCheckout(orderId);
  //       }
  //
  //     });
  //   } else {
  //
  //     Fluttertoast.showToast(msg: res['message'].toString() );
  //     setState(() {
  //       _isLoading = false;
  //     });
  //
  //
  //   }
  // }
  Future<void> callOrderPlaceAPI({String? paymentType}) async {
    setState(() {
      _isLoading = true;
    });

    try {
      var res = await _httpService.checkout(
          address_id: widget.address_id!,
          payment_mode: mode!,
          coupan_amount: couponDiscount ?? "0",
          coupan_code: couponController.text.toString(),
          delivery_date: "");
      print("ress===>>$res");
      // Check if the response is null
      if (res == null) {
        throw Exception("API returned null response");
      }

      // Check if 'status' exists and is true
      if (res['status'] == true) {
        setState(() {
          _isLoading = false;
          if (paymentType == "COD") {
            print("COD=====================");
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => OrderSuccessFullScreen()));
          } else if (paymentType == "Online") {
            String? orderId = res["results"]["razorpay_order_id"].toString();
            print("OrderID is ====>>> ${orderId}");
            print("Online=====================");

            openCheckout(orderId);
          }
        });
      } else {
        Fluttertoast.showToast(msg: res['message'].toString());
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      // Handle the error
      Fluttertoast.showToast(msg: "Error: ${e.toString()}");
      setState(() {
        _isLoading = false;
      });
      print("Error occurred: $e");
    }
  }


  CouponModel? couponModel;
  List<CouponData> allCouponList = [];

  Future<void> getAllCoupons() async {
    setState(() {
      _isLoading = true;
    });
    var res = await _httpService.getAllCouponCode();

    if (res['status'] == true) {
      setState(() {
        couponModel = CouponModel.fromJson(res);
        allCouponList = couponModel!.data;

        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String? couponDiscount = "0";
  ApplyCouponCodeModel? applyCouponCodeModel;

  Future<void> applyCoupon() async {
    int roundedPayingAmount = paying_amount.round();

    var res = await _httpService.applyCouponCode(
      price: roundedPayingAmount.toString(),
      coupan_code: couponController.text.toString(),
    );

    if (res['status'] == true) {
      applyCouponCodeModel = ApplyCouponCodeModel.fromJson(res);

      setState(() {
        couponDiscount = applyCouponCodeModel!.data!.coupanDiscount;
      });
      Fluttertoast.showToast(msg: res['message'].toString());
    } else {
      Fluttertoast.showToast(msg: res['message'].toString());
    }
  }

  String? payableAmount(
      String? discountedPrice, String? deleviryCharge, String? couponDiscount) {
    double total = 0;
    String? grandTotal = "0";
    double dp = double.parse(discountedPrice.toString());
    double dc = double.parse(deleviryCharge.toString());
    double cd = double.parse(couponDiscount.toString());

    setState(() {
      total = dp + dc - cd;
      grandTotal = total.toString();
    });
    return grandTotal.toString();
  }

  String? totalSavingFun(String? saving, String? couponDiscount) {
    double totalSaving = 0;
    double savg = double.parse(saving.toString());
    double cd = double.parse(couponDiscount.toString());

    setState(() {
      totalSaving = savg + cd;
    });

    return totalSaving.toString();
  }

  Razorpay? _razorpay;

  @override
  void initState() {
    getAllCoupons();
    getCardDetails();
    super.initState();
    _razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  double _onlineAmount = 0;

  _checkOut() {
    // print('item_total'+item_total.toString());
    _onlineAmount = item_total;
    _onlineAmount = roundDouble(_onlineAmount, 2);
    if (_onlineAmount > 0) {
      // openCheckout((_onlineAmount * 100).toInt());
    }
  }

  void openCheckout(String? orderId) async {
    final _prefs = await SharedPreferences.getInstance();

    var options = {
      'key': razorPayTxnKey,
      // 'amount': double.parse(amount.toString())*100,
      // 'amount': 1 * 100,
      'currency': 'INR',
      'image': 'https://admin.astrogurujii.com/logo/app_logo.png',
      'name': "ASTROGURUJII",
      'description': "AstroGurujii",
      // 'order_id': 'order_123456789',
      'order_id': orderId.toString(),
      'prefill': {
        'contact': _prefs.getString("phone").toString(),
        'email': _prefs.getString("email").toString()
      }
    };

    try {
      _razorpay!.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
    //  _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    setState(() {
      _razorPayTxnId = response.paymentId;
    });

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => OrderSuccessFullScreen()));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message!,
        timeInSecForIosWeb: 10);
    print("message on Fail =====>> ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!, timeInSecForIosWeb: 10);
  }
  // String? _selectedValue = "1";

  // Method to handle radio button changes
  void _handleRadioValueChanged(String? value) {
    setState(() {
      mode = value;
    });
  }
  Widget _selectPaymentOption(String? title, String? selectedOptions){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child:
      ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(title!, style: TextStyle(
          fontSize:  17,
          fontWeight: FontWeight.w800 ,
          color: Colors.grey[700],
        ),),
        trailing: Row(
          mainAxisSize: MainAxisSize.min, // Ensure the row takes only as much width as needed
          children: <Widget>[
            SizedBox(width: 10), // Add horizontal space between the title and radio button
           
            Radio<String>(
  value: selectedOptions!,             // should be a String
  groupValue: mode,                   // should be a String
  onChanged: (String? value) {
    if (value != null) {
      _handleRadioValueChanged(value);
    }
  },
  activeColor: AppColors.orangeColor,
),

          ],
        ),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, // Change back arrow color to white
          ),
          backgroundColor: blueColor,
          title: Text("Order Details", style: TextStyle(color: Colors.white)),
        ),
        body: _isLoading
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : SafeArea(
                child: Column(
                  children: [
                    Expanded(
                        child: ListView(
                      children: [
                        SizedBox(height: 10,),
                        Container(
                          margin:EdgeInsets.all(10),
                          padding: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Shipping Address",
                                style: TextStyle(fontSize: 18.0),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(widget.selected_address ?? ''),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1)),
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
                                    _selectPaymentOption("Online Payment", "Online"),
                                    _selectPaymentOption("From Wallet", "COD"),

                                    // // _buildSummaryRow('Package Type', '${widget.packageName}',isTotal: true),
                                    // _buildSummaryRow('Puja Plan', '₹ ${widget.packageAmount}.00'),
                                    // // Divider(),
                                    // _buildSummaryRow('GST (18%)', '₹${gstCalculate(widget.packageAmount)} %'),
                                    // SizedBox(height: 3),
                                    // Divider(),
                                    // SizedBox(height: 3),
                                    // _buildSummaryRow('Total', '₹ ${total?.toString?AsFixed(2)}', isTotal: true),
                                  ],),

                              )

                            ],
                          ),
                        ),
                        // Container(
                        //   height: 250,
                        //   padding: EdgeInsets.all(5),
                        //   child: Card(
                        //     elevation: 2,
                        //     child: Column(
                        //       mainAxisAlignment: MainAxisAlignment.start,
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         SizedBox(
                        //           height: 10,
                        //         ),
                        //         Text(
                        //           '   Select payment Method',
                        //           style: TextStyle(
                        //               fontSize: 18, color: Colors.black),
                        //         ),
                        //         SizedBox(
                        //           height: 20,
                        //         ),
                        //         SizedBox(
                        //           height: 20,
                        //         ),
                        //         Container(
                        //           height: 50,
                        //           padding: EdgeInsets.symmetric(horizontal: 10),
                        //           width: MediaQuery.of(context).size.width,
                        //           decoration: BoxDecoration(
                        //               borderRadius: BorderRadius.circular(5.0),
                        //               border: Border.all(
                        //                 color: blueColor,
                        //               )),
                        //           margin: EdgeInsets.symmetric(horizontal: 10),
                        //           child: Row(
                        //             children: [
                        //               Container(
                        //                 child: Text(
                        //                   'Online',
                        //                   style: TextStyle(
                        //                       fontSize: 16,
                        //                       color: Colors.black),
                        //                 ),
                        //               ),
                        //               Spacer(),
                        //               Radio(
                        //                   activeColor: blueColor,
                        //                   value: "Online",
                        //                   groupValue: mode,
                        //                   onChanged: (String? value) {
                        //                     setState(() {
                        //                       mode = value;
                        //                     });
                        //                   })
                        //             ],
                        //           ),
                        //         ),
                        //         SizedBox(
                        //           height: 20,
                        //         ),
                        //         Container(
                        //           height: 50,
                        //           padding: EdgeInsets.symmetric(horizontal: 10),
                        //           width: MediaQuery.of(context).size.width,
                        //           decoration: BoxDecoration(
                        //               borderRadius: BorderRadius.circular(5.0),
                        //               border: Border.all(
                        //                 color: blueColor,
                        //               )),
                        //           margin: EdgeInsets.symmetric(horizontal: 10),
                        //           child: Row(
                        //             children: [
                        //               Container(
                        //                 child: Text(
                        //                   'Cash on Delivery',
                        //                   style: TextStyle(
                        //                       fontSize: 16,
                        //                       color: Colors.black),
                        //                 ),
                        //               ),
                        //               Spacer(),
                        //               Radio(
                        //                   activeColor: blueColor,
                        //                   value: "COD",
                        //                   groupValue: mode,
                        //                   onChanged: (val) {
                        //                     setState(() {
                        //                       mode = val;
                        //                     });
                        //                   })
                        //             ],
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        //Payment details card

                        /// coupan
                        allCouponList.isEmpty
                            ? SizedBox()
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Coupons For You',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                            letterSpacing: -0.24,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        AllCouponsScreen(
                                                            onCouponSelected:
                                                                (couponCode) {
                                                              couponController
                                                                      .text =
                                                                  couponCode;
                                                            },
                                                            coupnList:
                                                                allCouponList))).then(
                                                (value) {
                                              setState(() {});
                                            });
                                          },
                                          child: Container(
                                            // color: Colors.red,
                                            child: Text(
                                              'All Coupons >',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Color(0xFFFC7601),
                                                fontSize: 14,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: -0.24,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(
                                      height: 15,

                                    ),

                                    ListView.builder(
                                      itemCount: allCouponList.isNotEmpty
                                          ? 1
                                          : allCouponList.length,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                color: Color(0x33000000)),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: [
                                                        Container(
                                                          height: 100,
                                                          width: 100,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: AppColors
                                                                .primaryOrange,
                                                          ),
                                                        ),
                                                        Center(
                                                          // Center the transform child inside the Stack
                                                          child: Transform(
                                                            alignment: Alignment
                                                                .center,
                                                            // Align transformation around the center
                                                            transform: Matrix4
                                                                .identity()
                                                              ..translate(
                                                                  0.0, 0.0)
                                                              ..rotateZ(-1.57),
                                                            // Rotating the text by -90 degrees
                                                            child: Text(
                                                              // '30% OFF',
                                                              allCouponList[
                                                                          index]
                                                                      .title ??
                                                                  "",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xFFEFEFEF),
                                                                fontSize: 12,
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                letterSpacing:
                                                                    -0.24,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                          // 'SUPERSAVE',
                                                          allCouponList[index]
                                                                  .coupanCode ??
                                                              "",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16,
                                                            fontFamily:
                                                                'Poppins',
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            letterSpacing:
                                                                -0.24,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        Text(
                                                          'Valid Till \n${allCouponList[index].endDate}',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontFamily:
                                                                'Poppins',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            letterSpacing:
                                                                -0.24,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 50,
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        couponController.text =
                                                            allCouponList[index]
                                                                .coupanCode
                                                                .toString();
                                                        setState(() {});
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 20),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              color: AppColors
                                                                  .primaryOrange,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 15,
                                                                    right: 15,
                                                                    bottom: 5,
                                                                    top: 5),
                                                            child: Text(
                                                              'Apply  ',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                letterSpacing:
                                                                    -0.24,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),

                                    SizedBox(
                                      height: 15,
                                    ),

                                    // (reffer_id.isNotEmpty)?Container(
                                    //   child: Row(
                                    //     children: [
                                    //       Text(
                                    //         'code ${reffer_id} Applied',style: TextStyle(fontSize: 18,color: Colors.green),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ):Container(),
                                  ],
                                ),
                              ),

                        Container(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 6,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: TextFormField(
                                    controller: couponController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      labelText: "Coupon Code",
                                      labelStyle: TextStyle(color: Colors.grey),
                                      border: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(6.0),
                                        ),
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(6.0),
                                        ),
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(6.0),
                                        ),
                                        borderSide: BorderSide(
                                            color: Colors.red, width: 1.1),
                                      ),
                                    ),
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: InkWell(
                                  onTap: () async {
                                    setState(() {
                                      if (couponController.text.isNotEmpty) {
                                        applyCoupon();
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "Coupon Code is empty");
                                      }
                                    });
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 56,
                                    margin: EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        left: 10,
                                        right: 10),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 20),
                                    child: Text(
                                      "Apply",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: primaryColor,
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
                        ),

                        SizedBox(
                          height: 10,
                        ),

                        Container(
                          // height: 250,
                          width: double.infinity,
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Payment Details',
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
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      child: Text(
                                        'Actual Price',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color:  Colors.grey[700]),
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                        '\u{20B9} ${actual_total.toString()}', style: TextStyle(color:  Colors.grey[700]),)
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),

                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      child: Text(
                                        'Total Discount',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color:  Colors.grey[700]),
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                        // '\u{20B9} ${paying_amount.toString()}')
                                        '\u{20B9} ${discount.toString()}', style: TextStyle(color:  Colors.grey[700]),)
                                  ],
                                ),
                              ),

                              // (appliedCoupan > 0.0)
                              //     ? Container(
                              //         padding: EdgeInsets.symmetric(
                              //             horizontal: 10),
                              //         child: Row(
                              //           children: [
                              //             Container(
                              //               child: Text(
                              //                 'Discount',
                              //                 style: TextStyle(
                              //                     fontSize: 16,
                              //                     color: Colors.black),
                              //               ),
                              //             ),
                              //             Spacer(),
                              //             Text(
                              //                 '\u{20B9} ${appliedCoupan.toString()}')
                              //           ],
                              //         ),
                              //       )
                              //     : Container(),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      child: Text(
                                        'Delivery Charges',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color:  Colors.grey[700]),
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                        '\u{20B9} ${delivery_charges.toString()}', style: TextStyle(color:  Colors.grey[700]),)
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      child: Text(
                                        'Coupon  Discount',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color:  Colors.grey[700]),
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                        '\u{20B9} ${couponDiscount.toString()}', style: TextStyle(color:  Colors.grey[700]),)
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      child: Text(
                                        'Total Amount',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Spacer(),
                                    // Text('\u{20B9} ${paying_amount.toString()}')
                                    Text(
                                      '\u{20B9} ${payableAmount(paying_amount.toString(), delivery_charges.toString(), couponDiscount)}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                              // SizedBox(
                              //   height: 10,
                              // ),
                              // Container(
                              //   padding: EdgeInsets.symmetric(horizontal: 10),
                              //   child: Row(
                              //     children: [
                              //       Container(
                              //         child: Text(
                              //           'Total Saving',
                              //           style: TextStyle(
                              //               fontSize: 16, color: blueColor),
                              //         ),
                              //       ),
                              //       Spacer(),
                              //       Text(
                              //         // "Rs ${discount}",
                              //         "Rs ${totalSavingFun(discount.toString(), couponDiscount)}",
                              //         style: TextStyle(color: blueColor),
                              //       )
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            //print("Address id Is:${widget.address_id}");
                            setState(() {
                              //_isLoading = true;
                            });

                            if (mode == "COD") {
                              callOrderPlaceAPI(paymentType: mode);
                            } else {
                              callOrderPlaceAPI(paymentType: mode);

                            }
                          },
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(
                                top: 20, bottom: 10, left: 20, right: 20),
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                            child: Text(
                              "Order Now",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            decoration: BoxDecoration(
                              color: primaryColor,
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
                    ))
                  ],
                ),
              ));
  }
}
