import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:astro_gurujii/Screens/chats_screen/Loading.dart';
import 'package:astro_gurujii/Screens/poojaScreen/controller/controller.dart';
import 'package:astro_gurujii/Screens/poojaScreen/ui/poojaDetailScreen.dart';
import 'package:astro_gurujii/Utilities/banner_loader.dart';
import 'package:astro_gurujii/widget/bottom_navigation_bar_custom.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Setup/SetUp.dart';
import '../../../Setup/app_colors.dart';
import '../../../Utilities/CustomText.dart';
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
import '../model/poojaListingModel.dart';

class PoojaScreen extends StatefulWidget {
  const PoojaScreen();

  @override
  State<PoojaScreen> createState() => _PoojaScreenState();
}

class _PoojaScreenState extends State<PoojaScreen> {
  PoojaController screenController = Get.put(PoojaController());
  var notifications_count = 0;
  final controllerHomePageLogic = Get.put(HomePageLogic());
  var terms = "https://api.astrogurujii.com/links/termandcondition";
  var privacy = "https://api.astrogurujii.com/links/privacypolicy";
  var aboutus = "https://api.astrogurujii.com/links/aboutus";
  var contactus = "https://api.astrogurujii.com/links/contactus";

  Data2? data2;
  bool _isLoading = true;

  WattingUserData? watting_user_data;

  void getChatStatus() async {
    setState(() {});
    var res = await _httpServices.lastCallList();
    if (res!.result == true) {
      setState(() {
        try {
          data2 = res.data2;
          if (data2!.callType == "chat" || data2!.callType == "Chat") {
            if (res.watting_user_data != null) {
              watting_user_data = res.watting_user_data;
            }
          }

          _isLoading = false;
        } catch (e) {}
      });
    } else {
      Fluttertoast.showToast(msg: res.message!);
      // _refreshController.refreshCompleted();
    }
  }

  final HttpServices _httpServices = HttpServices();

  var name = "";
  var mobile = "";
  var image = "";
  var wallet = "";
  String currency = "";
  var walletAmount = "";
  ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    // Dispose of the controller to avoid memory leaks
    _scrollController.dispose();
    super.dispose();
  }

  // Step 3: Function to scroll to the top
  void _scrollToTop() {
    _scrollController.animateTo(
      0.0, // Scroll to the top
      duration: Duration(milliseconds: 300),
      // Duration for the scroll animation
      curve: Curves.easeInOut, // Animation curve
    );
  }

  getProfile() async {
    var res = await _httpServices.profile_api();
    if (res!.status == true) {
      setState(() {
        //currency = res.results.currency.toString();
        currency = "INR";
        wallet = setWallet(res.results!.wallet.toString(), "INR",
            res.results!.wallet_usd.toString());
        walletAmount = res.results!.wallet.toString();
        notifications_count = res.notifications_count;
        name = res.results!.name!;
        mobile = res.results!.number!;
        image = res.results!.profileImg!;
      });
    } else {
      Fluttertoast.showToast(msg: res.message!);
    }
  }

  bool search_click_status = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfile();

    screenController.poojaListingApi();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
       onWillPop: () async {
        
      Navigator.push(context, MaterialPageRoute(builder: (context) => MainHomeScreenWithBottomNavigation()));
      return false;
      },
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(62.0),
            child: AppBar(
              leading: Builder(
                builder: (BuildContext context) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        padding: EdgeInsets.only(left: 10),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                        icon: SvgPicture.asset(
                          'assets/images/lines_three.svg',
                          height: 18,
                          width: 18,
                          color: whiteColor,
                        ),
                      ),

                      // Container(
                      //   padding: EdgeInsets.all(5),
                      //   decoration: BoxDecoration(
                      //       color: Colors.white,
                      //       borderRadius: BorderRadius.circular(20)),
                      //   child: Image.asset(
                      //     'assets/image/astro-logo-apbar.png',
                      //     height: 25,
                      //     width: 25,
                      //     fit: BoxFit.contain,
                      //   ),
                      // ),
                    ],
                  );
                },
              ),
              leadingWidth: Get.width * 0.18,
              automaticallyImplyLeading: false,
              // titleSpacing: -2,
              title: CustomText(
                text: "Astro Gurujii Puja",
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),

              // Container(
              //   child: Image.asset(
              //     'assets/images/name_astro_guruji.png',
              //     height: 20,
              //     width: Get.width * .3,
              //   ),
              // ),
              // title: Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //
              //     SizedBox(
              //       width: Get.width*0.14,
              //     ),
              //
              //   ],
              // ),

              elevation: 0,
              backgroundColor: Color(0xffFC7601),
              actions: [
                InkWell(
                    onTap: () {
                      setState(() {
                        if (search_click_status) {
                          _scrollToTop();
                          search_click_status = false;
                        } else {
                          _scrollToTop();
                          search_click_status = true;
                        }
                      });
                    },
                    child: SvgPicture.asset(
                      'assets/login/Search.svg',
                      color: whiteColor,
                    )),
                SizedBox(width: 10,),
                (wallet != null)
                    ? Align(
                  alignment: Alignment.center,
                  child: InkWell(
                      onTap: () async {
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
                                  builder: (_) => MyWallet()));
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border:
                            Border.all(color: Colors.white, width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8, right: 8, top: 4, bottom: 4),
                          child: CustomText(
                            text: "₹ ${wallet}",
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )

                    // Image.asset(
                    //   'assets/icon/wallet_icon_toolbar.png',
                    //   height: 20,
                    //   width: 20,
                    //   color: whiteColor,
                    // )

                  ),
                  /*CustomText(
                            text: (currency == "USD")
                                ? '\u{20B9}${wallet}'
                                : '\u{20B9}${wallet}',
                            color: whiteColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          )),*/
                )
                    : SizedBox(),
                const SizedBox(
                  width: 10,
                ),
                // InkWell(
                //     onTap: () {
                //       /*Navigator.push(context, MaterialPageRoute(builder: (_)=>CartScreen()));*/
                //       Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //               builder: (ctx) => LanguageChangeScreen()));
                //     },
                //     child: Image.asset(
                //       'assets/icon/language.png',
                //       height: 25,
                //       width: 25,
                //       color: whiteColor,
                //     )),
                // const SizedBox(
                //   width: 10,
                // ),
                // /* 'assets/login/notification.svg',*/
                // InkWell(
                //     onTap: () {
                //       setState(() {
                //         notifications_count = 0;
                //       });
                //       Navigator.push(
                //           context, MaterialPageRoute(builder: (_) => HelpUs()));
                //       /* Navigator.push(context,
                //         MaterialPageRoute(builder: (_) => NotificationScreen()));*/
                //     },
                //     child: Padding(
                //       padding: const EdgeInsets.only(top: 15, right: 6),
                //       child: Stack(
                //         children: <Widget>[
                //           Image.asset(
                //             'assets/icon/support_toolbar_icon.png',
                //             height: 25,
                //             width: 25,
                //             color: whiteColor,
                //           ),
                //           /*Positioned(
                //           top: 0.0,
                //           right: 0.0,
                //           child: Container(
                //             width: 8.0,
                //             height: 8.0,
                //             decoration: BoxDecoration(
                //                 shape: BoxShape.circle,
                //                 color: (notifications_count > 0)
                //                     ? Colors.red.shade600
                //                     : Colors.white),
                //           ),
                //         ),*/
                //         ],
                //       ),
                //     )),
                // const SizedBox(
                //   width: 10,
                // ),
              ],
            ),
          ),
          drawer: Drawer(
            child: ListView(
              children: [ InkWell(
                  onTap: () async {
                    final _prefs = await SharedPreferences.getInstance();
                    if (_prefs.get("is_skip") == "Y") {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => LoginPage()),
                              (route) => false);
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ProfileScreen()))
                          .then((value) {
                        setState(() {
                          getProfile();
                        });
                      });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: AppColors.orangeColor,
                          child: image.isEmpty
                              ? CircleAvatar(
                            radius: 30,
                            backgroundImage:
                            AssetImage("assets/profile/name.png"),
                          )
                              : CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(image),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: "Hi " + name,
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            CustomText(
                              text: "View your details",
                              fontSize: 14,
                              color: AppColors.orangeColor,
                              fontWeight: FontWeight.bold,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Divider(
                  thickness: 1,
                  color: AppColors.orangeColor,
                ),

                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => TransactionHistory()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 10, top: 20, bottom: 5),
                    child: Row(
                      children: [
                        SizedBox(
                            height: 28,
                            width: 28,
                            child: Image.asset(
                                "assets/d_icons/my_transaction_icon.png")),
                        SizedBox(
                          width: 20,
                        ),
                        CustomText(
                          text: "My Transaction",
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        Spacer(),
                        SizedBox(
                            height: 14,
                            width: 14,
                            child: Image.asset(
                                "assets/d_icons/arrow_right_icon.png")),
                      ],
                    ),
                  ),
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
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 10, top: 20, bottom: 5),
                    child: Row(
                      children: [
                        SizedBox(
                            height: 24,
                            width: 24,
                            child: Image.asset(
                                "assets/d_icons/my_wallet_icon.png")),
                        SizedBox(
                          width: 20,
                        ),
                        CustomText(
                          text: "My Wallet",
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        Spacer(),
                        SizedBox(
                            height: 14,
                            width: 14,
                            child: Image.asset(
                                "assets/d_icons/arrow_right_icon.png")),
                      ],
                    ),
                  ),
                ),

                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                TalkAstrologer(
                                  astroList:
                                  controllerHomePageLogic.astroListChat,
                                  appBarName: "Following",
                                  chatKey: "on",
                                  talkKey: "",
                                  screen: "home",
                                  skill_id: "",
                                  videoKey: "",
                                  callType: "chat",
                                  followAstro: "1",
                                ))).then((value) => {getChatStatus()});
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 10, top: 20, bottom: 5),
                    child: Row(
                      children: [
                        SizedBox(
                            height: 24,
                            width: 24,
                            child:
                            Image.asset("assets/d_icons/my_following.png")),
                        SizedBox(
                          width: 20,
                        ),
                        CustomText(
                          text: "My Following",
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        Spacer(),
                        SizedBox(
                            height: 14,
                            width: 14,
                            child: Image.asset(
                                "assets/d_icons/arrow_right_icon.png")),
                      ],
                    ),
                  ),
                ),

                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (ctx) => PoojaOrderList()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 10, top: 20, bottom: 5),
                    child: Row(
                      children: [
                        SizedBox(
                            height: 24,
                            width: 24,
                            child: Image.asset("assets/d_icons/my_orders.png")),
                        SizedBox(
                          width: 20,
                        ),
                        CustomText(
                          text: "My Bookings",
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        Spacer(),
                        SizedBox(
                            height: 14,
                            width: 14,
                            child: Image.asset(
                                "assets/d_icons/arrow_right_icon.png")),
                      ],
                    ),
                  ),
                ),

                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => MyOrderListSideScreen()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 10, top: 20, bottom: 5),
                    child: Row(
                      children: [
                        SizedBox(
                            height: 24,
                            width: 24,
                            child:
                            Image.asset("assets/d_icons/astro_mall.png")),
                        SizedBox(
                          width: 20,
                        ),
                        CustomText(
                          text: "Astromall",
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        Spacer(),
                        SizedBox(
                            height: 14,
                            width: 14,
                            child: Image.asset(
                                "assets/d_icons/arrow_right_icon.png")),
                      ],
                    ),
                  ),
                ),

                InkWell(
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (ctx) => HelpUs()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 10, top: 20, bottom: 5),
                    child: Row(
                      children: [
                        SizedBox(
                            height: 24,
                            width: 24,
                            child:
                            Image.asset("assets/d_icons/support_icon.png")),
                        SizedBox(
                          width: 20,
                        ),
                        CustomText(
                          text: "Customer Support",
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        Spacer(),
                        SizedBox(
                            height: 14,
                            width: 14,
                            child: Image.asset(
                                "assets/d_icons/arrow_right_icon.png")),
                      ],
                    ),
                  ),
                ),

                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (ctx) => RagisterAstro()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 10, top: 20, bottom: 5),
                    child: Row(
                      children: [
                        SizedBox(
                            height: 24,
                            width: 24,
                            child: Image.asset(
                                "assets/d_icons/astro_ragistration.png")),
                        SizedBox(
                          width: 20,
                        ),
                        CustomText(
                          text: "Astrologer Registration",
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        Spacer(),
                        SizedBox(
                            height: 14,
                            width: 14,
                            child: Image.asset(
                                "assets/d_icons/arrow_right_icon.png")),
                      ],
                    ),
                  ),
                ),

                InkWell(
                  onTap: () {
                    Share.share(
                        'https://play.google.com/store/apps/details?id=com.user.astrogurujii');
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 10, top: 20, bottom: 5),
                    child: Row(
                      children: [
                        SizedBox(
                            height: 24,
                            width: 24,
                            child:
                            Image.asset("assets/d_icons/refer_icon.png")),
                        SizedBox(
                          width: 20,
                        ),
                        CustomText(
                          text: "Refer a friend",
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        Spacer(),
                        SizedBox(
                            height: 14,
                            width: 14,
                            child: Image.asset(
                                "assets/d_icons/arrow_right_icon.png")),
                      ],
                    ),
                  ),
                ),

                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) =>
                                WebViewerTerms(
                                    appbarText: "About Us", webUrl: aboutus)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 10, top: 20, bottom: 5),
                    child: Row(
                      children: [
                        SizedBox(
                            height: 24,
                            width: 24,
                            child: Image.asset(
                                "assets/d_icons/about_us_icon.png")),
                        SizedBox(
                          width: 20,
                        ),
                        CustomText(
                          text: "About us",
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        Spacer(),
                        SizedBox(
                            height: 14,
                            width: 14,
                            child: Image.asset(
                                "assets/d_icons/arrow_right_icon.png")),
                      ],
                    ),
                  ),
                ),

                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) =>
                                WebViewerTerms(
                                    appbarText: "Privacy Policy",
                                    webUrl: privacy)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 10, top: 20, bottom: 5),
                    child: Row(
                      children: [
                        SizedBox(
                            height: 24,
                            width: 24,
                            child:
                            Image.asset("assets/d_icons/pravicy_icon.png")),
                        SizedBox(
                          width: 20,
                        ),
                        CustomText(
                          text: "Privacy Policy",
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        Spacer(),
                        SizedBox(
                            height: 14,
                            width: 14,
                            child: Image.asset(
                                "assets/d_icons/arrow_right_icon.png")),
                      ],
                    ),
                  ),
                ),

                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) =>
                                WebViewerTerms(
                                    appbarText: "Terms & Conditions",
                                    webUrl: terms)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 10, top: 20, bottom: 5),
                    child: Row(
                      children: [
                        SizedBox(
                            height: 24,
                            width: 24,
                            child:
                            Image.asset("assets/d_icons/t_and_c_icon.png")),
                        SizedBox(
                          width: 20,
                        ),
                        CustomText(
                          text: "Terms & Conditions",
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        Spacer(),
                        SizedBox(
                            height: 14,
                            width: 14,
                            child: Image.asset(
                                "assets/d_icons/arrow_right_icon.png")),
                      ],
                    ),
                  ),
                ),

                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 15),
                //   child: TextButton(
                //       onPressed: () {
                //         logout();
                //       },
                //       child: Row(
                //         children: [
                //           SvgPicture.asset(
                //             'assets/Icons/drawer/log.svg',
                //             height: 30,
                //             width: 30,
                //             //color: Color(0xFF5D5D5D),
                //           ),
                //           SizedBox(
                //             width: 20,
                //           ),
                //           Text(
                //             'Logout',
                //             style:
                //             TextStyle(color: Color(0xFFFF7C5D), fontSize: 18),
                //           )
                //         ],
                //       )),
                // ),

                Divider(
                  thickness: 1,
                  color: AppColors.orangeColor,
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 20, bottom: 10),
                  child: CustomText(
                    text: "Also available on",
                    fontSize: 14,
                    color: Colors.black54,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                        margin: EdgeInsets.all(5),
                        height: 28,
                        width: 28,
                        child: Image.asset("assets/d_icons/apple_icon.png")),
                    Container(
                        margin: EdgeInsets.all(5),
                        height: 28,
                        width: 28,
                        child: Image.asset("assets/d_icons/website.png")),
                    Container(
                        margin: EdgeInsets.all(5),
                        height: 28,
                        width: 28,
                        child: Image.asset("assets/d_icons/youtube.png")),
                    Container(
                        margin: EdgeInsets.all(5),
                        height: 28,
                        width: 28,
                        child: Image.asset("assets/d_icons/facebook.png")),
                    Container(
                        margin: EdgeInsets.all(5),
                        height: 28,
                        width: 28,
                        child: Image.asset("assets/d_icons/instagram.png")),
                    Container(
                        margin: EdgeInsets.all(5),
                        height: 28,
                        width: 28,
                        child: Image.asset("assets/d_icons/linkedin.png")),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 20, bottom: 10),
                  child: CustomText(
                    text: "Version 1.1.73",
                    fontSize: 14,
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 50,
                )

//old
                /*    InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (ctx) => TransactionHistory()));
                },
                child: ListTile(
                  leading: IconButton(
                    padding: EdgeInsets.all(0.0),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => TransactionHistory()));
                    },
                    icon: SvgPicture.asset(
                      'assets/Icons/drawer/transaction.svg',
                      height: 20,
                      width: 20,
                      color: Color(0xFF000000),
                    ),
                  ),
                  */ /*Image.asset(
                        'assets/Icons/drawer/transaction.png',
                        height: 38,*/ /*
                  title: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => TransactionHistory()));
                    },
                    child: Text(
                      'My Transaction',
                      style:
                          TextStyle(fontSize: 14, fontFamily: MyFonts.semibold),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (ctx) => HelpUs()));
                },
                child: ListTile(
                  leading: IconButton(
                    padding: EdgeInsets.all(0.0),
                    onPressed: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (ctx) => HelpUs()));
                    },
                    icon: SvgPicture.asset(
                      'assets/Icons/drawer/support.svg',
                      height: 20,
                      width: 20,
                      color: Color(0xFF5D5D5D),
                    ),
                  ),
                  title: Text(
                    'Customer Support Chat',
                    style: TextStyle(fontSize: 14, fontFamily: MyFonts.semibold),
                  ),
                ),
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
                child: ListTile(
                  leading: IconButton(
                    padding: EdgeInsets.all(0.0),
                    onPressed: () async {
                      final _prefs = await SharedPreferences.getInstance();
                      if (_prefs.get("is_skip") == "Y") {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => LoginPage()),
                            (route) => false);
                      }
                      Navigator.push(
                          context, MaterialPageRoute(builder: (_) => MyWallet()));
                    },
                    icon: SvgPicture.asset(
                      'assets/Icons/drawer/wallet.svg',
                      height: 20,
                      width: 20,
                      color: Color(0xFF5D5D5D),
                    ),
                  ),
                  title: Text(
                    'My Wallet',
                    style: TextStyle(fontSize: 14, fontFamily: MyFonts.semibold),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => TalkAstrologer(
                                astroList: controllerHomePageLogic.astroListChat,
                                appBarName: "Chat with Astrologer",
                                chatKey: "on",
                                talkKey: "",
                                screen: "home",
                                skill_id: "",
                                videoKey: "",
                                callType: "chat",
                                followAstro: "1",
                              ))).then((value) => {getChatStatus()});
                },
                child: ListTile(
                  leading: IconButton(
                    padding: EdgeInsets.all(0.0),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => TalkAstrologer(
                                    astroList:
                                        controllerHomePageLogic.astroListChat,
                                    appBarName: "Chat with Astrologer",
                                    chatKey: "on",
                                    talkKey: "",
                                    screen: "",
                                    skill_id: "",
                                    videoKey: "",
                                    callType: "chat",
                                    followAstro: "1",
                                  ))).then((value) => {getChatStatus()});
                    },
                    icon: SvgPicture.asset(
                      'assets/Icons/drawer/my_followers_icon.svg',
                      height: 20,
                      width: 20,
                      color: Color(0xFF5D5D5D),
                    ),
                  ),
                  title: Text(
                    'My Followers',
                    style: TextStyle(fontSize: 14, fontFamily: MyFonts.semibold),
                  ),
                ),
              ),


              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => WebViewerTerms(
                              appbarText: "About Us", webUrl: aboutus)));
                },
                child: ListTile(
                  leading: IconButton(
                    padding: EdgeInsets.all(0.0),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => WebViewerTerms(
                                  appbarText: "About Us", webUrl: aboutus)));
                    },
                    icon: SvgPicture.asset(
                      'assets/Icons/drawer/about.svg',
                      height: 20,
                      width: 20,
                      color: Color(0xFF5D5D5D),
                    ),
                  ),
                  title: Text(
                    'About Us',
                    style: TextStyle(fontSize: 14, fontFamily: MyFonts.semibold),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => WebViewerTerms(
                              appbarText: "Privacy Policy", webUrl: privacy)));
                },
                child: ListTile(
                  leading: IconButton(
                    padding: EdgeInsets.all(0.0),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => WebViewerTerms(
                                  appbarText: "Privacy Policy",
                                  webUrl: privacy)));
                    },
                    icon: SvgPicture.asset(
                      'assets/Icons/drawer/shield.svg',
                      height: 20,
                      width: 20,
                      color: Color(0xFF5D5D5D),
                    ),
                  ),
                  title: Text(
                    'Privacy Policy',
                    style: TextStyle(fontSize: 14, fontFamily: MyFonts.semibold),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => WebViewerTerms(
                              appbarText: "Terms & Conditions", webUrl: terms)));
                },
                child: ListTile(
                  leading: IconButton(
                    padding: EdgeInsets.all(0.0),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => WebViewerTerms(
                                  appbarText: "Terms & Conditions",
                                  webUrl: terms)));
                    },
                    icon: SvgPicture.asset(
                      'assets/Icons/drawer/terms.svg',
                      height: 30,
                      width: 30,
                      color: Color(0xFF5D5D5D),
                    ),
                  ),
                  title: Text(
                    'Terms & Conditions',
                    style: TextStyle(fontSize: 14, fontFamily: MyFonts.semibold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextButton(
                    onPressed: () {
                      logout();
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/Icons/drawer/log.svg',
                          height: 30,
                          width: 30,
                          //color: Color(0xFF5D5D5D),
                        ),
                        Text(
                          'Logout',
                          style:
                              TextStyle(color: Color(0xFFFF7C5D), fontSize: 18),
                        )
                      ],
                    )),
              )*/
              ],
            ),
          ),
          body: SingleChildScrollView(
            controller: _scrollController,
            child: GetBuilder(
              init: PoojaController(),
              builder: (controller) {
                return screenController.poojaListingLoading.value == true
                    ? Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                // Adjust width as needed
                                height: 100,
                                // Adjust height as needed
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Colors.grey[300]!,
                                      Colors.grey[100]!,
                                      Colors.grey[300]!,
                                    ],
                                    stops: const [0.0, 0.5, 1.0],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  width: double.infinity,
                                  // Adjust width as needed
                                  height: 20,
                                  // Adjust height as needed
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Colors.grey[300]!,
                                        Colors.grey[100]!,
                                        Colors.grey[300]!,
                                      ],
                                      stops: const [0.0, 0.5, 1.0],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ))
                    : SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildSearchField(),
                      _poojaImagesCarusel(),
                      screenController.poojaListingLoading.value == true
                          ?
                      // Loading()
                      Flexible(
                        fit: FlexFit.loose,
                        child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: 10,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        // Adjust width as needed
                                        height: 100,
                                        // Adjust height as needed
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin:
                                            Alignment.centerLeft,
                                            end:
                                            Alignment.centerRight,
                                            colors: [
                                              Colors.grey[300]!,
                                              Colors.grey[100]!,
                                              Colors.grey[300]!,
                                            ],
                                            stops: const [
                                              0.0,
                                              0.5,
                                              1.0
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(
                                            10.0),
                                        child: Container(
                                          width: double.infinity,
                                          // Adjust width as needed
                                          height: 20,
                                          // Adjust height as needed
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment
                                                  .centerLeft,
                                              end: Alignment
                                                  .centerRight,
                                              colors: [
                                                Colors.grey[300]!,
                                                Colors.grey[100]!,
                                                Colors.grey[300]!,
                                              ],
                                              stops: const [
                                                0.0,
                                                0.5,
                                                1.0
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            )),
                      )
                          : ListView.builder(
                        //itemCount: 10,
                        itemCount:
                        screenController.poojaModel!.data!.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, mainIndex) {
                          DateTime dateTime = DateTime.parse(
                              screenController
                                  .poojaModel!.data![mainIndex].sId
                                  .toString());

                          String onlyDate =
                          DateFormat.d().format(dateTime);
                          String onlyMonth =
                          DateFormat.MMM().format(dateTime);
                          String dateMonth = " $onlyDate  $onlyMonth";


                          String onlyDay= DateFormat.EEEE().format(dateTime);

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: screenController.poojaModel!
                                .data![mainIndex].result!.length,
                            itemBuilder: (context, resultIndex) {
                              return InkWell(
                                onTap: () async {
                                  SharedPreferences _prefs =
                                  await SharedPreferences
                                      .getInstance();

                                  String? userId =
                                  _prefs.getString("id");
                                  Get.to(PoojaDetailScreen(
                                    screenController
                                        .poojaModel!
                                        .data![mainIndex]
                                        .result![resultIndex]
                                        .sId
                                        .toString(),
                                    onlyDate,
                                    onlyMonth,
                                    onlyDay,
                                    userId!,
                                  ));
                                },
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                      const EdgeInsets.all(4.0),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          cardSection(
                                              context,
                                              resultIndex,
                                              dateMonth,
                                              mainIndex),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      )
                    ],
                  ),
                );
              },
            ),
          )),
    );
  }

  Widget _buildSearchField() {
    return search_click_status ? Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 1, color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10)),
      child: TextField(
        controller: screenController.searchController,
        decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Search in Puja..',
            hintStyle: TextStyle(fontWeight: FontWeight.w500),
            border: InputBorder.none),
        onChanged: (value) {
          screenController.poojaListingApi();
        },
      ),
    ) : Container();
  }

  Widget cardSection(BuildContext context, int resultIndex, String dateMonth,
      int index) {
    var temp = screenController.poojaModel!.data![index];
    return Padding(
      padding: const EdgeInsets.only(right: 8, left: 8),
      // padding: const EdgeInsets.only(right: 8, top: 8, bottom: 8, left: 45),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Color(0xFFFBFBFB),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          shadows: [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 10,
              offset: Offset(0, 0),
              spreadRadius: 0,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                SizedBox(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height / 7,
                  width: double.infinity,
                  child: ShimmerImageLoader2(
                    image: temp.result![resultIndex].pujaImage.toString(),),),
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.textBlack.withOpacity(0.65),
                      borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(15))),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 5, top: 5, bottom: 5),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Icon(
                        //   Icons.calendar_today_outlined,
                        //   color: whiteColor,
                        //   size: 15,
                        // ),
                        // SizedBox(
                        //   width: 8,
                        // ),
                        Text(
                          convertDate(
                            temp.result![resultIndex].pujaDatetime.toString(),
                          ),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontFamily: 'poppinssemibold',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 5,),
                        Text(
                          convertDatemonth(
                            temp.result![resultIndex].pujaDatetime.toString(),
                          ),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: 'poppinssemibold',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    temp.result![resultIndex].title ?? "",
                    style: TextStyle(
                      color: AppColors.nblacksColor,
                      fontSize: 17,
                      fontFamily: 'poppinsbold',
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),

                  Text(
                    temp.result![resultIndex].purposeOfPooja ?? "no data",
                    // textAlign: TextAlign.center,
                    maxLines: 2,
                    textAlign: TextAlign.left,
                    
                    style: TextStyle(
                      
                      color: AppColors.norangeColor,
                      fontSize: 13.5,
                      fontFamily: 'poppinssemibold',
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  // Text(
                  //   temp.result![resultIndex].aboutPuja??"",
                  //   // textAlign: TextAlign.center,
                  //   maxLines: 2,
                  //   style: TextStyle(
                  //     color: Color(0xFFFC7601),
                  //     fontSize: 14,
                  //     fontFamily: 'Segoe UI',
                  //     fontWeight: FontWeight.w400,
                  //    ),
                  // ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.temple_hindu_outlined,
                        size: 20,
                        color: AppColors.textBlack,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        temp.result![resultIndex].mandirName ?? "",
                        style: TextStyle(
                            color: AppColors.nblacksColor,
                            fontSize: 13,
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      // SizedBox(
                      //   width: 112,
                      //   child: InkWell(
                      //     onTap: () {
                      //       _openWhatsAppLink("Check the ${temp.result![resultIndex].title} on AstroguruJii.");
                      //     },
                      //     child: Container(
                      //       height: 36,
                      //
                      //       padding: const EdgeInsets.only(
                      //           top: 6, left: 24, right: 23, bottom: 7),
                      //       clipBehavior: Clip.antiAlias,
                      //       decoration: BoxDecoration(
                      //           color: Colors.white,
                      //           borderRadius: BorderRadius.circular(5),
                      //           border:
                      //               Border.all(color: Colors.grey, width: 1)),
                      //       child: Row(
                      //         mainAxisSize: MainAxisSize.min,
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         crossAxisAlignment: CrossAxisAlignment.center,
                      //         children: [
                      //           Image.asset(
                      //             "assets/images/whatsapp.png",
                      //             height: 16,
                      //             width: 16,
                      //           ),
                      //           SizedBox(
                      //             width: 5,
                      //           ),
                      //
                      //           Text(
                      //             'Share',
                      //             textAlign: TextAlign.center,
                      //             style: TextStyle(
                      //               color: Colors.black,
                      //               fontSize: 14,
                      //               fontFamily: 'Poppins',
                      //               letterSpacing: 0,
                      //               fontWeight: FontWeight.w500,
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(
                      //   width: 20,
                      // ),
                      Expanded(
                        child: Container(
    margin: EdgeInsets.all(8),
    padding: EdgeInsets.all(4),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.white,
        boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 0.4,
                spreadRadius: 0.0,
                offset: Offset(.0, 1.0), // shadow direction: bottom right
            )
        ],
    ),// child widget, replace with your own

                          child: Container(
                            height: 36,
                            padding: const EdgeInsets.only(
                                top: 6, left: 24, right: 23, bottom: 7),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.norangeColor,
                                  AppColors.norangeColor
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: IgnorePointer(
  ignoring: true,
                              child: AnimatedTextKit(
                                                    repeatForever: true,
                                                    pause: Duration(milliseconds: 200),
                                                    animatedTexts: [
                                                      RotateAnimatedText('Book Now',
                                textAlign: TextAlign.center,
                                textStyle: 
                                     TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: 'poppinsbold',
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.bold,
                                    ),),
                                                      RotateAnimatedText('Participate Now',
                               textAlign: TextAlign.center,
                                textStyle: 
                                     TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: 'poppinsbold',
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.bold,
                                    ),),
                                                      RotateAnimatedText('Limited Offers!',
                                                      textAlign: TextAlign.center,
                                textStyle: 
                                     TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: 'poppinsbold',
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.bold,
                                    ),),
                                                    ],
                                                  ),
                            ),
                        
                               
                              
                            
                          ),
                        ),
                      )
                    ],
                  ),


                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _poojaImagesCarusel() {
    print("screen height ${MediaQuery.of(context).size.height}");
    // List<String> images=[
    //   "https://picsum.photos/200/300",
    //   "https://picsum.photos/200/300",
    //   "https://picsum.photos/200/300",
    // ];
    return screenController.poojaModel!.promotionalBanner!.isEmpty
        ? Container()
        : GetBuilder<PoojaController>(
      init: PoojaController(),
      builder: (controller) {
        return Column(
          children: [
            Container(
              margin: EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height/6.139,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 16 / 9,
                    viewportFraction: 1.0,
                    onPageChanged: (index, reason) {
                      controller.valueChangeForPoojaListing(index);
                    },
                  ),
                  items: screenController.poojaModel!.promotionalBanner!
                      .map((imageUrl) {
                    return ShimmerImageLoader1(image: imageUrl.image.toString(),);
                  }).toList(),
                ),
              ),
            ),
            // SizedBox(
            //   height: 5,
            // ),
            CarouselIndicator(
              height: 7,
              width: 7,
              activeColor: primaryColor,
              color: Colors.grey,
              // count: screenController.poojaDetailModel!.data!.bannerImages!.length,
              count:
              screenController.poojaModel!.promotionalBanner!.length,
              index: controller.bannerIndexForPoojaListing,
            ),
          ],
        );
      },
    );
  }


  String convertDate(String inputDate) {
    // Parse the input date
    DateTime dateTime = DateTime.parse(inputDate);

    // Format the date as required
    String formattedDate = DateFormat('d').format(dateTime);

    return formattedDate;
  }

  String convertDatemonth(String inputDate) {
    // Parse the input date
    DateTime dateTime = DateTime.parse(inputDate);

    // Format the date as required
    String formattedDate = DateFormat('MMMM').format(dateTime);

    return formattedDate;
  }

}

 class ShimmerImageLoader1 extends StatelessWidget {
  final String image;
  ShimmerImageLoader1({required this.image});
    @override
    Widget build(BuildContext context) {
      return  CachedNetworkImage(
                imageUrl: image!,
                imageBuilder: (context, imageProvider) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover
                      ),
                    ),
                  );
                },
                placeholder: (context, url) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[200]!, // Base color for shimmer
                    highlightColor: AppColors.mlightPink,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                    ),
                  );
                },
                errorWidget: (context, url, error) {
                  return Icon(Icons.error, color: Colors.red);
                },

      );
    }
  }
  
 class ShimmerImageLoader2 extends StatelessWidget {
  final String image;
  ShimmerImageLoader2({required this.image});
    @override
    Widget build(BuildContext context) {
      return  CachedNetworkImage(
                imageUrl: image!,
                imageBuilder: (context, imageProvider) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(8),topRight: Radius.circular(8)),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover
                      ),
                    ),
                  );
                },
                placeholder: (context, url) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[200]!, // Base color for shimmer
                    highlightColor: AppColors.mlightPink,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                    ),
                  );
                },
                errorWidget: (context, url, error) {
                  return Icon(Icons.error, color: Colors.red);
                },

      );
    }
  }

