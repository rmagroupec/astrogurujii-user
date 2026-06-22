import 'dart:async';
import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:astro_gurujii/Screens/poojaScreen/model/poojDetailsModel.dart';
import 'package:astro_gurujii/Screens/poojaScreen/ui/reviewAndCheckout.dart';
import 'package:astro_gurujii/Setup/app_colors.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:astro_gurujii/Utilities/banner_loader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:readmore/readmore.dart';
import 'package:share_plus/share_plus.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tcard/tcard.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Setup/SetUp.dart';
import '../../Login.dart';
import '../../MyWallet.dart';
import '../../WebServices/HttpServices.dart';
import '../../chats_screen/Loading.dart';
import '../controller/controller.dart';
import 'language.dart';

class PoojaDetailScreen extends StatefulWidget {
  final String instaId;
  final String onlyDate;
  final String onlyMonth;
  final String onlyDay;
  final String userId;

  const PoojaDetailScreen(
    this.instaId,
    this.onlyDate,
    this.onlyMonth,
    this.onlyDay,
    this.userId,
  );

  @override
  State<PoojaDetailScreen> createState() => _PoojaDetailScreenState();
}

class _PoojaDetailScreenState extends State<PoojaDetailScreen> {
  final itemKey = GlobalKey();

  final GlobalKey _keyForTiming = GlobalKey();
  final GlobalKey _keyForPackage = GlobalKey();

  void _showPopupMenu(BuildContext context) {
    final RenderBox renderBox =
        _keyForTiming.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    showMenu(
      context: context,
      color: primaryColor,
      // shape:,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + size.height,
        offset.dx + size.width,
        offset.dy + size.height + 1,
      ),
      items: [
        PopupMenuItem<String>(
          value: '1',
          child: SizedBox(
            width:
                MediaQuery.of(context).size.width, // full width of the screen
            // color: primaryColor,
            // padding: EdgeInsets.all(8.0),
            child: Text(
              'Timing for the Puja will be notified one day in advance',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  void _showPopupMenuForPackage(BuildContext context) {
    final RenderBox renderBox =
        _keyForPackage.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    showMenu(
      context: context,
      color: primaryColor,
      // shape:,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + size.height,
        offset.dx + size.width,
        offset.dy + size.height + 1,
      ),
      items: [
        PopupMenuItem<String>(
          value: '1',
          child: SizedBox(
            width:
                MediaQuery.of(context).size.width,
            child: Text(
              'Applicable for Group Puja packages . For VIP Puja you can select the suitable time slot',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    screenController.poojaDetailsApi(widget.instaId);
  }

  @override
  void dispose() {
    super.dispose();
  }

  final dataKey = GlobalKey();
  final HttpServices _httpServices = HttpServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          elevation: 1,
          iconTheme: IconThemeData(
            color: whiteColor, //change your color here
          ),
          backgroundColor: AppColors.orangeColor,
          foregroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            "Puja Details",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: InkWell(
                  onTap: () {
                    Share.share(
                        'https://play.google.com/store/apps/details?id=com.user.astrogurujii');

                  },
                  child: Image.asset(
                    "assets/images/whatsapp.png",
                    height: 22,
                    width: 22,
                  )),
            ),
          ]),
      body: GetBuilder(
        init: PoojaController(),
        builder: (controller) {
           return screenController.poojaDetailsLoading.value == true
              ? Center(child: Loading())
              : Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: SafeArea(
                      child: Container(
                         margin: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            titleAndDateSection(context),
                            SizedBox(
                              height: 20,
                            ),
                            // imageSection(context),
                            SizedBox(
                              width:MediaQuery.of(context).size.width,
                              child: poojaImagesCarusel()),
                            SizedBox(
                              height: 10,
                            ),

                            Row(
                              children: [
                                Icon(
                                  Icons.temple_hindu_outlined,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "${screenController.poojaDetailModel!.data!.mandirName}",
                                  style: TextStyle(
                                      color: AppColors.nblacksColor,
                            fontSize: 13,
                            fontFamily: 'poppins',
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_month_outlined,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "${widget.onlyDate} ${widget.onlyMonth} 2025, ${widget.onlyDay}",
                                  style: TextStyle(
                                      color: AppColors.nblacksColor,
                            fontSize: 13,
                            fontFamily: 'poppins',
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            // SizedBox(height: 6,),
                            // CustomText(text: "${widget.onlyDate} ${widget.onlyMonth} 2025", fontWeight: FontWeight.w300,),
                            SizedBox(
                              height: 15,
                            ),

                            noOfPeopleBookedPooja(screenController),
                            SizedBox(
                              height: 5,
                            ),
                            TimerScreen(
                              datetime: screenController
                                  .poojaDetailModel!.data!.pujaDate
                                  .toString(),
                            ), SizedBox(
                              height: 10,
                            ),

                            poojaPackageNewDesign(),
                            SizedBox(
                              height: 10,
                            ),

                            poojaDetailsSection(),
                            SizedBox(
                              height: 20,
                            ),
                            aboutSection(context),
                            SizedBox(
                              height: 20,
                            ),
                            aboutTempleSection(context),
                            SizedBox(
                              height: 20,
                            ), faqSection(context),
                            SizedBox(
                              height: 20,
                            ),

                            customerReviewSection()
                          ],
                        ),
                      ),
                    ),
                  ),
                );
        }
      ),
      bottomNavigationBar: Material(
        color: Colors.transparent,
        elevation: 30,
        child: Container(
          height: 75,
          width: double.infinity,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReviewAndCheckout(
                            bannerList: screenController
                                .poojaDetailModel!.data!.bannerImages!,
                            date: "${widget.onlyDate} ${widget.onlyMonth}",
                            packageAmount: screenController.poojaDetailModel!
                                .data!.packages![selcetdpackage].packagePrice
                                .toString(),
                            packageName: screenController.poojaDetailModel!
                                .data!.packages![selcetdpackage].packageType
                                .toString(),
                            onlyDate: widget.onlyDate,
                            onlyMonth: widget.onlyMonth,
                            purposeOfPooja: screenController
                                    .poojaDetailModel!.data!.purposeOfPooja ??
                                "",
                            poojaName: screenController
                                    .poojaDetailModel!.data!.title ??
                                "",
                            templeName: screenController
                                    .poojaDetailModel!.data!.mandirName ??
                                "",
                            userId: widget.userId,
                          ),
                        ));
                  },
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.only(
                        top: 6, left: 24, right: 23, bottom: 7),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.orangeColor, AppColors.mBGColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IgnorePointer(
  ignoring: true,
                          child: AnimatedTextKit(
                            repeatForever: true,
                            pause: Duration(milliseconds: 200),
                            animatedTexts: [
                              RotateAnimatedText('Book Now',
                                  textStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                    letterSpacing: 0,
                                  )),
                              RotateAnimatedText('Participate Now',
                                  textStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                    letterSpacing: 0,
                                  )),
                              RotateAnimatedText('Limited Offers!',
                                  textStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                    letterSpacing: 0,
                                  )),
                            ],
                          ),
                        ),

                        // Text(
                        //   'Book Puja',
                        //   textAlign: TextAlign.center,
                        //   style: TextStyle(
                        //     color: Colors.white,
                        //     fontSize: 14,
                        //     fontFamily: 'Poppins',
                        //     letterSpacing: 0,
                        //     fontWeight: FontWeight.w500,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget noOfPeopleBookedPooja(PoojaController screenController) {
    return Column(
      children: [
        // Container(
        //   color: Colors.grey.shade300,
        //   height: 1,width: double.infinity,
        // ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(
                "${screenController.poojaDetailModel!.participents}+",
                style: TextStyle(color: primaryColor, fontSize: 15),
              ),
              SizedBox(
                width: 8,
              ),
              Container(
                color: AppColors.orangeColor,
                height: 20,
                width: 1,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                "Devotes already booked this puja.",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ),
        // Container(
        //   color: Colors.grey.shade300,
        //   height: 1,width: double.infinity,
        // ),
      ],
    );
  }

  Widget poojaDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Container(
        //   color: Colors.grey.shade300,
        //   height: 1,width: double.infinity,
        // ),

        SizedBox(
          height: 10,
        ),

        Padding(
          padding: const EdgeInsets.all(0.0),
          child: Text(
            "Benefits of puja",
            style: TextStyle(
                color: primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'poppins',
                letterSpacing: 0.5),
          ),
        ),
        SizedBox(
          height: 3,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 3.7,
          child: Divider(
            color: AppColors.orangeColor, // Line color
            height: 5, // Height of the divider (the space around the line)
            thickness: 3, // Thickness of the line itself
            indent: 0, // Indentation from the left side
            endIndent: 0, // Indentation from the right side
          ),
        ),
        SizedBox(
          height: 6,
        ),

        screenController.poojaDetailModel!.data!.benifits!.isEmpty
            ? Text("No data ")
            : ListView.builder(
                padding: EdgeInsets.all(0),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                // itemCount: 7,
                itemCount:
                    screenController.poojaDetailModel!.data!.benifits!.length,
                itemBuilder: (context, index) {
                  var temp =
                      screenController.poojaDetailModel!.data!.benifits![index];
                  return screenController
                          .poojaDetailModel!.data!.benifits!.isEmpty
                      ? Text("No data ")
                      : QAItem(
                          title: Row(
                            children: [
                              Container(
                                width: 4,
                                height:
                                    MediaQuery.of(context).size.height / 26.5,
                                color: primaryColor,
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 1.4,
                                  child: Text(temp.title.toString(),style: TextStyle(fontFamily: 'poppins',),)),
                            ],
                          ),
                          children: [
                              ListTile(
                                  title: SizedBox(
                                width: MediaQuery.of(context).size.width / 1,
                                child: DefaultTextStyle(
                                  style: TextStyle(color: Colors.black,fontFamily: 'poppins',),
                                  child: Text(
                                    temp.description.toString(),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontFamily: 'poppins',),
                                  ),
                                ),
                              )),
                            ]);
                },
              )
      ],
    );
  }

  Widget titleAndDateSection(BuildContext context) {
    var temp = screenController.poojaDetailModel!.data;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
                width: Get.width * 0.9,
                child: Text(
                  // "Sri Lalitha Tripurasundari Mahayagya Sri Lalitha Tripurasundari Mahayagya",
                  temp!.title.toString(),
                  style: TextStyle(
                      fontSize: 17,
                      color: AppColors.nblacksColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'poppinsbold'),
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
        SizedBox(
          height: 8,
        ),
        Text(
          //"Sri Lalitha Tripurasundari Mahayagya Sri Lalitha Tripurasundari Mahayagya",
          temp.purposeOfPooja ?? "",
          textAlign: TextAlign.left,
          style: TextStyle(
              color: AppColors.nblacksColor,
                      fontSize: 12,
                      fontFamily: 'poppinssemibold',
              fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget imageSection(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
            //  borderRadius: BorderRadius.circular(10),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(5),
                topLeft: Radius.circular(5),
                bottomRight: Radius.circular(5),
                bottomLeft: Radius.circular(5)),
            child: Image.network(
              // "https://picsum.photos/200/300",
              screenController.poojaDetailModel!.data!.pujaImage.toString(),
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Container(
                            height: 200,
                            width: double.infinity,
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
                        ],
                      ),
                    ));
              },
              fit: BoxFit.fill,
              height: 200,
              width: double.infinity,
            )),

        // GetBuilder(
        //   init: PoojaController(),
        //   builder: (controller) {
        //     return Container(
        //       decoration: BoxDecoration(
        //         color: primaryColor,
        //         borderRadius: BorderRadius.only(
        //             bottomLeft: Radius.circular(10),
        //             bottomRight: Radius.circular(10)),
        //       ),
        //       child: Padding(
        //         padding: const EdgeInsets.all(5.0),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             Text("Time Left:",
        //                 style: TextStyle(fontSize: 12, color: Colors.white)),
        //             Text(
        //               '${screenController.getRemainingTime()}',
        //               style: TextStyle(fontSize: 12, color: Colors.white),
        //             )
        //           ],
        //         ),
        //       ),
        //     );
        //   },
        // ),
      ],
    );
  }

  Widget aboutSection(BuildContext context) {
    var temp = screenController.poojaDetailModel!.data;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: "About Puja",
          color: primaryColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: "Berkshire Pro Swash",
        ),
        SizedBox(
          height: 3,
        ),
        SizedBox(
          width: 50,
          child: Divider(
            color: AppColors.orangeColor, // Line color
            height: 5, // Height of the divider (the space around the line)
            thickness: 3, // Thickness of the line itself
            indent: 0, // Indentation from the left side
            endIndent: 0, // Indentation from the right side
          ),
        ),
        SizedBox(
          height: 6,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.16,
          width: double.infinity,
          child: ShimmerImageLoader1(
            image:
                screenController.poojaDetailModel!.data!.pujaImage.toString(),
          ),
        ),
        // ClipRRect(
        //   borderRadius: BorderRadius.circular(10),
        //   child: Image.network(screenController.poojaDetailModel!.data!.pujaImage.toString(),
        //   fit: BoxFit.fill,
        //     height: 180,
        //     width: double.infinity,
        //     errorBuilder: (BuildContext context,
        //         Object exception,
        //         StackTrace? stackTrace) {
        //       return Shimmer.fromColors(
        //           baseColor: Colors.grey[300]!,
        //           highlightColor: Colors.grey[100]!,
        //           child: Padding(
        //             padding:
        //             const EdgeInsets.all(10.0),
        //             child: Column(
        //               children: [
        //                 Container(
        //                   height: 180,
        //                   width: double.infinity,
        //                   decoration: BoxDecoration(
        //                     gradient:
        //                     LinearGradient(
        //                       begin: Alignment
        //                           .centerLeft,
        //                       end: Alignment
        //                           .centerRight,
        //                       colors: [
        //                         Colors.grey[300]!,
        //                         Colors.grey[100]!,
        //                         Colors.grey[300]!,
        //                       ],
        //                       stops: const [
        //                         0.0,
        //                         0.5,
        //                         1.0
        //                       ],
        //                     ),
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           ));
        //     },
        //   ),
        // ),
        SizedBox(
          height: 10,
        ),

        ReadMoreText(
          // data[index].about,
          temp!.aboutPuja.toString(),

          trimLines: 4,
          textAlign: TextAlign.justify,
          lessStyle: TextStyle(
            fontFamily: "Arial",
            fontWeight: FontWeight.w500,
            color: AppColors.mBGColor,
          ),

          trimMode: TrimMode.Line,
          trimCollapsedText: ' Show more',
          trimExpandedText: '   Show less',
          moreStyle: TextStyle(
              fontSize: 14,
              fontFamily: "Arial",
              fontWeight: FontWeight.bold,
              color: AppColors.mBGColor),
        ),
        // CustomText(
        //   text: temp!.aboutPuja.toString(),
        // ),
      ],
    );
  }

  Widget aboutTempleSection(BuildContext context) {
    var temp = screenController.poojaDetailModel!.data;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: "About Temple",
          color: primaryColor,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(
          height: 3,
        ),
        SizedBox(
          width: 50,
          child: Divider(
            color: AppColors.orangeColor, // Line color
            height: 5, // Height of the divider (the space around the line)
            thickness: 3, // Thickness of the line itself
            indent: 0, // Indentation from the left side
            endIndent: 0, // Indentation from the right side
          ),
        ),
        SizedBox(
          height: 6,
        ),
        SizedBox(
            height: MediaQuery.of(context).size.height * 0.16,
            width: double.infinity,
            child: ShimmerImageLoader1(image: temp!.templeImage.toString())),
        // ClipRRect(
        //   borderRadius: BorderRadius.circular(10),
        //   child: Image.network(temp!.templeImage.toString(),
        //     fit: BoxFit.fill,
        //     height: 180,
        //     width: double.infinity,
        //     errorBuilder: (BuildContext context,
        //         Object exception,
        //         StackTrace? stackTrace) {
        //       return Shimmer.fromColors(
        //           baseColor: Colors.grey[300]!,
        //           highlightColor: Colors.grey[100]!,
        //           child: Column(
        //             children: [
        //               Container(
        //                 height: 180,
        //                 width: double.infinity,
        //                 decoration: BoxDecoration(
        //                   gradient:
        //                   LinearGradient(
        //                     begin: Alignment
        //                         .centerLeft,
        //                     end: Alignment
        //                         .centerRight,
        //                     colors: [
        //                       Colors.grey[300]!,
        //                       Colors.grey[100]!,
        //                       Colors.grey[300]!,
        //                     ],
        //                     stops: const [
        //                       0.0,
        //                       0.5,
        //                       1.0
        //                     ],
        //                   ),
        //                 ),
        //               ),
        //             ],
        //           ));
        //     },
        //   ),
        // ),

        // CustomText(
        //   text: "About Shree  ${temp!.mandirName.toString()}",
        //   color: primaryColor,
        //   fontSize: 16,
        // ),
        SizedBox(
          height: 7,
        ),

        ReadMoreText(
          // data[index].about,
          temp.aboutTempalDescription.toString(),
          textAlign: TextAlign.justify,
          trimLines: 4,
          lessStyle: TextStyle(
              fontFamily: "Arial",
              fontWeight: FontWeight.w500,
              color: AppColors.mBGColor),

          trimMode: TrimMode.Line,
          trimCollapsedText: ' Show more',
          trimExpandedText: '   Show less',
          moreStyle: TextStyle(
              fontSize: 14,
              fontFamily: "Arial",
              fontWeight: FontWeight.bold,
              color: AppColors.mBGColor),
        ),
        // CustomText(text: temp.aboutTempalDescription.toString()
        //
        //     ),
      ],
    );
  }

  Widget bannerSection(BuildContext context) {
    var temp = screenController.poojaDetailModel!.data;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.16,
      child: ListView.builder(
        itemCount: temp!.bannerImages!.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ShimmerImageLoader1(
                image: temp.bannerImages![index].toString(),
              )
              // ClipRRect(
              //     borderRadius: BorderRadius.circular(10),
              //     child: Image.network(
              //       // "https://picsum.photos/200/300",
              //       temp.bannerImages![index].toString(),
              //       errorBuilder: (BuildContext context,
              //           Object exception,
              //           StackTrace? stackTrace) {
              //         return Shimmer.fromColors(
              //             baseColor: Colors.grey[300]!,
              //             highlightColor: Colors.grey[100]!,
              //             child: Padding(
              //               padding:
              //               const EdgeInsets.all(10.0),
              //               child: Column(
              //                 children: [
              //                   Container(
              //                     height: 250,
              //                     width: Get.width * 0.7,
              //                     decoration: BoxDecoration(
              //                       gradient:
              //                       LinearGradient(
              //                         begin: Alignment
              //                             .centerLeft,
              //                         end: Alignment
              //                             .centerRight,
              //                         colors: [
              //                           Colors.grey[300]!,
              //                           Colors.grey[100]!,
              //                           Colors.grey[300]!,
              //                         ],
              //                         stops: const [
              //                           0.0,
              //                           0.5,
              //                           1.0
              //                         ],
              //                       ),
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ));
              //       },
              //       fit: BoxFit.fill,
              //       height: 250,
              //       width: Get.width * 0.7,
              //     )),
              );
        },
      ),
    );
  }

  Widget poojaImagesCarusel() {
  if (screenController.poojaDetailModel != null &&
      screenController.poojaDetailModel!.data != null &&
      screenController.poojaDetailModel!.data!.bannerImages != null &&
      screenController.poojaDetailModel!.data!.bannerImages!.isNotEmpty) { return screenController.poojaDetailModel!.data!.bannerImages!.isEmpty
        ? Container()
        : GetBuilder<PoojaController>(
            init: PoojaController(),
            builder: (controller) {
              return Column(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: MediaQuery.of(context).size.height * 0.1615,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      aspectRatio: 16 / 9,
                      viewportFraction: 1,
                      onPageChanged: (index, reason) {
                        controller.valueChange(index);
                      },
                    ),
                    items: screenController
                        .poojaDetailModel!.data!.bannerImages!
                        .map((imageUrl) {
                      return 
                        // color: Colors.red,
                         ShimmerImageLoader1(image: imageUrl.toString());
                    }).toList(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CarouselIndicator(
                    height: 7,
                    width: 7,
                    activeColor: primaryColor,
                    color: Colors.grey,
                    count: screenController
                        .poojaDetailModel!.data!.bannerImages!.length,
                    index: controller.bannerIndex,
                  ),
                ],
              );
            },
          );} else {
    return Center(child: Text("No images available."));
  }
  }

  Widget benefitsSection(BuildContext context) {
    return Column(
      children: [
        CustomText(
          text: "Benefits",
          color: primaryColor,
          fontSize: 20,
        ),
        SizedBox(
          height: 10,
        ),
        benefitsBannerSection(context),
        SizedBox(
          height: 10,
        ),
        //indicatorSection(context)
      ],
    );
  }

  PoojaController screenController = Get.put(PoojaController());

  Widget benefitsBannerSection(BuildContext context) {
    List<Widget> cards = List.generate(
      //5
      screenController.poojaDetailModel!.data!.benifits!.length,
      (index) => screenController.poojaDetailModel!.data!.benifits!.isEmpty
          ? Text("No data found")
          : Container(
              decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: Colors.grey)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomText(
                      // text: " Hello this is Testind Data only vlkjsdvjjdvjk vsdvsd ",
                      text: screenController
                          .poojaDetailModel!.data!.benifits![index].title
                          .toString(),
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomText(
                      //    text:
                      // "Lorem Ipsum is simply dummy text of the printing and typesetting industry. "
                      // "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, "
                      // "when an unknown printer took a galley of type and scrambled it to make a"
                      // " type specimen book. It has survived not only five centuries, but also the leap "
                      // "into electronic typesetting, remaining essentially unchanged. It was popularised in",
                      text: screenController
                          .poojaDetailModel!.data!.benifits![index].description
                          .toString(),

                      color: Colors.white,
                      fontSize: 12,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              )),
    );

    return SizedBox(
        height: 300,
        child: GetBuilder(
          init: PoojaController(),
          builder: (controller) {
            return TCard(
              cards: cards,
              size: Size(Get.width * 0.9, 300),
              controller: screenController.tCardController,
              onBack: (index, info) {
                print(index);
              },
              onEnd: () {
                print('end');

                screenController.tCardController.reset(cards: cards);
              },
            );

            //   CarouselSlider.builder(
            //   carouselController: screenController.carouselController,
            //   //   itemCount: controller.homeModel!.data!.threeBanners!.length,
            //   itemCount: 2,
            //   itemBuilder: (BuildContext context, int index, int realIndex) {
            //     //  var temp = controller.homeModel!.data!.threeBanners![index];
            //     return Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 8),
            //       child: Container(
            //         width: Get.width,
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(10),
            //           image: DecorationImage(
            //             image: NetworkImage("https://picsum.photos/200/300"),
            //             fit: BoxFit.cover,
            //           ),
            //         ),
            //       ),
            //     );
            //   },
            //   options: CarouselOptions(
            //     height: MediaQuery.of(context).size.width * .7,
            //     viewportFraction: 1.0,
            //     autoPlay: true,
            //     enlargeCenterPage: false,
            //     onPageChanged: (index, reason) {
            //       screenController.carouselIndex.value = index;
            //     },
            //   ),
            // );
          },
        ));
  }

  Widget indicatorSection(BuildContext context) {
    return Center(
      child: Obx(
        () => CarouselIndicator(
          cornerRadius: 100,
          width: 8,
          height: 8,
          // count: _homeController.slideImages.length,
          // index: _homeController.carouselIndex.value,

          count: 2,
          index: screenController.carouselIndex.value,
          color: Colors.grey,
          activeColor: primaryColor,
        ),
      ),
    );
  }

  Widget poojaPackageNewDesign() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.grey.shade300,
          height: 1,
          width: double.infinity,
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Text(
              "Puja Packages",
              style: TextStyle(
                  color: AppColors.orangeColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 5,
            ),
            IconButton(
              key: _keyForPackage,
              icon: Icon(Icons.error_outline, size: 20),
              onPressed: () {
                _showPopupMenuForPackage(context);
              },
            )
          ],
        ),
        SizedBox(
          height: 3,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 3.7,
          child: Divider(
            color: AppColors.orangeColor, // Line color
            height: 5, // Height of the divider (the space around the line)
            thickness: 3, // Thickness of the line itself
            indent: 0, // Indentation from the left side
            endIndent: 0, // Indentation from the right side
          ),
        ),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          height: Get.height * 0.29,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            itemCount:
                screenController.poojaDetailModel!.data!.packages!.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var temp =
                  screenController.poojaDetailModel!.data!.packages![index];

              return Padding(
                padding: EdgeInsets.only(left: index == 0 ? 8 : 10, right: 10),
                child:Column(
                  children: [
                    SizedBox(
                      height: 20,
                      child: index == 1
                          ? Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10) ),
                          color: AppColors.orangeColor,
                        ),
                        child: Center(
                          child: Text(
                            'Recommended',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                          : SizedBox
                          .shrink(), // Empty space for non-recommended items
                    ),
                    packageCard(
                        packageAmount: "${temp.packagePrice}",
                        packageType: "${temp.packageType}",
                        index: index),

                  ],
                )

              );
            },
          ),
        ),
        Container(
          // height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.orangeColor, AppColors.textWhite],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 1, color: AppColors.mBGColor)),
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              CustomText(
                text:
                    "${screenController.poojaDetailModel!.data!.packages![selcetdpackage].packageType}",
                fontWeight: FontWeight.bold,
                fontSize: 35,
                fontFamily: 'Arial',
                color: Colors.black,
              ),
              SizedBox(
                height: 10,
              ),
              CustomText(
                text:
                    "₹ ${screenController.poojaDetailModel!.data!.packages![selcetdpackage].packagePrice}",
                fontWeight: FontWeight.bold,
                fontSize: 30,
                fontFamily: 'Arial',
                color: Colors.black,
              ),
              SizedBox(
                height: 10,
              ),
              CustomText(
                text:
                    "For  ${screenController.poojaDetailModel!.data!.packages![selcetdpackage].packageName}",
                fontWeight: FontWeight.w400,
                fontSize: 14,
                fontFamily: 'Arial',
                color: Colors.black,
              ),
              SizedBox(
                height: 10,
              ),
              Divider(),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReviewAndCheckout(
                          bannerList: screenController
                              .poojaDetailModel!.data!.bannerImages!,
                          date: "${widget.onlyDate} ${widget.onlyMonth}",
                          packageAmount: screenController.poojaDetailModel!
                              .data!.packages![selcetdpackage].packagePrice
                              .toString(),
                          packageName: screenController.poojaDetailModel!.data!
                              .packages![selcetdpackage].packageType
                              .toString(),
                          onlyDate: widget.onlyDate,
                          onlyMonth: widget.onlyMonth,
                          purposeOfPooja: screenController
                                  .poojaDetailModel!.data!.purposeOfPooja ??
                              "",
                          poojaName:
                              screenController.poojaDetailModel!.data!.title ??
                                  "",
                          templeName: screenController
                                  .poojaDetailModel!.data!.mandirName ??
                              "",
                          userId: widget.userId,
                        ),
                      ));
                },
                child: Container(
                  height: 50,
                  width: double.infinity,
                  margin: EdgeInsets.all(10),
                  padding: const EdgeInsets.only(
                      top: 6, left: 24, right: 23, bottom: 7),
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.orangeColor, AppColors.orangeColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IgnorePointer(
  ignoring: true,
                        child: AnimatedTextKit(
                          repeatForever: true,
                          pause: Duration(milliseconds: 200),
                          animatedTexts: [
                            RotateAnimatedText('Book Now',
                                textStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                  fontFamily: 'Poppins',
                                  letterSpacing: 0,
                                )),
                            RotateAnimatedText('Participate Now',
                                textStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                  fontFamily: 'Poppins',
                                  letterSpacing: 0,
                                )),
                            RotateAnimatedText('Limited Offers!',
                                textStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                  fontFamily: 'Poppins',
                                  letterSpacing: 0,
                                )),
                          ],
                        ),
                      ),

                      // Text(
                      //   'Book Puja',
                      //   textAlign: TextAlign.center,
                      //   style: TextStyle(
                      //     color: Colors.white,
                      //     fontSize: 14,
                      //     fontFamily: 'Poppins',
                      //     letterSpacing: 0,
                      //     fontWeight: FontWeight.w500,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  int selcetdpackage = 0;
  Widget packageCard({
    required String packageType,
    required String packageAmount,
    required int index,
  }) {
    List<String> images = [
      "assets/images/single.png",
      "assets/images/couple.png",
      "assets/images/family.png"
    ];

    var temp = screenController.poojaDetailModel!.data!.packages![index];

    return InkWell(
      onTap: () {
        setState(() {
          selcetdpackage = index;
        });
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 3.7,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
           Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:index==1?BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)): BorderRadius.circular(10),
                border: Border.all(width: 1, color: Colors.grey),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                 Image.asset(
                    temp.packageType == "Individual"
                        ? images[0]
                        : temp.packageType == "Couple"
                            ? images[1]
                            : temp.packageType == "Family"
                                ? images[2]
                                : images[2],
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Container(
                                height: 70,
                                width: 65,
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
                            ],
                          ),
                        ),
                      );
                    },
                    fit: BoxFit.fill,
                    height: 70,
                    width: 65,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 3.7,
                    height: MediaQuery.of(context).size.height *0.12,
                    decoration: BoxDecoration(
                      gradient: selcetdpackage == index
                          ? LinearGradient(
                              colors: [
                                AppColors.orangeColor,
                                AppColors.mBGColor
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : LinearGradient(
                              colors: [
                                AppColors.textWhite,
                                AppColors.textWhite
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft:
                            Radius.circular(10), // Rounded bottom-left corner
                        bottomRight:
                            Radius.circular(10), // Rounded bottom-right corner
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 15),
                        CustomText(
                          text: temp.packageType == "Individual"
                              ? "1 person"
                              : temp.packageType == "Couple"
                                  ? "2 person"
                                  : temp.packageType == "Family"
                                      ? "Upto 2 person"
                                      : "Upto 2 person",
                          color: selcetdpackage == index
                              ? Colors.white
                              : Colors.black,
                        ),
                        const SizedBox(height: 15),
                        CustomText(
                          text: "₹ $packageAmount",
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          fontFamily: 'Arial',
                          color: selcetdpackage == index
                              ? Colors.white
                              : Colors.black,
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            selcetdpackage == index
                ? ClipPath(
                    clipper: MessageClipper(),
                    child: Container(
                      height: 20,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.orangeColor, AppColors.mBGColor],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget packageSection(
    BuildContext context,
  ) {
    return Container(
      key: dataKey,
      child: GetBuilder(
        init: PoojaController(),
        builder: (controllerr) {
          return Column(
            children: [
              SizedBox(
                height: 50,
                child: screenController
                        .poojaDetailModel!.data!.packages!.isEmpty
                    ? Container()
                    : ListView.builder(
                        // controller: screenController.scrollController,
                        itemCount: screenController
                            .poojaDetailModel!.data!.packages!.length,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              screenController.selectedIndex.value = index;
                              screenController.carouselController.animateTo(0.0, duration:  Duration(milliseconds: 300),
  curve: Curves.easeInOut);
                                 
                              screenController.update();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  height: 30,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      color: screenController
                                                  .selectedIndex.value ==
                                              index
                                          ? primaryColor.withOpacity(0.8)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                          color: primaryColor, width: 1.5)),
                                  child: Center(
                                      child: Text(
                                    // " ₹ 751",

                                    "₹ ${screenController.poojaDetailModel!.data!.packages![index].packagePrice.toString()}",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: screenController
                                                    .selectedIndex.value ==
                                                index
                                            ? Colors.white
                                            : Colors.black),
                                  ))),
                            ),
                          );
                        },
                      ),
              ),
              bannerSectionPackage(
                context,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget customerReviewSection() {
    return screenController.poojaDetailModel!.data!.reviews!.isEmpty
        ? Text("")
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              CustomText(
                text: "Customer Review",
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 300,
                width: double.infinity,
                // color: Colors.red,
                child: ListView.builder(
                  itemCount:
                      screenController.poojaDetailModel!.data!.reviews!.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    var temp = screenController
                        .poojaDetailModel!.data!.reviews![index];

                    return Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              "${temp.review}",
                              fit: BoxFit.fill,
                              height: 150,
                              width: Get.width * 0.97,
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                      height: 150,
                                      width: Get.width * 0.97,
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
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ClipOval(
                                  child: Image.network(
                                    "${temp.photo}",
                                    fit: BoxFit.fill,
                                    height: 45,
                                    width: 45,
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                      return Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Container(
                                            height: 60,
                                            width: 60,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
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
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                CustomText(
                                  text: "${temp.name}",
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
  }

  Widget bannerSectionPackage(
    BuildContext context,
  ) {
    return GetBuilder(
      init: PoojaController(),
      builder: (controller) {
        return Padding(
          padding: const EdgeInsets.all(10.0));
        //   child: CarouselSlider.builder(
        //     carouselController: screenController.carouselController,
        //     //  itemCount: 1,
        //     itemCount:
        //         screenController.poojaDetailModel!.data!.packages!.length,
        //     itemBuilder: (BuildContext context, int index, int realIndex) {
        //       //  var temp = controller.homeModel!.data!.threeBanners![index];
        //       return Padding(
        //           padding: const EdgeInsets.symmetric(horizontal: 8),
        //           child: Material(child: packageCardSection(context, index)
        //               //   packageCardSection(context, index)

        //               ));
        //     },
        //     options: CarouselOptions(
        //       height: Get.height * 0.45,
        //       //viewportFraction: 0.8,
        //       // autoPlay: true,
        //       enlargeCenterPage: false,
        //       enableInfiniteScroll: false,

        //       onPageChanged: (index, reason) {
        //         // screenController.carouselIndex.value = index;
        //         screenController.selectedIndex.value = index;
        //         screenController.scrollController.addListener(() {});
        //         screenController.update();
        //       },
        //     ),
        //   ),
        // );
      },
    );
  }

  final GlobalKey packageCardKey = GlobalKey();

  Widget packageCardSection(
    BuildContext context,
    int index,
  ) {
    return Stack(
      children: [
        Container(
          width: Get.width * 0.7,
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
                  blurRadius: 4,
                  offset: Offset(0, 0),
                  spreadRadius: 0,
                )
              ],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: screenController.selectedIndex.value == index
                      ? primaryColor
                      : Colors.grey.shade100,
                  width: 2)),
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 35, bottom: 10),
                        child: CustomText(
                          //   text: "Individual Guru Chandal \n Dosh Puja",

                          text: screenController.poojaDetailModel!.data!
                              .packages![index].packageName
                              .toString(),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 35, bottom: 10),
                        child: Container(
                          height: 2,
                          width: Get.width * 0.3,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              primaryColor,
                              primaryColor.withOpacity(0.4),
                            ],
                          )),
                        ),
                      ),
                      ListView.builder(
                        itemCount: screenController
                                    .poojaDetailModel!
                                    .data!
                                    .packages![index]
                                    .packageDescription!
                                    .length <
                                3
                            ? screenController.poojaDetailModel!.data!
                                .packages![index].packageDescription!.length
                            : 3,
                        // itemCount: screenController.poojaDetailModel!.data!.packages!.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, indexp) {
                          return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Stack(
                                alignment: Alignment.centerLeft,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30),
                                    child: SizedBox(
                                      // color: Colors.red,
                                      height: Get.height * 0.07,
                                      child: CustomText(
                                        // text:
                                        //     "link for recorded video of puja recorded video of puja in Shree Navgarh "
                                        //     "link for recorded video of puja in Shree Navgar",
                                        text: screenController
                                            .poojaDetailModel!
                                            .data!
                                            .packages![index]
                                            .packageDescription![indexp]
                                            .toString(),

                                        fontSize: 12,
                                        overflow: TextOverflow.ellipsis,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: primaryColor.withOpacity(0.6),
                                        shape: BoxShape.circle),
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Icon(
                                        Icons.check,
                                        color: whiteColor,
                                        size: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ));
                        },
                      ),
                    ],
                  ),
                ],
              )),
        ),
        Positioned(
            bottom: 30,
            right: Get.width * 0.7 / 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                    onTap: () {
                      openDialogBox(
                          context,
                          screenController.poojaDetailModel!.data!
                              .packages![index].packageName
                              .toString(),
                          index);
                    },
                    child: Center(
                        child: Icon(
                      Icons.keyboard_double_arrow_down,
                      color: Colors.grey,
                    ))),
                SizedBox(
                  height: 5,
                ),
                InkWell(
                  onTap: () async {
                    showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Confirm Payment'),
                          content: Text(
                              'Are you sure you want to proceed with the payment?'),
                          actionsAlignment: MainAxisAlignment.spaceEvenly,
                          actions: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context, false);
                              },
                              child: Container(
                                margin: EdgeInsets.all(10),
                                height: 45,
                                width: 100,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColors.orangeColor, width: 2),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Text(
                                    'Cancel',
                                    style:
                                        TextStyle(color: AppColors.orangeColor),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
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
                                  await getProfile();
                                  if (walletAmount == "0" ||
                                      int.parse(walletAmount) <
                                          int.parse(screenController
                                              .poojaDetailModel!
                                              .data!
                                              .packages![index]
                                              .packagePrice
                                              .toString())) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => MyWallet()));
                                  } else {
                                    screenController.bookPoojaApi(
                                        userId: widget.userId.toString(),
                                        poojaId: screenController
                                            .poojaDetailModel!.data!.sId
                                            .toString(),
                                        packageType: screenController
                                            .poojaDetailModel!
                                            .data!
                                            .packages![index]
                                            .packageType
                                            .toString(),
                                        packagePrice: screenController
                                            .poojaDetailModel!
                                            .data!
                                            .packages![index]
                                            .packagePrice
                                            .toString(),
                                        poojaDate: screenController
                                            .poojaDetailModel!.data!.pujaDate
                                            .toString(),
                                        contextbook: context);
                                  }
                                }

                                //Navigator.pop(context, false);
                              },
                              child: Container(
                                margin: EdgeInsets.all(10),
                                height: 45,
                                width: 100,
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
                  child: Center(
                    child: Container(
                      height: 38,
                      width: 120,
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: CustomText(
                          text: "PARTICIPATE",
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ))
      ],
    );
  }

  Widget faqSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: "FAQ",
          color: Colors.black,
          fontFamily: 'poppins',
          fontSize: 18,
        ),
        SizedBox(
          height: 3,
        ),
        SizedBox(
          width: 20,
          child: Divider(
            color: AppColors.orangeColor, // Line color
            height: 5, // Height of the divider (the space around the line)
            thickness: 3, // Thickness of the line itself
            indent: 0, // Indentation from the left side
            endIndent: 0, // Indentation from the right side
          ),
        ),
        SizedBox(
          height: 6,
        ),
        screenController.poojaDetailModel!.data!.faq!.isEmpty
            ? Text("No data ")
            : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                // itemCount: 7,
                itemCount: screenController.poojaDetailModel!.data!.faq!.length,
                itemBuilder: (context, index) {
                  var temp =
                      screenController.poojaDetailModel!.data!.faq![index];
                  return screenController.poojaDetailModel!.data!.faq!.isEmpty
                      ? Text("No data ")
                      : QAItem(
                          title: Row(
                            children: [
                              Container(
                                width: 4,
                                height:
                                    MediaQuery.of(context).size.height / 26.5,
                                color: primaryColor,
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 1.4,
                                  child: Text(temp.question.toString())),
                            ],
                          ),
                          children: [
                              ListTile(
                                  title: SizedBox(
                                width: MediaQuery.of(context).size.width / 1,
                                child: DefaultTextStyle(
                                  style: TextStyle(color: Colors.black,fontFamily: 'poppins',),
                                  child: Text(
                                    temp.answer.toString(),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontFamily: 'poppins',),
                                  ),
                                ),
                              )),
                            ]);
                },
              )
      ],
    );
  }

  Future openDialogBox(
    BuildContext context,
    String title,
    int index,
  ) {
    log("title===>>>> $title");

    return Get.dialog(
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: primaryColor, width: 2),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Material(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 35, bottom: 10),
                        child: CustomText(
                          // text: "Individual Guru Chandal \n Dosh Puja",

                          text: title,

                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 35, bottom: 10),
                        child: Container(
                          height: 2,
                          width: Get.width * 0.3,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              primaryColor,
                              primaryColor.withOpacity(0.4),
                            ],
                          )),
                        ),
                      ),
                      ListView.builder(
                        itemCount: screenController.poojaDetailModel!.data!
                            .packages![index].packageDescription!.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, indexp) {
                          return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Stack(
                                alignment: Alignment.centerLeft,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30),
                                    child: CustomText(
                                      // text:
                                      //     "link for recorded video of puja recorded video of puja in Shree Navgarh "
                                      //     "link for recorded video of puja in Shree Navgar",

                                      text: screenController
                                          .poojaDetailModel!
                                          .data!
                                          .packages![index]
                                          .packageDescription![indexp]
                                          .toString(),
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: primaryColor.withOpacity(0.6),
                                        shape: BoxShape.circle),
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Icon(
                                        Icons.check,
                                        color: whiteColor,
                                        size: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ));
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Container(
                          height: 38,
                          width: 120,
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: CustomText(
                              text: "PARTICIPATE",
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

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

  void _openWhatsAppLink(String? phone) async {
    var code = "+91";
    code = code.replaceAll("+", "");
    var url = "https://wa.me/$code$phone?text=";

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Could not launch $url";
    }
  }
}

// class QAItem extends StatelessWidget {
//   const QAItem({
//     Key? key,
//     required this.title,
//     required this.children,
//   }) : super(key: key);
//
//   final Widget title;
//
//   final List<Widget> children;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       child: ExpansionTile(
//         textColor: Colors.black,
//         title: title,
//
//         //
//         // title:  Text(
//         //   "${title}",
//         //   style: TextStyle(
//         //     fontSize: 13.0,
//         //     fontWeight: FontWeight.bold
//         //     // Text size of the children
//         //   ),
//         // ),
//         children: children,
//       ),
//     );
//   }
// }

class QAItem extends StatelessWidget {
  const QAItem({
    Key? key,
    required this.title,
    required this.children,
    this.titleColor = Colors.black,
    this.titleFontSize = 15.0,
    this.titleFontWeight = FontWeight.bold,
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  final Widget title;
  final List<Widget> children;
  final Color titleColor;
  final double titleFontSize;
  final FontWeight titleFontWeight;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        iconColor: AppColors.orangeColor,
        collapsedIconColor: AppColors.orangeColor,
        // tilePadding: EdgeInsets.zero,
        textColor: titleColor,
        tilePadding: EdgeInsets.symmetric(horizontal: 0),
        title: DefaultTextStyle(
          style: TextStyle(
            color: titleColor,
            fontSize: titleFontSize,
            fontWeight: titleFontWeight,
            fontFamily: 'poppins',
          ),
          child: title,
        ),
        children: children,
      ),
    );
  }
}

class TimerScreen extends StatefulWidget {
  final String datetime;
  const TimerScreen({Key? key, required this.datetime}) : super(key: key);
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late ValueNotifier<Duration> durationNotifier;
  Timer? timer;

  // Initial countdown duration, you can customize this.
  late Duration countdownDuration;

  @override
  void initState() {
    super.initState();
    final targetDateTime = DateTime.parse(widget.datetime);
    print(widget.datetime);
    // Initialize the countdown duration
    countdownDuration = _getTimeDifference(targetDateTime);

    // Create the ValueNotifier with the initial countdown duration
    durationNotifier = ValueNotifier<Duration>(countdownDuration);

    // Start the timer
    startTimer();
  }

  //  static const Duration countdownDuration = Duration(days: 10,hours:0,minutes: 0, seconds: 10);
  // final ValueNotifier<Duration> durationNotifier =
  // ValueNotifier<Duration>(countdownDuration);
  // Timer? timer;
  // @override
  // void initState() {
  //   super.initState();
  //   final targetDateTime = DateTime.parse(widget.datetime);
  //   setState(() {
  //     countdownDuration = _getTimeDifference(targetDateTime);
  //   });
  //   startTimer();
  // }
  @override
  void dispose() {
    timer?.cancel();
    durationNotifier.dispose();
    super.dispose();
  }

  Duration _getTimeDifference(DateTime targetDateTime) {
    final now = DateTime.now();
    final difference = targetDateTime.isAfter(now)
        ? targetDateTime.difference(now)
        : Duration.zero;
    return difference;
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  void addTime() {
    final seconds = durationNotifier.value.inSeconds - 1;
    if (seconds < 0) {
      timer?.cancel();
// Handle end of timer here
      showEndMessage();
    } else {
      durationNotifier.value = Duration(seconds: seconds);
    }
  }

  void showEndMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Timer Ended"),
          content: const Text("The timer has ended."),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      // color: Colors.red,
      child: ValueListenableBuilder<Duration>(
        valueListenable: durationNotifier,
        builder: (context, duration, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 6,
              ),
              CustomText(
                text: "Puja Starts in",
                fontWeight: FontWeight.w300,
                color: AppColors.orangeColor,
              ),
              SizedBox(
                height: 8,
              ),
              buildTime(duration),
            ],
          );
        },
      ),
    );
  }

  Future<bool> _onWillPop() async {
    timer?.cancel();
    Navigator.of(context).pop();
    return true;
  }

  Widget buildTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final days = twoDigits(duration.inDays);
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return Row(
      children: [
        buildTimeColumn(days, "Day"),
        buildTimeColumn(hours, "Hrs"),
        buildTimeColumn(minutes, "Mins"),
        buildTimeColumn(seconds, "Secs", isLast: true),
      ],
    );
  }

  Widget buildTimeColumn(String time, String label, {bool isLast = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildDigit(time[0]),
            buildDigit(time[1]),
            if (!isLast) buildTimeSeparator(),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.mBGColor,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget buildDigit(String digit) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 2),
      child: ClipRect(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          switchInCurve: Curves.easeOutExpo,
          switchOutCurve: Curves.easeInExpo,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return Stack(
              children: <Widget>[
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -1),
                    end: const Offset(0, 1),
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  )),
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                ),
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -1),
                    end: const Offset(0, 0),
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.bounceIn,
                  )),
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                ),
              ],
            );
          },
          child: Text(
            digit,
            key: ValueKey<String>(digit),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.mBGColor,
              fontSize: 35,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLabel(String label) {
    return Center(
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.mBGColor,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildTimeSeparator() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.0),
      child: Text(
        ":",
        style: TextStyle(
          color: AppColors.orangeColor,
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),
      ),
    );
  }
}

class MessageClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // Calculate the offsets for centering the clip horizontally
    double centerX = size.width / 2;

    var firstOffset = Offset(centerX - (size.width * 0.1), 0.0);
    var secondPoint = Offset(centerX, size.height);
    var lastPoint = Offset(centerX + (size.width * 0.1), 0.0);

    var path = Path()
      ..moveTo(firstOffset.dx, firstOffset.dy)
      ..lineTo(secondPoint.dx, secondPoint.dy)
      ..lineTo(lastPoint.dx, lastPoint.dy)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
 class ShimmerImageLoader1 extends StatelessWidget {
  final String image;
  ShimmerImageLoader1({required this.image});
    @override
    Widget build(BuildContext context) {
      return  ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: CachedNetworkImage(
                  imageUrl: image,
                  imageBuilder: (context, imageProvider) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
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
            
        ),
      );
    }
  }

