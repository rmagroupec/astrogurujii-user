

import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Screens/mall/Products.dart';
import 'package:astro_gurujii/Screens/mall/model/product_list/Result.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:astro_gurujii/Utilities/banner_loader.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductItem extends StatefulWidget {
  int? qty;
  final String? id;
  final String? title;
  final String? imageUrl;
  final String? price;
  final String? mrp;
  List<Result>? data;
  final int? pos;

  ProductItem(
      { this.mrp,
       this.data,
       this.pos,
       this.qty,
       this.id,
       this.title,
       this.imageUrl,
       this.price});

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _status = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  bool isLoading = true;
  String userId1 = "";
  HttpServices _httpService = HttpServices();

  _addToCard(String type) async {
    setState(() {
      isLoading = true;
    });
    final _prefs = await SharedPreferences.getInstance();
    userId1 = _prefs.getString('userID') ?? '';
    _prefs.setString('product_id', widget.id!);
    var res = await _httpService.add_to_cart(product_id: widget.id!);
    if (res!.status == true) {
      setState(() {
        Provider.of<Products>(context, listen: false)
            .incrementCounter(int.parse(res.item_count!));
      });
    } else {
      // print("SigUp fAILED");
    }
  }

  _addFavoiteCard() async {
    setState(() {
      isLoading = true;
    });
    var res = await _httpService.wishlist_add_update(product_id: widget.id!);
    if (res!.status == true) {
      setState(() {});
    } else {}
  }

  _removeToCard(String type) async {
    setState(() {
      isLoading = true;
    });
    final _prefs = await SharedPreferences.getInstance();
    userId1 = _prefs.getString('userID') ?? '';
    _prefs.setString('product_id', widget.id!);
    var res = await _httpService.sub_to_cart(product_id: widget.id!);
    if (res!.status == true) {
      setState(() {
        Provider.of<Products>(context, listen: false)
            .incrementCounter(int.parse(res.item_count!));
      });
    } else {
      // print("SigUp fAILED");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Padding(
        padding: EdgeInsets.all(5),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 2.0,
              ),
            ],
          ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.end,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(

                  height: MediaQuery.of(context).size.height / 5.3,
                  width: MediaQuery.of(context).size.width / 2.2,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.red,),
                  child: Stack(
                    children: [
                      ShimmerImageLoader(image: widget.imageUrl!),
                      Positioned(
                        right: -5,
                        top: 0,
                        child: InkWell(
                          splashColor: Theme.of(context).primaryColorLight,
                          onTap: () {
                            if (widget.data![widget.pos!].is_favorite == "Y") {
                              setState(() {
                                widget.data![widget.pos!].is_favorite = "N";
                              });
                            } else {
                              setState(() {
                                widget.data![widget.pos!].is_favorite = "Y";
                              });
                            }
                            _addFavoiteCard();
                          },
                          child: Container(
                            width: 48,
                            height: 48,
                            // margin: EdgeInsets.only(right: 10),
                            // alignment: Alignment.topLeft,
                            child: Image.asset(
                                widget.data![widget.pos!].is_favorite == "Y"
                                    ? "assets/Icons/whislist_heart_selected.png"
                                    : "assets/Icons/Heart.png",
                                height: 30,
                                width: 30,
                                color:
                                    widget.data![widget.pos!].is_favorite == "Y"
                                        ? Colors.red
                                        : Colors.grey),
                          ),
                        ),
                      ),

                    ],
                  )),
              SizedBox(
                height: 8,
              ),
              // Container(
              //   width: MediaQuery.of(context).size.width,
              //   margin: EdgeInsets.only(bottom: 10),
              //   child: Center(
              //       child: Image.network(
              //     widget.imageUrl,
              //     height: 100,
              //
              //         errorBuilder: (BuildContext context, Object error, StackTrace stackTrace) {
              //           return  Center(
              //             // child: Icon(Icons.error, color: Colors.red), // Display an error icon if the image fails to load
              //             child:Column(
              //               children: [
              //                 Container(
              //                   width: double.infinity, // Adjust width as needed
              //                   height: 100, // Adjust height as needed
              //                   decoration: BoxDecoration(
              //                     gradient: LinearGradient(
              //                       begin: Alignment.centerLeft,
              //                       end: Alignment.centerRight,
              //                       colors: [
              //                         Colors.grey[300],
              //                         Colors.grey[100],
              //                         Colors.grey[300],
              //                       ],
              //                       stops: const [0.0, 0.5, 1.0],
              //                     ),
              //                   ),
              //                 ),
              //
              //                 // SizedBox(height: 20,),
              //                 // Padding(
              //                 //   padding: const EdgeInsets.all(10.0),
              //                 //   child: Container(
              //                 //     width: double.infinity, // Adjust width as needed
              //                 //     height: 20, // Adjust height as needed
              //                 //     decoration: BoxDecoration(
              //                 //       gradient: LinearGradient(
              //                 //         begin: Alignment.centerLeft,
              //                 //         end: Alignment.centerRight,
              //                 //         colors: [
              //                 //           Colors.grey[300],
              //                 //           Colors.grey[100],
              //                 //           Colors.grey[300],
              //                 //         ],
              //                 //         stops: const [0.0, 0.5, 1.0],
              //                 //       ),
              //                 //     ),
              //                 //   ),
              //                 // )
              //               ],
              //             ), // Display an error icon if the image fails to load
              //
              //           );
              //         },
              //   )),
              // ),
              Container(
                width: MediaQuery.of(context).size.width / 2.5,
                // height: 32,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: AutoSizeText(
                  widget.title!,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  minFontSize: 14,
                  maxFontSize: 18,
                  style: TextStyle(fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 9.2,),
              Container(
                width: MediaQuery.of(context).size.width / 2.5,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: AutoSizeText(
                  '\u{20B9} ${widget.price.toString()}',
                  maxLines: 1,
                  maxFontSize: 18,
                  minFontSize: 14,
                  style: TextStyle(fontWeight: FontWeight.w800),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              (widget.data![widget.pos!].qty == 0)
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          _addToCard(widget.data![widget.pos!].id.toString());
                          int qtys = 0;
                          qtys = widget.data![widget.pos!].qty!;
                          qtys += 1;
                          widget.data![widget.pos!].qty = qtys;
                        });
                      },
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: blueColor,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10))),
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        child: Text(
                          "Add to Cart",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: EdgeInsets.all(0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                _removeToCard(
                                    widget.data![widget.pos!].id.toString());
                                int qtys = 0;
                                qtys = widget.data![widget.pos!].qty!;
                                qtys -= 1;
                                widget.data![widget.pos!].qty = qtys;
                              },
                              child: Container(
                                  padding: EdgeInsets.all(2),
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                      color: blueColor,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                  )),
                            ),
                            Container(
                              child:
                                  Text(widget.data![widget.pos!].qty.toString()),
                            ),
                            InkWell(
                              onTap: () {
                                _addToCard(
                                    widget.data![widget.pos!].id.toString());
                                int qtys = 0;
                                qtys = widget.data![widget.pos!].qty!;
                                qtys += 1;
                                widget.data![widget.pos!].qty = qtys;
                              },
                              child: Container(
                                  padding: EdgeInsets.all(2),
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                      color: blueColor,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  )),
                            ),
                            /*Container(
                       width: 50,
                       decoration: BoxDecoration(
                           color: blueColor,
                           borderRadius: BorderRadius.only(
                               bottomLeft: Radius.circular(10),
                               bottomRight: Radius.circular(10))),
                       padding: const EdgeInsets.symmetric(
                         vertical: 10,
                       ),
                       child: Text(
                         "Checkout",
                         style: TextStyle(
                             color: Colors.white,
                             fontSize: 19,
                             fontWeight: FontWeight.w600),
                         textAlign: TextAlign.center,
                       ),
                     ),*/
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

  void callAddAli() {}

  double? percent;
  String getPercentage(String price, String mrp) {
    percent =
        (double.parse(mrp) - double.parse(price)) / double.parse(mrp) * 100;
    return '${percent!.toInt().toString()}% off';
  }

  chechDescount(String price, String mrp) {
    if (double.parse(mrp) == double.parse(price)) {
      return false;
    } else {
      return true;
    }
  }
}

// SizedBox(
// child:
// Row(
// crossAxisAlignment: CrossAxisAlignment.end,
// mainAxisAlignment: MainAxisAlignment.end,
// children: [
// // (chechDescount(widget.data[widget.pos].price,widget.data[widget.pos].mrp))?Container(
// //     alignment: Alignment.topLeft,
// //     padding:
// //         EdgeInsets.symmetric(horizontal: 10, vertical: 5),
// //     decoration: BoxDecoration(
// //         color: Colors.black,
// //         borderRadius: BorderRadius.only(
// //             topLeft: Radius.circular(10),
// //             bottomRight: Radius.circular(10))),
// //     child: Text(
// //       getPercentage(widget.data[widget.pos].price,widget.data[widget.pos].mrp),
// //       style: TextStyle(color: Colors.white),
// //     )):Container(),
// InkWell(
// splashColor: Theme.of(context).primaryColorLight,
// onTap: (){
// if(widget.data[widget.pos].is_favorite=="Y"){
// setState(() {
// widget.data[widget.pos].is_favorite="N";
// });
//
// }else{
// setState(() {
// widget.data[widget.pos].is_favorite="Y";
// });
//
// }
// _addFavoiteCard();
// },
// child: Container(
// height: 48,
// margin: EdgeInsets.only(right: 10),
// alignment: Alignment.topLeft,
// child: Image.asset(
// widget.data[widget.pos].is_favorite == "Y"
// ? "assets/Icons/whislist_heart_selected.png"
//     : "assets/Icons/Heart.png",
// height: 30,
// width: 30,
// color: widget.data[widget.pos].is_favorite == "Y"
// ? Colors.red
//     : Colors.grey),
// ),
// ),
// ],
// ),
// ),
