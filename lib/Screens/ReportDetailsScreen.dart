
import 'package:astro_gurujii/Screens/ImageViewerScreen.dart';
import 'package:astro_gurujii/Screens/PdfScreen.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:flutter/material.dart';

class ReportDetailsScreen extends StatefulWidget{
  final String image;
  final String report;
  final String title;
  final String question;
  ReportDetailsScreen({required this.question,required this.report,required this.title,required this.image});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ReportDetailsScreenState();
  }

}
class ReportDetailsScreenState extends State<ReportDetailsScreen>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

        appBar: AppBar(
          leading: IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.arrow_back_ios_new,color: Colors.black,)),
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(widget.title,style: TextStyle(fontSize: 18,color: Colors.black),),
          /*actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.menu,color: Colors.black,))
        ],*/
        ),
        body: SingleChildScrollView(child:
        Column(
          children: [
            Align(
              alignment : Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.question??'',
                  style: TextStyle(fontSize: 15,color: Colors.black),
                ),
              ),
            ),

            Align(
              alignment : Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.report,
                  style: TextStyle(fontSize: 15,color: Colors.blueGrey),
                ),
              ),
            ),

            widget.image.isNotEmpty?Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: (){
                      String fileExtension = widget.image.substring(widget.image.lastIndexOf(".") + 1);
                      if(fileExtension=="pdf"){
                        Navigator.push(context, MaterialPageRoute(builder: (_)=>PdfScreen(url: widget.image,)));
                      }else{
                        Navigator.push(context, MaterialPageRoute(builder: (_)=>ImageViewerScreen(url: widget.image,)));
                      }

                      // Print the file extension
                      print("File extension: " + fileExtension);

                    },
                    child: Container(
                      width: 150,
                      height: 40,
                      child: Center(
                        child: Text(
                          "View File",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
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
                ),
              ],
            ):Container(),

          ],
        ),)

    );
  }

}