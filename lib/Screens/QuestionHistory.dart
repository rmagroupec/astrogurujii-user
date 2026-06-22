
import 'package:astro_gurujii/Screens/ReportDetailsScreen.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'WebServices/HttpServices.dart';
import 'WebServices/model/user_question/Result.dart';

class QuestionHistory extends StatefulWidget {
  static const String questionHistory = "questionHistory";

  @override
  _QuestionHistoryState createState() => _QuestionHistoryState();
}

class _QuestionHistoryState extends State<QuestionHistory> {
  String userId1="";
  List details=[];
  bool is_loading=true;
  HttpServices _httpService = HttpServices();


  List<Result> data=[];
  Future<void> getAskQuestion() async {
    final prefs = await SharedPreferences.getInstance();
    var res = await _httpService.get_ask_question(astro_id: '');
    if(res!.status == true){
      setState(() {

        is_loading=false;
        data=res.results!;

      });
    }else{
      is_loading=false;
      Fluttertoast.showToast(msg: "Something went wrong");

    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getAskQuestion();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_new,color: Colors.black,)),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text("Question History",style: TextStyle(fontSize: 18,color: Colors.black),),
        /*actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.menu,color: Colors.black,))
        ],*/
      ),
      body: is_loading?Center(child:Lottie.asset('assets/profile/loader.json',)):Container(
          color: Colors.white,
          child: (data.length>0)?ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context,int i){
                return Container(
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 4.0,
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Ask Question",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 21,
                                  ),
                                ),
                                Text(
                                  data[i].reply!.isEmpty?"Pending":"Completed",
                                  style: TextStyle(color: data[i].reply!.isEmpty?blueColor:Colors.green),
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Text(data[i].astro_name??''),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Text(data[i].pob??''),
                                        Text(data[i].tob??'')
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(color: Colors.grey,thickness: 1,),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text("Name",style: TextStyle(fontWeight: FontWeight.w500),),
                                      SizedBox(height: 5,),
                                      Text(data[i].name??'',style: TextStyle(color: Colors.grey),),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Gender",style: TextStyle(fontWeight: FontWeight.w500),),
                                      SizedBox(height: 5,),
                                      Text(data[i].gender??'',style: TextStyle(color: Colors.grey),),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Place of Birth",style: TextStyle(fontWeight: FontWeight.w500),),
                                      SizedBox(height: 5,),
                                      Text(data[i].pob??'',style: TextStyle(color: Colors.grey),),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text("Time of Birth",style: TextStyle(fontWeight: FontWeight.w500),),
                                      SizedBox(height: 5,),
                                      Text(data[i].tob??'',style: TextStyle(color: Colors.grey),),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Question",style: TextStyle(fontWeight: FontWeight.w500),),
                                      SizedBox(height: 5,),
                                      Text(data[i].question??'',style: TextStyle(color: Colors.grey),),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                      (data[i].reply!.isEmpty)?InkWell(
                        child: Container(
                          margin: EdgeInsets.only(top: 5,bottom: 5),
                          padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                          child: Text(
                            "Still Our Astrologer Working on Your Question",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.0, 1.0), //(x,y)
                                blurRadius: 2.0,
                              ),
                            ],
                          ),
                        ),
                      ):InkWell(
                        onTap: (){
                          if(!data[i].reply!.isEmpty ){

                            Navigator.push(context,
                                MaterialPageRoute(builder: (ctx) => ReportDetailsScreen(report: data[i].reply!,title: "Ask Question Report",image: "", question: '',)));
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 5,bottom: 5),
                          padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                          child: Text(
                            "View Answer",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.0, 1.0), //(x,y)
                                blurRadius: 2.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              ):Container(
      child: Center(child: Text("No Data Found"),),
    )
      ),
    );
  }
}