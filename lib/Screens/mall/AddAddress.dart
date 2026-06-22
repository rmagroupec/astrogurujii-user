
import 'package:astro_gurujii/Screens/Login.dart';
import 'package:astro_gurujii/Screens/mall/NewAddress.dart';
import 'package:astro_gurujii/Screens/mall/PlaceOrder.dart';
import 'package:astro_gurujii/Screens/mall/model/user_address/Address.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:astro_gurujii/Setup/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../WebServices/HttpServices.dart';

class AddAddress extends StatefulWidget {
  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  List<Widget> addressHolder = [ ];
  String userId1 = '';
  bool _isLoading = true;
  String SelectedAddress="";
  String address_id="";
  HttpServices _httpService = HttpServices();
  List<Address> address_list=[];

  Future<void> getAddress() async {
    var res = await _httpService.user_address(key: "list");
    if(res!.result==true){
      setState(() {
        _isLoading=false;
        address_list=res.address_list!;
      });
    }else{
      setState(() {
        _isLoading=false;
      });
    }
  }

  @override
  void initState() {
    getUser();
    getAddress();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: blueColor,
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          title: Text('Select Address',style: TextStyle(color: whiteColor),),
          actions: [
            IconButton(
                icon: Icon(Icons.add,color: whiteColor),
                onPressed: () {
                  if(userStaus=="Y"){
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>LoginPage()), (route) => false);
                  }else{
                    Navigator.push(context,
                        MaterialPageRoute(builder: (ctx) => NewAddress()));
                  }
                }),
          ],
        ),
        body: _isLoading
            ? Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        )
            : SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: address_list.length,
                    itemBuilder: (BuildContext context, int i) {
                      return Container(
                        child: Card(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5 ),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.grey[100],
                                  border: Border.all(
                                    color: AppColors.mBGColor,
                                  )),
                              margin: EdgeInsets.only(top: 20),
                              child: InkWell(
                                onTap: () {
                                  for(int i=0;i<address_list.length;i++){
                                    setState(() {
                                      address_list[i].is_default="Y";
                                    });
                                  }
                                  setState(() {
                                    address_list[i].is_default="N";
                                    SelectedAddress=address_list[i].address_type!+"\n"+
                                        address_list[i].contact_person_name!+"\n"+
                                        address_list[i].contact_person_mobile!+"\n"+
                                        address_list[i].building_name!+","+address_list[i].flat_no!+","+address_list[i].location!+"\n"+
                                        address_list[i].landmark!+"\n"+
                                        address_list[i].pincode.toString();
                                    address_id=address_list[i].id.toString();

                                  });

                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width/1.5,
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(address_list[i].address_type!),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(address_list[i].contact_person_name!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                                          Text(address_list[i].contact_person_mobile!),
                                          Text('${address_list[i].building_name!+","+address_list[i].flat_no!+","+address_list[i].location!}'),
                                          Text(address_list[i].landmark!),
                                          Text(address_list[i].pincode.toString()),
                                        ],
                                      ),
                                    ),
                                    // Spacer(),

                                    Icon(
                                      (address_list[i].is_default=="N")?Icons.radio_button_checked:Icons.radio_button_unchecked,
                                      color: Colors.pink,
                                    ),
                                    /* Icon(
                                        Icons.radio_button_unchecked,
                                        color: Colors.pink,
                                      )*/
                                  ],
                                ),
                              ),
                            )),
                      );
                    }),
              ),
              InkWell(
                onTap: () async {

                  if(address_list.length==0){
                        if(userStaus=="Y"){
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>LoginPage()), (route) => false);
                        }else {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (ctx) => NewAddress()));
                        }
                  }else if(SelectedAddress.isEmpty){
                    Fluttertoast.showToast(msg: "Please choose our delivery address");
                  }else{
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                PlaceOrder(address_id:address_id,selected_address: SelectedAddress,)));

                  }
                  //  addAddress();
                },
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(
                      top: 20, bottom: 10, left: 20, right: 20),
                  padding:
                  EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: _isLoading == true
                      ? Container(
                      height: 30,
                      width: 20,
                      child: CircularProgressIndicator())
                      : Text(
                    "Continue",
                    style: TextStyle(
                        color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  decoration: BoxDecoration(
                    color: blueColor,
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
            ],
          ),
        ),
      ),
    );
  }

  var userStaus="";
  Future<void> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userStaus=prefs.get("is_skip").toString();
    });

  }
}
