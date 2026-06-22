
import 'package:astro_gurujii/Screens/BlogViewScreen.dart';
import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:html/parser.dart';
import 'WebServices/model/blog_list/Result.dart';
class BlogScreenList extends StatefulWidget{
  final id;
  BlogScreenList({this.id});
  @override
  State<StatefulWidget> createState() {
    return BlogScreenListState();
  }
}
class BlogScreenListState extends State<BlogScreenList>{
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:PreferredSize(
          preferredSize:  Size.fromHeight(search_click_status?190.0:70.0),
          child: Card(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
            ),
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                const SizedBox(height: 30,),
                Row(
                  children: [
                    IconButton(onPressed: (){
                      Navigator.of(context).pop();
                    }, icon: Icon(Icons.arrow_back_ios,color: blackColor,)),
                    CustomText(text: "Astrology Blog",fontSize: 16,fontWeight: FontWeight.w600,color: blackColor,),

                  ],
                ),

              ],
            ),
          )
      ),

      body: Container(
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/background_image.png"),fit: BoxFit.cover)),
        child: (_isLoading)? Center(child:Lottie.asset(
          'assets/profile/loader.json',
        )):ListView.builder(
            itemCount: result.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context,index){
              return Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                child: InkWell(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => BlogViewScreen(img:result[index].img.toString(),id: result[index].id.toString(),)));
                  },
                  child: Container(
                    width: double.infinity,
                    height: 255,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 10,right: 10),
                          alignment: Alignment.topRight,
                          width: double.infinity,
                          height: 150,
                          decoration:  BoxDecoration(
                              color: const Color(0xff000000),
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  colorFilter:
                                  ColorFilter.mode(Colors.black.withOpacity(0.6),
                                      BlendMode.dstATop),
                                  image: CachedNetworkImageProvider(result[index].img.toString())
                              )
                          ),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                               /* Image.asset('assets/images/icons_eye.png',width: 25,height: 25,color: whiteColor,),
                                CustomText(text: result[index].view_count.toString(),color: whiteColor,fontWeight: FontWeight.w600,fontSize: 11,)
*/
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0,top: 12),
                              child: CustomText(text: result[index].title.toString().length> 20 ?result[index].title.toString().substring(0, 20)+'...' : result[index].title.toString(),color: blackColor,fontWeight: FontWeight.bold,fontSize: 14,),
                            ),
                            // CustomText(text: DateFormat('dd MMM,y').format(DateTime.parse(widget.data[index].createdDate.toString())),color: Color(0xFF626262),fontWeight: FontWeight.w400,fontSize: 11,),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: CustomText(text: "24,March,2021",color: blackColor,fontWeight: FontWeight.w400,fontSize: 14,),
                            ),
                          ],
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                            Container(
                                height: 60,
                                width: MediaQuery.of(context).size.width,
                                child: CustomText(text: parseHtmlString(result[index].description.toString(),),color:Color(0xFF626262) ,fontSize: 14,fontWeight: FontWeight.w600,maxLines: 3,align: TextAlign.start,))),

                      ],
                    ),
                  ),
                ),
              );
            }),
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