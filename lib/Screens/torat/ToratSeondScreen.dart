
import 'package:astro_gurujii/Screens/torat/TarotFormScreen.dart';
import 'package:astro_gurujii/Screens/torat/TarotThirdScreen.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import '../../Setup/SetUp.dart';
import '../torat/model/Result.dart';
class ToratSeondScreen extends StatefulWidget{
  List<Result>? data;
  var question;
  List<CardCount>? card_list;
  ToratSeondScreen({this.data,this.question,this.card_list});

  @override
  State<StatefulWidget> createState() {
    return ToratSeondScreenState();
  }
  
}



class ToratSeondScreenState extends State<ToratSeondScreen>{
 String  showDetails="N";

 int selectionSize=0;
 int pos1=0;
 int pos2=0;
 int pos3=0;

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
                    }, icon: Icon(Icons.arrow_back_ios,color: whiteColor,)),
                    CustomText(text: "Tarot",fontSize: 18,fontWeight: FontWeight.w600,color: whiteColor,),
                    const Spacer(),

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
          child: Container(
            width: double.infinity,
            child: ListView(
              children: [
                SizedBox(height: 30,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Your Question:",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 5,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${widget.question}",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.normal),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      child: Row(
                        children: [
                          Text(
                            "Choose three cards",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                        ],
                      )),
                ),
                SizedBox(
                  height: 10,
                ),

                Container(height: 50,
                    child:Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        margin: EdgeInsets.only(left: 5,right: 5),
                        child:  ListView.builder(
                            itemCount: widget.card_list!.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int i) {
                              return Container(
                                height: 50,
                                width: 30,
                                child: InkWell(
                                  onTap: (){
                                    print('=======dddddddddddddddddddddd====='+selectionSize.toString());

                                         if(selectionSize<3){
                                           if(widget.card_list![i].status=="N"){
                                             setState(() {
                                               widget.card_list![i].status="Y";
                                               selectionSize=selectionSize+1;
                                             });
                                           }
                                         }

                                         if(selectionSize==3){
                                           setState(() {
                                             showDetails="Y";
                                             widget.data!.insert(2,  widget.data![i]);
                                             widget.data![2].status="Y";
                                           });
                                         }else if(selectionSize==1){
                                           setState(() {
                                             widget.data!.insert(0,  widget.data![i]);
                                             widget.data![0].status="Y";
                                           });
                                         }else if(selectionSize==2){
                                           setState(() {
                                             widget.data!.insert(1,  widget.data![i]);
                                             widget.data![1].status="Y";
                                           });
                                         }


                                  },
                                  child: Card(
                                    color: (widget.card_list![i].status=="Y")?Colors.green:Colors.red,
                                   ),
                                ),
                              );
                            }),
                    )),

              Container(height: 400,
               child:Padding(
                 padding: const EdgeInsets.only(top: 20),
                 child: Container(
                     width: MediaQuery.of(context).size.width,
                     height: MediaQuery.of(context).size.height,
                     margin: EdgeInsets.only(left: 5,right: 5),
                     child:  GridView.count(
                       crossAxisCount: 3,
                       childAspectRatio: (2 /4),
                       shrinkWrap: true,
                       children: List.generate(3, (index) {
                         return InkWell(
                           onTap: (){

                           },
                           child: Container(
                             height: 300,
                             child: Card(
                               elevation: 4,
                               child: Column(
                                 children: [
                                   Container(
                                       width:double.infinity,
                                       height:30,
                                       decoration: BoxDecoration(
                                         color: getColor(index),
                                         borderRadius: BorderRadius.circular(0),
                                       ),
                                       child: Center(child: CustomText(text:setTitle(index),fontWeight: FontWeight.normal,fontSize: 16,))),
                                   Container(
                                      height: 192,
                                     decoration: BoxDecoration(
                                         image: DecorationImage(
                                             fit: (widget.data![index].status=="Y")?BoxFit.fill:BoxFit.contain,
                                             image: (widget.data![index].status=="Y")?NetworkImage(widget.data![index].image!):AssetImage("assets/astro/tarot_select.jpg")
                                         ),
                                         boxShadow: [
                                           BoxShadow(
                                             color: whiteColor,
                                             blurStyle: BlurStyle.outer,
                                             offset: Offset(0.0, 1.0), //(x,y)
                                             blurRadius: 1.0,
// spreadRadius: 1
                                           )
                                         ],
                                         borderRadius: BorderRadius.circular(5)
                                     ),
                                   ),
                                   (widget.data![index].status=="Y")?Container(
                                       width:double.infinity,
                                       height:30,
                                       decoration: BoxDecoration(
                                         color: whiteColor,
                                         borderRadius: BorderRadius.circular(0),
                                       ),
                                       child: Center(child: CustomText(text:widget.data![index].tarot_name!,fontWeight: FontWeight.normal,fontSize: 13,)
                                       )
                                   ):SizedBox(height: 30,),
                                 ],
                               ),
                             ),
                           ),
                         );
                       }),
                     )
                 ),
               )),

                (showDetails=="Y")?InkWell(
                  onTap: () async {
                    await Navigator.push(context, PageTransition(
                        duration: Duration(seconds: 1),
                        type: PageTransitionType.rightToLeft, child: TarotThirdScreen(data: widget.data)));

                  },
                  child: AnimatedContainer(
                    margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 10),
                    alignment: Alignment.center,
                    duration: Duration(seconds: 1),
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child:
                    Text(
                      "View What This Means",
                      style: TextStyle(color: Colors.white, fontSize: 18,fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          primaryColor,
                          primaryColor,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 2.0,
                        ),
                      ],
                    ),
                  ),
                ):SizedBox(),
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

