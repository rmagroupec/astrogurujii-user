
import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

import 'WebServices/model/notification/Result.dart';

class NotificationScreen extends StatefulWidget {
  static const String notification = "NotificationScreen";

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
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

    var res = await _httpService.notifications_list(id: "");
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

  Future<void> callAliForDelete(String id) async {
    var res = await _httpService.notifications_drop(id: id);
    if(res!.status ==true){
    }else{
      Fluttertoast.showToast(msg: "Something went wrong");

    }
  }

  Future<void> callAliForDeleteAll(String id) async {
    var res = await _httpService.notifications_drop(id: id);
    if(res!.status == true){
      setState(() {
        notifications.clear();
      });
    }else{
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
                    CustomText(text: "Notifications",fontSize: 16,fontWeight: FontWeight.w600,color: blackColor,),
                    const Spacer(),

                    InkWell(
                        onTap: (){
                          setState(() {
                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Do you want to delete all notifications'),
                                      SizedBox(height: 20,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [

                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                             
                                            ),

                                            onPressed: ()
                                            {
                                              Navigator.pop(context);
                                            },
                                            child: Text("Cancel"),
                                          ),
                                          SizedBox(width: 10,),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                         
                                            ),

                                            onPressed: ()
                                            {
                                              Navigator.pop(context);
                                              callAliForDeleteAll("");

                                            },
                                            child: Text("Ok"),
                                          ),



                                        ],
                                      )

                                    ],
                                  ),
                                )
                            );
                          });
                        },
                        child: Icon(Icons.delete,color: blueColor,)),
                    const SizedBox(width: 10,),
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
            return Dismissible(
              key: UniqueKey(),

              // only allows the user swipe from right to left
              direction: DismissDirection.endToStart,

              // Remove this product from the list
              // In production enviroment, you may want to send some request to delete it on server side
              onDismissed: (_) {
                setState(() {
                  callAliForDelete(notifications[index].id.toString());
                  notifications.removeAt(index);
                });
              },

              // Display item's title, price...
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(top: 8.0,bottom: 8),
                    child: Text(notifications[index].title!),
                  ),
                  subtitle: Column(
                    children: [
                      Row(
                        children: [
                          Text("${notifications[index].text.toString()}"),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0,bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(notifications[index].created_date??'',style: TextStyle(color: blackColor)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  trailing: Padding(
                    padding: const EdgeInsets.only(top: 18),
                    child: const Icon(Icons.arrow_back),
                  ),
                ),
              ),

              // This will show up when the user performs dismissal action
              // It is a red background and a trash icon
              background: Container(
                color: Colors.red,
                margin: const EdgeInsets.symmetric(horizontal: 15),
                alignment: Alignment.centerRight,
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            );
          },
        )
      ),
    );
  }

}
