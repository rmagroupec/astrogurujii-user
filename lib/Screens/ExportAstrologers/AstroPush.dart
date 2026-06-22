import 'package:astro_gurujii/Screens/Models/HomeDataModel.dart';
import 'package:astro_gurujii/Screens/mall/CategoryMall.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AstroPush extends StatefulWidget {
  List<ProductCategory>data=[];
   AstroPush({Key? key,required this.data}) : super(key: key);

  @override
  _AstroPushState createState() => _AstroPushState();
}

class _AstroPushState extends State<AstroPush> {
  List<String> images = [
    "assets/images/astrologer1.png",
    "assets/images/astrologer2.png",
    "assets/images/astrologer3.png",
    "assets/images/astrologer4.png",
    "assets/images/astrologer5.png",
    "assets/images/astrologer6.png"
  ];

  List<int> colorsList = [0xff011373, 0xff880627, 0xffBA1A39, 0xffD5AC7E];

  @override
  Widget build(BuildContext context) {
    return topTrending();
  }

  Widget topTrending() {
    return Container(
      padding: const EdgeInsets.only(left: 18, right: 18),
      height: MediaQuery.of(context).size.height*0.276,
      width: MediaQuery.of(context).size.width,
      child: GridView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: widget.data.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              crossAxisSpacing: 10,
              childAspectRatio: 1.65,
              mainAxisSpacing: 10),
          itemBuilder: (BuildContext ctx, int index) {
            return topTrendingItem(index);
          }),
    );
  }

  Widget topTrendingItem(int index) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (ctx) =>
                CategoryMall(
                  id: widget.data[index].sId.toString(),text: widget.data[index].name,))
        );
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Color(colorsList[index % 3] ),
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                )
            ),
            // height: MediaQuery.of(context).size.height * 0.8,

            child: Container(
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.107),
              decoration:  BoxDecoration(
                     borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight:Radius.circular(10)),
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(widget.data[index].image.toString()),
                      /*image: NetworkImage(
                          "https://static.nike.com/a/images/t_PDP_1280_v1/f_auto,q_auto:eco/c8370df5-e9ef-466a-a2fa-70c196a24666/zion-1-pf-basketball-shoes-bHGvxg.png"),*/
                      fit: BoxFit.cover)),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.14,
            child: Container(
               height: MediaQuery.of(context).size.height*0.118,
              width: MediaQuery.of(context).size.width * 0.414,
              alignment: Alignment.topCenter,
              margin: const EdgeInsets.only(left: 6, right: 10, top: 10),
              padding:
                  const EdgeInsets.only(bottom: 10, left: 6, right: 6, top: 15),
             /* child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                    text: widget.data[index].name.toString(),
                    style: TextStyle(
                        color: blackColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                    // Single tapped.
                  ),
                  TextSpan(
                    text: widget.data[index].description.toString(),
                    style: TextStyle(
                        color: greyColor2,
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                    // Double tapped.
                  ),
                ]),
              ),*/
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(text: widget.data[index].name.toString(),color: blackColor,fontSize: 16,fontWeight: FontWeight.w600,),
                  SizedBox(height: 7,),
                  CustomText(text: widget.data[index].description.toString(),color: greyColor2,fontSize: 14,fontWeight: FontWeight.w400,maxLines: 1,align: TextAlign.center,),
                ],
              ),
              decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
            ),
          ),
        ],
      ),
    );
  }
}
