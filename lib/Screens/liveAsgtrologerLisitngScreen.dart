import 'package:astro_gurujii/Screens/Models/live_listing/live_listing_reponse.dart';
import 'package:astro_gurujii/Setup/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

import '../../Setup/SetUp.dart';
import '../../Utilities/CustomText.dart';
import '../widget/bottom_navigation_bar_custom.dart';
import 'WebServices/HttpServices.dart';
import 'live/LiveVideoCallScreen.dart';


class LiveAstroLogersScreen extends StatefulWidget {
   LiveAstroLogersScreen({Key? key});

  @override
  State<LiveAstroLogersScreen> createState() => _LiveAstroLogersScreenState();
}

class _LiveAstroLogersScreenState extends State<LiveAstroLogersScreen> {
  final HttpServices _httpServices = HttpServices();
  List<Data> liveAstrologersList = [];
bool isloading = false;
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  void getLiveAstrologer() async {
    var res = await _httpServices.getLiveListing();
    if (res!.status == true) {
      setState(() {

        liveAstrologersList = res.data!;
        _refreshController.refreshCompleted();
        isloading = true;
      });
    } else {
      Fluttertoast.showToast(msg: res.message!);
      _refreshController.refreshCompleted();
      setState(() {
        isloading= true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLiveAstrologer();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
       onWillPop: () async {
        
      Navigator.push(context, MaterialPageRoute(builder: (context) => MainHomeScreenWithBottomNavigation()));
      return false;
      },
      child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: whiteColor, //change your color here
            ),
            backgroundColor: primaryColor,
            title: Text(
              "Live Astrologers",
              style: TextStyle(color: whiteColor),
            ),
          ),
          body:
         isloading ? GridView.builder(
            itemCount: liveAstrologersList.length,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns in the grid
              childAspectRatio: 0.8, // Adjust the aspect ratio as needed
              mainAxisSpacing: 5.0, // Space between rows
              crossAxisSpacing: 5.0, // Space between columns
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  print('sdbnbhjsdhjsdj' + liveAstrologersList[index].isLive.toString());
                  if (liveAstrologersList[index].isLive == "1") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LiveVideoCallScreen(
                          screenType: "home",
                          id: liveAstrologersList[index].sId,
                          channelName: liveAstrologersList[index].channelId.toString(),
                          astroid: liveAstrologersList[index].astrologerId!.sId.toString(),
                          name: liveAstrologersList[index].astrologerId!.displayName.toString(),
                          astroImage: liveAstrologersList[index].astrologerId!.profileImg.toString(),
                          numberOfuserJoin: liveAstrologersList[index].users,
                          profile: "",
                        ),
                      ),
                    ).then((value) {
                      getLiveAstrologer();
                      setState(() {});
                    });
                  } else {
                    Fluttertoast.showToast(msg: "User is not live");
                  }
                },
                child: Container(
                  margin: EdgeInsets.all(5),
                  width: Get.width * 0.8,
                  decoration: BoxDecoration(
                    // color: Colors.white,
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              liveAstrologersList[index].astrologerId!.profileImg.toString(),
                              height: Get.height * 0.2,
                              width: double.infinity,
                              fit: BoxFit.fill,
                              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: Get.height * 0.14,
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
                                  ),
                                );
                              },
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: liveAstrologersList[index].isLive == "1" ? Colors.red : Colors.grey.shade500,
                                borderRadius: BorderRadius.only(topRight: Radius.circular(10)),
                              ),
                              child: Text(
                                liveAstrologersList[index].isLive == "1" ? 'Live' : "Upcoming",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: CustomText(
                          text: liveAstrologersList[index].astrologerId!.name.toString(),
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: CustomText(
                          text: liveAstrologersList[index].isLive == "0" ? "${liveAstrologersList[index].startTime} - ${liveAstrologersList[index].endTime}" : "",
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ) : Center(child: CircularProgressIndicator(color: AppColors.orangeColor,),)
    
        // ListView.builder(
        //   itemCount: liveAstrologersList.length,
        //   shrinkWrap: true,
        //
        //
        //   itemBuilder: (context, index) {
        //     return
        //
        //       GestureDetector(
        //         onTap: () {
        //           print('sdbnbhjsdhjsdj' +
        //               liveAstrologersList[index]
        //                   .isLive
        //                   .toString());
        //           if (liveAstrologersList[index].isLive ==
        //               "1") {
        //
        //             // joinLiveAstrologer(liveAstrologersList[index].sId.toString());
        //
        //             Navigator.push(
        //                 context,
        //                 MaterialPageRoute(
        //                     builder: (context) => LiveVideoCallScreen(
        //                         screenType: "home",
        //                         id: liveAstrologersList[index]
        //                             .sId,
        //                         channelName:
        //                         liveAstrologersList[index]
        //                             .channelId,
        //                         astroid:
        //                         liveAstrologersList[index]
        //                             .astrologerId!
        //                             .sId,
        //                         name: liveAstrologersList[index]
        //                             .astrologerId!
        //                             .name,
        //                         astroImage:
        //                         liveAstrologersList[index]
        //                             .astrologerId!
        //                             .profileImg,
        //                         numberOfuserJoin:
        //                         liveAstrologersList[index]
        //                             .users,
        //                         profile: ""))).then((value) {
        //                getLiveAstrologer();
        //               setState(() {});
        //             });
        //           } else {
        //             Fluttertoast.showToast(
        //                 msg: "User is not live");
        //           }
        //           // Handle item tap
        //         },
        //         child: Container(
        //           margin: EdgeInsets.only(
        //               left: 5, right: 5, top: 5, bottom: 5),
        //            width: Get.width * 1,
        //           decoration: BoxDecoration(
        //             color: Colors
        //                 .white, // Container background color
        //             borderRadius: BorderRadius.circular(
        //                 10), // Optional: Round corners
        //             boxShadow: [
        //               BoxShadow(
        //                 color: Colors.grey
        //                     .withOpacity(0.4), // Shadow color
        //                 spreadRadius: 2, // Spread radius
        //                 blurRadius: 2, // Blur radius
        //                 offset: Offset(0,
        //                     2), // Offset in x and y direction
        //               ),
        //             ],
        //           ),
        //           child: Column(
        //             crossAxisAlignment:
        //             CrossAxisAlignment.start,
        //             children: [
        //               Stack(
        //                 children: [
        //                   ClipRRect(
        //                     borderRadius:
        //                     BorderRadius.circular(10),
        //                     child:
        //                     Image.network(liveAstrologersList[index].astrologerId!.profileImg.toString(),
        //                       height: Get.height * 0.2,
        //                       width: double.infinity,
        //                       fit: BoxFit.fill,
        //                       errorBuilder: (BuildContext context,
        //                           Object exception,
        //                           StackTrace? stackTrace) {
        //                         return Shimmer.fromColors(
        //                             baseColor: Colors.grey[300]!,
        //                             highlightColor: Colors.grey[100]!,
        //                             child: Padding(
        //                               padding:
        //                               const EdgeInsets.all(10.0),
        //                               child: Column(
        //                                 children: [
        //                                   Container(
        //                                     height: Get.height * 0.14,
        //                                     width: double.infinity,
        //                                     decoration: BoxDecoration(
        //                                       gradient:
        //                                       LinearGradient(
        //                                         begin: Alignment
        //                                             .centerLeft,
        //                                         end: Alignment
        //                                             .centerRight,
        //                                         colors: [
        //                                           Colors.grey[300]!,
        //                                           Colors.grey[100]!,
        //                                           Colors.grey[300]!,
        //                                         ],
        //                                         stops: const [
        //                                           0.0,
        //                                           0.5,
        //                                           1.0
        //                                         ],
        //                                       ),
        //                                     ),
        //                                   ),
        //                                 ],
        //                               ),
        //                             ));
        //                       },
        //                     ),
        //                   ),
        //                   Positioned(
        //                     top: 0,
        //                     right: 0,
        //                     child: Container(
        //                       padding: EdgeInsets.symmetric(
        //                           horizontal: 8, vertical: 4),
        //                       decoration: BoxDecoration(
        //                         color:
        //                         liveAstrologersList[index]
        //                             .isLive ==
        //                             "1"
        //                             ? Colors.red
        //                             : Colors.grey.shade500,
        //                         borderRadius: BorderRadius.only(
        //                             topRight:
        //                             Radius.circular(10)),
        //                       ),
        //                       child: Text(
        //                         liveAstrologersList[index]
        //                             .isLive ==
        //                             "1"
        //                             ? 'Live'
        //                             : "Upcoming",
        //                         style: TextStyle(
        //                           fontSize: 12,
        //                           color: Colors.white,
        //                           fontWeight: FontWeight.w500,
        //                         ),
        //                       ),
        //                     ),
        //                   ),
        //
        //                 ],
        //               ),
        //               Padding(
        //                 padding: const EdgeInsets.all(5.0),
        //                 child: CustomText(
        //                   text: liveAstrologersList[index]
        //                       .astrologerId!
        //                       .name
        //                       .toString(),
        //                   color: Colors.black,
        //                   fontSize: 13,
        //                   fontWeight: FontWeight.bold,
        //                 ),
        //               ),
        //               Padding(
        //                 padding: const EdgeInsets.all(5.0),
        //                 child: CustomText(
        //                   text: liveAstrologersList[index]
        //                       .isLive ==
        //                       "0"
        //                       ? "${liveAstrologersList[index].startTime} - ${liveAstrologersList[index].endTime}"
        //                       : "",
        //                   color: Colors.black,
        //                   fontSize: 10,
        //                   fontWeight: FontWeight.w700,
        //                 ),
        //               )
        //             ],
        //           ),
        //         ),
        //       );
        //   },
        // ),
      ),
    );
  }
}
