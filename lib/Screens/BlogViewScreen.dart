
import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Setup/app_colors.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';


import '../Setup/SetUp.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'WebServices/model/blog_list/Result.dart';
import 'package:html/parser.dart';
import 'package:translator/translator.dart';


class BlogViewScreen extends StatefulWidget{
  var title;
  var description;
  var date;
  var time;
  var id;
  var img;

  BlogViewScreen({this.img,this.id,this.title,this.description,this.date,this.time});

  @override
  State<StatefulWidget> createState() {
    return BlogViewScreenState();
  }
  
}
class BlogViewScreenState extends State<BlogViewScreen>{
  String _translatedDescription = ''; // New variable to hold translated description
  final translator = GoogleTranslator();
  bool _isEnglishToHindi = false;

  void toggleLanguage() {
    setState(() {
      _isEnglishToHindi = !_isEnglishToHindi;
      translateDescription(result[0].description.toString()); // Translate the description again when toggling language
    });
  }

  void translateDescription(String description) async {
    // Parse HTML content to extract text
    final text = parse(description).documentElement!.text;
    print("Description before translation: $text");

    // Translate the extracted text
    final response = await translator.translate(
      text,
      from: _isEnglishToHindi ? 'en' : 'hi',
      to: _isEnglishToHindi ? 'hi' : 'en',
    );

    // Print translated text
    print("Translated description: ${response.text}");

    setState(() {

      _translatedDescription=response.text;

      // Re-insert translated text into the HTML structure
      // _translatedDescription = description.replaceAllMapped(
      //   RegExp(text),
      //       (match) => response.text,
      //
      //);


    });

    print("descrpiton after=====>>>> ${_translatedDescription}");
  }

  // void translateDescription(String description) async {
  //   print("description before =====>>>>${description} ");
  //   final response = await translator.translate(
  //     // result[0].description.toString(), // Translate the original description
  //     description, // Translate the original description
  //     from: _isEnglishToHindi ? 'en' : 'hi',
  //     to: _isEnglishToHindi ? 'hi' : 'en',
  //   );
  //   print("description after===>>>> ${response.text}");
  //
  //   setState(() {
  //     _translatedDescription = response.text; // Store the translated description
  //   });
  //
  //   print("iiiiiiii===>>>> ${_translatedDescription}");
  // }


  bool search_click_status=false;
  bool _isLoading=true;
  List<Result> result=[];
  final HttpServices _httpServices=HttpServices();


  Future<void> getBlogApi() async {
    var res=await _httpServices.blog_list(id:widget.id);
    if(res!.status==true){
      setState(() {
        if(res.results!=null){
          /*astrologer.clear();*/
          result=res.results!;
          translateDescription(result[0].description.toString());

        }
        _isLoading=false;
      });
    }else{
      _isLoading=false;
      Fluttertoast.showToast(msg: "Something went wrong");

    }
  }


  @override
  void initState() {
    getBlogApi();
    super.initState();
  }
  int _toggleValue = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: primaryColor,
              expandedHeight: 200.0,
              floating: true,
              pinned: true,
              snap: false,
              flexibleSpace: FlexibleSpaceBar(

                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          Text("                       ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              )),
                          SizedBox(width: 20,),

                        ],
                      ),

                    ],
                  ),
                  background: Image.network(
                    widget.img,
                    fit: BoxFit.cover,
                  )),
            ),
          ];
        },
        body: (_isLoading)? Center(child:Lottie.asset(
          'assets/profile/loader.json',
        )):ListView(
          children: [


            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: CustomText(text: result[0].title.toString(),color: Color(0xFF000000),fontWeight: FontWeight.bold,fontSize: 18,),
                  ),
                ),

                Column(children: [
                  Container(
                    height: 20,
                    margin: const EdgeInsets.only(
                      right: 25,
                      top: 10,
                    ),
                    width: 70,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border.all(color: primaryColor),
                        // color: Colors.lightGreen,
                        borderRadius: BorderRadius.circular(5)),
                    child: InkWell(
                      onTap: (){
                        Share.share(
                          "${result[0].title} \n\n ${result[0].description}",
                        ).then((data) {
                          // print(data);
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:  [
                          Image.asset(
                            "assets/profile/share_icon.png",
                            height: 15,
                            color: primaryColor,
                          ),
                          SizedBox(width: 5,),
                          Text(
                            "Share",
                            style: TextStyle(color:primaryColor ,fontSize: 10,fontWeight: FontWeight.w500),
                          ),

                        ],
                      ),
                    ),
                  ),

                  // InkWell(
                  //     onTap: (){
                  //
                  //       toggleLanguage();
                  //
                  //     },
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: Icon(Icons.translate,size: 25,color: Colors.black,),
                  //     )),

                  // AnimatedToggle(
                  //   values: ['Hindi', 'English'],
                  //   onToggleCallback: (value) {
                  //     setState(() {
                  //       _toggleValue = value;
                  //     });
                  //   },
                  //   buttonColor: const Color(0xFF0A3157),
                  //   backgroundColor: const Color(0xFFB5C1CC),
                  //   textColor: const Color(0xFFFFFFFF),
                  // ),


                  Column(
                    children: [
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          // buttontoogle(context),
                          LanguageToggle(function: toggleLanguage),

                          SizedBox(width: 20,)
                        ],
                      ),
                    ],
                  ),



                ],)
              ],
            ),


            SizedBox( height: 15,),

            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: CustomText(text: "Category",color: Color(0xFF000000),fontWeight: FontWeight.w600,fontSize: 16,),
                ),
                SizedBox(width: 60,),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: CustomText(text: result[0].category.toString(),color: Color(0xFF000000),fontWeight: FontWeight.w600,fontSize: 16,),
                ),
              ],
            ),
            SizedBox(height: 5,),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: CustomText(text: "Author Name",color: Color(0xFF000000),fontWeight: FontWeight.w600,fontSize: 16,),
                ),
                SizedBox(width: 30,),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: CustomText(text: result[0].auther.toString(),color: Color(0xFF000000),fontWeight: FontWeight.w600,fontSize: 16,),
                ),
              ],
            ),
            SizedBox(height: 5,),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: CustomText(text: "Posted on",color: Color(0xFF000000),fontWeight: FontWeight.w600,fontSize: 16,),
                ),
                SizedBox(width: 50,),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: CustomText(text: result[0].created_date.toString(),color: Color(0xFF000000),fontWeight: FontWeight.w600,fontSize: 16,),
                ),
              ],
            ),
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              // child: Html(data: result[0].description.toString(),
               child: Text( _translatedDescription),
             // child: Html(data: _translatedDescription),
            ),
          ],
        ),
      ),
    );
  }
  String parseHtmlString(String htmlString) {
    final String d="kjfdjhd";
    final document = parse(htmlString);
    final String parsedString = parse(document.body!.text).documentElement!.text;
    return parsedString;
  }



}


class LanguageToggle extends StatefulWidget {
  final VoidCallback function;

  const LanguageToggle({Key? key, required this.function}) : super(key: key);
  @override
  _LanguageToggleState createState() => _LanguageToggleState();
}

class _LanguageToggleState extends State<LanguageToggle> {
  bool isEnglish = true; // Toggle state

  @override
  Widget build(BuildContext context) {
    return

      GestureDetector(
      onTap: () {
        setState(() {
          isEnglish = !isEnglish;
        });
        widget.function();


        print("hhello");

      },
      child: Container(
        width: 100,
        height: 30,
        // margin: EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.black26,
        ),
        child: Stack(
          children: <Widget>[
            AnimatedPositioned(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              left: isEnglish ? 0 : 40, // Position of the highlight
              right: isEnglish ? 40 : 0,
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text('EN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 10),
                child: Text('HI', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}