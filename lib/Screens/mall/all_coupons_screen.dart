import 'package:flutter/material.dart';

import '../../Setup/SetUp.dart';
import '../../Setup/app_colors.dart';
import 'model/all_coupon_model.dart';

class AllCouponsScreen extends StatefulWidget {
  final  List<CouponData> coupnList;
    AllCouponsScreen({required this.coupnList, this.onCouponSelected});
  final Function(String couponCode)? onCouponSelected;


  @override
  State<AllCouponsScreen> createState() => _AllCouponsScreenState();
}

class _AllCouponsScreenState extends State<AllCouponsScreen> {
  String couponCode="";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // Change back arrow color to white
        ),

        backgroundColor: blueColor,
        title: Text("All Coupons",style: TextStyle(color: Colors.white)),
      ),
      body: ListView.builder(
      itemCount: widget.coupnList.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return  Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: double.infinity,
            decoration:
            BoxDecoration(color: Color(0x33000000)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: AppColors.primaryOrange,
                          ),
                        ),
                        Center(
                          // Center the transform child inside the Stack
                          child: Transform(
                            alignment: Alignment.center,
                            // Align transformation around the center
                            transform: Matrix4.identity()
                              ..translate(0.0, 0.0)
                              ..rotateZ(-1.57),
                            // Rotating the text by -90 degrees
                            child: Text(
                              // '30% OFF',
                              widget.coupnList[index].title ?? "",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFFEFEFEF),
                                fontSize: 12,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.24,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment:
                      MainAxisAlignment.start,
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          // 'SUPERSAVE',
                          widget.coupnList[index].coupanCode ?? "",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.24,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Valid Till \n${widget.coupnList[index].endDate }',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.24,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    InkWell(
                      onTap: () {

                        if (widget.onCouponSelected != null) {
                          widget.onCouponSelected!(widget.coupnList[index].coupanCode ?? "");
                        }

                        Navigator.pop(context);

                        },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 20),
                        child: Container(
                          decoration: BoxDecoration(
                              color:
                              AppColors.primaryOrange,
                              borderRadius:
                              BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15,
                                right: 15,
                                bottom: 5,
                                top: 5),
                            child: Text(
                              'Apply  ',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.24,
                              ),
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
        );
      },),

    );
  }
}
