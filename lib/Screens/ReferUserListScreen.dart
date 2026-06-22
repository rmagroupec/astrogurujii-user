
import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

import 'WebServices/model/refer_user_list/Result.dart';

class ReferUserListScreen extends StatefulWidget {
  const ReferUserListScreen({Key? key}) : super(key: key);



  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<ReferUserListScreen> {
  String userId1="";
  List details=[];
  bool _isLoading=true;
  HttpServices _httpService = HttpServices();
  bool is_loading=true;

  List<Result> notifications=[];

  Future<void> getDataApi() async {
    setState(() {
      _isLoading=true;
    });

    var res = await _httpService.refer_user_list();
    if(res!.status == true){
      setState(() {
        if(res.results!=null){
          notifications= res.results!;
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
    getDataApi();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:PreferredSize(
          preferredSize:  Size.fromHeight(70.0),
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
                    CustomText(text: "Invited Friends",fontSize: 16,fontWeight: FontWeight.w600,color: blackColor,),
                    const Spacer(),

                  ],
                ),

              ],
            ),
          )
      ),

      body: Container(

          child: _isLoading?Center(child:Lottie.asset(
            'assets/profile/loader.json',
          ))
              :ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (BuildContext ctx, index) {
              // Display the list item
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 45,
                    backgroundImage: CachedNetworkImageProvider(notifications[index].profile_img!),
                  ) ,
                  title: Padding(
                    padding: const EdgeInsets.only(top: 8.0,bottom: 8),
                    child: Text(notifications[index].name!),
                  ),
                  subtitle: Column(
                    children: [
                      Row(
                        children: [
                          Text("${notifications[index].name.toString()}"),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0,bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(notifications[index].Created_date??'',style: TextStyle(color: blackColor)),
                          ],
                        ),
                      ),
                    ],
                  ),

                ),
              );
            },
          )
      ),
    );
  }

}
