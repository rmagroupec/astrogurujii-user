
import 'package:astro_gurujii/Screens/ReportDetailsScreen.dart';
import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Screens/WebServices/model/UserReportList/ReportIntakeForm.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

class MyReport extends StatefulWidget {
  @override
  _MyReportState createState() => _MyReportState();
}

class _MyReportState extends State<MyReport> {
  String userId1="";
  List details=[];
  bool is_loading=true;
  List<ReportIntakeForm> report_intake_form=[];
  HttpServices _httpService = HttpServices();

  Future<void> getAskQuestion() async {

    var res = await _httpService.user_report_list();
    if(res!.result == true){
      setState(() {

        is_loading=false;
        report_intake_form=res.report_intake_form!;

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
        title: Text("My Report",style: TextStyle(fontSize: 18,color: Colors.black),),
        /*actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.menu,color: Colors.black,))
        ],*/
      ),
      body: is_loading?Center(child:Lottie.asset('assets/profile/loader.json',)):Container(
          color: Colors.white,
          child: (report_intake_form.length>0)?ListView.builder(
              itemCount: report_intake_form.length,
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
                      InkWell(
                        onTap: (){
                          if(report_intake_form[i].status=="Complete"){

                             Navigator.push(context,
                                MaterialPageRoute(builder: (ctx) => ReportDetailsScreen(question:report_intake_form[i].any_comments!,report: report_intake_form[i].reply!,title: "Report",image: report_intake_form[i].file!,)));
                          }

                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Report Name",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 21,
                                    ),
                                  ),
                                  Text(
                                    (report_intake_form[i].status=="Complete")?"Completed":"Active",
                                    style: TextStyle(color: (report_intake_form[i].reply==null)?primaryColor:Colors.green),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Text(report_intake_form[i].report_type??''),
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Text(report_intake_form[i].created_at??''),
                                          //  Text(report_intake_form[i].tob??'')
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
                                        Text(report_intake_form[i].first_name!+" "+report_intake_form[i].last_name!??'',style: TextStyle(color: Colors.grey),),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Gender",style: TextStyle(fontWeight: FontWeight.w500),),
                                        SizedBox(height: 5,),
                                        Text(report_intake_form[i].gender??'',style: TextStyle(color: Colors.grey),),
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
                                        Text(report_intake_form[i].pob??'',style: TextStyle(color: Colors.grey),),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text("Time of Birth",style: TextStyle(fontWeight: FontWeight.w500),),
                                        SizedBox(height: 5,),
                                        Text(report_intake_form[i].tob??'',style: TextStyle(color: Colors.grey),),
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
                                        Text("Marital Status",style: TextStyle(fontWeight: FontWeight.w500),),
                                        SizedBox(height: 5,),
                                        Text(report_intake_form[i].marital_status??'',style: TextStyle(color: Colors.grey),),

                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Contact Number",style: TextStyle(fontWeight: FontWeight.w500),),
                                        SizedBox(height: 5,),
                                        Text(report_intake_form[i].number??'',style: TextStyle(color: Colors.grey),),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              Align(
                                alignment : Alignment.topLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Comments",style: TextStyle(fontWeight: FontWeight.w500),),
                                    SizedBox(height: 5,),
                                    Text(report_intake_form[i].any_comments??'',style: TextStyle(color: Colors.grey),),

                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      (report_intake_form[i].status!="Complete")?InkWell(
                        child: Container(
                          margin: EdgeInsets.only(top: 5,bottom: 5),
                          padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                          child: Text(
                            setTest(report_intake_form[i].status!),
                            style: TextStyle(color: Colors.white, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor,
                                offset: Offset(0.0, 1.0), //(x,y)
                                blurRadius: 2.0,
                              ),
                            ],
                          ),
                        ),
                      ):SizedBox()
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

  String setTest(String status) {
    if(status.toUpperCase()=="Active".toUpperCase()){
      return "Still Our Astrologer Working on Your Report";
    }else if(status.toUpperCase()=="Submited".toUpperCase()){
      return "Still Our Expert Review Your Report ";
    }else{
      return "Completed";
    }


  }
}
