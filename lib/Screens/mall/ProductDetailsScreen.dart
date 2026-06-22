
import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Screens/mall/Badge.dart';
import 'package:astro_gurujii/Screens/mall/CartScreen.dart';
import 'package:astro_gurujii/Screens/mall/Products.dart';
import 'package:astro_gurujii/Screens/mall/WishList.dart';
import 'package:astro_gurujii/Screens/mall/model/product_list/ProductImg.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:badges/badges.dart' as badges;

import 'model/product_list/Result.dart';

class ProductDetailsScreen extends StatefulWidget {
  List<Result>? data=[];
  final String? text;
  final int? pos;
  final String? id;
  ProductDetailsScreen({this.id,this.pos,this.data,this.text});

  static const String productDetailScreen = "/productDetailScreen";

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetailsScreen> {

  int _current = 0;
  List<ProductImg> imgList = [];
  double delivery_charges=0.0;
  double discount=0.0;
  double gst=0.0;
  double item_total=0.0;
  String? message;
  double paying_amount=0.0;

  List <T> map<T>(List list , Function handler)
  {
    List<T> result = [];
    for(var i = 0 ; i < list.length; i++)
    {
      result.add(handler(i, list[i]));
    }
    return result;
  }
  bool isLoading=true;
  bool _isLoading=true;
  List details1=[];
  //Get Product All Details from API
  HttpServices _httpService = HttpServices();
  List<Result> other_products=[];
  List<Result> data=[];
  Future<void> getProductDetails() async {
    setState(() {
      _isLoading=true;
    });
   setState(() {
     imgList.clear();
    // other_products=res.other_products;
     if(widget.data![widget.pos!].product_img!.isEmpty){
       imgList.addAll(widget.data![widget.pos!].product_img!);
     }else{
       imgList.addAll(widget.data![widget.pos!].product_img!);
     }

     isLoading = false;
     _isLoading = false;
   });
  }

  _addToCard(String type) async{
    setState(() {
      isLoading = true;
    });

    var res = await _httpService.add_to_cart(product_id: type);
    if(res!.status==true)
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

  _removeToCard(String type) async{
    setState(() {
      isLoading = true;
    });

    var res = await _httpService.sub_to_cart(product_id:type);
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



  Future<void> getCardDetails() async {

    var res = await _httpService.cart_list(product_id: '');
    if(res!.status == true){
      setState(() {
        delivery_charges=double.parse(res.delivery_charges!);
        discount=double.parse(res.saving!);
        gst=double.parse(res.gst!);
        item_total=double.parse(res.item_total!);
        paying_amount=double.parse(res.paying_amount!);
      });
    }
  }


  Future<void> productListAli() async {
   // print('================>'+widget.id+"============"+widget.data![widget.pos!].id);
    setState(() {
      _isLoading=true;
    });
    var res = await _httpService.product_list(category_id: widget.id!,product_id: widget.data![widget.pos!].id!, id: '');
    if(res!.status == true){
      setState(() {
        _isLoading=false;
        other_products=res.results!;
      });
    }else{
      setState(() {
        _isLoading=false;
      });
    }
  }

  Future<void> productListAliSingle() async {
    //print('================>'+widget.id+"============"+widget.data![widget.pos!].id);
    setState(() {
      _isLoading=true;
    });
    var res = await _httpService.product_list(id: widget.data![widget.pos!].id!, category_id: '', product_id: '');
    if(res!.status == true){
      setState(() {
        _isLoading=false;
        data=res.results!;
      });
    }else{
      setState(() {
        _isLoading=false;
      });
    }
  }




  _addFavoiteCard(String p_id) async {
    setState(() {
      isLoading = true;
    });
    var res = await _httpService.wishlist_add_update(product_id: p_id);
    if (res!.status == true) {
      setState(() {
        Provider.of<Products>(context, listen: false).incrementFavCounter(int.parse(res.item_count!));
      });
    } else {
    }
  }



  @override
  void initState() {
    productListAliSingle();
    getProductDetails();
    getCardDetails();
    productListAli();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var counter = Provider.of<Products>(context).getCounter;
    var wish_count = Provider.of<Products>(context).getFavCounter;
    //print('wish_count'+wish_count.toString());
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    //final loadedProducts = Provider.of<Products>(conte  xt).findById(productId);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        title: CustomText(text: widget.text!,color: Colors.white,fontWeight: FontWeight.w600,fontSize: 15,),
        leading:  IconButton(onPressed: (){
          Navigator.of(context).pop();
        }, icon: Icon(Icons.arrow_back_ios,color: whiteColor,)),
        actions: [


        /*  Badge(
            child: IconButton(
                icon: Icon(
                  Icons.heart_broken_rounded,
                  color: blackColor,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>WishList())).then((value) => productListAli());
                }),
            value: '${wish_count.toString()}' ?? '0',
            color: blackColor,
          ),*/

          InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>WishList())).then((value) => productListAli());
              },
              child: Image.asset('assets/Icons/whislist_heart_selected.png',height: 30,
                width: 30,color: whiteColor,)),
          badges.Badge(
            child: IconButton(
                icon:SvgPicture.asset('assets/login/bag.svg',height: 30,
                  width: 30,color: whiteColor,),
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => CartScreen())).then((value) => {
                    productListAliSingle(),
                  getCardDetails()
                  });
                }),
            badgeContent: Text('$counter' ?? '0'),
            // color: blackColor,
          ),

          const SizedBox(width: 20,),
        ],
      ),
      body: _isLoading?Container(child: Center(
        child: CircularProgressIndicator(),
      ),):Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: ListView(
                children: [
                  Container(
                    //width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Container(
                          height: 250,
                          child: CarouselSlider.builder(
                            itemCount: imgList.length,
                            itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
                                Container(
                                  //       width: MediaQuery.of(context).size.width,
                                  //     margin:  EdgeInsets.symmetric(horizontal: 5),
                                  padding: EdgeInsets.zero,
                                  decoration:  BoxDecoration(
                                      borderRadius: BorderRadius.circular(0),
                                      image:  DecorationImage(
                                          image: CachedNetworkImageProvider(imgList[itemIndex].image.toString())
                                      )
                                  ),

                                )
                            , options: CarouselOptions(
                            height: 240,
                            initialPage: 0,
                            reverse: false,
                            viewportFraction: 1.0,
                            enableInfiniteScroll: false,
                            scrollDirection: Axis.horizontal,
                          ),
                          ),
                        ),
                        SizedBox(
                          width:MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: map<Widget>(
                                imgList,(index,url)
                            {
                              return Container(
                                width: 10.0,
                                height: 10.0,
                                margin: EdgeInsets.symmetric(horizontal: 2.0),
                                decoration: BoxDecoration(shape: BoxShape.circle,
                                    color: _current == index ?blackColor : Colors.grey),
                              );
                            }
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 1,vertical: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex:2,
                                        child: Container(

                                          child: Text(
                                            data[0].name??'',
                                            style: TextStyle(
                                                fontSize: 19,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Container(
                                            child: Text(
                                              '\u{20B9}${data[0].price}/-',
                                              style: TextStyle(
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),

                                         Container(
                                            child:Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    onTap: (){
                                                      if(data[0].qty!>0){
                                                        _removeToCard(data[0].id.toString());
                                                        int qtys=0;
                                                        qtys=data[0].qty!;
                                                        qtys-=1;
                                                        data[0].qty=qtys;
                                                      }

                                                    },
                                                    child: Container(
                                                        padding: EdgeInsets.all(2),
                                                        margin: EdgeInsets.symmetric(horizontal: 20),
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
                                                    child: Text(data[0].qty.toString()),
                                                  ),
                                                  InkWell(
                                                    onTap: (){
                                                      _addToCard(data[0].id.toString());
                                                      int qtys=0;
                                                      qtys=data[0].qty!;
                                                      qtys+=1;
                                                      data[0].qty=qtys;

                                                    },
                                                    child: Container(
                                                        padding: EdgeInsets.all(2),
                                                        margin: EdgeInsets.symmetric(horizontal: 20),
                                                        decoration: BoxDecoration(
                                                            color: blueColor,
                                                            borderRadius:
                                                            BorderRadius.circular(20)),
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
                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top:  0,left: 10),
                    child: Text(
                      "Product Details",
                      style: TextStyle(
                          color: blackColor,
                          fontSize: 19,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Html(
                        data:data[0].details??''),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20,left: 10),
                    child: Text(
                      "Benefits",
                      style: TextStyle(
                          color: blackColor,
                          fontSize: 19,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Html(
                        data:data[0].benefits??''),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20,left: 10),
                    child: Text(
                      "Try Other Products",
                      style: TextStyle(
                          color: blackColor,
                          fontSize: 19,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 10),
                      height: 270,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: other_products.length,
                          itemBuilder: (ctx, i) => Container(
                              margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                              width: 180,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(0.0, 0.0), //(x,y)
                                    ),
                                  ],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        (chechDescount(other_products[i].price!,other_products[i].mrp!))?Container(
                                            alignment: Alignment.topLeft,
                                            padding:
                                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                            decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(10),
                                                    bottomRight: Radius.circular(10))),
                                            child: Text(
                                              getPercentage(other_products[i].price!,other_products[i].mrp!),
                                              style: TextStyle(color: Colors.white),
                                            )):Container(),
                                        InkWell(
                                          splashColor: Theme.of(context).primaryColorLight,
                                          onTap: (){
                                            if(other_products[i].is_favorite=="Y"){
                                              setState(() {
                                                other_products[i].is_favorite="N";
                                              });

                                            }else{
                                              setState(() {
                                                other_products[i].is_favorite="Y";
                                              });


                                            }
                                            _addFavoiteCard(other_products[i].id!);
                                          },
                                          child: Container(
                                            height: 48,
                                            margin: EdgeInsets.only(right: 10),
                                            alignment: Alignment.topLeft,
                                            child: Image.asset(
                                                other_products[i].is_favorite == "Y"
                                                    ? "assets/Icons/whislist_heart_selected.png"
                                                    : "assets/Icons/Heart.png",
                                                height: 30,
                                                width: 30,
                                                color: other_products[i].is_favorite == "Y"
                                                    ? Colors.red
                                                    : Colors.grey),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(),
                                  Container(
  height: 80,
  width: 80,
  clipBehavior: Clip.antiAlias,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(8),
  ),
  child: Image.network(
    other_products[i].display_image ?? '', // null safety
    fit: BoxFit.cover,
    errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
      return Center(
        child: Icon(Icons.broken_image, color: Colors.red, size: 32),
      );
    },
    loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) return child;
      return Center(
        child: CircularProgressIndicator(
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
              : null,
        ),
      );
    },
  ),
),

                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 40,
                                          margin: EdgeInsets.only(bottom: 10),
                                          child: AutoSizeText(
                                            other_products[i].name!,
                                            maxLines: 2,
                                            minFontSize: 14,
                                            maxFontSize: 18,
                                            style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(bottom: 10),
                                          child: Text(
                                            '\u{20B9}${other_products[i].price}',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  (other_products[i].qty==0)?InkWell(
                                    onTap: ()
                                    {
                                      setState(() {
                                        _addToCard(other_products[i].id.toString());
                                        other_products[i].qty =  (other_products[i].qty ?? 0) + 1;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: blueColor,
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10))),
                                      padding: const EdgeInsets.symmetric(
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
                                  ):Container(
                                    height: 40,
                                    child:Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: (){
                                              _removeToCard(other_products[i].id.toString());
                                              other_products[i].qty= (other_products[i].qty ?? 0) -1;
                                            },
                                            child: Container(

                                                margin: EdgeInsets.symmetric(horizontal: 20),
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
                                            child: Text(other_products[i].qty.toString()),
                                          ),
                                          InkWell(
                                            onTap: (){
                                              _addToCard(other_products[i].id.toString());
                                              other_products[i].qty= (other_products[i].qty ?? 0)+1;
                                            },
                                            child: Container(

                                                margin: EdgeInsets.symmetric(horizontal: 20),
                                                decoration: BoxDecoration(
                                                    color: blueColor,
                                                    borderRadius:
                                                    BorderRadius.circular(20)),
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
                              )))),
                  Container(
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: blueColor,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: ()
                      {
                        //Navigator.push(context, MaterialPageRoute(builder: (ctx) => AddAddress() ));
                      },
                      child: Text(
                        "Total Amount",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    Container(
                      child: Text(
                        '\u{20B9}${paying_amount}/-',
                        style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: ()
                  {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => CartScreen())).then((value) =>{
                    getCardDetails(),
                        productListAliSingle()
                    } );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    decoration:
                    BoxDecoration(border: Border.all(color: Colors.white)),
                    child: Row(
                      children: [
                        Text(
                          "Order Now",
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  double? percent;
  String getPercentage(String price, String mrp) {
    percent=(double.parse(mrp) - double.parse(price))/double.parse(mrp)*100;
    return '${percent!.toInt().toString()}% off';
  }

  chechDescount(String price, String mrp) {
    if(double.parse(mrp) == double.parse(price)){
      return false;
    }else {
      return true;
    }

  }

}
