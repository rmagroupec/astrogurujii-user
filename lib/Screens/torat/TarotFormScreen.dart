
import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Screens/torat/ToratSeondScreen.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';


class TarotFormScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return TarotFormScreenState();
  }
  
}
class TarotFormScreenState extends State<TarotFormScreen>{
  final TextEditingController _anyComment = TextEditingController();
  HttpServices _httpService = HttpServices();
  bool? isLoading;


  callWebService()
  async {
    setState(() {
      isLoading = true;
    });

    var res = await _httpService.tarot(question: _anyComment.text.toString().trim());
    if(res!.status == true)
    {
      cardList.clear();
     await generateCard();
      isLoading = false;
      await Navigator.push(context, PageTransition(
          duration: Duration(seconds: 1),
          type: PageTransitionType.rightToLeft, child: ToratSeondScreen(card_list:cardList,data: res.results,question:_anyComment.text.toString())));


    }else{
        setState(() {
          isLoading = false;
        });
      }
  }

  List<CardCount> cardList=[];
  @override
  void initState() {
    generateCard();
    super.initState();

  }

  generateCard(){
    for(int i=0;i<51;i++){
      setState(() {
        cardList.add(CardCount(status: "N"));
      });
    }
  }

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
          child: Column(
            children: [


              Container(
                margin: EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    Container(
                        margin: EdgeInsets.only(top: 10,left: 10),
                        child: Row(
                          children: [
                            Text(
                              "Please enter your question below",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                          ],
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 10,left: 10),
                        child: Row(
                          children: [
                           /* Text(
                              "Simply think a Question",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w700),
                            ),*/
                          ],
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        controller: _anyComment,
                        keyboardType: TextInputType.multiline,
                        maxLines: 10,
                        decoration: InputDecoration(
                            hintText: "Type Your Question Here",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),

                    InkWell(
                      onTap: () async {
                        if (_anyComment.text.toString().trim().isNotEmpty) {
                          callWebService();
                          //await Navigator.push(context, MaterialPageRoute(builder: (ctx) => OtpScreen(mobileNumber: mobileNumber.text)));
                        }
                      },
                      child: AnimatedContainer(
                        margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 10),
                        alignment: Alignment.center,
                        duration: Duration(seconds: 1),
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child:  isLoading == true ?
                        Container(height: 20,width:20,child:
                        CircularProgressIndicator(backgroundColor: Colors.white,)):
                        Text(
                          "Proceed",
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
                    ),

                  ],
                ),
              ),
            ],
          ),
        )
      ),
    );

  }

}

class CardCount{
  var status;
  CardCount({this.status});
}