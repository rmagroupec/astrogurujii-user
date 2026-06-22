
import 'dart:async';

import 'package:astro_gurujii/Screens/homeScreen/Home.dart';
import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Screens/mall/wallet_payment_success_screen.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Setup/SetUp.dart';
import '../widget/bottom_navigation_bar_custom.dart';
import 'mall/OrderSuccessFullScreen.dart';

class FinalPaymentScreen extends StatefulWidget {
  static const String finalPaymentScreen = "/finalCheckoutScreen";
  var amount;
  var offer_id;
  var offer;
  var currency;
  FinalPaymentScreen({this.amount, this.offer, this.currency, this.offer_id});
  @override
  _FinalPaymentScreenState createState() => _FinalPaymentScreenState();
}

class _FinalPaymentScreenState extends State<FinalPaymentScreen> {
  int? selectedRadio;

  bool? isLoading;
  HttpServices _httpService = HttpServices();
  String? walletAmount;
  double _onlineAmount = 0;
  bool _isLoading = false;
  String _razorPayTxnId = "";
  double netPrice = 0.0;
  double origenalPrice = 0.0;
  int gstPercent = 18;
  double gstCalcutale = 18;
  Razorpay? _razorpay;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPrice();

    _razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void getPrice() async {
    setState(() {
      origenalPrice = double.parse(widget.amount);
      if (widget.currency == "USD") {
        gstCalcutale = (origenalPrice * 0) / 100;
        netPrice = origenalPrice + 0;
      } else {
        gstCalcutale = (origenalPrice * gstPercent) / 100;
        netPrice = origenalPrice + gstCalcutale;
      }
    });
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    setState(() {
      _razorPayTxnId = response.paymentId.toString();
    });
    addWallet();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg:
            "Your payment for ASTROGURUJII was not completed. Any amount if debited will be added in your wallet or refunded within 2-3 days",
        timeInSecForIosWeb: 10);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg:
            "Your payment for ASTROGURUJII was not completed. Any amount if debited will be added in your wallet or refunded within 2-3 days",
        timeInSecForIosWeb: 10);
  }

  Future<void> addWallet() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoading = true;
    });
    var res = await _httpService.addWallet(
        amount: _onlineAmount.toString(),
        offer_id: widget.offer_id,
        transaction_id: _razorPayTxnId,
        wallet_amount: wallerBonus(origenalPrice,
            double.parse(getBonus(widget.amount, double.parse(widget.offer)))), profit_amount: '', coupan_code: '');
    _isLoading = false;
    if (res!.status == true) {
      //walletAmount = res.wallet;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => WalletPaymentSuccessScreen()));
      // setState(() {
      //   showAnimatedAlertDialog(context, res.message);
      // });
    } else {
      Fluttertoast.showToast(
          msg:
              "Your payment for ASTROGURUJII was not completed. Any amount if debited will be added in your wallet or refunded within 2-3 days",
          timeInSecForIosWeb: 10);
    }
    setState(() {});
  }

  void openCheckout(int amount) async {
    final _prefs = await SharedPreferences.getInstance();

    var options = {
      'key': razorPayTxnKey,
      'amount': amount,
      'currency': widget.currency,
      // 'image':'assets/images/AstroGurijiIcon.png',
      'image':'https://admin.astrogurujii.com/logo/app_logo.png',

      // 'name': _prefs.getString("name"),
      'name':"ASTROGURUJII",

      'description': "ASTROGURUJII",
      //'order_id': 'order_123456789',
      'prefill': {
        'contact': _prefs.getString("phone"),
        'email': _prefs.getString("email")
      }
    };

    try {
      _razorpay!.open(options);
    } catch (e) {
      // debugPrint(e.toString());
    }
  }

  _checkOut() {
    _onlineAmount = netPrice;
    _onlineAmount = roundDouble(_onlineAmount, 2);
    if (_onlineAmount > 0) {
      openCheckout((_onlineAmount * 100).toInt());
    }
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay!.clear();
  }

/*
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedRadio = 0;
  }
*/

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: primaryColor,
      statusBarBrightness: Brightness.dark,
    ));
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: Container(
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: whiteColor,
                        )),
                    CustomText(
                      text: "PAYMENT INFORMATION",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: whiteColor,
                    ),
                  ],
                ),
              ],
            ),
          )),
      body: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Column(
          children: [
            Expanded(
                child: ListView(
              children: [
                /* Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 10, bottom: 10),
                          child: Text(
                            "Select Payment Method",
                            style: TextStyle(
                                fontSize: 19, fontWeight: FontWeight.w500),
                          )),
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedRadio = 1;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Color(blueGreyColor))),
                          child: ListTile(
                            title: Text(
                              "Debit/ Credit Card/ Net Banking",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            trailing: Radio(
                                activeColor: Color(pinkColor),
                                value: 1,
                                groupValue: selectedRadio,
                                onChanged: (val) {
                                  setSelectedRadio(val);
                                }),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedRadio = 2;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Color(blueGreyColor))),
                          child: ListTile(
                              title: Text(
                                "Pay With Paytm",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              trailing: Radio(
                                  activeColor: Color(pinkColor),
                                  value: 2,
                                  groupValue: selectedRadio,
                                  onChanged: (val) {
                                    setSelectedRadio(val);
                                  })),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedRadio = 3;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Color(blueGreyColor))),
                          child: ListTile(
                            title: Text(
                              "Pay with Wallet",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            trailing: Radio(
                                activeColor: Color(pinkColor),
                                value: 3,
                                groupValue: selectedRadio,
                                onChanged: (val) {
                                  setSelectedRadio(val);
                                }),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),*/
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(color: Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Text(
                          "Payment Summary",
                          style: TextStyle(
                              fontSize: 21, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Divider(
                        color: Color(blueGreyColor),
                        thickness: 1,
                      ),
                      Container(
                        height: 180,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                            child: Text(
                                          "Total Amount",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        )),
                                      ),
                                      Text(
                                        '${widget.currency == "INR" ? '\u{20B9}' : "\u{20B9}"} ${origenalPrice.toStringAsFixed(1)}',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 9,
                                        child: (widget.currency == "USD")
                                            ? SizedBox(
                                                height: 0,
                                              )
                                            : Text(
                                                "GST@18%",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: (widget.currency == "USD")
                                            ? SizedBox(
                                                height: 0,
                                              )
                                            : Text(
                                                "${widget.currency == "INR" ? '\u{20B9}' : "\u{20B9}"} ${gstCalcutale.toStringAsFixed(1)}",
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 9,
                                        child: Text(
                                          "Amount Payable",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          "${widget.currency == "INR" ? '\u{20B9}' : "\u{20B9}"} ${netPrice.toStringAsFixed(1)}",
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 9,
                                        child: Text(
                                          "Bonus Wallet Amount",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          "${widget.currency == "INR" ? '\u{20B9}' : "\u{20B9}"} ${getBonus(widget.amount, double.parse(widget.offer))}",
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 9,
                                        child: Text(
                                          "Total Wallet Amt.incl. Cashback Amt",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          "${widget.currency == "INR" ? '\u{20B9}' : "\u{20B9}"} ${wallerBonus(origenalPrice, double.parse(getBonus(widget.amount, double.parse(widget.offer))))}",
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    width: double.infinity,
                    // color: Color(blueGreyColor),
                    color: Colors.brown,

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Pay",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        Text(
                          "${widget.currency} ${netPrice.toStringAsFixed(1)}/-",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        )
                      ],
                    ))
              ],
            )),
            InkWell(
              onTap: () {
                _checkOut();
              },
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 30),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                child: Text(
                  "PAY NOW",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
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
            )
          ],
        ),
      ),
    );
  }

  // showAlertDialog(BuildContext context, String message) async {
  //   // set up the button
  //   BuildContext dialogContext;
  //   // set up the AlertDialog
  //   AlertDialog alert = AlertDialog(
  //     title: Column(
  //       children: [
  //         SizedBox(
  //           height: 10,
  //         ),
  //         Center(child: Text("Thank you")),
  //       ],
  //     ),
  //     content: Container(
  //       height: 200,
  //       child: Column(
  //         children: [
  //           Text(
  //             message,
  //             style: TextStyle(
  //                 color: blackColor,
  //                 fontSize: 14,
  //                 fontWeight: FontWeight.normal),
  //           ),
  //           SizedBox(
  //             height: 30,
  //           ),
  //           InkWell(
  //             onTap: () async {
  //               Navigator.of(context).pop();
  //               Navigator.of(context).pushAndRemoveUntil(
  //                   MaterialPageRoute(builder: (context) => Home()),
  //                   (Route<dynamic> route) => false);
  //             },
  //             child: Container(
  //               height: 40,
  //               decoration: BoxDecoration(
  //                 gradient: LinearGradient(
  //                   colors: [
  //                     Color(0xFFFC7601),
  //                     Color(0xFFFC7601),
  //                   ],
  //                 ),
  //                 borderRadius: BorderRadius.circular(30),
  //                 boxShadow: [
  //                   BoxShadow(
  //                     color: Colors.grey,
  //                     offset: Offset(0.0, 1.0), //(x,y)
  //                     blurRadius: 2.0,
  //                   ),
  //                 ],
  //               ),
  //               width: double.infinity,
  //               margin: EdgeInsets.only(left: 20, right: 20),
  //               child: Center(
  //                 child: Text(
  //                   "OK",
  //                   style: TextStyle(
  //                       color: whiteColor,
  //                       fontSize: 13,
  //                       fontWeight: FontWeight.w500),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  //
  //   // show the dialog
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }

  void showAnimatedAlertDialog(BuildContext context, String message) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (context, animation1, animation2) {
        return const SizedBox.shrink();
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
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => MainHomeScreenWithBottomNavigation()),
                              (Route<dynamic> route) => false,
                        );
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

  getBonus(amount, offer) {
    var cal_percent_amount =
        (double.tryParse(amount.toString())! * (offer / 100)).toString();
    return cal_percent_amount;
  }

  wallerBonus(double origenalPrice, double parse) {
    return (origenalPrice + parse).toStringAsFixed(1);
  }
}
