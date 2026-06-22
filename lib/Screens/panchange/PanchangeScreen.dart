
import 'package:astro_gurujii/Screens/PlaceSearchScreen.dart';
import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Screens/panchange/model/AdvancedPanchang.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';



class PanchangeScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return NumerologyScreenState();
  }

}
class NumerologyScreenState extends State<PanchangeScreen>{
  bool _isLoading=true;
  var search_city="Search City";
  HttpServices _httpService = HttpServices();
  TextEditingController controller = new TextEditingController();
  AdvancedPanchang? advanced_panchang;
  Future<void> getMajorVdashaApi1(String yy,String mm,String dd,String hh,String min,String lat,String longi) async {
    setState(() {
      _isLoading=true;
    });
    var res = await _httpService.advanced_panchang(year: yy,month: mm,day: dd,hour: hh,min: min,lat: lat,lon: longi);
    if(res!.status == true){
      setState(() {
        _isLoading=false;

        advanced_panchang= res.advanced_panchang;
      });
    }else{
      _isLoading=false;
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }

  void callAli(String lat,String longi) async{
    setState(() {
      final f = new DateFormat('yyyy-MM-dd-hh-mm');
      var date= f.format(DateTime.now()).toString();
      final split = date.split('-');
      final Map<int, String> values = {
        for (int i = 0; i < split.length; i++)
          i: split[i]
      };
      getMajorVdashaApi1(values[0].toString(),values[1].toString(),values[2].toString(),values[3].toString(),values[4].toString(),lat,longi);
    });


  }

  @override
  void initState() {
    callAli("28.535517","77.391029");
    super.initState();
  }
/*
  void showPlacePicker() async {
    LocationResult result = await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PlacePicker("AIzaSyAGs0KCxeavJJXpELDFJhtUS3PL1YrStwY")));

    // Handle the result in your way
    setState(() {
      search_city=result.name;
    });
    callAli(result.latLng.latitude.toString(),result.latLng.longitude.toString());
  }

*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Panchang"),
      ),
      body: _isLoading ? Center(child:Lottie.asset('assets/profile/loader.json',)):SingleChildScrollView(child:
      Column(
        crossAxisAlignment : CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8,top: 8),
            child: CustomText(text:'What is Panchang?',color: blackColor,fontSize: 16,fontWeight: FontWeight.normal,align: TextAlign.start,),
          ),
          SizedBox(height: 5,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: whiteColor,
                border: Border.all(color: greyColor),
                borderRadius: BorderRadius.circular(6),
              ),
              child: new Container(
                alignment: Alignment.centerLeft,
                child: TextField(
                  maxLines: 7,
                  readOnly: true,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(left: 5),
                      border: InputBorder.none,
                      hintText: 'Panchang is the astrological daily calendar based on the Indian calendar. Daily panchang is one of the most popular reference manual for astrologers and people of the hindu community who rely on a days planetary position to determine auspicious timing, festivals, vrats etc...',
                      hintStyle: TextStyle(
                          color: Colors.black, fontSize: 16)),
                ),
              ),
            ),
          ),
          SizedBox(height: 15,),
          Container(
            color: card2,
            child: Column(
              crossAxisAlignment : CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8,top: 8),
                  child: CustomText(text:'Enter Location',color: blackColor,fontSize: 16,fontWeight: FontWeight.normal,align: TextAlign.start,),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 40,
                    color: whiteColor,
                    child: new Container(
                      decoration: BoxDecoration(
                        color: whiteColor,
                        border: Border.all(color: greyColor),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: InkWell(
                        onTap: (){

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PlaceSearchScreen((value) {
                                    setState(() {
                                      setFPlace(value);
                                    });
                                    return value;
                                  })
                              ));
                        },
                        child: new Container(
                          height: 40,
                          width: double.infinity,
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: CustomText(text:search_city,color: blackColor,fontSize: 14,fontWeight: FontWeight.normal,align: TextAlign.start,),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          kundaliView(),

        ],
      )
      ),
    );
  }



  Widget kundaliView() {
    return Column(
      children: [
        Container(
          color: card1,
          height:40,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CustomText(text:'Day',color: blackColor,fontSize: 14,fontWeight: FontWeight.normal,align: TextAlign.start,),
                ),
                Expanded(
                  flex: 1,
                  child: CustomText(text:'${advanced_panchang!.day}',color: blackColor,fontSize: 14,fontWeight: FontWeight.normal,align: TextAlign.start,),
                ),
              ],
            ),
          ),
        ),

        Container(
          color: card2,
          height:40,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CustomText(text:'Tithi',color: blackColor,fontSize: 14,fontWeight: FontWeight.normal,align: TextAlign.start,),
                ),
                Expanded(
                  flex: 1,
                  child: CustomText(text:'${advanced_panchang!.tithi!.details!.tithi_name}',color: blackColor,fontSize: 14,fontWeight: FontWeight.normal,align: TextAlign.start,),
                ),
              ],
            ),
          ),
        ),

        Container(
          color: card3,
          height:40,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CustomText(text:'nakshatra',color: blackColor,fontSize: 14,fontWeight: FontWeight.normal,align: TextAlign.start,),
                ),
                Expanded(
                  flex: 1,
                  child: CustomText(text:'${advanced_panchang!.nakshatra!.details!.nak_name}',color: blackColor,fontSize: 14,fontWeight: FontWeight.normal,align: TextAlign.start,),
                ),
              ],
            ),
          ),
        ),

        Container(
          color: card4,
          height:40,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CustomText(text:'yoga',color: blackColor,fontSize: 14,fontWeight: FontWeight.normal,align: TextAlign.start,),
                ),
                Expanded(
                  flex: 1,
                  child: CustomText(text:'${advanced_panchang!.yog!.details!.yog_name}',color: blackColor,fontSize: 14,fontWeight: FontWeight.normal,align: TextAlign.start,),
                ),
              ],
            ),
          ),
        ),

        Container(
          color: card5,
          height:40,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CustomText(text:'karan',color: blackColor,fontSize: 14,fontWeight: FontWeight.normal,align: TextAlign.start,),
                ),
                Expanded(
                  flex: 1,
                  child: CustomText(text:'${advanced_panchang!.karan!.details!.karan_name}',color: blackColor,fontSize: 14,fontWeight: FontWeight.normal,align: TextAlign.start,),
                ),
              ],
            ),
          ),
        ),

        Container(
          color: card6,
          height:40,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CustomText(text:'Paksha',color: blackColor,fontSize: 14,fontWeight: FontWeight.normal,align: TextAlign.start,),
                ),
                Expanded(
                  flex: 1,
                  child: CustomText(text:'${advanced_panchang!.paksha}',color: blackColor,fontSize: 14,fontWeight: FontWeight.normal,align: TextAlign.start,),
                ),
              ],
            ),
          ),
        ),

        Container(
          color: card7,
          height:40,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CustomText(text:'Ritu',color: blackColor,fontSize: 14,fontWeight: FontWeight.normal,align: TextAlign.start,),
                ),
                Expanded(
                  flex: 1,
                  child: CustomText(text:'${advanced_panchang!.ritu}',color: blackColor,fontSize: 14,fontWeight: FontWeight.normal,align: TextAlign.start,),
                ),
              ],
            ),
          ),
        ),

        Container(
          color: card8,
          height:40,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CustomText(text:'Sunrise - Sunset',color: blackColor,fontSize: 14,fontWeight: FontWeight.normal,align: TextAlign.start,),
                ),
                Expanded(
                  flex: 1,
                  child: CustomText(text:'${advanced_panchang!.sunrise} - ${advanced_panchang!.sunset}',color: blackColor,fontSize: 14,fontWeight: FontWeight.normal,align: TextAlign.start,),
                ),
              ],
            ),
          ),
        ),

        Container(
          color: card9,
          height:40,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CustomText(text:'Moonrise - Moonset',color: blackColor,fontSize: 14,fontWeight: FontWeight.normal,align: TextAlign.start,),
                ),
                Expanded(
                  flex: 1,
                  child: CustomText(text:'${advanced_panchang!.moonrise} - ${advanced_panchang!.moonset}',color: blackColor,fontSize: 14,fontWeight: FontWeight.normal,align: TextAlign.start,),
                ),
              ],
            ),
          ),
        ),
        Container(
          color: card1,
          height:40,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CustomText(text:'Ayana',color: blackColor,fontSize: 14,fontWeight: FontWeight.normal,align: TextAlign.start,),
                ),
                Expanded(
                  flex: 1,
                  child: CustomText(text:'${advanced_panchang!.ayana}',color: blackColor,fontSize: 14,fontWeight: FontWeight.normal,align: TextAlign.start,),
                ),
              ],
            ),
          ),
        ),
        Container(
          color: card2,
          height:40,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CustomText(text:'Vikram Samvat',color: blackColor,fontSize: 14,fontWeight: FontWeight.normal,align: TextAlign.start,),
                ),
                Expanded(
                  flex: 1,
                  child: CustomText(text:'${advanced_panchang!.vikram_samvat} ${advanced_panchang!.vkram_samvat_name}',color: blackColor,fontSize: 14,fontWeight: FontWeight.normal,align: TextAlign.start,),
                ),
              ],
            ),
          ),
        ),
        Container(
          color: card3,
          height:40,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CustomText(text:'Shaka Samvat',color: blackColor,fontSize: 14,fontWeight: FontWeight.normal,align: TextAlign.start,),
                ),
                Expanded(
                  flex: 1,
                  child: CustomText(text:'${advanced_panchang!.shaka_samvat} ${advanced_panchang!.shaka_samvat_name}',color: blackColor,fontSize: 14,fontWeight: FontWeight.normal,align: TextAlign.start,),
                ),
              ],
            ),
          ),
        ),


      ],
    );
  }


  void setFPlace(String value) {
    getLatidudeF(value.toString());
    setState(() {
      search_city=(value.length>40)?value.substring(0,40)+"..":value;
    });
  }
  Future<void> getLatidudeF(String address) async {
    var res = await _httpService.geocode(place: address);
    setState(() {
      callAli(res!.lat.toString(),res.lng.toString());

    });

  }
}