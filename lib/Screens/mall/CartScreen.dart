
import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Screens/mall/AddAddress.dart';
import 'package:astro_gurujii/Screens/mall/Products.dart';
import 'package:astro_gurujii/Screens/mall/model/cart_list/Result.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:astro_gurujii/Setup/app_colors.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  static const String cartScreen = "/CartScreen";


  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String userId1="",productId="";
  List details=[];
  bool _isLoading=true;
  String qty="";
  var total;
  double delivery_charges=0.0;
  double discount=0.0;
  double gst=0.0;
  double item_total=0.0;
  String? message;
  double paying_amount=0.0;
  bool isLoading=true;

  HttpServices _httpService = HttpServices();
  List<Result> cart_list=[];
  Future<void> getCardDetails() async {
    var res = await _httpService.cart_list(product_id: '');
    if(res!.status == true){
      setState(() {
        _isLoading=false;
        if(res.results!.length==0){
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "Please add items in your cart");
        }else{
          cart_list=res.results!;
          delivery_charges=double.parse(res.delivery_charges!);
          discount=double.parse(res.saving!);
          gst=double.parse(res.gst!);
          item_total=double.parse(res.item_total!);
          paying_amount=double.parse(res.paying_amount!);
        }
      });
    }else{
      setState(() {
        _isLoading=false;
      });
    }
  }

  _addToCard(String type,String id) async{
    setState(() {
      isLoading = true;
    });

    var res = await _httpService.add_to_cart(product_id: id);
    if(res!.status == true)
    {
      setState(() {
        getCardDetails();
        Provider.of<Products>(context, listen: false).incrementCounter(int.parse(res.item_count!));
      });

    }
    else
    {
      //print("SigUp fAILED");
    }
  }

  _removeToCard(String type,String id) async{
    setState(() {
      isLoading = true;
    });

    var res = await _httpService.sub_to_cart(product_id:id);
    if(res!.status == true)
    {
      setState(() {
        getCardDetails();
        Provider.of<Products>(context, listen: false).incrementCounter(int.parse(res.item_count!));
      });

    }
    else
    {
      // print("SigUp fAILED");
    }
  }



  _removeToCardTotal(String id) async{
    setState(() {
      isLoading = true;
    });

    var res = await _httpService.remove_item_to_cart(product_id:id);
    if(res!.status ==true)
    {
      setState(() {
        getCardDetails();
        Provider.of<Products>(context, listen: false).incrementCounter(int.parse(res.item_count!));
      });

    }
    else
    {
      // print("SigUp fAILED");
    }
  }

  @override
  void initState() {

    getCardDetails();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: primaryColor,
          title: CustomText(
            text: "My Cart",
            color: whiteColor,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: whiteColor,
              )),
        ),
        body: _isLoading?Container(child: Center(child: CircularProgressIndicator(color: AppColors.orangeColor,),),):
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cart_list.length,
                  itemBuilder: (ctx,i)
                  {
                    return Container(
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 0.2), //(x,y)
                            blurRadius: 2.0,
                          ),
                        ],
                      ),
                      child: Container(
                        margin:
                        EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex:2,
                              child: Container(
                                child: Image.network(
                                  cart_list[i].display_image!,
                                  height: 70,
                                  width: 70,
                                ),
                              ),
                            ),
                            Expanded(
                              flex:4,
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text(
                                        '\u{20B9} ${cart_list[i].price.toString()} /-',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                      margin: EdgeInsets.only(bottom: 8),
                                    ),
                                    Container(
                                      child: Text(cart_list[i].product_name!),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            Expanded(
                              flex:3,
                              child: Container(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap:(){
                                            if(int.parse(cart_list[i].qty!)>0){
                                              _removeToCard("qty_remove",cart_list[i].product_id.toString());
                                            }

                                            setState(() {
                                            if(int.parse(cart_list[i].qty!)>0){
                                              int qtys=0;
                                              qtys=int.parse(cart_list[i].qty!);
                                              qtys-=1;
                                              cart_list[i].qty=qtys.toString();
                                              if(cart_list[i].qty==0){
                                                cart_list.removeAt(i);
                                              }
                                            }
                                              
                                            });
                                          },
                                          child: Container(
                                              padding: EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                  color: blueColor,
                                                  borderRadius:
                                                  BorderRadius.circular(20)),
                                              child: Icon(
                                                Icons.remove,
                                                color: Colors.white,
                                              )),
                                        ),
                                        Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Text(
                                              cart_list[i].qty.toString()??'',
                                              style: TextStyle(
                                                  color: blueColor,
                                                  fontSize: 18),
                                            )),
                                        InkWell(
                                          onTap: (){
                                            _addToCard("add",cart_list[i].product_id.toString());
                                            setState(() {
                                              int qtys=0;
                                              qtys=int.parse(cart_list[i].qty!);
                                              qtys+=1;
                                              cart_list[i].qty=qtys.toString();
                                             
                                            });
                                          },
                                          child: Container(
                                              padding: EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                  color: blueColor,
                                                  borderRadius:
                                                  BorderRadius.circular(20)),
                                              child: Icon(
                                                Icons.add,
                                                color: Colors.white,
                                              )),
                                        ),
                                      ],
                                    ),
                                    InkWell(
                                        onTap: () {
                                          cartBottomSheet(context,cart_list[i].product_id!);
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(top: 10),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.delete,
                                                color: Colors.grey,
                                              ),
                                              Text(
                                                "Remove",
                                                style:
                                                TextStyle(color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              /* Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      width: double.infinity,
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
                      child: Container(
                        margin:
                        EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Delivery at : office",style: TextStyle(fontSize: 19,fontWeight: FontWeight.w500),),

                                  Container(margin: EdgeInsets.only(top: 5),child: Text("B-817, Noida One, Sector-62, Noida-201309")),

                                ],
                              ),
                            ),
                            Container(
                              child: Text("Change",style: TextStyle(color: blueColor,fontWeight: FontWeight.w500),),
                            ),


                          ],
                        ),
                      ),
                    ),   */  // address
              /*Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      width: double.infinity,
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
                      child: Container(
                        margin:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(child: Container(margin: EdgeInsets.only(right: 40),child: TextFormField(
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(blueGreyColor)),
                                ),
                                hintText: "Avail coupon discount",
                              ),
                            ))),
                            Text("Apply Now",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),)

                          ],
                        ),
                      ),
                    ),*/
              Container(
                margin: EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.all(10),
                width: double.infinity,

                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1)),child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Payment Summary',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.mBGColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_down_outlined)
                      ],
                    ),

                    SizedBox(height: 15,),
                    Container(
                      height: 120,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                  child: Text(
                                    "Sub Total",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,color: Colors.grey[700]),
                                  )),
                              Text(
                                "Delivery Charges",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600, color: Colors.grey[700]),
                              ),
                              Text(
                                "GST (18%)",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600, color: Colors.grey[700]),
                              ),

                              Divider(),
                              Text(
                                "Total Pay",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800),
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                '\u{20B9} ${item_total.toString()}',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,color: Colors.grey[700]),
                              ),
                              Text(
                                '\u{20B9} ${delivery_charges.toString()}',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,color: Colors.grey[700]),
                              ),
                              Text(
                                '\u{20B9} ${gst.toString()}',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,color: Colors.grey[700]),
                              ),

                              Divider(),
                              Text(
                                '\u{20B9} ${paying_amount}',
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => AddAddress()));
                },
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(left: 10, right: 10, ),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                  child: Text(
                    "PROCEED",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
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
              )

            ],
          ),
        )

    );
  }

  void cartBottomSheet(context,String product_Id) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        context: context,
        builder: (ctx) {
          return Container(
            height: 350,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 60),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: redColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          "Remove an item",
                          style: TextStyle(
                              fontSize: 21, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                            "Are you sure want to remove item from your shopping cart?",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 21),
                          )),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: ()
                        {
                          Navigator.pop(context);
                        },
                        child: Container(
                            padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                            decoration: BoxDecoration(color: Color(0xFFF5F5F5),borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              "NO",
                              style: TextStyle(color: Colors.black),
                            )),
                      ),
                      InkWell(
                        onTap: ()
                        {
                          _removeToCardTotal(product_Id);
                          Navigator.pop(context);

                        },
                        child: Container(
                            decoration: BoxDecoration(color: redColor,borderRadius: BorderRadius.circular(10)),

                            padding: EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 10,
                            ),
                            child: Text("REMOVE",style: TextStyle(color: Colors.white),)),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

}


