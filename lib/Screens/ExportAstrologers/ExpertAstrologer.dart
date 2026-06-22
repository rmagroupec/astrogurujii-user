import 'package:astro_gurujii/Screens/AstroDetails/AstroDetails.dart';
import 'package:astro_gurujii/Screens/Models/HomeDataModel.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:glassmorphism_widgets/glassmorphism_widgets.dart';

import '../../Setup/app_colors.dart';

class ExpertAstrologer extends StatefulWidget {
  List<Astrologer> data = [];
  ExpertAstrologer({Key? key, required this.data}) : super(key: key);

  @override
  _ExpertAstrologerState createState() => _ExpertAstrologerState();
}

class _ExpertAstrologerState extends State<ExpertAstrologer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height:  MediaQuery.of(context).size.height*0.31,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: widget.data.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (ctx) =>
                            AstroDetails(
                                astroLogerName: widget.data[index].name!,
                                categoryId: widget.data[index].id)));
              },
              child:

              Padding(
                padding: const EdgeInsets.all(5.0),
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
                    padding: const EdgeInsets.all(3.0),
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
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFFFFF5EE), // #FFC796
                            Color(0xFFFFF5EE),],

                        ),

                      ),
                      // width: 160,
                      width: 160,

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            height: 10,
                          ),

                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    shape: BoxShape.circle
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(2.5),
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundImage: CachedNetworkImageProvider(
                                        widget.data[index].profileImg.toString()),
                                  ),
                                ),
                              ),


                              Container(
                                width: 70,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,

                                    children: [
                                      Icon(Icons.star,color: Colors.yellow,size: 20,),
                                      SizedBox(width: 5,),

                                      CustomText(
                                        text: "4",
                                        fontWeight: FontWeight.bold,
                                      ),


                                    ],),
                                ),
                              ),
                            ],),


                          SizedBox(
                            height: 10,
                          ),


                          CustomText(
                            text: widget.data[index].name.toString(),
                            // color: primaryColor,
                            color: Colors.black,
                            fontSize: 14,
                            maxLines: 1,
                            fontWeight: FontWeight.bold,
                            align: TextAlign.left,
                          ),
                          CustomText(
                            text: widget.data[index].experience.toString() +
                                " Yr Exp.",
                            color: Colors.grey,
                            fontSize: 14,
                            maxLines: 1,
                            fontWeight: FontWeight.w400,
                            align: TextAlign.left,
                          ),
                          SizedBox(
                            height: 1,
                          ),
                          Center(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                (!widget.data[index].per_min_chat_offer.isEmpty)
                                    ? Text("${setOfferCallingrate(index)}",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 16,
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.black))
                                    : Container(),
                                CustomText(
                                  text: "${setCallingrate(index)}",
                                  align: TextAlign.left,
                                  fontSize: 18,
                                  color: blackColor,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          // InkWell(
                          //   onTap: () {
                          //     Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (ctx) => AstroDetails(
                          //                 categoryId: widget.data[index].id)));
                          //   },
                          //   child: GlassContainer(
                          //     linearGradient: LinearGradient(
                          //       colors: [primaryColor.withAlpha(80), primaryColor],
                          //       begin: Alignment.topLeft,
                          //       end: Alignment.bottomRight,
                          //     ),
                          //     height: 35,
                          //     width: MediaQuery.of(context).size.width,
                          //     child: Row(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       children: [
                          //         CustomText(
                          //           // text: 'Connect',
                          //           text: 'Connect',
                          //           color: Colors.black,
                          //           fontSize: 13,
                          //           fontWeight: FontWeight.w500,
                          //         )
                          //       ],
                          //     ),
                          //   ),
                          // ),

                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => AstroDetails(
                                          astroLogerName:  widget.data[index].name!,
                                          categoryId: widget.data[index].id)));
                            },
                            child: Container(
                              height: 35,
                              width: 130,
                              decoration: BoxDecoration(
                                  color: AppColors.appblueColor,
                                  borderRadius: BorderRadius.circular(20)


                              ),
                              child: Center(
                                child: CustomText(
                                  // text: 'Connect',
                                  text: 'Chat',
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  setCallingrate(int index) {
    var price = "";
    if (widget.data[index].country == "INR") {
      price = "\u{20B9}${widget.data[index].per_min_chat.toString()}/min";
      return price;
    } else {
      price = "\u{20B9}${widget.data[index].per_min_chat.toString()}/min";
      return price;
    }
  }

  String setOfferCallingrate(int index) {
    var price = "";
    if (widget.data[index].country == "INR") {
      price = "\u{20B9}${widget.data[index].per_min_chat_offer.toString()}/min";
      return price;
    } else {
      price = "\u{20B9}${widget.data[index].per_min_chat_offer.toString()}/min";
      return price;
    }
  }
}
