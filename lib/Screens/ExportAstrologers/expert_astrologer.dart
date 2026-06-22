import 'package:flutter/material.dart';

import '../../Setup/SetUp.dart';
import '../../Utilities/CustomText.dart';
import '../AstroDetails/AstroDetails.dart';
import '../Models/HomeDataModel.dart';

class ExpertAstro extends StatefulWidget {
  List<Astrologer> data = [];

  ExpertAstro({Key? key, required this.data}) : super(key: key);

  @override
  State<ExpertAstro> createState() => _ExpertAstroState();
}

class _ExpertAstroState extends State<ExpertAstro> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 220,
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: widget.data.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => AstroDetails(
                                    astroLogerName:widget.data[index].name! ,
                                    categoryId: widget.data[index].id)));
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 140,
                            height: 160,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  widget.data[index].profileImg.toString(),
                                ),
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                width: 30,
                                height: 15,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15), color: blackColor),
                                child: Padding(
                                  padding: EdgeInsets.all(3),
                                  child: Image.asset(
                                    'assets/Icons/camera.png',
                                  ),
                                ),
                              ),
                            ),
                            /*Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children:  [
                        SizedBox(height: 10,),
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: CachedNetworkImageProvider(widget.data[index].profileImg.toString()),
                        ),
                        SizedBox(height: 5,),
                        CustomText(text: 'Exp ${widget.data[index].experience} Yrs.',color: greyColor2,fontSize: 10,fontWeight: FontWeight.w400,),
                        SizedBox(height: 5,),
                        CustomText(text: widget.data[index].name.toString(),color: blackColor,fontSize: 14,fontWeight: FontWeight.w400,align: TextAlign.center,),
                        SizedBox(height: 5,),
                        CustomText(text: widget.data[index].language!.map((e) => e.name).toList().join(','),color: greyColor2,fontSize: 12,fontWeight: FontWeight.w400,),
                      ],
                    ),*/
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    CustomText(
                      text: widget.data[index].name.toString(),
                      color: blackColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      align: TextAlign.center,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              );
            }));
  }
}
