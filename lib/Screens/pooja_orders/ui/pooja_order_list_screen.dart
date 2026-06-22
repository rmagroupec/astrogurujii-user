import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Screens/chats_screen/const.dart';
import 'package:astro_gurujii/Screens/poojaScreen/ui/poojaScreen.dart';
import 'package:astro_gurujii/Screens/pooja_orders/ui/add_Details.dart';
import 'package:astro_gurujii/Screens/pooja_orders/ui/viewDetails.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../Setup/SetUp.dart';
import '../../live/LiveVideoCallScreen.dart';
import '../controller/PoojaOrderController.dart';

class PoojaOrderList extends StatefulWidget {
  @override
  State<PoojaOrderList> createState() => _PoojaOrderListState();
}

class _PoojaOrderListState extends State<PoojaOrderList> {
  PoojaOrderController screenController = Get.put(PoojaOrderController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    screenController.poojaBookingApi();
  }

  inFun() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: whiteColor, //change your color here
          ),
          backgroundColor: primaryColor,
          title: Text(
            "Puja Orders",
            style: TextStyle(color: whiteColor),
          ),
        ),
        body: GetBuilder<PoojaOrderController>(
          init: PoojaOrderController(),
          builder: (controller) {
            return screenController.poojaBookingsModel == null
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
                                width:
                                    double.infinity, // Adjust width as needed
                                height: 100, // Adjust height as needed
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
                                  width:
                                      double.infinity, // Adjust width as needed
                                  height: 20, // Adjust height as needed
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
                : ListView.builder(
                    itemCount:
                        screenController.poojaBookingsModel!.data!.length,
                    itemBuilder: (context, index) {
                      var temp =
                          screenController.poojaBookingsModel!.data![index];
                      return InkWell(
                          onTap: () {
                            // screenController.joinLive(temp.sId);
                            if (temp.is_live == true) {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => LiveVideoCallScreen(
                              //             screenType: "pooja",
                              //             id: temp.sId,
                              //             channelName: temp.channelId!,
                              //             astroid: temp.astrologerId ?? "",
                              //             name: temp.astrologerName ?? "",
                              //             astroImage:
                              //                 temp.pujaId!.pujaImage.toString(),
                              //             //numberOfuserJoin: temp.members,
                              //             profile: ""))).then((value) {
                              //   // getLiveAstrologer();
                              //   setState(() {
                              //     screenController.poojaBookingApi();
                              //   });
                              // });
                            } else {
                              Fluttertoast.showToast(msg: "User not live");
                            }
                          },
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    left: 10, right: 10, top: 5, bottom: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 2,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment:CrossAxisAlignment.start,
                                  children: [
                                    // ClipRRect(
                                    //     //  borderRadius: BorderRadius.circular(10),
                                    //     borderRadius: BorderRadius.only(
                                    //         topRight: Radius.circular(10),
                                    //         topLeft: Radius.circular(10)),
                                    //     child: Image.network(
                                    //       temp.pujaId?.pujaImage ??
                                    //           "https://picsum.photos/200/300",
                                    //       fit: BoxFit.fill,
                                    //       height: Get.height * 0.2,
                                    //       width: double.infinity,
                                    //       errorBuilder: (BuildContext context,
                                    //           Object error,
                                    //           StackTrace? stackTrace) {
                                    //         // Here you can return any widget you want to show in case of error
                                    //         return Shimmer.fromColors(
                                    //             baseColor: Colors.grey[300]!,
                                    //             highlightColor:
                                    //                 Colors.grey[100]!,
                                    //             child: Padding(
                                    //               padding: const EdgeInsets.all(
                                    //                   10.0),
                                    //               child: Column(
                                    //                 children: [
                                    //                   Container(
                                    //                     width: double
                                    //                         .infinity, // Adjust width as needed
                                    //                     height:
                                    //                         Get.height * 0.2,
                                    //                     decoration:
                                    //                         BoxDecoration(
                                    //                       gradient:
                                    //                           LinearGradient(
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
                                    //     )),
                                    SizedBox(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height / 7,
                  width: double.infinity,
                  child: ShimmerImageLoader2(
                    image: temp.pujaId!.pujaImage.toString(),),),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              SizedBox(
                                                  width: Get.width * 0.7,
                                                  child: CustomText(
                                                    text: temp.pujaId?.title ??
                                                        "",
                                                   fontSize: 17,
                            fontFamily: 'poppinssemibold',
                            fontWeight: FontWeight.bold,
                            maxLines: 2,
                                                  )),
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment:CrossAxisAlignment.start,
                                            children: [
                                              CustomText(
                                                text: "Puja Date",
                                                fontSize: 10,
                                                fontFamily: 'poppinssemibold',
                            fontWeight: FontWeight.w600,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                              CustomText(
                                                text: convertDateFormat(
                                                    temp.pujaDate.toString()),
                                                fontSize: 12,
                                                fontFamily: 'poppinssemibold',
                            fontWeight: FontWeight.bold,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (ctx) =>
                                                        AddDetails(temp.sId
                                                            .toString())));
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        15, 5, 15, 5),
                                                child: CustomText(
                                                   fontFamily: 'poppinssemibold',
                            fontWeight: FontWeight.bold,
                                                  text: "Add Details",
                                                  color: whiteColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            if (temp.is_live == true) {
                                              // Navigator.push(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //         builder: (context) =>
                                              //             LiveVideoCallScreen(
                                              //                 screenType:
                                              //                     "pooja",
                                              //                 id: temp.sId,
                                              //                 channelName: temp
                                              //                     .channelId!,
                                              //                 astroid:
                                              //                     temp.astrologerId ??
                                              //                         "",
                                              //                 name:
                                              //                     temp.astrologerName ??
                                              //                         "",
                                              //                 astroImage: temp
                                              //                     .pujaId!
                                              //                     .pujaImage
                                              //                     .toString(),
                                              //                 profile:
                                              //                     ""))).then(
                                              //     (value) {
                                              //   // getLiveAstrologer();
                                              //   setState(() {
                                              //     screenController
                                              //         .poojaBookingApi();
                                              //   });
                                              // });
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg: "User not live");
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        15, 5, 15, 5),
                                                child: CustomText(
                                                  text:temp.is_live == true ? "Join Live" : "Wait For Live",
                                                   fontFamily: 'poppinssemibold',
                            fontWeight: FontWeight.bold,
                                                  color: whiteColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                             fontFamily: 'poppinssemibold',
                            fontWeight: FontWeight.w400,
                                            text: "Booking Date",
                                            fontSize: 12,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          CustomText(
                                            text: formatDate(
                                                temp.createdAt ?? ""),
                                            fontSize: 10,
                                             fontFamily: 'poppinssemibold',
                            fontWeight: FontWeight.w500,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Container(
                                    //   decoration: BoxDecoration(
                                    //     color: primaryColor,
                                    //     borderRadius: BorderRadius.only(
                                    //         bottomLeft: Radius.circular(10),
                                    //         bottomRight: Radius.circular(10)),
                                    //   ),
                                    //   child: Padding(
                                    //     padding: const EdgeInsets.all(5.0),
                                    //     child: Row(
                                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    //       children: [
                                    //         Text("Time Left:",
                                    //             style: TextStyle(
                                    //                 fontSize: 12, color: Colors.white)),
                                    //         Text(
                                    //           "",
                                    //           style: TextStyle(
                                    //               fontSize: 12, color: Colors.white),
                                    //         )
                                    //       ],
                                    //     ),
                                    //   ),
                                    // )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 10, right: 10, top: 5, bottom: 5),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: temp.is_live == true
                                      ? Colors.red
                                      : Colors.grey.shade500,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10)),
                                ),
                                child: Text(
                                  temp.is_live == true ? 'Live' : "Upcoming",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                            ],
                          ));
                    },
                  );
          },
        ));
  }

  String formatDate(String isoDateString) {
    // Parse the ISO string to a DateTime object
    DateTime dateTime = DateTime.parse(isoDateString);

    // Define the desired format (e.g., "12 July 2024")
    var formatter = DateFormat('d MMMM yyyy');

    // Format the DateTime object to a string
    return formatter.format(dateTime);
  }

  DateTime? endTime;
  String getRemainingTime() {
    Duration remaining = endTime!.difference(DateTime.now());
    int days = remaining.inDays;
    int hours = remaining.inHours.remainder(24);
    int minutes = remaining.inMinutes.remainder(60);
    int seconds = remaining.inSeconds.remainder(60);
    return '$days days $hours hours $minutes mins $seconds seconds';
  }

  String convertDateFormat(String isoDateString) {
    // Parse the ISO date string into a DateTime object
    DateTime dateTime = DateTime.parse(isoDateString);

    // Create a DateFormat to output your desired format
    DateFormat outputFormat = DateFormat('dd/MM/yyyy');

    // Convert the DateTime into the desired format string
    return outputFormat.format(dateTime);
  }

  final _api = HttpServices();
}
