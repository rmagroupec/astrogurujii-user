
import 'package:astro_gurujii/Screens/Login.dart';
import 'package:astro_gurujii/Screens/MyWallet.dart';
import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Setup/SetUp.dart';

class AskAQuestion extends StatefulWidget {
  final String astro_id;
  final String price;
  AskAQuestion({Key? key, required this.astro_id, required this.price}) : super(key: key);

  @override
  _AskAQuestionState createState() => _AskAQuestionState();
}

class _AskAQuestionState extends State<AskAQuestion> {
  final TextEditingController review_controller = TextEditingController();
  bool selection = true;
  String wallet = "0.0";
  HttpServices _httpService = HttpServices();
  bool is_loading = true;
  String currency = '';
  String currencySign = "\u{20B9}";

  Future<void> getDataApi() async {
    final prefs = await SharedPreferences.getInstance();
    var res = await _httpService.user_question_add(
        astrologer_id: widget.astro_id,
        question: review_controller.text,
        price: widget.price);
    if (res!.status == true) {
      setState(() {
        Fluttertoast.showToast(msg: res.message!);
        is_loading = false;
        Navigator.pop(context);
      });
    } else {
      is_loading = false;
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }

  Future<void> validate() async {
    if (review_controller.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please ask a question");
    } else {
      if (double.parse(wallet) < double.parse(widget.price)) {
        final _prefs = await SharedPreferences.getInstance();
        if (_prefs.get("is_skip") == "Y") {
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (_) => LoginPage()), (route) => false);
        } else {
          Navigator.push(
              context, MaterialPageRoute(builder: (ctx) => MyWallet()));
        }
      } else {
        getDataApi();
      }
    }
  }

  void getProfile() async {
    var res = await _httpService.profile_api();
    if (res!.status == true) {
      setState(() {
        wallet = res.results!.wallet.toString();
        currency = res.results!.currency.toString();
        if (currency == "USD") {
          setState(() {
            currencySign = "\u{20B9}";
          });
        } else {
          setState(() {
            currencySign = "\u{20B9}";
          });
        }
      });
    } else {
      Fluttertoast.showToast(msg: res.message!);
    }
  }

  @override
  void initState() {
    getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: whiteColor,
            )),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "ASK A QUESTION",
          style: TextStyle(fontSize: 18, color: whiteColor),
        ),
        /*actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.menu,color: Colors.black,))
        ],*/
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /* Container(
              // margin: EdgeInsets.only(left: 10, right: 10),
              height: MediaQuery.of(context).size.height /6,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(

                boxShadow: [
                  BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 2.0,
                      blurStyle: BlurStyle.outer),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 20),
                    child: Text(
                      "Is this for you or for someone else?",
                      style:
                      TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                  SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                          child:InkWell(
                            onTap: (){
                              setState(() {
                                if(selection){
                                  selection=false;
                                }else{
                                  selection=true;
                                }
                              });
                        },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              decoration: (selection)?BoxDecoration(
                                color: Colors.grey.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(30)
                              ):BoxDecoration(
                                  color: blueColor,
                                  borderRadius: BorderRadius.circular(30)
                              ),
                              alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: 45,
                              child: Text("Someone else",style: TextStyle(color: (selection)?Colors.black:Colors.white),),
                      ),
                          )),
                      Expanded(
                          child:InkWell(
                            onTap: (){
                              setState(() {
                                if(selection){
                                  selection=false;
                                }else{
                                  selection=true;
                                }
                              });

                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              decoration: (selection)?BoxDecoration(
                                  color: blueColor,
                                  borderRadius: BorderRadius.circular(30)
                              ):BoxDecoration(
                                  color: Colors.grey.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(30)
                              ),
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              height: 45,
                              child: Text("Myself",style: TextStyle(color: (selection)?Colors.white:Colors.black),),
                            ),
                          )),
                    ],
                  )
                ],
              ),
            ),*/
            SizedBox(
              height: 10,
            ),
            Container(
              // margin: EdgeInsets.only(left: 10, right: 10),
              height: MediaQuery.of(context).size.height / 6,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 2.0,
                      blurStyle: BlurStyle.outer),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                    ),
                    child: Text(
                      "Get an answer in 24 hours to any question you have from our expert panel of astrologers",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 10),
                    child: Text(
                      "Question charge is Rs.${currencySign} ${widget.price} per Question only",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: blueColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              // margin: EdgeInsets.only(left: 10, right: 10),
              height: MediaQuery.of(context).size.height / 3.2,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 2.0,
                      blurStyle: BlurStyle.outer),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 20),
                    child: Text(
                      "ASK YOUR QUESTION",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 10, right: 5),
                    padding: EdgeInsets.only(left: 10, right: 5),
                    height: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                            color: Colors.black.withOpacity(0.1), width: 2)),
                    child: TextFormField(
                      controller: review_controller,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: "Write here",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              // margin: EdgeInsets.only(left: 10, right: 10),
              height: MediaQuery.of(context).size.height / 4,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 2.0,
                      blurStyle: BlurStyle.outer),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  InkWell(
                    onTap: () {
                      validate();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      height: 50,
                      margin: EdgeInsets.only(left: 30, right: 30),
                      decoration: BoxDecoration(
                          color: blueColor,
                          borderRadius: BorderRadius.circular(7)),
                      child: Text(
                        "POST YOUR QUESTION",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
