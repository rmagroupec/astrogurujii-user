
import 'package:astro_gurujii/Setup/app_colors.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

import '../../Setup/SetUp.dart';
import '../Models/testimonilas/AllTestimonialsModel.dart';
import '../WebServices/HttpServices.dart';

class AllTestimonialsScreen extends StatefulWidget {
  @override
  State<AllTestimonialsScreen> createState() => _AllTestimonialsScreenState();
}

class _AllTestimonialsScreenState extends State<AllTestimonialsScreen> {
  HttpServices _httpService = HttpServices();
  bool _isLoading=false;
  List<Data> testimonialslist=[];
  Future<void> getTestimonialsList() async {

    try{
      _isLoading=true;
      var res = await _httpService.getAllTestimonials();
      if(res!.status==true){
        setState(() {
          _isLoading=false;
          testimonialslist=res.data!;
        });
      }

      setState(() {

      });
    }finally{
      setState(() {
        _isLoading=false;
      });
    }

  }

  @override
  void initState() {
    getTestimonialsList();
    super.initState();
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  hexStringToHexInt(String hex) {
    hex = hex.replaceFirst('#', '');
    hex = hex.length == 6 ? 'ff' + hex : hex;
    int val = int.parse(hex, radix: 16);
    return val;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: whiteColor, //change your color here
          ),
          title: Text(
            "Testimonials",
            style: TextStyle(color: whiteColor),
          ),
          backgroundColor: primaryColor,
          elevation: 0.0,
        ),
        body:_isLoading?Center(child: CircularProgressIndicator(color: AppColors.orangeColor,)):
        ListView.builder(
          itemCount: testimonialslist.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              padding: EdgeInsets.only(left: 10,right: 10,top: 20,bottom: 20),
              margin: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
              decoration: BoxDecoration(
                color: Color(hexStringToHexInt(testimonialslist[index].color.toString())), // Container background color
                borderRadius: BorderRadius.circular(20), // Optional: Round corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4), // Shadow color
                    spreadRadius: 1, // Spread radius
                    blurRadius: 1, // Blur radius
                    offset: Offset(0, 2), // Offset in x and y direction
                  ),
                ],
              ),

                child:


                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(testimonialslist[index].img.toString()),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(text: testimonialslist[index].title.toString(),fontSize: 16,color: Colors.black,fontWeight: FontWeight.w700,),
                          SizedBox(
                            width: Get.width*0.72,
                            child: Html(data: testimonialslist[index].description.toString(),
                              //,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.black38),
                            ),
                          )
                        ],
                      ),
                    )

                  ],
                )
            );
          },
        ));
  }
}
