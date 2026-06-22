
import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:flutter/material.dart';

import 'WebServices/model/google_map/Prediction.dart';
typedef StringValue = String Function(String);
class PlaceSearchScreen extends StatefulWidget{
  StringValue callback;
  PlaceSearchScreen(this.callback);

  @override
  State<StatefulWidget> createState() {
    return PlaceSearchScreenState();
  }
  
}
class PlaceSearchScreenState extends State<PlaceSearchScreen>{
  TextEditingController controller = new TextEditingController();
  HttpServices _httpService = HttpServices();

  onSearchTextChanged(String text) async {
    if (text.isEmpty) {
      getMapApi("");
      return;
    }else{
      getMapApi(text);
    }
  }
  List<Prediction> predictions=[];
  Future<void> getMapApi(String address) async {
    var res = await _httpService.googleMap(address: address);
    setState(() {
      predictions=res!.predictions!;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: CustomText(text: 'Select Location',color: blackColor,fontWeight: FontWeight.bold,fontSize: 15,),
        backgroundColor: whiteColor,
        elevation: 0.0,
        leading:  IconButton(onPressed: (){
          Navigator.of(context).pop();
        }, icon: Icon(Icons.arrow_back_ios,color: blackColor,)),
        actions: [

        ],
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Container(
                decoration: BoxDecoration(
                  color: whiteColor,
                  border: Border.all(color: greyColor),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: new Container(
                  alignment: Alignment.centerLeft,
                  child: new ListTile(
                    leading: new Icon(Icons.search),
                    title: new TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(left: 5),
                          border: InputBorder.none,
                          hintText: 'Search City',
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 16
                          )
                      ),
                      onChanged: onSearchTextChanged,
                    ),
                    trailing: new IconButton(icon: new Icon(Icons.cancel), onPressed: () {
                      controller.clear();
                      onSearchTextChanged('');
                    },),
                  ),
                ),
              ),
            ), // search
            Expanded(
              flex: 2,
              child: ListView.builder(
                  itemCount: predictions.length,
                  itemBuilder: (BuildContext context,int index){
                    return Container(

                      margin: EdgeInsets.only(right: 5, left: 5, top: 10),
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: InkWell(
                        onTap: () {
                          widget.callback(predictions[index].description.toString());
                          Navigator.pop(context);
                        },
                        child: Container(
                          child: Row(
                            mainAxisAlignment : MainAxisAlignment.start,
                            crossAxisAlignment : CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex:1,
                                child: Container(
                                  child: Icon(Icons.location_on,
                                    color: greyColor12,),
                                ),
                              ),
                              Expanded(
                                flex:17,
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: 25),
                                      child: Align(
                                        alignment : Alignment.centerLeft,
                                        child: Text(predictions[index].description,textAlign: TextAlign.left, style: TextStyle(

                                            fontWeight: FontWeight.normal,
                                            fontSize: 13),),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 23),
                                      child: Divider(color: Colors.grey,thickness: 1,),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    );
                  })),


          ],
        ),
      ),
    );
  }
  
}