
import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import '../../Setup/SetUp.dart';
import '../offer/model/Result.dart';
typedef StringValue = Result Function(Result);

class AvailableOfferScreen extends StatefulWidget {
  static const String questionHistory = "questionHistory";
  StringValue callback;
  AvailableOfferScreen(this.callback);

  @override
  _AvailableOfferState createState() => _AvailableOfferState();
}

class _AvailableOfferState extends State<AvailableOfferScreen> {
  String userId1="";
  List details=[];
  bool is_loading=true;
  HttpServices _httpService = HttpServices();


  List<Result> data=[];
  Future<void> getAskQuestion() async {
    var res = await _httpService.coupan_list(coupan_code: "",type: "");
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
        title: Text("Apply Offer",style: TextStyle(fontSize: 18,color: Colors.black),),
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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment : MainAxisAlignment.start,
                      crossAxisAlignment : CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4,),
                        CustomText(text: "${data[i].title}",fontSize: 18,fontWeight: FontWeight.bold,color: Color(0xFF000000),align: TextAlign.center,),
                        SizedBox(height: 4,),
                        CustomText(text: 'Get ${data[i].coupan_discount}% off up to Rs. ${data[i].discount_amount_up_to}',fontSize: 14,fontWeight: FontWeight.normal,color: Color(0xFF000000),align: TextAlign.center,),
                        SizedBox(height: 4,),
                        CustomText(text: 'Valid on amount ${data[i].minimum_order_price} or more',fontSize: 14,fontWeight: FontWeight.normal,color: Color(0xFF000000),align: TextAlign.center,),
                        SizedBox(height: 10,),
                        Divider(
                          color: Color(0xFFD9D9D9),
                          thickness: 2,
                        ),
                        SizedBox(height: 7,),

                        Row(
                          crossAxisAlignment : CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Container(
                                child:DottedBorder(
  options: RectDottedBorderOptions(
    color: getOfferAllowStaus(
      data[i].per_user_use!,
      data[i].user_coupan_user_count.toString(),
    )
        ? primaryColor
        : greyColor1,
    strokeWidth: 1,
    dashPattern: [4],
    // borderRadius: BorderRadius.circular(8),
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: Container(
      height: 30,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        '${data[i].coupan_code}',
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontFamily: "MetropolisSemiBold",
        ),
      ),
    ),
  ),
)

                              ),
                            ),

                            Expanded(
                                flex: 5,
                                child: SizedBox()),

                            Expanded(
                              flex: 3,
                              child: InkWell(
                                  onTap: () {
                                    if(getOfferAllowStaus(data[i].per_user_use!,data[i].user_coupan_user_count.toString())){
                                      widget.callback(data[i]);
                                      Navigator.pop(context);
                                    }

                                  },
                                  child:CustomText(text: 'APPLY',color: getOfferAllowStaus(data[i].per_user_use!,data[i].user_coupan_user_count.toString())?primaryColor:greyColor1,fontWeight: FontWeight.w400,fontSize: 18,)),
                            )
                          ],
                        ),

                        SizedBox(height: 7,),
                        Divider(
                          color: Color(0xFFD9D9D9),
                          thickness: 2,
                        ),
                        SizedBox(height: 7,),
                        CustomText(text: 'You will save ${data[i].coupan_discount}% off up to Rs. ${data[i].discount_amount_up_to} with this code',fontSize: 14,fontWeight: FontWeight.normal,color: getOfferAllowStaus(data[i].per_user_use!,data[i].user_coupan_user_count.toString())?primaryColor:greyColor1,align: TextAlign.center,),
                        SizedBox(height: 7,),
                      ],
                    ),
                  ),
                );
              }
          ):Container(
            child: Center(child: Text("No Data Found"),),
          )
      ),
    );
  }

  getOfferAllowStaus(String per_user_use, String user_coupan_user_count) {

    if(int.parse(per_user_use)>int.parse(user_coupan_user_count)){
      return true;
    }
    else{
      return false;
    }

  }
}