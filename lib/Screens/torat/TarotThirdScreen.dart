
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import '../torat/model/Result.dart';
class TarotThirdScreen extends StatefulWidget{
  List<Result>? data;

  TarotThirdScreen({ this.data});

  @override
  State<StatefulWidget> createState() {
    return ToratSeondScreenState();
  }

}
class ToratSeondScreenState extends State<TarotThirdScreen>{
  String  showDetails="N";
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: primaryColor,
      statusBarBrightness: Brightness.dark,
    ));
    return Scaffold(
      backgroundColor: primaryColor,
      appBar:PreferredSize(
          preferredSize:  Size.fromHeight(80.0),
          child: Container(
            child: Column(
              children: [
                const SizedBox(height: 30,),
                Row(
                  children: [
                    IconButton(onPressed: (){
                      Navigator.of(context).pop();
                    }, icon: Icon(Icons.arrow_back_ios,color:whiteColor,)),
                    CustomText(text: "Tarot",fontSize: 18,fontWeight: FontWeight.w600,color: whiteColor,),
                    const Spacer(),
                    InkWell(
                      onTap: (){
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: CustomText(text: "Ask Next Question",fontSize: 18,fontWeight: FontWeight.w600,color: blackColor,),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
      ),
      body: Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                SizedBox(height: 10,),
                Center(
                  child: CustomText(text:widget.data![0].tarot_name!,fontWeight: FontWeight.bold,fontSize: 16,),
                ),
                SizedBox(height: 10,),
                Container(
                  width: double.infinity,
                  child: Html(data:widget.data![0].tarot_desc),
                ),
                SizedBox(height: 10,),
                Center(
                  child: CustomText(text:widget.data![1].tarot_name!,fontWeight: FontWeight.bold,fontSize: 16,),
                ),
                SizedBox(height: 10,),

                Container(
                  width: double.infinity,
                  child: Html(data:widget.data![1].tarot_desc),
                ),
                SizedBox(height: 10,),
                Center(
                  child: CustomText(text:widget.data![2].tarot_name!,fontWeight: FontWeight.bold,fontSize: 16,),
                ),
                SizedBox(height: 10,),
                Container(
                  width: double.infinity,
                  child: Html(data:widget.data![2].tarot_desc),
                ),
              ],
            ),
          )
      ),
    );
  }
  setTitle(int index) {
    if(index==0){
      return "SELF";
    }else if(index==1){
      return "SITUATION";
    }
    else if(index==2){
      return "CHALLENGES";

    }
  }

  getColor(int index) {
    if(index==0){
      return color1;
    }else if(index==1){
      return color2;
    }
    else if(index==2){
      return color3;

    }

  }

}