
import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Screens/mall/Badge.dart';
import 'package:astro_gurujii/Screens/mall/CartScreen.dart';
import 'package:astro_gurujii/Screens/mall/ProductDetailsScreen.dart';
import 'package:astro_gurujii/Screens/mall/ProductItem.dart';
import 'package:astro_gurujii/Screens/mall/Products.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';import 'package:badges/badges.dart' as badges;

import 'model/product_list/Result.dart';

class WishList extends StatefulWidget {
  final String? id;
  final String? text;

  WishList({this.id, this.text});

  @override
  _CategoryMallState createState() => _CategoryMallState();
}

class _CategoryMallState extends State<WishList> {
  bool _isLoading=true;
  List details1=[];
  String quantity="";
  bool _status=false;
  TextEditingController controller = new TextEditingController();
  HttpServices _httpService = HttpServices();
  List<Result> data=[];

  Future<void> productListAli() async {
    var res = await _httpService.wish_list(category_id: widget.id!, product_id: '');
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

  _addToCard(String type) async{
    setState(() {
      _isLoading = true;
    });

    var res = await _httpService.add_to_cart(product_id: widget.id!);
    if(res!.status == true)
    {
      setState(() {
        Provider.of<Products>(context, listen: false).incrementCounter(int.parse(res.item_count!));
      });

    }
    else
    {
      // print("SigUp fAILED");
    }
  }

  _removeToCard(String type) async{
    var res = await _httpService.sub_to_cart(product_id: widget.id!);
    if(res!.status == true)
    {
      setState(() {
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
    // TODO: implement initState
    setState(() {
      productListAli();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var counter = Provider.of<Products>(context).getCounter;
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        title: CustomText(
          text: "Wishlist",
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        actions: [

         badges.Badge(
            child: IconButton(
                icon:SvgPicture.asset('assets/login/bag.svg',height: 30,
                  width: 30,color: Colors.white,),
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => CartScreen()));
                }),
            badgeContent: Text('$counter' ?? '0'),
            // color: blackColor,
          ),

          const SizedBox(width: 20,),
        ],
      ),
      body: Container(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                color: whiteColor,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Container(
                      decoration: BoxDecoration(
                        color: whiteColor,
                        border: Border.all(color: greyColor),
                        borderRadius: BorderRadius.circular(10),
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
                                hintText: 'Search',
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 16)),
                            onChanged: onSearchTextChanged,
                          ),
                          trailing: new IconButton(
                            icon: new Icon(Icons.cancel),
                            onPressed: () {
                              controller.clear();
                              onSearchTextChanged('');
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              _isLoading
                  ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
                  : Expanded(
                child: _searchResult.length != 0 || controller.text.isNotEmpty
                    ? ListView(
                  children: [
                    GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: 268,),
                      itemCount: _searchResult.length,
                      itemBuilder:
                          (BuildContext context, int index) =>
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) =>
                                          ProductDetailsScreen(
                                              data: _searchResult,
                                              text: _searchResult[index]
                                                  .name!,
                                              pos: index,
                                              id: widget.id!))).then(
                                      (value) => {productListAli()});
                            },
                            child: ProductItem(
                              data: _searchResult,
                              pos: index,
                              qty: _searchResult[index].qty!,
                              id: _searchResult[index].id.toString(),
                              title: _searchResult[index].name!,
                              imageUrl:
                              _searchResult[index].display_image!,
                              price:
                              _searchResult[index].price.toString(),
                              mrp: _searchResult[index].mrp.toString(),
                            ),
                          ),
                    )
                  ],
                ): ListView(
                  children: [
                    GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: 268,
                        // childAspectRatio: 0.72,

                      ),
                      itemCount: data.length,
                      itemBuilder:
                          (BuildContext context, int index) =>
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) =>
                                          ProductDetailsScreen(
                                              data: data,
                                              text: data[index].name!,
                                              pos: index,
                                              id: widget.id!))).then(
                                      (value) => {productListAli()});
                            },
                            child: ProductItem(
                              data: data,
                              pos: index,
                              qty: data[index].qty!,
                              id: data[index].id.toString(),
                              title: data[index].name!,
                              imageUrl: data[index].display_image!,
                              price: data[index].price.toString(),
                              mrp: data[index].mrp.toString(),
                            ),
                          ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Result> _searchResult = [];
  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    data.forEach((userDetail) {
      if (userDetail.name!.toLowerCase().contains(text.toLowerCase()) || userDetail.name!.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(userDetail);
    });

    setState(() {});
  }
}