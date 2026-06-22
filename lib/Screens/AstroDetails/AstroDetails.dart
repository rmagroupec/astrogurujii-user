
import 'dart:io';

import 'package:astro_gurujii/Screens/ChatIntakeForm.dart';
import 'package:astro_gurujii/Screens/ExportAstrologers/ExpertAstrologer.dart';
import 'package:astro_gurujii/Screens/Models/AstroDetailsModel.dart';
import 'package:astro_gurujii/Screens/Models/HomeDataModel.dart';
import 'package:astro_gurujii/Screens/RatingListScreen.dart';
import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Screens/WebviewScreen.dart';
import 'package:astro_gurujii/Screens/bottomSheet.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:astro_gurujii/Setup/app_colors.dart';
import 'package:astro_gurujii/Setup/app_images.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;

import 'package:astro_gurujii/Setup/color.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:astro_gurujii/Utilities/CustomUi.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:readmore/readmore.dart';

import 'package:translator/translator.dart';
import 'package:html/parser.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../BlogViewScreen.dart';
import '../Models/GetGiftModel.dart';
import '../MyWallet.dart';
import '../live/components/gift_bottm_sheet.dart';

class AstroDetails extends StatefulWidget {
  final categoryId;
  final String? astroLogerName;

  const AstroDetails({Key? key, this.categoryId, this.astroLogerName})
      : super(key: key);

  @override
  _AstroDetailsState createState() => _AstroDetailsState();
}

class _AstroDetailsState extends State<AstroDetails> {
  final HttpServices _httpServices = HttpServices();
  List<Results> data = [];
  List<Galary> galllary = [];
  String? wallet = "0.0";
  String? currency;
  bool loading = true;
  bool _isLoading = true;
  List<Astrologer> astroData = [];
  List<Data> dataGifts = [];

  void getListGift() async {
    var res = await _httpServices.getGiftsListing();
    if (res!.status == true) {
      setState(() {
        dataGifts = res.data!;
      });
    } else {
      Fluttertoast.showToast(msg: res.message!);
    }
  }

  final _api = HttpServices();

  onGiftSendFun({String? giftId, String? to, String? type, int? amount}) {
    _api
        .giftSendApiForAstroFun(
            giftId: giftId, to: to, type: type, amount: amount)
        .then((value) {
      if (value['status'] == true) {
        Fluttertoast.showToast(
          msg: value['message'].toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        // Navigator.pop(context);
      } else if (value['status'] == false) {
        showInsufficientBalanceDialog(context, value['message'].toString());
      }
    }).onError((error, stackTrace) {
      print("Errorin API giftSendApi: $error");
      print("Errorin API stacktrace: $stackTrace");
    });
  }

  void astroDetailsApi() async {
    var res = await _httpServices.astrologer_details(id: widget.categoryId);
    if (res!.status == true) {
      setState(() {
        data = res.results!;
        translateAbout(data[0]
            .about); // Translate the description again when toggling language
        _isLoading = false;
      });
    } else {
      Fluttertoast.showToast(msg: res.message!);
      _isLoading = false;
    }
  }

  String? us_name;
  String? us_image;
  void getProfile() async {
    var res = await _httpServices.profile_api();
    if (res!.status == true) {
      setState(() {
        currency = res.results!.currency.toString();
        wallet = setWallet(res.results!.wallet.toString(),
            res.results!.currency.toString(), res.results!.wallet_usd.toString());
        us_name = res.results!.name.toString();
        us_image = res.results!.profileImg.toString();
      });
    } else {
      Fluttertoast.showToast(msg: res.message!);
    }
  }

  void homeApi() async {
    var res = await _httpServices.home_data();
    if (res!.status == true) {
      setState(() {
        astroData = res.astrologer!;
      });
    } else {
      Fluttertoast.showToast(msg: res.message!);
    }
  }

  void callFollowApi(String? astro_id) async {
    var res = await _httpServices.follow_astro(id: astro_id!);
    if (res!.status == true) {
      setState(() {
        Fluttertoast.showToast(msg: res.message!);
        astroDetailsApi();
      });
    } else {
      Fluttertoast.showToast(msg: res.message!);
    }
  }

  Future<void> callNotifyMeApi({String? id, String? type}) async {
    var res = await _httpServices.notifyme(astro_id: id!);
    if (res!.status ==true) {
      setState(() {
        _isLoading = false;
        createSnackBar(res.message!);
        //Fluttertoast.showToast(msg: res.message!);
      });
    } else {
      _isLoading = false;
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }

  void createSnackBar(String? message) {
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

  @override
  void initState() {
    print("astro---->>> ${widget.categoryId}");
    getProfile();
    astroDetailsApi();
    homeApi();
    getListGift();
    super.initState();
  }

  bool showMore = false;

  String? _translatedDescription =
      ''; // New variable to hold translated description
  final translator = GoogleTranslator();
  bool _isEnglishToHindi = false;

  void toggleLanguage() {
    setState(() {
      _isEnglishToHindi = !_isEnglishToHindi;
      translateAbout(data[0]
          .about); // Translate the description again when toggling language
    });
  }

  void translateAbout(String? description) async {
    print("about before : $description");

    // Translate the extracted text
    final response = await translator.translate(
      description!,
      from: _isEnglishToHindi ? 'en' : 'hi',
      to: _isEnglishToHindi ? 'hi' : 'en',
    );

    // Print translated text
    print(" about after:  ${response.text}");

    setState(() {
      _translatedDescription = response.text;
      // Re-insert translated text into the HTML structure
      // _translatedDescription = description.replaceAllMapped(
      //   RegExp(text),
      //       (match) => response.text,
      //
      //);
    });

    print("descrpiton after=====>>>> ${_translatedDescription}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          elevation: 0,
          title: CustomText(
            // text: 'Astrologer Details',
            text: widget.astroLogerName.toString(),
            color: whiteColor,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
          backgroundColor: primaryColor,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.arrow_back,
                color: whiteColor,
              )),
          actions: [
            InkWell(
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => MyWallet()));
                },
                child: Image.asset(
                  "assets/images/walletIconImage.png",
                  height: 23,
                  width: 23,
                )),
            SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () {
                Share.share(
                    'https://play.google.com/store/apps/details?id=com.user.astrogurujii');
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          // color: Colors.red,
                          border: Border.all(color: whiteColor, width: 1)),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/images/whatsapp.png",
                            fit: BoxFit.fill,
                            height: 18,
                            width: 18,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Share",
                            style: TextStyle(color: whiteColor),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        body: (_isLoading)
            ? Center(
                child: Lottie.asset(
                'assets/profile/loader.json',
              ))
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade400,
                                      blurRadius: 4.0,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 8),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          /// Image view with circle and border
                                          Expanded(
                                            flex: 1,
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (ctx) =>
                                                        AstroDetails(
                                                      astroLogerName:
                                                          data[index].name,
                                                      categoryId:
                                                          data[index].id,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Column(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.all(3),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          getColorImageBorder(
                                                              data[index]
                                                                  .is_busy),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: CircleAvatar(
                                                      radius: 38,
                                                      backgroundImage:
                                                          NetworkImage(
                                                              data[index]
                                                                  .profileImg
                                                                  .toString()),
                                                    ),
                                                  ),
                                                  SizedBox(height: 7),
                                                  RatingBar.builder(
                                                    initialRating: double.parse(
                                                        data[index]
                                                            .avg_rate
                                                            .toString()),
                                                    minRating: 1,
                                                    itemSize: 15,
                                                    ignoreGestures: true,
                                                    allowHalfRating: true,
                                                    itemCount: 5,
                                                    itemBuilder: (context, _) =>
                                                        Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                    ),
                                                    onRatingUpdate: (rating) {},
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    "${data[index].consult} Orders",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10),

                                          /// Content view
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  data[index].name.toString(),
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 7),
                                                Text(
                                                  data[index]
                                                      .category!
                                                      .map((e) => e.name)
                                                      .toList()
                                                      .join(', '),
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black),
                                                ),
                                                SizedBox(height: 7),
                                                Text(
                                                  data[index]
                                                      .language!
                                                      .map((e) => e.name)
                                                      .toList()
                                                      .join(','),
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black),
                                                ),
                                                SizedBox(height: 7),
                                                Text(
                                                  "${data[index].experience} Yr Exp.",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black),
                                                ),
                                              ],
                                            ),
                                          ),

                                          /// Button
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              PopupMenuButton<String?>(
                                                onSelected: (value) {
                                                  // Handle your action
                                                  switch (value) {
                                                    case 'Report and block':
                                                      // Implement your logic for Report and block
                                                      print(
                                                          'Report and block clicked');
                                                      _showMyDialog(
                                                          context,
                                                          data[index]
                                                              .name
                                                              .toString(),
                                                          data[index]
                                                              .profileImg
                                                              .toString());
                                                      break;
                                                    case 'Follow':
                                                      // Implement your logic for Follow
                                                      print('Follow clicked');
                                                      break;
                                                    default:
                                                      print('Unknown');
                                                  }
                                                },
                                                itemBuilder: (BuildContext
                                                        context) =>
                                                    <PopupMenuEntry<String?>>[
                                                  const PopupMenuItem<String?>(
                                                    value: 'Report and block',
                                                    child: Text(
                                                        'Report and block'),
                                                  ),
                                                  const PopupMenuItem<String?>(
                                                    value: 'Follow',
                                                    child: Text('Follow'),
                                                  ),
                                                ],
                                                icon: const Icon(Icons
                                                    .more_vert), // Three dot icon
                                              ),
                                              SizedBox(
                                                height: 40,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  callFollowApi(data[index]
                                                      .id
                                                      .toString());
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 12,
                                                      vertical: 6),
                                                  decoration: BoxDecoration(
                                                    color: data[index]
                                                                .is_Follow
                                                                .toString() ==
                                                            "0"
                                                        ? Colors.grey.shade500
                                                        : AppColors.orangeColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.3),
                                                        spreadRadius: 1,
                                                        blurRadius: 4,
                                                        offset: Offset(0, 2),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      data[index]
                                                                  .is_Follow
                                                                  .toString() ==
                                                              "0"
                                                          ? 'Follow'
                                                          : 'Followed',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: data[index]
                                                                    .is_Follow
                                                                    .toString() ==
                                                                "0"
                                                            ? Colors.black
                                                            : Colors.white,
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

                                    Divider(color: Colors.grey.shade300),

                                    /// Chat, Call, and Video Call Stats
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          IconTextItem(
                                            iconPath:
                                                'assets/images/ChatIconImage.svg',
                                            text:
                                                "${data[index].chat_count} mins",
                                          ),
                                          VerticalDivider(
                                              color: Colors.grey.shade400),
                                          IconTextItem(
                                            iconPath:
                                                'assets/images/callIconImage.svg',
                                            text:
                                                "${data[index].audio_count} mins",
                                          ),
                                          VerticalDivider(
                                              color: Colors.grey.shade400),
                                          IconTextItem(
                                            iconPath:
                                                'assets/images/videoCallIcon.svg',
                                            text:
                                                "${data[index].video_count} mins",
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              /// end new design

                              const SizedBox(
                                height: 20,
                              ),

                              Row(
                                children: [
                                  SizedBox(
                                    width: 15,
                                  ),
                                  CustomText(
                                    text: 'Skills',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: blackColor,
                                  ),
                                ],
                              ),

                              SizedBox(
                                height: 3,
                              ),
                              Padding(
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
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GridView.count(
                                      crossAxisCount: 3,
                                      physics: NeverScrollableScrollPhysics(),
                                      childAspectRatio: (1 / .4),
                                      shrinkWrap: true,
                                      children: List.generate(
                                          data[index].skill!.length, (index1) {
                                        return Padding(
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
                                            child: Center(
                                              child: CustomText(
                                                text:
                                                    '${data[index].skill![index1].name}',
                                                maxLines: 1,
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                                align: TextAlign.center,
                                                
                                                color: blackColor,
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: 20,
                              ),

                              Row(
                                children: [
                                  SizedBox(
                                    width: 15,
                                  ),
                                  CustomText(
                                    text: 'Expertise',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: blackColor,
                                  ),
                                ],
                              ),

                              SizedBox(
                                height: 3,
                              ),

                              Padding(
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
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GridView.count(
                                      crossAxisCount: 3,
                                      physics: NeverScrollableScrollPhysics(),
                                      childAspectRatio: (1 / .4),
                                      shrinkWrap: true,
                                      children: List.generate(
                                          data[index].category!.length,
                                          (index1) {
                                        print(
                                            "data[index].about====>>> ${data[index].about}");

                                        return Padding(
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
                                            child: Center(
                                                child: CustomText(
                                              text:
                                                  '${data[index].category![index1].name}',
                                              maxLines: 1,
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              color: blackColor,
                                            )),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: 20,
                              ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: CustomText(
                                      text: 'About',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: blackColor,
                                    ),
                                  ),
                                  LanguageToggle(
                                    function: toggleLanguage,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),

                              data[index].about == ""
                                  ? Text("No data")
                                  : Padding(
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
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ReadMoreText(
                                            // data[index].about,
                                            _translatedDescription!,

                                            trimLines: 6,
                                            lessStyle: TextStyle(
                                                color: AppColors.showMoreColor),

                                            trimMode: TrimMode.Line,
                                            trimCollapsedText: ' Show more',
                                            trimExpandedText: '   Show less',
                                            moreStyle: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.showMoreColor),
                                          ),
                                        ),
                                      ),
                                    ),

                              // Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: Container(
                              //     decoration: BoxDecoration(
                              //       boxShadow:  [
                              //         BoxShadow(
                              //           color: Colors.grey.shade200,
                              //           offset: Offset(0.0, 1.0), //(x,y)
                              //           blurRadius: 4.0,
                              //         ),
                              //       ],
                              //
                              //     ),
                              //     child: Card(
                              //       elevation: 2,
                              //       child: Column(
                              //         children: [
                              //
                              //           Padding(
                              //             padding: const EdgeInsets.only(left: 8,right: 8,top: 8),
                              //             child:
                              //
                              //             CustomText(
                              //               text: data[index].about,
                              //               fontSize: 14,
                              //               overflow: TextOverflow.ellipsis,                                          fontWeight: FontWeight.normal,
                              //               color: blackColor,
                              //               maxLines: showMore==false?6:200,
                              //             ),
                              //
                              //           ),
                              //           TextButton(onPressed: (){
                              //           showMore=!showMore;
                              //           setState(() {
                              //
                              //           });
                              //           print("fff$showMore");
                              //
                              //           }, child: Text(
                              //             showMore==false? "Show more":"Show less",
                              //           ))
                              //         ],
                              //       ),
                              //     ),
                              //   ),
                              // ),

                              SizedBox(height: 5),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CustomText(
                                      text: 'Gallery',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: blackColor,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(
                                height: 5,
                              ),
                              (data[index].galary != null &&
                                      data[index].galary!.length > 0)
                                  ? Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 200,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 15,
                                          ),

                                          // Padding(
                                          //   padding: const EdgeInsets.only(
                                          //       left: 20),
                                          //   child: CustomText(
                                          //     text: 'Gallery',
                                          //     color: blackColor,
                                          //     fontWeight: FontWeight.w600,
                                          //     fontSize: 18,
                                          //   ),
                                          // ),

                                          const SizedBox(
                                            height: 10,
                                          ),

                                          data[index].galary!.isEmpty
                                              ? Container()
                                              : Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 130,
                                                  margin: const EdgeInsets.only(
                                                      left: 10, right: 10),
                                                  child: ListView.builder(
                                                      itemCount: data[index]
                                                          .galary!
                                                          .length,
                                                      shrinkWrap: true,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemBuilder:
                                                          (contex, index1) {
                                                        return InkWell(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (_) =>
                                                                        WebviewScreen(
                                                                          url: data[index]
                                                                              .galary![index1]
                                                                              .file,
                                                                        )));
                                                          },
                                                          // child: Container(
                                                          //   width: 120,
                                                          //   margin:
                                                          //       EdgeInsets.only(
                                                          //           left: 5,
                                                          //           right: 5),
                                                          //   height: 150,
                                                          //   decoration: BoxDecoration(
                                                          //       border: Border.all(
                                                          //           color: Colors
                                                          //               .black,
                                                          //           width: 1),
                                                          //       borderRadius:
                                                          //           BorderRadius
                                                          //               .circular(
                                                          //                   10),
                                                          //       image: DecorationImage(
                                                          //           fit: BoxFit
                                                          //               .cover,
                                                          //           image: CachedNetworkImageProvider(setImage(data[index].galary[index1].file)))),
                                                          // ),

                                                          child: Container(
                                                            width: 120,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 5,
                                                                    right: 5),
                                                            height: 150,
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .black,
                                                                  width: 1),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            child:
                                                                FutureBuilder<
                                                                    String?>(
                                                              future: setImage(
                                                                  data[index]
                                                                      .galary![
                                                                          index1]
                                                                      .file),
                                                              builder: (context,
                                                                  snapshot) {
                                                                if (snapshot
                                                                        .connectionState ==
                                                                    ConnectionState
                                                                        .waiting) {
                                                                  return Center(
                                                                      child:
                                                                          CircularProgressIndicator()); // Show loader while processing
                                                                } else if (snapshot
                                                                        .hasError ||
                                                                    !snapshot
                                                                        .hasData ||
                                                                    snapshot.data ==
                                                                        null) {
                                                                  return Center(
                                                                      child: Text(
                                                                          'Failed to generate thumbnail')); // Debug fallback
                                                                } else {
                                                                  final isVideo = data[index]
                                                                          .galary![
                                                                              index1]
                                                                          .file!
                                                                          .split(
                                                                              '.')
                                                                          .last
                                                                          .toLowerCase() ==
                                                                      "mp4";
                                                                  final thumbnailPath =
                                                                      snapshot
                                                                          .data;
                                                                  return isVideo
                                                                      ? ClipRRect(
                                                                          borderRadius: BorderRadius.circular(
                                                                              10),
                                                                          child:
                                                                              Stack(
                                                                            alignment:
                                                                                Alignment.center,
                                                                            children: [
                                                                              Image.file(
                                                                                File(thumbnailPath!),
                                                                                fit: BoxFit.fill,
                                                                                width: double.infinity,
                                                                              ),
                                                                              Icon(
                                                                                Icons.play_arrow_rounded,
                                                                                color: Colors.grey.withOpacity(0.8),
                                                                                size: 80,
                                                                              )
                                                                            ],
                                                                          ))
                                                                      :

                                                                      // Display video thumbnail
                                                                      ClipRRect(
                                                                          borderRadius: BorderRadius.circular(
                                                                              10),
                                                                          child: CachedNetworkImage(
                                                                              imageUrl: thumbnailPath!,
                                                                              fit: BoxFit.cover)); // Display original image
                                                                }
                                                              },
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                        ],
                                      ),
                                    )
                                  : SizedBox(),

                              const SizedBox(height: 0),

                              /// location and experiance
                              Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade200,
                                      offset: Offset(0.0, 1.0), //(x,y)
                                      blurRadius: 4.0,
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Card(
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              /// experience

                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      height: 50,
                                                      width: 50,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors
                                                                .grey.shade200,
                                                            offset: Offset(
                                                                0.0, 1.0),
                                                            //(x,y)
                                                            blurRadius: 4.0,
                                                          ),
                                                        ],
                                                        gradient:
                                                            LinearGradient(
                                                                colors: [
                                                              AppColors
                                                                  .color1green,
                                                              AppColors
                                                                  .color2green
                                                            ]),
                                                      ),
                                                      child: Center(
                                                        child: CustomText(
                                                          text: data[index]
                                                              .experience
                                                              .toString(),
                                                          fontSize: 16,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 5),
                                                    CustomText(
                                                      text:
                                                          "${data[index].experience.toString()} years experience",
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              /// location
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      height: 50,
                                                      width: 50,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors
                                                                .grey.shade200,
                                                            offset: Offset(
                                                                0.0, 1.0),
                                                            //(x,y)
                                                            blurRadius: 4.0,
                                                          ),
                                                        ],
                                                        gradient:
                                                            LinearGradient(
                                                                colors: [
                                                              AppColors
                                                                  .color1Pink,
                                                              AppColors
                                                                  .color2Pink
                                                            ]),
                                                      ),
                                                      child: Center(
                                                          child: Icon(
                                                        Icons
                                                            .location_on_outlined,
                                                        color: Colors.white,
                                                      )),
                                                    ),
                                                    SizedBox(height: 5),
                                                    Container(
                                                      // color: Colors.red,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.4,
                                                      child: CustomText(
                                                        // text: "Jaipur, India",
                                                        text:
                                                            "${data[index].city ?? ""}, ${data[index].state ?? ""},${data[index].astro_country ?? ""}",
                                                        fontSize: 13,
                                                        align: TextAlign.center,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8, bottom: 8),
                                      child: Container(
                                        height: 80,
                                        width: 1,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(
                                height: 15,
                              ),

                              /// Ratings and Reviews
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Ratings & Reviews',
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 20,
                                                color: ColorData.color1F1F1F))),
                                    Container(
                                      height: 20,
                                      alignment: Alignment.centerRight,
                                      child: ElevatedButton(
                                          onPressed: () {
                                            if (data[index].rating != null &&
                                                data[index].rating!.isNotEmpty) {
                                              // Navigate to RatingListScreen if there are reviews
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (ctx) =>
                                                      RatingListScreen(
                                                    review: data[0]
                                                        .rating![index]
                                                        .review!
                                                        .toString(),
                                                    astro_name:
                                                        data[index].name!,
                                                    astro_image: data[0]
                                                        .rating![index]
                                                        .profileImg
                                                        .toString(),
                                                    ratings: data[index].rating!,
                                                  ),
                                                ),
                                              );
                                            } else {
                                              // Show toast if no reviews are available
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      "No reviews available"),
                                                  duration:
                                                      Duration(seconds: 2),
                                                ),
                                              );
                                            }

                                            // Navigator.push(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //         builder: (ctx) =>
                                            //             RatingListScreen(
                                            //                 review: data[0]
                                            //                     .rating[index]
                                            //                     .review
                                            //                     .toString(),
                                            //                 astro_name:
                                            //                     data[index]
                                            //                         .name,
                                            //                 // astro_image: data[index].profileImg,
                                            //                 astro_image: data[0]
                                            //                     .rating[index]
                                            //                     .profileImg
                                            //                     .toString(),
                                            //                 ratings: data[index]
                                            //                     .rating)));
                                          },
                                          style: ElevatedButton.styleFrom(
                                              shadowColor: primaryColor,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          35)),
                                              side: BorderSide(
                                                color: primaryColor,
                                              )),
                                          child: Text(
                                            'View all reviews',
                                            style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12,
                                                    letterSpacing: -0.3,
                                                    color: whiteColor)),
                                          )),
                                    )
                                  ],
                                ),
                              ),

                              const SizedBox(
                                height: 27,
                              ),

                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.zero,
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                data[index]
                                                        .avg_rate
                                                        .toString() ??
                                                    "",
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Icon(
                                                Icons.star,
                                                color: ColorData.colorFFA62F,
                                                size: 16,
                                              )
                                            ],
                                          ),

                                          // const SizedBox(height: 4),

                                          Row(
                                            children: [
                                              const SizedBox(width: 10),
                                              Icon(
                                                Icons.person,
                                                size: 13,
                                                color: ColorData.color727272,
                                              ),
                                              Text(
                                                '${data[index].rating_total_person.toString() ?? ""} Total',
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 12,
                                                    color:
                                                        ColorData.color727272,
                                                    letterSpacing: -0.48),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      margin: EdgeInsets.zero,
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 2),
                                            child: Row(
                                              children: [
                                                Icon(Icons.star,
                                                    color:
                                                        ColorData.colorFFA62F,
                                                    size: 15),
                                                Icon(Icons.star,
                                                    color:
                                                        ColorData.colorFFA62F,
                                                    size: 15),
                                                Icon(Icons.star,
                                                    color:
                                                        ColorData.colorFFA62F,
                                                    size: 15),
                                                Icon(Icons.star,
                                                    color:
                                                        ColorData.colorFFA62F,
                                                    size: 15),
                                                Icon(Icons.star,
                                                    color:
                                                        ColorData.colorFFA62F,
                                                    size: 15),
                                                LinearPercentIndicator(
                                                  width: 170.0,
                                                  lineHeight: 3,
                                                  percent: ((double.parse(
                                                          data[index]
                                                              .five_rate 
                                                              .toString())) /
                                                      100) > 1.0 ? 1.0 :((double.parse(
                                                          data[index]
                                                              .five_rate 
                                                              .toString())) /
                                                      100) ,
                                                  // progressColor: ColorData.colorFF6A66,
                                                  progressColor: Colors.white,
                                                  backgroundColor: Colors.white,
                                                ),
                                                Text(
                                                  "${data[index].five_rate.toString()}",
                                                  style: GoogleFonts.roboto(
                                                      textStyle: TextStyle(
                                                          fontSize: 9,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          color: ColorData
                                                              .color727272)),
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 2),
                                            child: Row(
                                              children: [
                                                const Icon(Icons.star,
                                                    color: Colors.transparent,
                                                    size: 15),
                                                Icon(Icons.star,
                                                    color:
                                                        ColorData.colorFFA62F,
                                                    size: 15),
                                                Icon(Icons.star,
                                                    color:
                                                        ColorData.colorFFA62F,
                                                    size: 15),
                                                Icon(Icons.star,
                                                    color:
                                                        ColorData.colorFFA62F,
                                                    size: 15),
                                                Icon(Icons.star,
                                                    color:
                                                        ColorData.colorFFA62F,
                                                    size: 15),
                                                LinearPercentIndicator(
                                                  width: 170.0,
                                                  lineHeight: 3,
                                                  percent: (double.parse(
                                                          data[index]
                                                              .four_rate
                                                              .toString())) /
                                                      100,
                                                  // progressColor: ColorData.colorFF6A66,
                                                  progressColor: Colors.white,
                                                  backgroundColor: Colors.white,
                                                ),
                                                Text(
                                                  "${data[index].four_rate.toString()}",
                                                  style: GoogleFonts.roboto(
                                                      textStyle: TextStyle(
                                                          fontSize: 9,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          color: ColorData
                                                              .color727272)),
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 2),
                                            child: Row(
                                              children: [
                                                const Icon(Icons.star,
                                                    color: Colors.transparent,
                                                    size: 15),
                                                const Icon(Icons.star,
                                                    color: Colors.transparent,
                                                    size: 15),
                                                Icon(Icons.star,
                                                    color:
                                                        ColorData.colorFFA62F,
                                                    size: 15),
                                                Icon(Icons.star,
                                                    color:
                                                        ColorData.colorFFA62F,
                                                    size: 15),
                                                Icon(Icons.star,
                                                    color:
                                                        ColorData.colorFFA62F,
                                                    size: 15),
                                                LinearPercentIndicator(
                                                  width: 170.0,
                                                  lineHeight: 3,
                                                  percent: (double.parse(
                                                          data[index]
                                                              .three_rate
                                                              .toString())) /
                                                      100,
                                                  // progressColor: ColorData.colorFF6A66,
                                                  progressColor: Colors.white,
                                                  backgroundColor: Colors.white,
                                                ),
                                                Text(
                                                  "${data[index].three_rate.toString()}",
                                                  style: GoogleFonts.roboto(
                                                      textStyle: TextStyle(
                                                          fontSize: 9,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          color: ColorData
                                                              .color727272)),
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 2),
                                            child: Row(
                                              children: [
                                                const Icon(Icons.star,
                                                    color: Colors.transparent,
                                                    size: 15),
                                                const Icon(Icons.star,
                                                    color: Colors.transparent,
                                                    size: 15),
                                                const Icon(Icons.star,
                                                    color: Colors.transparent,
                                                    size: 15),
                                                Icon(Icons.star,
                                                    color:
                                                        ColorData.colorFFA62F,
                                                    size: 15),
                                                Icon(Icons.star,
                                                    color:
                                                        ColorData.colorFFA62F,
                                                    size: 15),
                                                LinearPercentIndicator(
                                                  width: 170.0,
                                                  lineHeight: 3,
                                                  percent: (double.parse(
                                                          data[index]
                                                              .two_rate
                                                              .toString())) /
                                                      100,
                                                  // progressColor: ColorData.colorFF6A66,
                                                  progressColor: Colors.white,
                                                  backgroundColor: Colors.white,
                                                ),
                                                Text(
                                                  "${data[index].two_rate.toString()}",
                                                  style: GoogleFonts.roboto(
                                                      textStyle: TextStyle(
                                                          fontSize: 9,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          color: ColorData
                                                              .color727272)),
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 2),
                                            child: Row(
                                              children: [
                                                const Icon(Icons.star,
                                                    color: Colors.transparent,
                                                    size: 15),
                                                const Icon(Icons.star,
                                                    color: Colors.transparent,
                                                    size: 15),
                                                const Icon(Icons.star,
                                                    color: Colors.transparent,
                                                    size: 15),
                                                const Icon(Icons.star,
                                                    color: Colors.transparent,
                                                    size: 15),
                                                Icon(Icons.star,
                                                    color:
                                                        ColorData.colorFFA62F,
                                                    size: 15),
                                                LinearPercentIndicator(
                                                  width: 170.0,
                                                  lineHeight: 3,
                                                  percent: (double.parse(
                                                          data[index]
                                                              .one_rate
                                                              .toString())) /
                                                      100,
                                                  // progressColor: ColorData.colorFF6A66,
                                                  progressColor: Colors.white,
                                                  backgroundColor: Colors.white,
                                                ),
                                                Text(
                                                  "${data[index].one_rate.toString()}",
                                                  style: GoogleFonts.roboto(
                                                      textStyle: TextStyle(
                                                          fontSize: 9,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          color: ColorData
                                                              .color727272)),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 35),

                              ratingsReviews(),

                              SizedBox(
                                child: ExpertAstrologer(
                                  data: astroData,
                                ),
                              ),

                              /// send gifts
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "assets/icon/gift.png",
                                      fit: BoxFit.fill,
                                      height: 25,
                                      width: 25,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    CustomText(
                                        text:
                                            "Send Gift to ${widget.astroLogerName}",
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    InkWell(
                                        onTap: () {
                                          howToWorksDialog(context);
                                        },
                                        child: Icon(
                                          Icons.error_outline,
                                          size: 19,
                                        )),

                                    // Image.asset("assets/images/howGiftWorkIcon.png",fit:BoxFit.fill,
                                    //   height: 15,
                                    //     width:16
                                    //   )
                                  ],
                                ),
                              ),

                              GridView.builder(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                itemCount: dataGifts.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4,
                                        crossAxisSpacing: 10.0,
                                        mainAxisSpacing: 10.0,
                                        mainAxisExtent: 120),
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    onTap: () {
                                      onGiftSendFun(
                                          giftId:
                                              dataGifts[index].sId.toString(),
                                          to: widget.categoryId.toString(),
                                          type: "normal",
                                          amount: dataGifts[index].price);
                                    },
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 5,
                                        ),
                                        ClipOval(
  child: Image.network(
    dataGifts[index].image ?? '',
    fit: BoxFit.cover,
    height: 60,
    width: 60,
    errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.shade300,
          ),
        ),
      );
    },
    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
      if (loadingProgress == null) return child;
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.shade300,
          ),
        ),
      );
    },
  ),
),
CustomText(
                                          text: dataGifts[index].title ?? "",
                                          fontSize: 13,
                                          color: Colors.black,
                                          // fontWeight: FontWeight.bold
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        CustomText(
                                            text: "₹ ${dataGifts[index].price}",
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ],
                                    ),
                                  );
                                },
                              )
                            ],
                          );
                        }),
                  ),

                  /// send gift

                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 5, bottom: 10, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: InkWell(
                            /// 1 check status astrologer is busy or offline
                            /// 2 if busy or offline then user then
                            /// 3 check user wallet

                            onTap: () async {
                              /// 1 check status astrologer is busy or offline
                               getProfile();
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
                                      us_name!,
                                      us_image!,
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
                                      currency!,
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
                              height: 60,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: getColor(data[0].isChatOnline,
                                      data[0].is_busy, "chat"),
                                  borderRadius: BorderRadius.circular(10)),
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // Icon(Icons.error,color: whiteColor,),
                                        Image.asset(
                                          'assets/images/chatIconPng.png',
                                          width: 25,
                                          height: 25,
                                          color: whiteColor,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        CustomText(
                                          text: setTitleStatus(
                                              data[0].isChatOnline!,
                                              data[0].is_busy!,
                                              "chat")!,
                                          color: whiteColor,
                                          fontSize:
                                              (data[0].is_busy == 0) ? 16 : 16,
                                          fontWeight: FontWeight.bold,
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // Icon(Icons.error,color: whiteColor,),
                                        (!data[0].per_min_chat_offer.isEmpty)
                                            ? Text(
                                                '${setOfferCallingrate("chat", 0)}',
                                                style: TextStyle(
                                                  color: greyColor3,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                ),
                                                textAlign: TextAlign.center,
                                              )
                                            : Container(),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        CustomText(
                                          text: '${setCallingrate("chat", 0)}',
                                          color: whiteColor,
                                          fontSize:
                                              (data[0].is_busy == 0) ? 16 : 16,
                                          fontWeight: FontWeight.w400,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 2,
                          child: InkWell(
                            onTap: () async {
                               getProfile();
                              if (data[0].is_busy == 0 &&
                                  data[0].isVoiceOnline == "off") {
                                callNotifyMeApi(
                                    id: data[0].id.toString(), type: "audio");
                              } else {
                                bottomSheet(
                                    us_name!,
                                    us_image!,
                                    data[0].astro_number.toString(),
                                    context,
                                    data[0].id.toString(),
                                    (data[0].per_min_voice_call_offer.isEmpty)
                                        ? data[0].perMinVoiceCall.toString()
                                        : data[0]
                                            .per_min_voice_call_offer
                                            .toString(),
                                    "5",
                                    data[0].profileImg!,
                                    currency!,
                                    "+91",
                                    data[0].name!,
                                    wallet.toString(),
                                    "audio",
                                    loading);
                              }
                            },
                            child: Container(
                              height: 60,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: getColor(data[0].isVoiceOnline,
                                      data[0].is_busy, "audio"),
                                  borderRadius: BorderRadius.circular(10)),
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // Icon(Icons.error,color: whiteColor,),
                                        Image.asset(
                                          'assets/images/callPng.png',
                                          width: 20,
                                          height: 20,
                                          color: whiteColor,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        CustomText(
                                          text: setTitleStatus(
                                              data[0].isVoiceOnline,
                                              data[0].is_busy,
                                              "audio")!,
                                          color: whiteColor,
                                          fontSize:
                                              (data[0].is_busy == 0) ? 16 : 16,
                                          fontWeight: FontWeight.bold,
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // Icon(Icons.error,color: whiteColor,),
                                        (!data[0]
                                                .per_min_voice_call_offer
                                                .isEmpty)
                                            ? Text(
                                                '${setOfferCallingrate("chat", 0)}',
                                                style: TextStyle(
                                                  color: greyColor3,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                ),
                                                textAlign: TextAlign.center,
                                              )
                                            : Container(),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        CustomText(
                                          text: '${setCallingrate("audio", 0)}',
                                          color: whiteColor,
                                          fontSize:
                                              (data[0].is_busy == 0) ? 16 : 16,
                                          fontWeight: FontWeight.w400,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 2,
                          child: InkWell(
                            onTap: () async {
                               getProfile();
                              if (data[0].is_busy == 0 &&
                                  data[0].isVideoOnline == "off") {
                                callNotifyMeApi(
                                    id: data[0].id.toString(), type: "audio");
                              } else {
                                bottomSheet(
                                    us_name!,
                                    us_image!,
                                    data[0].astro_number.toString(),
                                    context,
                                    data[0].id.toString(),
                                    (data[0].per_min_video_call_offer.isEmpty)
                                        ? data[0].perMinVideoCall.toString()
                                        : data[0]
                                            .per_min_video_call_offer
                                            .toString(),
                                    "5",
                                    data[0].profileImg!,
                                    currency!,
                                    "+91",
                                    data[0].name!,
                                    wallet.toString(),
                                    "video",
                                    loading);
                              }
                            },
                            child: Container(
                              height: 60,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: getColor(data[0].isVideoOnline,
                                      data[0].is_busy, "video"),
                                  borderRadius: BorderRadius.circular(10)),
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // Icon(Icons.error,color: whiteColor,),
                                        Image.asset(
                                          'assets/profile/video_call.png',
                                          width: 24,
                                          height: 24,
                                          color: whiteColor,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        CustomText(
                                          text: setTitleStatus(
                                              data[0].isVideoOnline,
                                              data[0].is_busy,
                                              "video")!,
                                          color: whiteColor,
                                          fontSize:
                                              (data[0].is_busy == 0) ? 16 : 16,
                                          fontWeight: FontWeight.w500,
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 22),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        (!data[0]
                                                .per_min_voice_call_offer
                                                .isEmpty)
                                            ? Text(
                                                '${setOfferCallingrate("chat", 0)}',
                                                style: TextStyle(
                                                  color: greyColor3,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                ),
                                                textAlign: TextAlign.center,
                                              )
                                            : Container(),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        CustomText(
                                          text: '${setCallingrate("video", 0)}',
                                          color: whiteColor,
                                          fontSize:
                                              (data[0].is_busy == 0) ? 16 : 16,
                                          fontWeight: FontWeight.w400,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ));
  }

  ///Ratings & Reviews
  Widget ratingsReviews() {
    return Container(
      width: Get.width,
      color: ColorData.colorF6F6F6,
      child: Column(
        children: <Widget>[
          // rowCardHeadings(String?Data.ratingsReview, 7.0, 17.0, 21.0, 0.0),
          data[0].rating!.isEmpty ? Container() : ratingCard(),
          //ratingCard(),
        ],
      ),
    );
  }

  ///Rating & Review Card
  Widget ratingCard() {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: (data[0].rating!.length > 5) ? 5 : data[0].rating!.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          print(
              "ffffffff===>>> ${data[0].rating![index].profileImg.toString()}");
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 4.0,
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                  flex: 1,
                                  child: CircleAvatar(
                                      radius: 30,
                                      backgroundImage: data[0]
                                                  .rating![index]
                                                  .profileImg
                                                  .toString() ==
                                              ""
                                          ? AssetImage(
                                              "assets/images/demoPic.jpg")
                                          : NetworkImage(data[0]
                                              .rating![index]
                                              .profileImg
                                              .toString()))),
                              SizedBox(width: 23.0),
                              Expanded(
                                flex: 4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          child: CustomText(
                                            fontSize: 16.0,
                                            text:
                                                "${data[0].rating![index].name.toString()}",
                                            fontWeight: FontWeight.w500,
                                            color: ColorData.color000000,
                                            maxLines: 3,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 7.0),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        stars(
                                            double.parse(data[0]
                                                .rating![index]
                                                .rating
                                                .toString()),
                                            11.0),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: CustomText(
                                            fontSize: 13.0,
                                            text: data[0]
                                                        .rating![index]
                                                        .review
                                                        .toString() ==
                                                    ""
                                                ? "No Review"
                                                : data[0]
                                                    .rating![index]
                                                    .review
                                                    .toString(),
                                            //text: "dsd",
                                            fontWeight: FontWeight.w400,
                                            color: ColorData.color747474,
                                          ),
                                        ),
                                        Expanded(
                                          child: CustomText(
                                            text:
                                                "${data[0].rating![index].createdDate.toString()}",
                                            color: ColorData.color727272,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: PopupMenuButton<String?>(
                        padding: EdgeInsets.zero,

                        onSelected: (value) {
                          // Handle your action
                          switch (value) {
                            case 'Report and review':
                              // Implement your logic for Report and block
                              print('Report and review');
                              break;
                            default:
                              print('Unknown');
                          }
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String?>>[
                          const PopupMenuItem<String?>(
                            value: 'Report and review',
                            child: Text('Report and review'),
                          ),
                          // const PopupMenuItem<String?>(
                          //   value: 'Follow',
                          //   child: Text('Follow'),
                          // ),
                        ],
                        icon: const Icon(Icons.more_vert), // Three dot icon
                      ),
                    )
                  ],
                )),
          );
        });
  }

  ///Stars
  Widget stars(double rating, double size) {
    return RatingBar.builder(
      initialRating: rating,
      minRating: 1,
      itemSize: size,
      ignoreGestures: true,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemPadding: const EdgeInsets.symmetric(horizontal: 2.5),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: ColorData.colorFFA62F,
      ),
      onRatingUpdate: (rating) {
        //print(rating);
      },
    );
  }

  // setImage(String? file) {
  //   var fileName = (file.split('.').last);
  //   print("==========================================================" + fileName);
  //   if (fileName == "mp4") {
  //     return 'https://admin.astropush.com/images/i/Group.png';
  //   } else {
  //     return file;
  //   }
  // }

  Future<String?> setImage(String? file) async {
    var fileName = file!.split('.').last.toLowerCase();

    if (fileName == "mp4") {
      try {
        // Check if it's a remote URL
        if (file.startsWith('http')) {
          // Download the video to a temporary file
          final tempDir = Directory.systemTemp;
          final tempVideoFile = File('${tempDir.path}/temp_video.mp4');
          final response = await http.get(Uri.parse(file));
          await tempVideoFile.writeAsBytes(response.bodyBytes);

          // Generate a thumbnail from the downloaded video
          final thumbnailPath = await VideoThumbnail.thumbnailFile(
            video: tempVideoFile.path,
            imageFormat: ImageFormat.JPEG,
            maxWidth: 120,
            quality: 75,
          );

          return thumbnailPath; // Return thumbnail path
        } else {
          // Generate a thumbnail directly from a local file
          final thumbnailPath = await VideoThumbnail.thumbnailFile(
            video: file,
            imageFormat: ImageFormat.JPEG,
            maxWidth: 120,
            quality: 75,
          );

          return thumbnailPath;
        }
      } catch (e) {
        print("Error generating thumbnail: $e");
        return null; // Return null if thumbnail generation fails
      }
    }
    return file; // Return original file path for non-video files
  }

  String? setWallet(String? wallet, String? currency, String? usdWallet) {
    if (currency == "USD") {
      return "${usdWallet}";
    } else {
      return "${wallet}";
    }
  }

  String? setCallingrate(callType, int index) {
    var price = "";
    if (data[index].is_busy != 0) {
      price = "Busy";
      return price;
    } else {
      if (callType == "chat") {
        if (data[index].country == "INR") {
          price = "\u{20B9}${data[index].perMinChat}/min";
          return price;
        } else {
          price = "\u{20B9}${data[index].perMinChat}/min";
          return price;
        }
      } else if (callType == "video") {
        if (data[index].country == "INR") {
          price = "\u{20B9}${data[index].perMinVideoCall}/min";
          return price;
        } else {
          price = "\u{20B9}${data[index].perMinVideoCall}/min";
          return price;
        }
      } else if (callType == "audio") {
        if (data[index].country == "INR") {
          price = "\u{20B9}${data[index].perMinVoiceCall}/min";
          return price;
        } else {
          price = "\u{20B9}${data[index].perMinVoiceCall}/min";
          return price;
        }
      } else if (callType == "ask") {
        if (data[index].country == "INR") {
          price = "\u{20B9}${data[index].perQuestionPrice}/min";
          return price;
        } else {
          price = "\u{20B9}${data[index].perQuestionPrice}/min";
          return price;
        }
      }
    }
  }

  String? setOfferCallingrate(callType, int index) {
    var price = "";
    if (data[index].is_busy != 0) {
      price = "Busy";
      return price;
    } else {
      if (callType == "chat") {
        if (data[index].country == "INR") {
          price = "\u{20B9}${data[index].per_min_chat_offer}";
          return price;
        } else {
          price = "\u{20B9}${data[index].per_min_chat_offer}";
          return price;
        }
      } else if (callType == "video") {
        if (data[index].country == "INR") {
          price = "\u{20B9}${data[index].per_min_video_call_offer}";
          return price;
        } else {
          price = "\u{20B9}${data[index].per_min_video_call_offer}";
          return price;
        }
      } else if (callType == "audio") {
        if (data[index].country == "INR") {
          price = "\u{20B9}${data[index].per_min_voice_call_offer}";
          return price;
        } else {
          price = "\u{20B9}${data[index].per_min_voice_call_offer}";
          return price;
        }
      } else if (callType == "ask") {
        return "";
      }
    }
  }

/*  getColor(String? Online, int is_busy, String? title) {
    if (Online == "on" && is_busy == 0 && title == "chat") {
      return Colors.green;
    } else if (Online == "on" && is_busy == 0 && title == "call") {
      return Colors.green;
    } else if (Online == "on" && is_busy == 0 && title == "video") {
      return Colors.green;
    } else if (Online == "off") {
      return Colors.grey;
    } else if (is_busy == 1) {
      return Colors.red;
    } else {
      return Colors.red;
    }

  }*/

/*
  String? setTitleStatus(String? Online, int is_busy, String? title) {
    if (Online == "on" && is_busy == 0 && title == "chat") {
      return "Online";
    } else if (Online == "on" && is_busy == 0 && title == "call") {
      return "Online";
    } else if (Online == "on" && is_busy == 0 && title == "video") {
      return "online";
    } else if (Online == "off") {
      return "Offline";
    } else if (is_busy == 1) {
      return "Busy";
    } else {
      return "Busy";
    }
  }
*/

  setBorderColorChat(String? Online, int is_busy) {
    if (Online == "on" && is_busy == 0) {
      return greenColor;
    } else if (Online == "off") {
      return offlineColor;
    } else if (is_busy == 1) {
      return busyColor;
    } else {
      return offlineColor;
    }
  }

  String? setTitle(String? Online, int is_busy, String? title) {
    if (Online == "on" && is_busy == 0 && title == "CHAT NOW") {
      return "Chat";
    } else if (Online == "on" && is_busy == 0 && title == "Talk NOW") {
      return "Call";
    } else if (Online == "on" && is_busy == 0 && title == "Video Call") {
      return "Video Call";
    } else if (Online == "off") {
      return "Offline";
    } else if (is_busy == 1) {
      return "Busy";
    } else {
      return "Busy";
    }
  }

  getSkils(String? skill) {
    var values = skill!
        .split(",")
        .map((x) => x.trim())
        .where((element) => element.isNotEmpty)
        .toList();
    return values;
  }

  bool setCheckForChat(String? userWallet, String? video_rate) {
    var totalMin = 0.0;
    totalMin = double.parse(userWallet!) / double.parse(video_rate!);
    if (totalMin < 5) {
      return true;
    }
    return false;
  }

  // getColor(String? Online, int is_busy, String? title) {
  //   if (Online == "on" && is_busy == 0 && title == "chat") {
  //     return Colors.green;
  //   } else if (Online == "on" && is_busy == 0 && title == "audio") {
  //     return Colors.green;
  //   } else if (Online == "on" && is_busy == 0 && title == "video") {
  //     return Colors.green;
  //   } else if (Online != "on") {
  //     return Colors.grey;
  //   } else if (is_busy == 1) {
  //     return Colors.red;
  //   } else {
  //     return Colors.red;
  //   }
  // }

  getColor(String? Online, int is_busy, String? title) {
    // if ((Online == "on" && is_busy == 0 && title == "chat") ||
    //     (Online == "on" && is_busy == 0 && title == "audio") ||
    //     (Online == "on" && is_busy == 0 && title == "video")) {
    //   return Colors.green;
    // }
    if (Online == "on" && is_busy == 0 && title == "chat") {
      // return Colors.green;
      return AppColors.yellowColor;
    } else if (Online == "on" && is_busy == 0 && title == "audio") {
      return AppColors.appGreenColor;
    } else if (Online == "on" && is_busy == 0 && title == "video") {
      // return Colors.green;
      return AppColors.appblueColor;
    } else if (Online == "off") {
      return Colors.grey;
    } else if (is_busy == 1) {
      return Colors.red;
    } else {
      return Colors.red;
    }
  }

  getTextColor(String? Online, int is_busy, String? title) {
    if ((Online == "on" && is_busy == 0 && title == "chat") ||
        (Online == "on" && is_busy == 0 && title == "audio") ||
        (Online == "on" && is_busy == 0 && title == "video")) {
      return Colors.green;
    } else if (Online == "off") {
      return Colors.grey;
    } else if (is_busy == 1) {
      return Colors.red;
    } else {
      return Colors.red;
    }
  }

  String? setTitleStatus(String? Online, int is_busy, String? title) {
    if (Online == "on" && is_busy == 0 && title == "chat") {
      return "Chat";
    } else if (Online == "on" && is_busy == 0 && title == "audio") {
      return "Call";
    } else if (Online == "on" && is_busy == 0 && title == "video") {
      return "Video Call";
    } else if (Online == "off") {
      return "Notify me";
    } else if (is_busy == 1) {
      return "Notify me";
    } else {
      return "Busy";
    }
  }
}

getColorImageBorder(int is_busy) {
  if (is_busy == 0) {
    return Colors.green;
  } else {
    return Colors.red;
  }
}

Future<void> _showMyDialog(
    BuildContext context, String? name, String? image) async {
  return showDialog<void>(
    context: context,
    // barrierDismissible: false, // User must tap button to dismiss
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          child: SingleChildScrollView(
              child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 1,
                  ),
                  CustomText(
                    text: "Report & Block",
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Image.asset(
                        "assets/images/cancelImage.png",
                        height: 30,
                        width: 30,
                      ))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              ClipOval(
                  child: Image.network(
                image.toString(),
                fit: BoxFit.fill,
                height: 60,
                width: 60,
              )),
              SizedBox(
                height: 10,
              ),
              CustomText(
                text: name!,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              SizedBox(
                height: 10,
              ),
              CustomText(
                text: "Reason for blocking",
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey,
                      )),
                  width: double.infinity,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Write your reason....",
                      contentPadding: EdgeInsets.only(left: 20),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: CustomText(
                      text: "Submit",
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: CupertinoColors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          )),
        ),
      );
    },
  );
}

/// IconTextItem Widget
class IconTextItem extends StatelessWidget {
  final String? iconPath;
  final String? text;

  IconTextItem({this.iconPath, this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(iconPath!, width: 18, height: 18, color: Colors.grey),
        SizedBox(width: 5),
        Text(
          text!,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
