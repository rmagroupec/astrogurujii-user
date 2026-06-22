import 'package:astro_gurujii/Screens/HelpUs.dart';
import 'package:astro_gurujii/Screens/Login.dart';
import 'package:astro_gurujii/Screens/Models/profileModel.dart';
import 'package:astro_gurujii/Screens/MyReport.dart';
import 'package:astro_gurujii/Screens/MyWallet.dart';
import 'package:astro_gurujii/Screens/Profile/ProfileScreen.dart';
import 'package:astro_gurujii/Screens/QuestionHistory.dart';
import 'package:astro_gurujii/Screens/ReferUserListScreen.dart';
import 'package:astro_gurujii/Screens/SplashScreen.dart';
import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Screens/mall/MyOrderListSideScreen.dart';
import 'package:astro_gurujii/Screens/mall/WishList.dart';
import 'package:astro_gurujii/Screens/transection_screen/TransactionHistory.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';

import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  _CustomDrawerState createState() => _CustomDrawerState();
}

enum Availability { loading, available, unavailable }

class _CustomDrawerState extends State<CustomDrawer> {
  final HttpServices _httpServices = HttpServices();
  ProfileResults? profileResults;
  String? image;
  var walletAmount = "";
  String currency = '';
  String currencySign = "\u{20B9}";
  Availability _availability = Availability.loading;
  /*final InAppReview inAppReview = InAppReview.instance;
  Availability _availability = Availability.loading;*/
  @override
  void initState() {
    getProfile();
    super.initState();

    getUser();
  }

  var refer_amount = "";
  var referral_code = "";
  void getProfile() async {
    var res = await _httpServices.profile_api();
    if (res!.status == true) {
      setState(() {
        profileResults = res.results;
        refer_amount = res.refer_amount!;
        referral_code = res.results!.referralCode!;
        image = profileResults!.profileImg;
        walletAmount = profileResults!.wallet.toString();
        currency = res.results!.currency!.toString();
        if (currency == "USD") {
          setState(() {
            currencySign = "\u{20B9}";
          });
        } else {
          setState(() {
            currencySign = "\u{20B9}";
          });
        }
        walletAmount = setWallet(res.results!.wallet.toString(),
            res.results!.currency.toString(), res.results!.wallet_usd.toString());
      });
    } else {
      Fluttertoast.showToast(msg: res.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Image.asset(
                          'assets/login/clear.png',
                          width: 40,
                          height: 40,
                        )),
                    InkWell(
                        onTap: () {
                          if (userStaus == "Y") {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                              (Route<dynamic> route) => false,
                            );
                          } else {
                            logoutDialog(context);
                          }
                        },
                        child: CustomText(
                          text: (userStaus == "N") ? 'Logout' : 'Login',
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: redColor,
                        ))
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Stack(
                //  alignment: Alignment.bottomCenter,
                //   fit: StackFit.loose,
                children: [
                  Container(
                    width: 120,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Color(0xFFD1D3FF),
                        width: 10,
                      ),
                    ),
                    child: Center(
                        child: CircleAvatar(
                            radius: 35,
                            backgroundImage: image == null
                                ? const AssetImage('assets/profile/name.png')
                                : NetworkImage(
                                        profileResults!.profileImg.toString())
                                    as ImageProvider)),
                  ),
                  Positioned(
                    bottom: 2,
                    right: 10,
                    child: SizedBox(
                      height: 40,
                      width: 40,
                      child: TextButton(
                          onPressed: () async {
                            final _prefs =
                                await SharedPreferences.getInstance();
                            if (_prefs.get("is_skip") == "Y") {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => LoginPage()),
                                  (route) => false);
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          const ProfileScreen())).then((value) {
                                setState(() {
                                  getProfile();
                                });
                              });
                            }
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF64ffffff),
                                    Color(0xFF64ffffff),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Image.asset(
                                'assets/login/edit.png',
                                width: 55,
                                height: 55,
                              ))),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              CustomText(
                text: profileResults?.name ?? '',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF464646),
                align: TextAlign.center,
              ),
              InkWell(
                onTap: () async {
                  final _prefs = await SharedPreferences.getInstance();
                  if (_prefs.get("is_skip") == "Y") {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => LoginPage()),
                        (route) => false);
                  } else {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => MyWallet()));
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    CustomText(
                      text: 'Balance: ${currencySign}${walletAmount}',
                      color: blueColor,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () async {
                        final _prefs = await SharedPreferences.getInstance();
                        if (_prefs.get("is_skip") == "Y") {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => LoginPage()),
                              (route) => false);
                        } else {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => MyWallet()));
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3,
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: blueColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: CustomText(
                          text: 'Recharge',
                          color: whiteColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => TransactionHistory()));
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/login/trans_history.png',
                          width: 60,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomText(
                          text: 'Transactions',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF464646),
                          align: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => MyOrderListSideScreen()));
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/login/orders.png',
                          width: 35,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomText(
                          text: 'Orders',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF464646),
                          align: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => QuestionHistory()));
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/login/ask_question.png',
                          width: 35,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomText(
                          text: 'Questions',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF464646),
                          align: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (ctx) => MyReport()));
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/login/rate.png',
                          width: 45,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        CustomText(
                          text: 'Reports',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF464646),
                          align: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (ctx) => WishList()));
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/login/heart.png',
                          width: 45,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomText(
                          text: 'Whishlist',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF464646),
                          align: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () async {},
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/login/share_app.png',
                          width: 45,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomText(
                          text: 'Rate Us',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF464646),
                          align: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Share.share(
                          'Download ASTROGURUJII App and get 1 minute free call with your favorite Astrologer- ${"https://play.google.com/store/apps/details?id=com.astro"}');
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/login/share_app.png',
                          width: 35,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomText(
                          text: 'Share app',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF464646),
                          align: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (ctx) => HelpUs()));
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/login/bx_support.png',
                          width: 45,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomText(
                          text: 'Support',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF464646),
                          align: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 30, right: 30),
                child: Divider(
                  color: Color(0xFFD9D9D9),
                  thickness: 2,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              (userStaus == "N")
                  ? Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: 'Invite & Earn',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                    color: Color(0xFF4B4B4B),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  CustomText(
                                    text:
                                        'Get ${currencySign} ${refer_amount} ',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18,
                                    color: Color(0xFF4B4B4B),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Share.share(
                                          'Namaste! I use ASTROGURUJII - 24x7 Astrology'
                                          ' for you; app for online Astrology consultancy. '
                                          'Download the app today with my referral code and'
                                          ' get up to ${currencySign} ${refer_amount}  for free Astrology Consultancy.'
                                          ' Hurry! Only top referrals are eligible'
                                          ' on my referral code.\n\nDownload App:'
                                          ' https://play.google.com/store/apps/details?id=com.astro '
                                          '\n\nUse my referral code: ${referral_code}');
                                    },
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.width / 3,
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: blueColor,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: CustomText(
                                        text: 'Invite Friends',
                                        color: whiteColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                 Container(
                                     child:DottedBorder(
  options: RectDottedBorderOptions(
    color:  primaryColor
        ,
    strokeWidth: 1,
    dashPattern: [4],
    // borderRadius: BorderRadius.circular(8),
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: Container(
      height: 30,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        '${referral_code}',
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontFamily: "MetropolisSemiBold",
        ),
      ),
    ),
  ),
)
                                  )],
                              )),
                          Expanded(
                              flex: 1,
                              child: Image.asset(
                                'assets/login/girl.png',
                                height: 100,
                                width: 200,
                              ))
                        ],
                      ),
                    )
                  : SizedBox(),
              (userStaus == "N")
                  ? InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => ReferUserListScreen()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, top: 10),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            width: MediaQuery.of(context).size.width / 3,
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: greyColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: CustomText(
                              text: 'Friends',
                              color: blackColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  logoutDialog(
    BuildContext context,
  ) {
    return showDialog(
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Center(
          child: CustomText(
            text: "Do you want to logout?",
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: blueColor,
          ),
        ),
        contentPadding: EdgeInsets.zero,
        content: Container(
          height: 150,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 80,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 3.5,
                      height: 43,
                      decoration: BoxDecoration(
                          // gradient: const LinearGradient(
                          //   colors: [
                          //     Color(0xFF34CDDE),
                          //     Color(0xFF2450A1),
                          //   ],
                          //   begin: Alignment.topLeft,
                          //   end: Alignment.bottomRight,
                          //   stops: [0.0, 1.0],
                          // ),
                          color: blueColor,
                          borderRadius: BorderRadius.circular(7)),
                      child: CustomText(
                        text: "Cancel",
                        color: whiteColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      logout();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 3.5,
                      height: 43,
                      decoration: BoxDecoration(
                          // gradient: const LinearGradient(
                          //   colors: [
                          //     Color(0xFF34CDDE),
                          //     Color(0xFF2450A1),
                          //   ],
                          //   begin: Alignment.topLeft,
                          //   end: Alignment.bottomRight,
                          //   stops: [0.0, 1.0],
                          // ),
                          color: blueColor,
                          borderRadius: BorderRadius.circular(7)),
                      child: CustomText(
                        text: "Ok",
                        color: whiteColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
      context: context,
    );
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.clear();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SplashScreen()),
        (Route<dynamic> route) => false,
      );
    });
  }

  var userStaus = "";
  Future<void> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userStaus = prefs.get("is_skip").toString();
    });
  }
}
