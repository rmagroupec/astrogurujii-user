
import 'package:astro_gurujii/Screens/BlogViewScreen.dart';
import 'package:astro_gurujii/Screens/Models/HomeDataModel.dart';
import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/parser.dart';

import '../WebServices/model/blog_list/Result.dart';

class Blogs extends StatefulWidget {
  List<Blog>? data = [];
  Blogs({Key? key, this.data}) : super(key: key);

  @override
  _BlogsState createState() => _BlogsState();
}

class _BlogsState extends State<Blogs> {
  bool search_click_status = false;
  bool _isLoading = true;
  List<Result> result = [];
  final HttpServices _httpServices = HttpServices();
  Future<void> getBlogApi() async {
    var res = await _httpServices.blog_list(id: "");
    if (res!.status == true) {
      setState(() {
        if (res.results != null) {
          /*astrologer.clear();*/
          result = res.results!;
        }
        _isLoading = false;
      });
    } else {
      _isLoading = false;
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }

  @override
  void initState() {
    getBlogApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 7),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height*0.32,
      child: ListView.builder(
          itemCount: result.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => BlogViewScreen(
                            img: result[index].img.toString(),
                            id: result[index].id.toString(),
                          )));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width*0.8,
                  height: MediaQuery.of(context).size.height*0.32,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topRight,
                        width: MediaQuery.of(context).size.width*0.8,
                        height: MediaQuery.of(context).size.height*0.2,
                        decoration: BoxDecoration(
                            color: const Color(0xff000000),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                // colorFilter: ColorFilter.mode(
                                //     Colors.black.withOpacity(0.6), BlendMode.dstATop),
                                image: CachedNetworkImageProvider(result[index].img.toString()))),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              /*Image.asset('assets/images/icons_eye.png',width: 25,height: 25,color: whiteColor,),
                          CustomText(text: result[index].view_count,color: whiteColor,fontWeight: FontWeight.w600,fontSize: 11,)*/
                            ],
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width,
                              child: CustomText(
                                text: parseHtmlString(
                                  result[index].title.toString(),
                                ),
                                color: blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                maxLines: 2,
                                align: TextAlign.start,
                              ))),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CustomText(
                            text: parseHtmlString(
                              result[index].description.toString(),
                            ).length >
                                15
                                ? parseHtmlString(
                              result[index].description.toString(),
                            ).substring(0, 15) +
                                '...'
                                : parseHtmlString(
                              result[index].description.toString(),
                            ),
                            color: Color(0xFFB3B3B3),
                            fontWeight: FontWeight.w400,
                            maxLines: 1,
                            fontSize: 14,
                          ),
                          SizedBox(
                            width: 1,
                          ),
                          // CustomText(text: DateFormat('dd MMM,y').format(DateTime.parse(widget.data[index].createdDate.toString())),color: Color(0xFF626262),fontWeight: FontWeight.w400,fontSize: 11,),
                          CustomText(
                            text: result[index].created_date.toString(),
                            color: Color(0xFFB3B3B3),
                            fontWeight: FontWeight.w400,
                            fontSize: 11,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  String parseHtmlString(String htmlString) {
    final String d = "kjfdjhd";
    final document = parse(htmlString);
    final String parsedString = parse(document.body!.text).documentElement!.text;
    return parsedString;
  }
}
