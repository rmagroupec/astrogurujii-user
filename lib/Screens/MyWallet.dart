
import 'package:astro_gurujii/Screens/FinalPaymentScreen.dart';
import 'package:astro_gurujii/Screens/Models/profileModel.dart';
import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Screens/transection_screen/TransactionHistory.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Setup/app_colors.dart';
import '../Setup/app_images.dart';
import 'WebServices/model/Wallet_amount_list/Result.dart';
import 'offer/model/Result.dart';

class MyWallet extends StatefulWidget {
  static const String myWallet = "/myWallet";

  @override
  _MyWalletState createState() => _MyWalletState();
}

class _MyWalletState extends State<MyWallet> {
  TextEditingController _amountController = TextEditingController();

  bool isLoading = true;
  HttpServices _httpService = HttpServices();

  // HomeModal homeData;
  String? walletAmount;
  double _onlineAmount = 0;
  bool _isLoading = false;
  String _razorPayTxnId = "";
  ProfileResults? profileResults;
  bool is_loading = true;
  String? image;
  var walletAmounts = "";
  String currency = '';
  String currencySign = "\u{20B9}";

  void getProfile() async {
    var res = await _httpService.profile_api();
    if (res!.status == true) {
      setState(() {
        profileResults = res.results;
        image = profileResults!.profileImg;
        walletAmounts = profileResults!.wallet.toString();

        currency = res.results!.currency.toString();
        if (currency == "USD") {
          setState(() {
            currencySign = "\u{20B9}";
          });
        } else {
          setState(() {
            currencySign = "\u{20B9}";
          });
        }
        walletAmounts = setWallet(res.results!.wallet.toString(), "INR",
            res.results!.wallet_usd.toString());
      });
    } else {
      Fluttertoast.showToast(msg: res.message!);
    }
  }

  List<Resultss> resultsWallet = [];

  void getWalletAmountList() async {
    var res = await _httpService.Wallet_amount_list();
    if (res!.status == true) {
      setState(() {
        resultsWallet = res.results!;
        is_loading = false;
      });
    } else {
      Fluttertoast.showToast(msg: res!.message.toString());
    }
  }

  Result? result;
  List<AddAmount> amount_list = [];
  List<AddAmount> amount_listUSD = [];
  Razorpay? _razorpay;

  @override
  void initState() {
    isLoading = false;
    // TODO: implement initState
    super.initState();
    getWalletAmountList();
    getProfile();
    amount_list.add(AddAmount(50));
    amount_list.add(AddAmount(100));
    amount_list.add(AddAmount(200));
    amount_list.add(AddAmount(500));
    amount_list.add(AddAmount(1000));
    amount_list.add(AddAmount(2000));

    amount_listUSD.add(AddAmount(5));
    amount_listUSD.add(AddAmount(10));
    amount_listUSD.add(AddAmount(20));
    amount_listUSD.add(AddAmount(50));
    amount_listUSD.add(AddAmount(100));
    amount_listUSD.add(AddAmount(200));

    // callWebService();
    _razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    setState(() {
      _razorPayTxnId = response.paymentId!;
    });
    // addWallet();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message.toString(),
        timeInSecForIosWeb: 10);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName.toString(), timeInSecForIosWeb: 10);
  }

/*  Future<void> addWallet() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoading = true;
    });
    var res = await _httpService.addWallet(
        amount: _onlineAmount.toString(), transaction_id: _razorPayTxnId);
    _isLoading = false;
    if (res.result == 'success') {
      //walletAmount = res.wallet;
      setState(() {
        callWebService();
      });
    } else {
      //Fluttertoast.showToast(msg: res.message);
    }
    setState(() {});
  }*/

  _checkOut() {
    _onlineAmount = double.parse(_amountController.text);
    //_onlineAmount = roundDouble(_onlineAmount, 2);
    if (_onlineAmount > 0) {
      openCheckout((_onlineAmount * 100).toInt());
    }
  }

  void openCheckout(int amount) async {
    final _prefs = await SharedPreferences.getInstance();
    var options = {
      'key': "rzp_test_G19VhzaJPCOP0h",
      'amount': amount,
      'currency': 'INR',
      'name': _prefs.getString("name"),
      'description': "Astrogurujii",
      //'order_id': 'order_123456789',
      'prefill': {
        'contact': _prefs.getString("phone"),
        'email': _prefs.getString("email")
      }
    };

    try {
      _razorpay!.open(options);
    } catch (e) {
      //debugPrint(e.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay!.clear();
  }

  String? editableText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SingleChildScrollView(
        child: is_loading
            ? Center(
                child: Lottie.asset(
                'assets/profile/loader.json',
              ))
            : SafeArea(
                child: Container(
                  color: whiteColor,
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: blueColor,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20))),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Icon(
                                      Icons.arrow_back_ios_new,
                                      color: whiteColor,
                                      size: 25,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    " My Wallet",
                                    style: TextStyle(
                                        fontSize: 20, color: whiteColor,fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 50,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 1,
                              ),
                              Column(
                                children: [
                                  Image.asset(
                                    AppImages.circular_image_icon,
                                    width: 150,
                                    height: 150,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "ASTROGURUJII",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: whiteColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),

                                  // Padding(
                                  //   padding: const EdgeInsets.only(top: 10,left: 10,right: 30,bottom: 10),
                                  //   child: Row(
                                  //     crossAxisAlignment: CrossAxisAlignment.center,
                                  //     mainAxisAlignment: MainAxisAlignment.center,
                                  //     children: [
                                  //       Text(
                                  //         "Available Balance -  ",
                                  //         style: TextStyle(
                                  //             fontSize: 20,
                                  //             color: whiteColor,
                                  //             fontWeight: FontWeight.w600),
                                  //       ),
                                  //
                                  //       Row(
                                  //         children: [
                                  //           Text(
                                  //             currencySign,
                                  //             style:
                                  //             TextStyle(color: whiteColor, fontSize: 20),
                                  //           ),
                                  //           SizedBox(
                                  //             width: 10,
                                  //           ),
                                  //           Text(
                                  //             "${walletAmounts}",
                                  //             style:
                                  //             TextStyle(color: whiteColor, fontSize: 20),
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     ],
                                  //   ),
                                  // )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),



                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.mlightPink,
                             borderRadius: BorderRadius.circular(20)
                          ),

                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(children: [

                              Row(children: [
                                CustomText(

                                  text: "Wallet Balance",
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,

                                ),
                              ],),
                              SizedBox(height: 8,),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                Row(children: [
                                  Text(
                                    currencySign,
                                    style: TextStyle(color: Colors.black, fontSize: 35),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "${walletAmounts}",
                                    style: TextStyle(color: Colors.black, fontSize: 35,fontWeight: FontWeight.bold),
                                  ),
                                ]),

                                InkWell(
                                  onTap: (){

                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (ctx) => TransactionHistory()));
                                  },

                                  child: Container(
                                    padding: EdgeInsets.only(left: 20,right: 20,top: 5,bottom: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadiusDirectional.circular(20),
                                      border: Border.all(color: Colors.black,width: 2)
                                    ),
                                    child: Text(
                                          "Show History",style: TextStyle( fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 16,
                                    decoration: TextDecoration.underline
                                    ),


                                    ),
                                  ),
                                )

                              ],)
                            ],),
                          ),
                        ),
                      ),





                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        // height: MediaQuery.of(context).size.height / 1.45,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.0, 1.0), //(x,y)
                                blurRadius: 2.0,
                                blurStyle: BlurStyle.outer),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20, top: 20),
                              child: Text(
                                "Available Offers",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            /* Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 50),
                              child: Row(
                                children: [
                                  Text(
                                    currencySign,
                                    style:
                                        TextStyle(color: yellow, fontSize: 20),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "${walletAmounts}",
                                    style:
                                        TextStyle(color: yellow, fontSize: 20),
                                  ),
                                  Spacer(),
                                  */ /* Column(
                              children: [
                                Text("Min Amount to be \nadd" +
                                    " ${"${currencySign} 200"} and max" +
                                    "${"${currencySign} 1000"}")
                              ],
                            )*/ /*
                                ],
                              ),
                            ),*/
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(left: 5, right: 5),
                                child: GridView.count(
                                  crossAxisCount: 3,
                                  childAspectRatio: (1 / .5),
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  children: List.generate(resultsWallet.length,
                                      (index) {
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (ctx) =>
                                                    FinalPaymentScreen(
                                                        offer_id:
                                                            resultsWallet[index]
                                                                .offer_id,
                                                        amount: resultsWallet[
                                                                index]
                                                            .recharge_amount,
                                                        offer:
                                                            resultsWallet[index]
                                                                .offer,
                                                        currency: "INR"))).then(
                                            (value) => {
                                                  getProfile(),
                                                });
                                      },
                                      child: Card(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                    color: primaryColor
                                                        .withOpacity(0.0),
                                                    blurStyle: BlurStyle.outer,
                                                    offset: Offset(0.0, 1.0),
                                                    //(x,y)
                                                    blurRadius: 8.0,
                                                    spreadRadius: 1)
                                              ],
                                              border: Border.all(
                                                  color: primaryColor),
                                              color: whiteColor,
                                              shape: BoxShape.rectangle),
                                          child: Column(
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Container(
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                          '${resultsWallet[index].currency == "INR" ? '\u{20B9}' : "\u{20B9}"} ${resultsWallet[index].recharge_amount}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 18),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              (resultsWallet[index]
                                                      .msg!
                                                      .isNotEmpty)
                                                  ? Container(
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: primaryColor
                                                                    .withOpacity(
                                                                        0.0),
                                                                blurStyle:
                                                                    BlurStyle
                                                                        .outer,
                                                                offset: Offset(
                                                                    0.0, 1.0),
                                                                //(x,y)
                                                                blurRadius: 8.0,
                                                                spreadRadius: 1)
                                                          ],
                                                          border: Border.all(
                                                              color:
                                                                  primaryColor),
                                                          color: primaryColor,
                                                          shape: BoxShape
                                                              .rectangle),
                                                      child: Align(
                                                        child: Text(
                                                          '${resultsWallet[index].msg}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14),
                                                        ),
                                                      ),
                                                    )
                                                  : const SizedBox()
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: AppColors.mlightPink,
                borderRadius: BorderRadius.circular(5)
            ),
            child: Text("Additional 18% GST is applicable on all recharge packs (T&C applied)", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400), textAlign: TextAlign.left
              ,),
          ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  double minimum_order_price = 0.0;
  double coupan_discount = 0.0;
  double discount_amount_up_to = 0.0;
  double editAmount = 0.0;
  double discountedPrice = 0.0;
  double profitAmount = 0.0;

  void getOffer(Result result) {
    if (result.discount_type == "Percentage") {
      minimum_order_price = double.parse(result.minimum_order_price!);
      coupan_discount = double.parse(result.coupan_discount!);
      discount_amount_up_to = double.parse(result.discount_amount_up_to!);
      editAmount = double.parse(_amountController.text);
      discountedPrice = editAmount - (coupan_discount * editAmount) / 100.0;
      profitAmount = editAmount - discountedPrice;

      if (editAmount >= minimum_order_price) {
        if (profitAmount <= discount_amount_up_to) {
        } else {
          profitAmount = discount_amount_up_to;
        }
      } else {
        profitAmount = 0;
      }
    } else if (result.discount_type == "Fixed") {
      minimum_order_price = double.parse(result.minimum_order_price!);
      coupan_discount = double.parse(result.coupan_discount!);
      discount_amount_up_to = double.parse(result.discount_amount_up_to!);
      editAmount = double.parse(_amountController.text);
      if (editAmount >= minimum_order_price) {
        profitAmount = coupan_discount;
      } else {
        profitAmount = 0;
      }
    }
  }
}

String setWallet(String wallet, String currency, String usdWallet) {
  if (currency == "USD") {
    return "${usdWallet}";
  } else {
    return "${wallet}";
  }
}

class AddAmount {
  int amount;

  AddAmount(this.amount);
}
