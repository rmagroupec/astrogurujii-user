
import 'package:astro_gurujii/Screens/Models/AstroDetailsModel.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../Setup/color.dart';

class RatingListScreen extends StatefulWidget {
  String astro_image;
  String astro_name;
  String review;
  List<Rating> ratings;

  RatingListScreen({required this.ratings, required this.astro_image, required this.astro_name,required this.review});

  @override
  State<StatefulWidget> createState() {
    return ReviewAllScreenState();
  }
}

class ReviewAllScreenState extends State<RatingListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // Change your color here
        ),
        title: Text(
          "Rating & Review",
          style: TextStyle(color: Colors.white),
        ),
      ),
      // appBar: AppBar(
      //   elevation: 0,
      //   title: CustomText(text: 'Rating & Review',color: blackColor,fontWeight: FontWeight.w600,fontSize: 15,),
      //   backgroundColor: whiteColor,
      //   leading:  IconButton(onPressed: (){
      //     Navigator.of(context).pop();
      //   }, icon: Icon(Icons.arrow_back_ios,color: blackColor,)),
      // ),

      body: Container(
          child: ListView.builder(
              itemCount: widget.ratings.length,
              itemBuilder: (BuildContext context, int index) {
                return
                  widget.ratings.length==0?Text("No Review"):

                  Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 4.0,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  child: CircleAvatar(
                                backgroundImage: widget.ratings[index].profileImg  == ""
                                    ? AssetImage("assets/images/demoPic.jpg")
                                    : NetworkImage(widget.ratings[index].profileImg.toString() ),
                                radius: 35,
                              )),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        child: Text(
                                            widget.ratings[index].name ?? '')),
                                    Container(
                                      height: 15,
                                      child: RatingBar.builder(
  initialRating: getRating(widget.ratings[index].rating.toString()),
  minRating: 1,
  itemSize: 15,
  direction: Axis.vertical,
  allowHalfRating: true,
  itemCount: 5,
  ignoreGestures: true, // disables interaction, replacing tapOnlyMode and updateOnDrag
  itemBuilder: (context, _) => const Icon(
    Icons.star,
    color: Colors.amber,
  ),
  onRatingUpdate: (_) {},
),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width*0.6,
                                        alignment: Alignment.topLeft,
                                        margin: EdgeInsets.only(top: 10),
                                        child: Text(
                                          widget.ratings[index].review.toString()==""?"No review":widget.ratings[index].review.toString(),
                                          style: TextStyle(color: Colors.grey),
                                        )),
                                  ],
                                ),
                              ),

                            ],

                          ),

                        ),

                        // Container(
                        //     alignment: Alignment.topLeft,
                        //     margin: EdgeInsets.only(top: 10),
                        //     child: Text(
                        //       widget.ratings[index].review==""?"No review":widget.ratings[index].review,
                        //       style: TextStyle(color: Colors.grey),
                        //     )),
                        // (widget.ratings[index].astr_comment
                        //         .toString()
                        //         .isNotEmpty)
                        //     ? Container(
                        //         decoration: new BoxDecoration(
                        //           borderRadius: new BorderRadius.circular(6.0),
                        //           color: Color(yColor),
                        //         ),
                        //         alignment: Alignment.topLeft,
                        //         margin: EdgeInsets.only(top: 10),
                        //         child: Padding(
                        //           padding: const EdgeInsets.all(8.0),
                        //           child: Column(
                        //             children: [
                        //               /* Align(
                        //           alignment : Alignment.topLeft,
                        //           child: Text("Replied by "+widget.astro_name??'', textAlign: TextAlign.left,style: TextStyle(color: Colors.black),)),*/
                        //               SizedBox(
                        //                 height: 10,
                        //               ),
                        //               Align(
                        //                   alignment: Alignment.topLeft,
                        //                   child: Text(
                        //                     widget.ratings[index].astr_comment
                        //                             .toString() ??
                        //                         '' ??
                        //                         '',
                        //                     textAlign: TextAlign.left,
                        //                     style: TextStyle(
                        //                         color: Color(testColor)),
                        //                   )
                        //               ),
                        //
                        //
                        //             ],
                        //           ),
                        //         ))
                        //     : Container(),


                        SizedBox(
                          height: 3,
                        )
                      ],
                    ),
                  ),
                );
              })),
    );
  }

  getRating(String rating) {
    try {
      double ratee = double.parse(rating);
      return ratee;
    } catch (e) {
      return 5.0;
    }

    return 1.0;
  }
}
