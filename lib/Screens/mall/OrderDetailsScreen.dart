
import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Screens/mall/model/order_list/OrderItem.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../Setup/app_colors.dart';
import 'order_details_model.dart';

class OrderDetailsScreen extends StatefulWidget {
  final List<OrdersResults>? orders;
  final List<OrderItemsN>? order_items;
  String? orderID;
  int? pos;

  OrderDetailsScreen({
    Key? key,
    required this.orderID,
    this.pos,
    this.orders,
    this.order_items,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CartListScreenState();
  }
}

class CartListScreenState extends State<OrderDetailsScreen> {
  HttpServices _httpService = HttpServices();
  bool _isLoading = true;

  // List<OrderItem> order_items=[];
  // List<OrderItemsN> order_items=[];
  String button_text = "Cancel";

  // var order;
  OrderDetailsModelN? orderDetailsModelN;

  Future<void> productsDetailsApi() async {
    var res = await _httpService.order_list(order_id: widget.orderID!);
    if (res!.status == true) {
      setState(() {
        // orderDetailsModelN=res;
        _isLoading = false;
        // order= res.results[widget.pos];

        //  print("Orders===>>> $order");
        // order_items= res.results[widget.pos].orderItems;
        // print("order_items===>>> $order_items");
      });
    } else {
      Fluttertoast.showToast(msg: "Something went wrong");
      _isLoading = false;
    }
  }

  Future<void> callCancleApi() async {
    var res = await _httpService.cancel_order(order_id: widget.orderID!);
    if (res['status'] == true) {
      Fluttertoast.showToast(msg: res['message'].toString());

      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(msg: res['message'].toString());
    }
  }

  @override
  void initState() {
    print("orderID====>>> ${widget.orderID}");
    print("pos====>>> ${widget.pos}");
    super.initState();
    productsDetailsApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: blueColor,
          title: Text(
            "Order Details",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: (_isLoading)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            // "Order ID- "+order.id.toString(),
                            "Order ID- " + widget.orderID.toString(),
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.green,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: widget.order_items!.length,
                        itemBuilder: (ctx, i) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 1.0), //(x,y)
                                  blurRadius: 4.0,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                "" +
                                                        widget.order_items![i]
                                                            .productName ??
                                                    '',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                ),
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                "₹" +
                                                        widget.order_items![i]
                                                            .price ??
                                                    '',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                ),
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),

                                          /* Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: orderStatus(),
                                  )*/
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          margin: EdgeInsets.all(5),
                                          height: 70,
                                          width: 70,
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: Image(
                                                image:
                                                    CachedNetworkImageProvider(
                                                        widget.order_items![i]
                                                            .image),
                                                fit: BoxFit.fill,
                                              )),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: orderStatus(),
                    ),
                    Card(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Total Order Price",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                          ),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          "₹" +
                                                  widget.orders![widget.pos!]
                                                      .orderAmount
                                                      .toString() ??
                                              '',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                          ),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Payment Mode:",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                          ),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          "" +
                                                  widget.orders![widget.pos!]
                                                      .paymentMethod ??
                                              '',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                          ),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Delivery Address",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "" + widget.orders![widget.pos!].contactName ??
                                    '' +
                                        " | " "" +
                                        widget.orders![widget.pos!].phone ??
                                    '',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Mobile Number " +
                                        widget.orders![widget.pos!].phone ??
                                    '',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "" + widget.orders![widget.pos!].address ?? '',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Pin Code " +
                                        widget.orders![widget.pos!].pincode
                                            .toString() ??
                                    '',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    (button_text != "Cancel")
                        ? Container()
                        : Align(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 30.0,
                                ),
                                Center(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: InkWell(
                                      onTap: () {
                                        showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Cancel Order'),
                          content: Text(
                              'Are you sure you want to cancel your order ?'),
                          actionsAlignment: MainAxisAlignment.spaceEvenly,
                          actions: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context, false);
                              },
                              child: Container(
                                margin: EdgeInsets.all(10),
                                height: 45,
                                width: 100,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColors.orangeColor, width: 2),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Text(
                                    'Cancel',
                                    style:
                                        TextStyle(color: AppColors.orangeColor),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                callCancleApi();
                                //Navigator.pop(context, false);
                              },
                              child: Container(
                                margin: EdgeInsets.all(10),
                                height: 45,
                                width: 100,
                                decoration: BoxDecoration(
                                    color: AppColors.orangeColor,
                                    // border: Border.all(color: appTheme, width: 2),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Text(
                                    'Yes',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            // TextButton(
                            //   onPressed: () {
                            //     SystemNavigator.pop();
                            //     //  Navigator.pop(context, true);
                            //   },
                            //   child: const Text(''),
                            // ),
                          ],
                        );
                      },
                    );

                                      },
                                      child: Container(
                                        width: 200,
                                        decoration: BoxDecoration(
                                            gradient: loginButtonGradient(),
                                            borderRadius:
                                                BorderRadius.circular(30.0)),
                                        constraints: BoxConstraints(
                                            maxWidth: 300.0, minHeight: 50.0),
                                        alignment: Alignment.center,
                                        child: Text(
                                          button_text,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 30.0,
                                ),
                              ],
                            ),
                          ),
                    SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              ));
  }

  loginButtonGradient() {
    return LinearGradient(
      colors: [
        Color(hexStringToHexInt("#143250")),
        Color(hexStringToHexInt("#143250")),
      ],
    );
  }

  Widget orderStatus() {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.circle,
                color: color(),
                size: 10.0,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                status(),
                style: TextStyle(
                  fontSize: 16,
                  color: color(),
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              datestatus(),
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  String status() {
    if (widget.orders![widget.pos!].status == 'PLACED') {
      setState(() {
        button_text = "Cancel";
      });
      return "Your order has been placed";
    } else if (widget.orders![widget.pos!].status == 'processing'.toUpperCase()) {
      setState(() {
        button_text = "Cancel";
      });
      return "Confirm order";
    } else if (widget.orders![widget.pos!].status == 'packed'.toUpperCase()) {
      setState(() {
        button_text = "Cancel";
      });
      return "Order has been packed & Ready for Dispatch";
    } else if (widget.orders![widget.pos!].status ==
        'on_delivery'.toUpperCase()) {
      setState(() {
        button_text = "Cancel";
      });
      return "Your order is on the way";
    } else if (widget.orders![widget.pos!].status ==
        'out_for_delivery'.toUpperCase()) {
      setState(() {
        button_text = "Return";
      });
      return "Arriving Today";
    } else if (widget.orders![widget.pos!].status == 'completed'.toUpperCase()) {
      setState(() {
        button_text = "Return";
      });
      return "Your order has been Delivered";
    } else if (widget.orders![widget.pos!].status == 'declined'.toUpperCase()) {
      return "Rejected";
    } else if (widget.orders![widget.pos!].status == 'CANCEL'.toUpperCase()) {
      setState(() {
        button_text = "not";
      });
      return "Cancelled";
    } else if (widget.orders![widget.pos!].status ==
        'return_requested'.toUpperCase()) {
      setState(() {
        button_text = "not";
      });
      return "Return requested";
    } else if (widget.orders![widget.pos!].status ==
        'return_confirm'.toUpperCase()) {
      setState(() {
        button_text = "not";
      });
      return "Return confirmed";
    } else if (widget.orders![widget.pos!].status ==
        'return_completed'.toUpperCase()) {
      setState(() {
        button_text = "not";
      });
      return "Return Completed";
    } else {
      return '';
    }
  }

  String datestatus() {
    if (widget.orders![widget.pos!].status == 'PLACED') {
      return 'Delivery expected by ' + widget.orders![widget.pos!].deliveryDate;
    } else if (widget.orders![widget.pos!].status == 'processing'.toUpperCase()) {
      return 'Delivery expected by ' + widget.orders![widget.pos!].deliveryDate;
    } else if (widget.orders![widget.pos!].status == 'packed'.toUpperCase()) {
      return 'Delivery expected by ' + widget.orders![widget.pos!].deliveryDate;
    } else if (widget.orders![widget.pos!].status ==
        'on delivery'.toUpperCase()) {
      return 'Delivery expected by ' + widget.orders![widget.pos!].deliveryDate;
    } else if (widget.orders![widget.pos!].status ==
        'out_for_delivery'.toUpperCase()) {
      return '';
    } else if (widget.orders![widget.pos!].status == 'completed'.toUpperCase()) {
      return 'Delivered at ' + widget.orders![widget.pos!].deliveryDate;
    } else if (widget.orders![widget.pos!].status == 'declined'.toUpperCase()) {
      return 'Cancelled at ' + widget.orders![widget.pos!].deliveryDate;
    } else if (widget.orders![widget.pos!].status == 'CANCEL'.toUpperCase()) {
      return 'Cancelled at ' + widget.orders![widget.pos!].deliveryDate;
    } else if (widget.orders![widget.pos!].status ==
        'return_requested'.toUpperCase()) {
      return 'Pickup expected by ' + widget.orders![widget.pos!].deliveryDate;
    } else if (widget.orders![widget.pos!].status ==
        'return_confirm'.toUpperCase()) {
      return 'Pickup expected by ' + widget.orders![widget.pos!].deliveryDate;
    } else if (widget.orders![widget.pos!].status ==
        'return_completed'.toUpperCase()) {
      return 'Pickup Completed at ' + widget.orders![widget.pos!].deliveryDate;
    } else {
      return '';
    }
  }

  color() {
    if (widget.orders![widget.pos!].status == 'PLACED') {
      return Colors.green;
    } else if (widget.orders![widget.pos!].status == 'processing'.toUpperCase()) {
      return Colors.green;
    } else if (widget.orders![widget.pos!].status == 'packed'.toUpperCase()) {
      return Colors.green;
    } else if (widget.orders![widget.pos!].status ==
        'on_delivery'.toUpperCase()) {
      return Colors.green;
    } else if (widget.orders![widget.pos!].status ==
        'out_for_delivery'.toUpperCase()) {
      return Colors.green;
    } else if (widget.orders![widget.pos!].status == 'completed'.toUpperCase()) {
      return Colors.green;
    } else if (widget.orders![widget.pos!].status == 'declined'.toUpperCase()) {
      return Colors.red;
    } else if (widget.orders![widget.pos!].status == 'CANCEL'.toUpperCase()) {
      return Colors.red;
    } else if (widget.orders![widget.pos!].status ==
        'return_requested'.toUpperCase()) {
      return Colors.red;
    } else if (widget.orders![widget.pos!].status ==
        'return_confirm'.toUpperCase()) {
      return Colors.red;
    } else if (widget.orders![widget.pos!].status ==
        'return_completed'.toUpperCase()) {
      return Colors.red;
    } else {
      return '';
    }
  }
}
