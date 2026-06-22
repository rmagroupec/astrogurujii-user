import 'dart:developer';
import 'dart:io';

import 'package:astro_gurujii/Screens/AstroOtherServices.dart';
import 'package:astro_gurujii/Screens/AstroTalk/AstroTalk.dart';
import 'package:astro_gurujii/Screens/Banner/Banner.dart';
import 'package:astro_gurujii/Screens/ChatIntakeForm.dart';
import 'package:astro_gurujii/Screens/ExportAstrologers/AstroPush.dart';
import 'package:astro_gurujii/Screens/ExportAstrologers/Blogs.dart';
import 'package:astro_gurujii/Screens/ExportAstrologers/ClientsTestimonials.dart';
import 'package:astro_gurujii/Screens/ExportAstrologers/ExpertAstrologer.dart';
import 'package:astro_gurujii/Screens/HelpUs.dart';
import 'package:astro_gurujii/Screens/Login.dart';
import 'package:astro_gurujii/Screens/Models/HomeDataModel.dart';
import 'package:astro_gurujii/Screens/Models/last_call_list/LastCallListModel.dart';
import 'package:astro_gurujii/Screens/MyWallet.dart';
import 'package:astro_gurujii/Screens/Profile/ProfileScreen.dart';
import 'package:astro_gurujii/Screens/TalkAstrologer/TalkAstrologers.dart';
import 'package:astro_gurujii/Screens/VersionDialogScreen.dart';
import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Screens/WebViewerTerms.dart';
import 'package:astro_gurujii/Screens/controllers/home_page_logic.dart';
import 'package:astro_gurujii/Screens/homeScreen/home_custom/live_strologers.dart';
import 'package:astro_gurujii/Screens/homeScreen/home_custom/my_order.dart';
import 'package:astro_gurujii/Screens/homeScreen/shimmerEffects/smierr.dart';
import 'package:astro_gurujii/Screens/homeScreen/view_chat_screen.dart';
import 'package:astro_gurujii/Screens/live/LiveVideoCallScreen.dart';
import 'package:astro_gurujii/Screens/mall/ShoppingMall.dart';
import 'package:astro_gurujii/Screens/poojaScreen/ui/poojaScreen.dart';
import 'package:astro_gurujii/Screens/pooja_orders/ui/pooja_order_list_screen.dart';
import 'package:astro_gurujii/Screens/ragisterAstro/ragister_astro.dart';
import 'package:astro_gurujii/Screens/testimonials/all_testimonials_screen.dart';
import 'package:astro_gurujii/Screens/transection_screen/TransactionHistory.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:astro_gurujii/Utilities/CustomUi.dart';
import 'package:astro_gurujii/widget/bottom_navigation_bar_custom.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_widgets/glassmorphism_widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share_plus/share_plus.dart';


import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Setup/app_colors.dart';
import '../../Setup/app_images.dart';
import '../../Setup/strings.dart';
import '../../Utilities/banner_loader.dart';
import '../../widget/app_bar_home_screen.dart';
import '../../widget/drawer_custom.dart';
import '../../widget/floating_card_custom.dart';
import '../ExportAstrologers/horoscope.dart';
import '../Models/AstroDetailsModel.dart';
import '../Models/live_listing/live_listing_reponse.dart';
import '../SplashScreen.dart';
import '../bottomSheet.dart';
import '../chats_screen/chat/Chat.dart';
import '../language/language_change_screen.dart';
import '../liveAsgtrologerLisitngScreen.dart';
import '../mall/MyOrderListSideScreen.dart';
import 'chatLisitngModel.dart';
import 'chatListScreen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final controllerHomePageLogic = Get.put(HomePageLogic());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final HttpServices _httpServices = HttpServices();
  List<HomeBanner> bannerData = [];
  List<HomeBanner> banner_ads = [];
  List<Live> liveData = [];
  List<Data> liveAstrologersList = [];
  List<Astrologer> astroData = [];
  List<Astrologer> top_astrologer = [];
  List<Testimonials> testmonialData = [];
  List<Blog> blogData = [];
  List<ProductCategory> productData = [];
  bool _isLoading = true;
  bool isSelected = true;
  final bool _flexibleUpdateAvailable = false;
  var walletAmount = "";
  var terms = "https://admin.astrogurujii.com/links/termandcondition";
  var privacy = "https://admin.astrogurujii.com/links/privacypolicy";
  var aboutus = "https://admin.astrogurujii.com/links/aboutus";
  var contactus = "https://api.astrogurujii.com/links/contactus";
  var shipinganddelivery =
      "https://api.astrogurujii.com/links/shipinganddelivery";
  var cancleandrefund = "https://api.astrogurujii.com/links/cancleandrefund";

  var notifications_count = 0;

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  bool setCheckForChat(String userWallet, String videoRate) {
    var totalMin = 0.0;
    totalMin = double.parse(userWallet) / double.parse(videoRate);
    if (totalMin < 5) {
      return true;
    }
    return false;
  }

  void createSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Align(
          child: Container(
            //color: Colors.white,
            decoration: BoxDecoration(
                color: primaryColor,
                border: Border.all(width: 2.0, color: primaryColor),
                borderRadius: BorderRadius.circular(20)),
            child: Container(
              height: 100,
              child: Align(
                child: CustomText(
                  text: "${message}".toString(),
                  color: blackColor,
                  align: TextAlign.start,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 2000,
        behavior: SnackBarBehavior.floating,
      ));
  }

  List<Results> data = [];
  bool loading = true;

  Future<void> callNotifyMeApi({String? id, String? type}) async {
    var res = await _httpServices.notifyme(astro_id: id.toString());
    if (res!.status == true) {
      setState(() {
        // _isLoading = false;
        createSnackBar(res.message!);
        //Fluttertoast.showToast(msg: res.message);
      });
    } else {
      // _isLoading = false;
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }

  astroDetailsApi(String id) async {
    var res = await _httpServices.astrologer_details(id: id);
    if (res?.status == true) {
      setState(() {
        data = res!.results!;
        // translateAbout(data[0]
        //     .about); // Translate the description again when toggling language

        _isLoading = false;
      });
    } else {
      Fluttertoast.showToast(msg: res!.message!.toString());
      _isLoading = false;
    }
  }

  void homeApi() async {
    var res = await _httpServices.home_data();
    
    if (res!.status == true) {
      setState(() {
         _refreshController.refreshCompleted();
        bannerData = res.banner!;
        banner_ads = res.banner_ads!;
        liveData = res.live!;
        astroData = res.astrologer!;
        top_astrologer = res.top_astrologer!;
        testmonialData = res.testimonials!;
        blogData = res.blog!;
        productData = res.productCategory!;
        _isLoading = false;
       
        if (res.is_open_rating == "Yes") {
          //show(context, res.channel_id);
        }
      });
    } else {
      Fluttertoast.showToast(msg: res.message!);
      _refreshController.refreshCompleted();
    }
  }

  ChatListingModelN? chatListingModelN;
  bool loadingChatList = false;

  void chatListing() async {
    setState(() {
      loadingChatList = true;
    });

    var res = await _httpServices.chatListingApi();
    if (res?.status == true) {
      setState(() {
        chatListingModelN = res;
        loadingChatList = false;

        log('---a-sdfdsafdsaf--fdsafdsa ${chatListingModelN?.data?.length}');
        print("doneeee");
      });
    } else {}
  }

  void getLiveAstrologer() async {
    var res = await _httpServices.getLiveListing();
    if (res!.status == true) {
      setState(() {
        liveAstrologersList = res.data!;
        _refreshController.refreshCompleted();
      });
    } else {
      Fluttertoast.showToast(msg: res.message!);
      _refreshController.refreshCompleted();
    }
  }

  void joinLiveAstrologer(String liveId) async {
    var res = await _httpServices.joinLiveAstrologerApi(liveId);
    if (res!.status == true) {
      setState(() {
        _refreshController.refreshCompleted();
      });
    } else {
      Fluttertoast.showToast(msg: res.message!);
      _refreshController.refreshCompleted();
    }
  }

  var name = "";
  var mobile = "";
  var image = "";
  var wallet = "";
  String currency = "";

  void getProfile() async {
    var res = await _httpServices.profile_api();
    if (res!.status == true) {
      setState(() {
        //currency = res.results!.currency.toString();
        currency = "INR";
        wallet = setWallet(res.results!.wallet.toString(), "INR",
            res.results!.wallet_usd.toString());
        walletAmount = res.results!.wallet.toString();
        _refreshController.refreshCompleted();
        notifications_count = res.notifications_count;
        name = res.results!.name!;
        mobile = res.results!.number!;
        image = res.results!.profileImg!;
      });
    } else {
      Fluttertoast.showToast(msg: res.message!);
      _refreshController.refreshCompleted();
    }
  }

  void getSetting() async {
    var res = await _httpServices.setting();
    if (res!.status == true) {
      setState(() {
        /*terms = res.results!.terms_and_conditions;
        privacy = res.results!.privacy_policy;
        aboutus = res.results!.about_us;*/
        if (res.results!.usermaintenance_status == "OFF") {
          _showMaintanceDialog(context, res.results!.usermaintenance_text,
              res.results!.usermaintenance_image);
        }
      });
    } else {
      Fluttertoast.showToast(msg: res.message!);
      _refreshController.refreshCompleted();
    }
  }

  _showMaintanceDialog(
      BuildContext context, String? title, String? image) async {
    showDialog(
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Constants.padding),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: contentBox1(context, title!, image!),
          );
        },
        context: context);
  }

  contentBox1(context, String title, String image) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
              left: Constants.padding,
              top: Constants.avatarRadius + Constants.padding,
              right: Constants.padding,
              bottom: Constants.padding),
          margin: const EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.network(image),
              const SizedBox(
                height: 10,
              ),
              Html(
                data: title,
              ),
              const SizedBox(
                height: 22,
              ),
              Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                     
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: CustomText(
                      text: "Continue",
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
            ],
          ),
        ), // bottom part
        Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: CircleAvatar(
            backgroundColor: primaryColor,
            radius: 40,
            child: const ClipRRect(
                borderRadius: const BorderRadius.all(
                    Radius.circular(Constants.avatarRadius)),
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.white,
                  size: 35,
                )),
          ),
        ), // top part
      ],
    );
  }

  Data2? data2;
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
      _refreshController.refreshCompleted();
    }
  }

  void getChatStatusClick() async {
    setState(() {});
    var res = await _httpServices.lastCallList();
    if (res!.result == true) {
      setState(() {
        data2 = res.data2;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) => Chat(
                    channelID: data2!.fbChannelId,
                    fbchannelID: data2!.channelId,
                    astrologerId: data2!.astroId,
                    name: data2!.userName,
                    place: "",
                    dob: "",
                    astroName: data2!.astroName,
                    tob: data2!.difference.toString(),
                    gender: "",
                    gid: data2!.fbChannelId,
                    currency: "INR",
                    astrologerChatRate: " ",
                    astrologerImage: data2!.astroProfileImg,
                    wallet: ""))).then((value) => {getChatStatus()});
      });
    } else {
      Fluttertoast.showToast(msg: res.message!);
      _refreshController.refreshCompleted();
    }
  }

  @override
  void initState() {
    chatListing();
    getChatStatus();
    getSetting();
    homeApi();
    getLiveAstrologer();
    getProfile();
    _checkVersion();
    controllerHomePageLogic.getAstrologerApiChat();
    controllerHomePageLogic.getAstrologerApiVoice();
    controllerHomePageLogic.getAstrologerApiVideo();
    // Screen.keepOn(false);
    super.initState();

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        //print("New Notification");
      }
    });

    ///when app is open
    FirebaseMessaging.onMessage.listen((message) {
      // print(FirebaseMessaging.onMessage.listen);
      if (message.notification != null) {
        // AwesomeNotifications().createNotification(
        //   content: NotificationContent(
        //     id: 10,
        //     channelKey: 'basic_channel',
        //     title: message.notification!.title,
        //     body: message.notification!.body,
        //     bigPicture: message.data['imageUrl'],
        //     wakeUpScreen: true,
        //     notificationLayout: message.data['imageUrl'] == null
        //         ? NotificationLayout.Default
        //         : NotificationLayout.BigPicture,
        //     displayOnForeground: true,
        //   ),
        // );
      }
    });

    ///when app is running in background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print(FirebaseMessaging.onMessageOpenedApp.listen);
      if (message.notification != null) {
        print(message.notification!.title.toString());
        print(message.notification!.body.toString());
        print(message.data.toString());
      }
    });

    /*   Future.delayed(Duration(seconds: 4)).then((_) {
      showModalBottomSheet(
          context: context,
          builder: (builder) {
            return ProfileScreenBottomSheet();
          });
    });*/

    super.initState();
  }

  _checkVersion() async {
    var _response = await _httpServices.setting();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String _buildNumber = packageInfo.buildNumber;
    print("this is build numbder");
    print(_buildNumber);
    print(_response!.results!.user_android_cur_int);

    if (Platform.isAndroid) {
      if (_response!.results!.user_android_cur_int > int.parse(_buildNumber)) {
        print("inside this ");
        return showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) => VersionDialogScreen(
                  appVersion: _response,
                ));
      }
    }
  }

  void _onLeagueRefresh() async {
    homeApi();
    chatListing();
    getProfile();
    getLiveAstrologer();
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

Future<bool> _showCloseDialog(BuildContext context) async {
    return await showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)), // Top rounded corners
    ),
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // Important for fitting content
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Text('Wait! Are you sure you want to close the App.', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, color: primaryColor, fontWeight: FontWeight.w600))),
            SizedBox(height: 10),
            // Text('This is the content of the bottom sheet.'),
            SizedBox(height: 20),
            // 
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 35),
                  decoration: BoxDecoration(color: primaryColor,borderRadius: BorderRadius.circular(10)),
                  child: Text("Explore App",style: TextStyle(color: whiteColor, fontWeight: FontWeight.w600, fontSize: 17),),),
              ),
              GestureDetector(
                onTap: (){
                SystemNavigator.pop(); 
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 35),
                  decoration: BoxDecoration(color: greyColor.withOpacity(0.2),borderRadius: BorderRadius.circular(10)),
                  child: Text("Close App",style: TextStyle(color: blackColor, fontWeight: FontWeight.w600, fontSize: 17),),),
              ),
            ],)
          ],
        ),
      );
    },
  )?? false; // Handle null case (dialog dismissed)
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await _showCloseDialog(context);
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar(
          height: 62.0,
          backgroundColor: const Color(0xffFC7601),
          iconColor: Colors.white,
          logoPath: 'assets/image/astro-logo-apbar.png',
          titleImagePath: 'assets/images/name_astro_guruji.png',
          walletIconPath: 'assets/icon/wallet_icon_toolbar.png',
          supportIconPath: 'assets/icon/support_toolbar_icon.png',
    
          onWalletTap: () async {
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
          onSupportTap: ()  {
            print('clicked');
            // setState(() {
            //   notifications_count = 0;
            // });
            //
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => HelpUs()));
    
          },
          isWalletVisible: true,
        ),
          drawer:  CustomDrawer(
          name: name,
          image: image,
          onProfileTap: () async {
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
                      builder: (_) => const ProfileScreen())).then((value) {
                setState(() {
                  getProfile();
                });
              });
            }
          },
          onTransactionTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (ctx) => TransactionHistory()));
          },
          onWalletTap: () async {
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
          onFollowingTap: () {
          Navigator.push(
          context,
          MaterialPageRoute(
          builder: (_) => TalkAstrologer(
          astroList: controllerHomePageLogic.astroListChat,
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
          onPoojaBookingsTap: () {
      Navigator.push(context,
      MaterialPageRoute(builder: (ctx) => PoojaOrderList()));
      },
          onAstromallBookingsTap:  () {
      Navigator.push(
      context,
      MaterialPageRoute(
      builder: (ctx) => MyOrderListSideScreen()));
      },
          onSupportTap:  () {
      Navigator.push(
      context, MaterialPageRoute(builder: (ctx) => HelpUs()));
      },
          onRegistrationTap: () {
      Navigator.push(context,
      MaterialPageRoute(builder: (ctx) => RagisterAstro()));
      },
          onReferTap: () {
      Share.share(
      'https://play.google.com/store/apps/details?id=com.user.astrogurujii');
      },
          onAboutUsTap: () {
      Navigator.push(
      context,
      MaterialPageRoute(
      builder: (ctx) => WebViewerTerms(
      appbarText: "About Us", webUrl: aboutus)));
      },
          onPrivacyPolicyTap:  () {
      Navigator.push(
      context,
      MaterialPageRoute(
      builder: (ctx) => WebViewerTerms(
      appbarText: "Privacy Policy", webUrl: privacy)));
      },
          onTermsTap: () {
      Navigator.push(
      context,
      MaterialPageRoute(
      builder: (ctx) => WebViewerTerms(
      appbarText: "Terms & Conditions", webUrl: terms)));
      },
          onLogoutTap: () {
            logoutDialog(context);
      // logout();
      },
      onAppleTap:  () {
      _launchURL('https://astrogurujii.com/');
      },
      onWebTap: () {
      _launchURL('https://astrogurujii.com/');
      },
      onYouTubeTap:  () {
      _launchURL(
      'https://youtube.com/@astrogurujii?si=-uXZQ_o0tnI1C_Z8');
      },
    
      onFaceBookTap:() {
      _launchURL(
      'https://www.facebook.com/astrogurujii.official?mibextid=rS40aB7S9Ucbxw6v');
      },
      onInstagramTap:() {
      _launchURL(
      'https://www.instagram.com/astrogurujii.app/profilecard/?igsh=MWV5NDZzN3NhcjloNQ==');
      },
      onLinkedLnTap: () {
      _launchURL(
      'https://www.linkedin.com/in/astro-gurujii-199039290/');
      },
          version: "1.1.73",
    
        ),
    
      
        body: Stack(
          children: [
            SmartRefresher(
              enablePullDown: true,
              enablePullUp: false,
              header: WaterDropMaterialHeader(),
              controller: _refreshController,
              onRefresh: _onLeagueRefresh,
              child: ListView(
                children: [
                  /// search bar
                  const SizedBox(
                    height: 10,
                  ),
                  (bannerData != null && bannerData.length > 0)
                      ? BannerScreen(
                          data: bannerData,
                          type: "normal",
                        )
                      : ShimmerBanner(),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                     color: AppColors.mlightPink,
                    child: Column(
                      children: [
                        Container(
                      padding: EdgeInsets.only(top: 5),
                      color: AppColors.mlightPink,
                      child: const AstroTalk(),
                    ),
    
                    ///other service
                    Container(
                      padding: EdgeInsets.only(bottom: 5),
                      color: AppColors.mlightPink,
                      child: const AstroOtherServices(),
                    ),
    
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
    
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 15, bottom: 10),
                    child: CustomText(
                      text: "Daily Horoscope",
                      color: const Color(0xFF2D2D2D),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
    
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Horoscope(),
                  ),
    
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 5),
                    child: IntrinsicHeight(
                      child: Row(
                        children: <Widget>[
                          CustomText(
                            text: "Top Astrologers",
                            color: const Color(0xFF2D2D2D),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => TalkAstrologer(
                                          astroList: controllerHomePageLogic
                                              .astroListVoice,
                                          appBarName: "Talk with Astrologer",
                                          chatKey: "",
                                          talkKey: "on",
                                          screen: "",
                                          videoKey: "",
                                          skill_id: "",
                                          callType: "audio",
                                          expert_astro: "on"))).then(
                                  (value) => {getChatStatus()});
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: CustomText(
                                text: 'View All',
                                // color: greyColor,
                                color: primaryColor,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
    
                  const SizedBox(
                    height: 15,
                  ),
                  (astroData != null && astroData.length > 0)
                      ? SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: ExpertAstrologer(
                              data: astroData,
                            ),
                          ),
                        )
                      : ShimmerAstrologerHome(),
                  // : ShimmerCard(),
    
                  const SizedBox(
                    height: 10,
                  ),
                  (banner_ads != null && banner_ads.length > 0)
                      ? BannerScreen(data: banner_ads, type: "ads")
                      : ShimmerBanner(),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, top: 5),
                      child: IntrinsicHeight(
                        child: Row(
                          children: <Widget>[
                            CustomText(
                              text: "My Orders",
                              color: const Color(0xFF2D2D2D),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatListScreen(),
                                    ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: CustomText(
                                  text: 'View All',
                                  // color: greyColor,
                                  color: primaryColor,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // chatListingModelN == null
                  //     ? Container(  )
                  //     : MyOrder(astroDetailsApi: astroDetailsApi, chatListingModelN: chatListingModelN, data: data,),
                  chatListingModelN == null ? Container(
    
                    // color: Colors.red,
                    // height: 100,
                    // width: 100,
    
                  ) :
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    padding: EdgeInsets.only(
                        top: 15, bottom: 15, left: 10, right: 10),
                    decoration: BoxDecoration(
                      color: Colors.white, // Container background color
                      borderRadius: BorderRadius.circular(
                          20), // Optional: Round corners
                      boxShadow: [
                        BoxShadow(
                          color:
                          Colors.grey.withOpacity(0.4), // Shadow color
                          spreadRadius: 2, // Spread radius
                          blurRadius: 1, // Blur radius
                          offset:
                          Offset(0, 2), // Offset in x and y direction
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: primaryColor,
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage:
                            NetworkImage(chatListingModelN?.data?[0]
                                .astroProfileImg),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            CustomText(
                              text: "${chatListingModelN?.data?[0].astroDisplayName}",
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            CustomText(
                              text: "${chatListingModelN?.data![0].callDate}",
                              fontSize: 16,
                              color: Colors.black38,
                              fontWeight: FontWeight.w400,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    var temp = chatListingModelN?.data?[0];
    
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (ctx) =>
                                                ChatViewOnly(
                                                  // channelID: data2!.fbChannelId,
    
    
                                                  channelID: temp!.fbChannelId
                                                      .toString(),
                                                  // fbchannelID: data2!.channelId,
                                                  fbchannelID: temp.channelId,
                                                  // astrologer_id: data2!.astroId,
                                                  astrologer_id: temp.astrId,
                                                  name: temp.userName,
                                                  place: "",
                                                  dob: "",
                                                  astroName: temp.astroDisplayName,
                                                  // tob: data2!.difference.toString(),
                                                  tob: "",
                                                  gender: "",
                                                  // gid: data2!.fbChannelId,
                                                  gid: temp.fbChannelId,
                                                  currency: "INR",
                                                  astrologer_chat_rate: "",
                                                  astrologer_image:
                                                  temp.astroProfileImg,
                                                  wallet: "",
                                                  rating: temp.rating,
                                                  review: temp.review
                                                )));
    
                                    //     .then((value) => {getChatStatus()});
                                    // });
                                  },
    
                                  child: Container(
                                    height: Get.height * 0.04,
                                    width: Get.width * 0.28,
                                    decoration: BoxDecoration(
                                        color: AppColors.appblueColor,
                                        borderRadius:
                                        BorderRadius.circular(20)),
                                    child: Center(
                                      child: CustomText(
                                        // text: 'Connect',
                                        text: 'View Chat',
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  onTap: () async {
                                    /// 1 check status astrologer is busy or offline
                                    // await getProfile();
                                    await  astroDetailsApi(chatListingModelN?.data![0].astrId);
    
                                    if (data[0].is_busy == 0 &&
                                        data[0].isChatOnline == "off") {
                                      callNotifyMeApi(
                                          id: data[0].id.toString(), type: "chat");
                                    } else {
                                      var callRate =
                                      (data[0].per_min_chat_offer.isEmpty)
                                          ? data[0].perMinChat.toString()
                                          : data[0].per_min_chat_offer.toString();
                                      if (setCheckForChat(
                                          wallet.toString(), callRate)) {
                                        bottomSheet(
                                          name,
                                            image,
                                            data[0].astro_number.toString(),
                                            context,
                                            data[0].id.toString(),
                                            (data[0].per_min_chat_offer.isEmpty)
                                                ? data[0].perMinChat.toString()
                                                : data[0]
                                                .per_min_chat_offer
                                                .toString(),
                                            "5",
                                            data[0].profileImg!,
                                            currency,
                                            "+91",
                                            data[0].name!,
                                            wallet.toString(),
                                            "chat",
                                            loading);
                                      } else {
    
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (ctx) => ChatIntakeForm(
                                                    wallet: wallet.toString(),
                                                    rate: callRate,
                                                    name: data[0].name!,
                                                    profile: data[0].profileImg!,
                                                    astrologer_id:
                                                    data[0].id.toString())))
                                            .then((value) => {getProfile()});
    
                                      }
                                    }
                                  },
    
                                  child: Container(
                                    height: Get.height * 0.04,
                                    width: Get.width * 0.28,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                        BorderRadius.circular(20),
                                        border: Border.all(
                                            color: AppColors.appblueColor)),
                                    child: Center(
                                      child: CustomText(
                                        // text: 'Connect',
                                        text: 'Chat again',
                                        color: AppColors.appblueColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            // CustomText(
                            //   text: "Special offer Chat at Rs 5/min only",
                            //   fontSize: 10,
                            //   color: primaryColor,
                            //   fontWeight: FontWeight.w400,
                            // ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        CustomText(
                          text: "Recommended Astrologers",
                          color: const Color(0xFF2D2D2D),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => TalkAstrologer(
                                            astroList: controllerHomePageLogic
                                                .astroListVoice,
                                            appBarName: "Talk with Astrologer",
                                            chatKey: "",
                                            talkKey: "on",
                                            screen: "",
                                            videoKey: "",
                                            skill_id: "",
                                            callType: "audio",
                                            expert_astro: "on")))
                                .then((value) => {getChatStatus()});
                          },
                          child: CustomText(
                            text: 'View All',
                            // color: greyColor,
                            color: primaryColor,
                          ),
                        )
                      ],
                    ),
                  ),
    
                  (top_astrologer != null && top_astrologer.length > 0)
                      ? SizedBox(
                          child: ExpertAstrologer(
                            data: top_astrologer,
                          ),
                        )
                      : ShimmerAstrologerHome(),
                  SizedBox(
                    height: 10,
                  ),
                  (testmonialData != null && testmonialData.length > 0)
                      ? IntrinsicHeight(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: <Widget>[
                              CustomText(
                                text: "Testimonials",
                                color: const Color(0xFF2D2D2D),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              AllTestimonialsScreen()));
                                },
                                child: CustomText(
                                  text: 'View All',
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      : SizedBox(),
    
                  (testmonialData != null && testmonialData.length > 0)
                      ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClientsTestimonials(
                            data: testmonialData,
                          ),
                      )
                      : SizedBox(),
    
    
    
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        CustomText(
                          text: "Live Astrologers",
                          color: const Color(0xFF2D2D2D),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LiveAstroLogersScreen(
                                  ),
                                ));
                          },
                          child: CustomText(
                            text: 'View All',
                            // color: greyColor,
                            color: primaryColor,
                          ),
                        )
                      ],
                    ),
                  ),
                  LiveAstrologerCard(liveAstrologersList:liveAstrologersList,),
                  SizedBox(
                    height: 10,
                  ),
    
    
                  (blogData.length > 0)
                      ? Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: <Widget>[
                            CustomText(
                              text: "Latest From Blog",
                              color: const Color(0xFF2D2D2D),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      )
                      : Container(),
                  (blogData.length > 0)
                      ? const SizedBox(
                          height: 10,
                        )
                      : SizedBox(),
                  (blogData.length > 0)
                      ? Blogs(
                          data: blogData,
                        )
                      : SizedBox(),
                  const SizedBox(
                    height: 20,
                  ),
                  (productData.length > 0)
                      ? Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: IntrinsicHeight(
                            child: Row(
                              children: <Widget>[
                                VerticalDivider(
                                  color: blackLightcolor,
                                  width: 20,
                                  thickness: 5,
                                ),
                                CustomText(
                                  text: "Astro Mall",
                                  color: const Color(0xFF2D2D2D),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: InkWell(
                                      splashColor:
                                          Theme.of(context).primaryColorLight,
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (ctx) =>
                                                    ShoppingMall()));
                                      },
                                      child: CustomText(
                                        text: 'View All',
                                        color: blueColor,
                                      )),
                                )
                              ],
                            ),
                          ),
                        )
                      : SizedBox(),
                  (productData.length > 0)
                      ? const SizedBox(
                          height: 20,
                        )
                      : SizedBox(),
                  (productData.length > 0)
                      ? AstroPush(data: productData)
                      : SizedBox(),
    
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    color: Color(0xFFF1F1F1),
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Container(
                                width: Get.width * 0.2,
                                height: Get.height * 0.06,
                                child: Image.asset(AppImages.private_icon)),
                            Text(
                              Strings.Private,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12),
                            )
                          ],
                        ),
                        SizedBox(
                          height: Get.height * 0.08,
                          child: VerticalDivider(
                            thickness: 2,
                            color: Colors.black54,
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                                width: Get.width * 0.2,
                                height: Get.height * 0.06,
                                child: Image.asset(AppImages.verified_icon)),
                            Text(
                              Strings.Verified,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12),
                            )
                          ],
                        ),
                        SizedBox(
                          height: Get.height * 0.08,
                          child: VerticalDivider(
                            thickness: 2,
                            color: Colors.black54,
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                                width: Get.width * 0.2,
                                height: Get.height * 0.06,
                                child: Image.asset(AppImages.secure_icon)),
                            Text(
                              Strings.Secure,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Image.asset('assets/images/secure_payment1.png'),
                  SizedBox(
                    height: Get.height * 0.08,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(left: 28.0, right: 28, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => TalkAstrologer(
                                        astroList:
                                            controllerHomePageLogic.astroListChat,
                                        appBarName: "Chat with Astrologer",
                                        chatKey: "on",
                                        talkKey: "",
                                        screen: "home",
                                        skill_id: "",
                                        videoKey: "",
                                        callType: "chat",
                                      ))).then((value) => {getChatStatus()});
                        },
                        child: GlassContainer(
                          border: 0,
                          linearGradient: LinearGradient(
                            colors: [
                              Color(0xFFFC7601),
                              Color(0xFFFC7601),
                              // Color(0xFFFC7601).withOpacity(0.60)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          /* linearGradient: LinearGradient(
                                  colors: [
                                    Color(0xFFFC7601),
                                    Color(0xFFFC7601),
                                  ],
                                ),*/
                          height: 40,
                          alignment: Alignment.centerLeft,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Icon(Icons.error,color: whiteColor,),
                              SvgPicture.asset(
                                'assets/d_icons/chat_svg.svg',
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              CustomText(
                                text: 'Chat to Astrologer',
                                color: whiteColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          /*  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => TalkAstrologer(
                                            appBarName: "Video Call with Astrologer",
                                            chatKey: "",
                                            videoKey: "on",
                                            skill_id: "",
                                            talkKey: "",
                                            callType: "video"))).then((value) => {
                                  getChatStatus()
                                });*/
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => TalkAstrologer(
                                      astroList:
                                          controllerHomePageLogic.astroListVoice,
                                      appBarName: "Talk with Astrologer",
                                      chatKey: "",
                                      screen: "home",
                                      talkKey: "on",
                                      videoKey: "",
                                      callType: "audio",
                                      expert_astro: "")));
    
                          /* Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => ShoppingMall()));*/
                        },
                        child: GlassContainer(
                          border: 0,
                          linearGradient: LinearGradient(
                            colors: [
                              Color(0xFFFC7601),
                              Color(0xFFFC7601),
                              //  Color(0xFFFC7601).withOpacity(0.60)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/d_icons/call_svg.svg',
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              CustomText(
                                text: 'Call with Astrologer',
                                color: whiteColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              )
                            ],
                          ),
                        ),
                      ),
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

  /// live Astrologers

  Widget liveAstrologers({required BuildContext context}) => Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Live Astrologers',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Segoe UI',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                  Text(
                    'See all',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.6000000238418579),
                      fontSize: 14,
                      fontFamily: 'Segoe UI',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => LiveVideoCallScreen(
                      //             screenType: "home",
                      //             channelName: "1234",
                      //             name: "profile name",
                      //             profile: "", )));
                    },
                    child: Container(
                      height: 100,
                      width: 100,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x3F000000),
                              blurRadius: 4,
                              offset: Offset(0, 0),
                              spreadRadius: 0,
                            ),
                            BoxShadow(
                              color: Color(0x3F000000),
                              blurRadius: 4,
                              offset: Offset(0, 0),
                              spreadRadius: 0,
                            )
                          ],
                          image: DecorationImage(
                              image: AssetImage('assets/image/astro_image.png'),
                              fit: BoxFit.cover)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: 27,
                                height: 10,
                                decoration: ShapeDecoration(
                                  color: Color(0xFFF80C0C),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(9)),
                                  ),
                                ),
                                child: Center(
                                    child: Row(
                                  children: [
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Container(
                                      height: 5,
                                      width: 5,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.white),
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      'Live',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 8,
                                        fontFamily: 'Segoe UI',
                                        fontWeight: FontWeight.w400,
                                        height: 0,
                                      ),
                                    ),
                                  ],
                                )),
                              )
                            ],
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(8),
                                    bottomRight: Radius.circular(8))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Param',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontFamily: 'Segoe UI',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                                Text(
                                  'Vedic Astrology',
                                  style: TextStyle(
                                    color: Color(0xFFFED700),
                                    fontSize: 10,
                                    fontFamily: 'Segoe UI',
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      );

  logoutDialog(
    BuildContext context,
  ) {
    return showDialog(
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Center(
          child: CustomText(
            text: "Logout Confirmation",
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: blueColor,
          ),
        ),
        contentPadding: EdgeInsets.all(15),
        content: Container(
          height: 150,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 10,
              ),
              Text("Are you sure ? You want to logout from AstroguruJii", ),
              SizedBox(
                height: 40,
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
                      // logoutDialog(context);
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

  Widget get astroSearch => Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.grey.shade300)),
        child: TextFormField(
          onTap: () {},
          decoration: InputDecoration(
              // contentPadding: EdgeInsets.only(top:5),
              border: InputBorder.none,
              fillColor: Colors.red,
              prefixIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(
                                color: Colors.grey.shade400, width: 1.5))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(
                        Icons.search,
                        color: Colors.black,
                        size: 24.0,
                      ),
                    )),
              ),
              hintStyle: TextStyle(
                color: Colors.black.withOpacity(0.4000000059604645),
                fontSize: 16,
                fontFamily: 'Segoe UI',
                fontWeight: FontWeight.w600,
                height: 0,
              ),
              hintText: "Search Astrologer"),
        ),
      );

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

  double rating_point = 0.0;
  TextEditingController review_controler = TextEditingController();

  show(BuildContext context, var chanal) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          content: StatefulBuilder(
            // You need this, notice the parameters below:
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Please rate your experience',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RatingBar.builder(
                      itemSize: 30,
                      glowColor: Color(0xfff19425),
                      initialRating: rating_point,
                      itemBuilder: (context, _) {
                        return Icon(
                          Icons.star,
                          color: Color(0xfff19425),
                        );
                      },
                      onRatingUpdate: (rating) {
                        setState(() {
                          rating_point = rating;
                        });
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Additional comments',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: EdgeInsets.only(left: 10, bottom: 5),
                    child: TextFormField(
                      controller: review_controler,
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      minLines: null,
                      maxLines: null,
                      // If this is null, there is no limit to the number of lines, and the text container will start with enough vertical space for one line and automatically grow to accommodate additional lines as they are entered.
                      expands: true,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Review Here",
                          hintStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (rating_point < 1) {
                          Fluttertoast.showToast(
                              msg: "Please give your valuable feedback");
                        } else {
                          Navigator.pop(context);
                          //callAliForRaiting(rating_point, review_controler.text, chanal);
                        }
                      });
                    },
                    child: Container(
                        height: 45,
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xffFC7601),
                              Color(0xffFC7601),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          //  color:Color(0xFFff8542),
                        ),
                        child: Text(
                          "SUBMIT",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700),
                        )),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  mataRaniMandir({required BuildContext context}) {
    return Container(
      height: Get.height * 0.16,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            height: Get.height * 0.17,
            width: Get.width * 0.85,
            margin: EdgeInsets.all(10),
            decoration: ShapeDecoration(
              color: Color(0xFFFF6500),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset('assets/images/mata-rani-image.png'),
                SizedBox(
                  width: 15,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mata Rani Mandir',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Segoe UI',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Devi Maa Pooja',
                              style: TextStyle(
                                color: Color(0xFFFFCE31),
                                fontSize: 16,
                                fontFamily: 'Segoe UI',
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.videocam_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                Text(
                                  'Group Video Call',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'Segoe UI',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Time Left',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontFamily: 'Segoe UI',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              '00:56:89',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'Segoe UI',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

/* Future<void> callAliForRaiting(double rating_point, String text, var chanal) async {
    var res = await _httpServices.add_rating(
        channel_id: chanal.toString(), rating: rating_point.toString(), review: text ?? "Good");
    if (res?.status == true) {
      setState(() {});
    } else {
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }*/
}

class filterAstro extends StatefulWidget {
  const filterAstro({
    Key? key,
  }) : super(key: key);

  @override
  State<filterAstro> createState() => _filterAstroState();
}

class _filterAstroState extends State<filterAstro> {
  int isSelected = 0;
  final Color _colorContainer = Color(0xFFF0F0F0);

  bool selected = true;
  final List filterIcon = [
    'assets/Icons/all.png',
    'assets/Icons/love_n.png',
    'assets/Icons/carrer_n.png',
    'assets/Icons/health.png',
    'assets/Icons/marraige.png',
  ];

  final List filterText = ['All', 'Love', 'Carrer', 'Health', 'Marraige'];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 30,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: filterText.length,
          itemBuilder: (context, index) {
            return InkWell(
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              splashColor: Colors.white,
              hoverColor: Colors.white,
              highlightColor: Colors.white,
              onTap: () {
                setState(() {
                  isSelected = index;
                });
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                height: 30,
                width: 80,
                decoration: BoxDecoration(
                  color: isSelected == index ? blackColor : _colorContainer,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image(
                      image: AssetImage(filterIcon[index].toString()),
                      height: 15,
                    ),
                    Text(
                      filterText[index].toString(),
                      style: TextStyle(
                          color: isSelected == index ? whiteColor : blackColor),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}

class Constants {
  Constants._();

  static const double padding = 20;
  static const double avatarRadius = 45;
}
