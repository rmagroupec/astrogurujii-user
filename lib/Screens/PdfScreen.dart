
import 'package:flutter/material.dart';

class PdfScreen extends StatefulWidget{
  final url;
  PdfScreen({this.url});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PdfScreenState();
  }
  
}
class PdfScreenState extends State<PdfScreen>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar:  AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_new,color: Colors.black,)),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text("Report",style: TextStyle(fontSize: 18,color: Colors.black),),
        /*actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.menu,color: Colors.black,))
        ],*/
      ),
      body: Container()
    );


  }
  
}