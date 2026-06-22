import 'package:astro_gurujii/Screens/Models/HomeDataModel.dart';
import 'package:astro_gurujii/Setup/app_colors.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';

import '../../Setup/SetUp.dart';

class ClientsTestimonials extends StatefulWidget {
  final List<Testimonials> data;

  const ClientsTestimonials({Key? key, required this.data}) : super(key: key);

  @override
  _ClientsTestimonialsState createState() => _ClientsTestimonialsState();
}

class _ClientsTestimonialsState extends State<ClientsTestimonials> {
  String parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    return parse(document.body!.text).documentElement!.text;
  }

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.data.length,
          itemBuilder: (BuildContext context, int index, int page) {
            final testimonial = widget.data[index];
            return Container(
              width: double.infinity,
              // margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color:
                Color(
                    hexStringToHexInt(("${widget.data[index].color}"))),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(7.0),
                    child: CustomText(
                      text: parseHtmlString(testimonial.description.toString()),
                      maxLines: 4,
                      fontSize: 14,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w400,
                      color: whiteColor,
                      align: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: 7),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                         CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                            testimonial.img.toString(),
                          ),
                          radius: 23,
                          backgroundColor: AppColors.primaryOrange,
                        ),
                        SizedBox(width: 7,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              testimonial.title.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                                color: AppColors.mBGColor,
                              ),
                            ),
                            Text(
                              "India",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize:12,
                                color: whiteColor,
                              ),
                            ),
                          ],
                        ),


                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          options: CarouselOptions(
            enableInfiniteScroll: false,
            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
              });
            },
            aspectRatio: 22 / 10,
            viewportFraction: 1,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 200),
            autoPlayCurve: Curves.fastOutSlowIn,
            scrollDirection: Axis.horizontal,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: SizedBox(
            height: height * 0.025,
            child: ListView.builder(
              itemCount: widget.data.length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  width: 6,
                  height: 6,
                  margin: EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentIndex == index
                        ? AppColors.mBGColor
                        : Colors.black.withOpacity(0.4),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
