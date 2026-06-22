
import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Screens/mall/OrderDetailsScreen.dart';
import 'package:astro_gurujii/Screens/mall/ShoppingMall.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/order_list/Result.dart';
import 'order_details_model.dart';

class MyOrderListSideScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return CartListScreenState();
  }

}
class CartListScreenState extends State<MyOrderListSideScreen>{
  HttpServices _httpService = HttpServices();
  bool _isLoading = true;
  // List<Result> _cart=[];
  List<OrdersResults> _cart=[];
   OrderDetailsModelN?  orderDetailsModelN;


  //https://bhavishyaguru.org/api/api/order_list
  Future<void> productsDetailsApi() async {
    final prefs = await SharedPreferences.getInstance();
    var res = await _httpService.order_list(order_id: '');

    if(res!.status == true){
      setState(() {
        orderDetailsModelN=res;

        _isLoading = false;
        _cart= res.results!;


      });
    }else{
      Fluttertoast.showToast(msg: "Something went wrong");
      _isLoading = false;
    }
  }

  @override
  void initState() {
    super.initState();
    productsDetailsApi();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        backgroundColor: blueColor,
        title: Text(
          "My Orders",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: (_isLoading)?Center(child: CircularProgressIndicator(),):(_cart.length==0)?
      Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              SizedBox(height: 16.0),

              Text(
                "You haven't placed any order yet!",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 30.0),
              Text(
                "Order section is empty. After placing order. You can track them from here!",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.normal
                ),
              ),
              SizedBox(height: 24.0),
              InkWell(
                onTap: () {

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => ShoppingMall()));

                },
                child: Container(
                  padding: EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                      left: 20,
                      right: 20
                  ),
                  child: Text("Shopping Now",style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: blueColor
                  ),
                ),
              ),
            ],
          ),
        ),
      ):Container(
        margin: EdgeInsets.all(5),
        child: ListView(
          children: [
            Column(
              children: List.generate(_cart.length, (i) {
                return InkWell(
                  onTap: (){

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetailsScreen(
                             orders: _cart,
                            order_items: _cart[i].orderItems ,
                            orderID: _cart[i].id.toString(),
                              pos:i
                          ),
                        )).then((res){
                      productsDetailsApi();
                    });

                  },
                  child: Card(
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            child:Align(
                              alignment : Alignment.centerLeft,
                              child: orderStatus(i),
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.all(5),
                                height:100,
                                width: 100,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image(image:CachedNetworkImageProvider(_cart[i].image),fit: BoxFit.fill,)),
                              ),
                              Expanded(
                                flex:1,
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text(
                                          ""+_cart[i].productName,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color:Colors.black,
                                          ),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(child: Icon(Icons.arrow_forward_ios,color: Colors.grey,)),
                              SizedBox(width: 10,),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),

          ],
        ),
      ),
    );
  }

  Widget orderStatus(int i) {
    return Column(
      children: [
        Align(
          alignment : Alignment.topLeft,
          child: Row(
            children: [
              SizedBox(width: 10,),
              Icon(
                Icons.circle,
                color: color(i),
                size: 10.0,
              ),
              SizedBox(width: 10,),
              Text(
                status(i),
                style: TextStyle(
                  fontSize: 16,
                  color:color(i),
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Align(
          alignment : Alignment.topLeft,
          child: Row(
            children: [
              SizedBox(width: 10,),
              Text(
                datestatus(i),
                style: TextStyle(
                  fontSize: 16,
                  color:Colors.black,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String status(int i) {
    if(_cart[i].status=='PLACED'.toUpperCase()){
      return "Your order has been placed";
    }else if(_cart[i].status=='processing'.toUpperCase()){
      return "Confirm order";
    }else if(_cart[i].status=='packed'.toUpperCase()){
      return "Order has been packed & Ready for Dispatch";
    }else if(_cart[i].status=='on_delivery'.toUpperCase()){
      return "Your order is on the way";
    }else if(_cart[i].status=='out_for_delivery'.toUpperCase()){
      return "Arriving Today";
    }else if(_cart[i].status=='completed'.toUpperCase()){
      return "Your order has been Delivered";
    }else if(_cart[i].status=='declined'.toUpperCase()){
      return "Rejected";
    }else if(_cart[i].status=='CANCEL'.toUpperCase()){
      return "Cancelled";
    }else if(_cart[i].status=='return_requested'.toUpperCase()){
      return "Return requested";
    }else if(_cart[i].status=='return_confirm'.toUpperCase()){
      return "Return confirmed";
    }else if(_cart[i].status=='return_completed'.toUpperCase()){
      return "Return Completed";
    }else{
      return '';
    }


  }

  String datestatus(int i) {
    if(_cart[i].status=='PLACED'){
      return 'Delivery expected by '+_cart[i].deliveryDate;
    }else if(_cart[i].status=='processing'.toUpperCase()){
      return 'Delivery expected by '+_cart[i].deliveryDate;
    }else if(_cart[i].status=='packed'.toUpperCase()){
      return 'Delivery expected by '+_cart[i].deliveryDate;
    }else if(_cart[i].status=='on_delivery'.toUpperCase()){
      return 'Delivery expected by '+_cart[i].deliveryDate;
    }else if(_cart[i].status=='out_for_delivery'.toUpperCase()){
      return '';
    }else if(_cart[i].status=='completed'.toUpperCase()){
      return 'Delivered at '+_cart[i].deliveryDate;
    }else if(_cart[i].status=='declined'.toUpperCase()){
      return 'Cancelled at '+_cart[i].deliveryDate;
    }else if(_cart[i].status=='CANCEL'.toUpperCase()){
      return 'Cancelled at '+_cart[i].deliveryDate;
    }else if(_cart[i].status=='return_requested'.toUpperCase()){
      return 'Pickup expected by '+_cart[i].deliveryDate;
    }else if(_cart[i].status=='return_confirm'.toUpperCase()){
      return 'Pickup expected by '+_cart[i].deliveryDate;
    }else if(_cart[i].status=='return_completed'.toUpperCase()){
      return 'Pickup Completed at '+_cart[i].deliveryDate;
    }else{
      return '';
    }

  }

  color(int i) {
    if(_cart[i].status=='PLACED'){
      return Colors.green;
    }else if(_cart[i].status=='processing'.toUpperCase()){
      return Colors.green;
    }else if(_cart[i].status=='packed'.toUpperCase()){
      return Colors.green;
    }else if(_cart[i].status=='on_delivery'.toUpperCase()){
      return Colors.green;
    }else if(_cart[i].status=='out_for_delivery'.toUpperCase()){
      return Colors.green;
    }else if(_cart[i].status=='completed'.toUpperCase()){
      return Colors.green;
    }else if(_cart[i].status=='declined'.toUpperCase()){
      return Colors.red;
    }else if(_cart[i].status=='CANCEL'.toUpperCase()){
      return Colors.red;
    }else if(_cart[i].status=='return_requested'.toUpperCase()){
      return Colors.red;
    }else if(_cart[i].status=='return_confirm'.toUpperCase()){
      return Colors.red;
    }else if(_cart[i].status=='return_completed'.toUpperCase()){
      return Colors.red;
    }else{
      return Colors.green;
    }
  }


}



