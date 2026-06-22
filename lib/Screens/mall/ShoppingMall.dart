
import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Screens/mall/Badge.dart';
import 'package:astro_gurujii/Screens/mall/CartScreen.dart';
import 'package:astro_gurujii/Screens/mall/CategoryMall.dart';
import 'package:astro_gurujii/Screens/mall/Products.dart';
import 'package:astro_gurujii/Screens/mall/WishList.dart';
import 'package:astro_gurujii/Screens/mall/model/category/Result.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:astro_gurujii/Setup/app_colors.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:badges/badges.dart' as badges;
import '../../Utilities/banner_loader.dart';
import '../poojaScreen/controller/controller.dart';
import 'astroMallBannerModel.dart';

class ShoppingMall extends StatefulWidget {

  @override
  _ShoppingMallState createState() => _ShoppingMallState();
}

class _ShoppingMallState extends State<ShoppingMall> {
  bool _isLoading=true;
  bool search_click_status = false;
  final List<Map<String, String>> shopping = [
    {"id": "a3", "images": "Assets/Images/red_panna.png", "text": "Red Panna"},
    {"id": "a1", "images": "Assets/Images/gemstone.png", "text": "Gemstone"},
    {"id": "a2", "images": "Assets/Images/rudraksh.png", "text": "Rudraksh"},
    {"id": "a2", "images": "Assets/Images/moti.png", "text": "Yantra"},
    {"id": "a3", "images": "Assets/Images/red_panna.png", "text": "Red Panna"},
    {"id": "a1", "images": "Assets/Images/gemstone.png", "text": "Gemstone"},
    {"id": "a2", "images": "Assets/Images/rudraksh.png", "text": "Rudraksh"},
    {"id": "a2", "images": "Assets/Images/moti.png", "text": "Yantra"},
  ];
  TextEditingController controller = new TextEditingController();
  List details = [];
  HttpServices _httpService = HttpServices();
  List<Result> category_list=[];
  Future<void> categoryListAli() async {
    var res = await _httpService.product_category_list(astrologer_id: '');
    if(res!.status ==true){
      setState(() {
        _isLoading=false;
        category_list=res.results!;

      });
    }else{
      setState(() {
        _isLoading=false;
      });
    }
  }

List<AstoBannerData> bannerList=[];

  Future<void> astrobannerApi() async {
    var res = await _httpService.astoBannerApiFun();
    if(res!.status == true){
      setState(() {
         bannerList=res.data!;

      });
    }else{

    }
  }

  @override
  void initState() {
    astrobannerApi();
    categoryListAli();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var counter = Provider.of<Products>(context).getCounter;
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        foregroundColor: whiteColor,
        title: CustomText(text: 'Astro Mall',color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20,align: TextAlign.start,),
        backgroundColor: primaryColor,
        elevation: 1.0,
        // leading:  IconButton(onPressed: (){
        //   Navigator.of(context).pop();
        // }, icon: Icon(Icons.arrow_back_ios,color: Colors.white,)),
        actions: [
          InkWell(
              onTap: () {
                setState(() {
                  if (search_click_status) {
                    search_click_status = false;
                  } else {
                    search_click_status = true;
                  }
                });
              },
              child: SvgPicture.asset(
                'assets/login/Search.svg',
                color: whiteColor,
                  width: 25,
                height: 25,

              )),
          SizedBox(width: 10,),
          InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>WishList()));
              },
              child: Image.asset('assets/Icons/whislist_heart_selected.png',height: 30,
                width: 30,color: Colors.white,)),
          const SizedBox(width: 10,),
          badges.Badge(
            child: IconButton(
                icon:SvgPicture.asset('assets/login/bag.svg',height: 25,
                  width: 25,color: Colors.white,),
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => CartScreen()));
                }),
            badgeContent: Text('$counter' ?? '0'),
            // color: Colors.black,
          ),
          const SizedBox(width: 10,),
        ],

      ),
      body: Container(
        color: whiteColor,
        child: Column(

          children: [

          search_click_status ?  Padding(
              padding: const EdgeInsets.all(8.0),
              child:  Container(
                decoration: BoxDecoration(
                  color: whiteColor,
                  border: Border.all(color: greyColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                child:  Container(
                  alignment: Alignment.centerLeft,
                  child:  ListTile(
                    leading:  Icon(Icons.search),
                    title:  TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(left: 5),
                          border: InputBorder.none,
                          hintText: 'Search',
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 16
                          )
                      ),
                      onChanged: onSearchTextChanged,
                    ),
                    trailing:  IconButton(icon:  Icon(Icons.cancel), onPressed: () {
                      controller.clear();
                      onSearchTextChanged('');
                    },),
                  ),
                ),
              ),
            ) :  Container(), // search
            bannerList.isEmpty? SizedBox():  bannerAstroMall(),

            _isLoading?Container(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AstroMallShimmerLoadinng()
              ],
            )):
            Expanded(
                child: _searchResult.length != 0 || controller.text.isNotEmpty
                    ?ListView.builder(
                    itemCount: _searchResult==null?0:_searchResult.length,
                    itemBuilder: (BuildContext context,int index){
                      return Container(
                        decoration: BoxDecoration(color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 1.0), //(x,y)
                              blurRadius: 4.0,
                            ),
                          ],
                        ),

                        margin: EdgeInsets.only(right: 5, left: 5, top: 10),
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (ctx) =>
                                    CategoryMall(
                                      id: _searchResult[index].id.toString(),text: _searchResult[index].name!,))
                            );
                          },
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [

                                    Container(
                                        width: 100,
                                        decoration:  BoxDecoration(
                                          color: whiteColor,
                                          shape: BoxShape.circle,
                                          border:  Border.all(
                                            color:  Color(0xFFD1D3FF),
                                            width: 6,
                                          ),
                                        ),
                                        child: Center(
                                          child: CircleAvatar(
                                            radius: 45,
                                            backgroundImage: CachedNetworkImageProvider(_searchResult[index].image.toString()) as ImageProvider,
                                          ) ,

                                        )
                                    ),
                                   /* Container(
                                      child: Image.network(
                                        _searchResult[index].image, height: 85,),
                                    ),*/
                                    Container(
                                      margin: EdgeInsets.only(left: 25),
                                      child: Text(_searchResult[index].name!, style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18),),
                                    ),
                                  ],
                                ),
                                Container(
                                  child: Icon(Icons.arrow_forward_ios,
                                    color: blueColor,),
                                ),
                              ],
                            ),
                          ),
                        ),

                      );
                    }):

                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, top: 5),
                            child: IntrinsicHeight(
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width/1.1,
                                    child: CustomText(
                                      text: "Explore Premium Products by Category",
                                      maxLines: 2,
                                      color: const Color(0xFF2D2D2D),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Spacer(),
                                 ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left :10.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width/2.7,
                            child: Divider(
                              color: AppColors.orangeColor,  // Line color
                              height: 5,            // Height of the divider (the space around the line)
                              thickness: 3,         // Thickness of the line itself
                              indent: 0,            // Indentation from the left side
                              endIndent: 0,         // Indentation from the right side
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height/1.8,
                          width: MediaQuery.of(context).size.width,
                          child: GridView.builder(gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,        // Number of items per row
                            crossAxisSpacing: 10,    // Space between items in the horizontal direction
                            mainAxisSpacing: 10,     // Space between items in the vertical direction
                            childAspectRatio: 1,    // Aspect ratio of each item
                          ),
                itemCount: 3,   itemBuilder: (context,index){
                            return GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(
                                                    builder: (ctx) =>
                                                        CategoryMall(
                                                          id: category_list[index].id.toString(),text: category_list[index].name!,))
                                                );
                              },
                              child: Container(child: Column(
                                children: [
                                  Container(
                                      height:MediaQuery.of(context).size.height/5.8,
                                      width: MediaQuery.of(context).size.width/2.2,
                                      child: ShimmerImageLoader(image: category_list[index].image.toString(),)),
                                  SizedBox(height: 8,),
                                  Text(category_list[index].name!, style:TextStyle(fontSize: 16,fontWeight: FontWeight.bold, color: AppColors.mBGColor
                                  ))
                                ],
                              )),
                            );
                            //   Container(
                            //   height: 100,
                            //   width: ,
                            //   decoration: BoxDecoration(image: DecorationImage(image: CachedNetworkImageProvider(category_list[index].image.toString()) as ImageProvider,)),
                            // );
                          }),
                        ),
                      ],
                    )
                // ListView.builder(
                //     itemCount: category_list==null?Container():category_list.length,
                //     itemBuilder: (BuildContext context,int index){
                //       return Container(
                //         decoration: BoxDecoration(color: Colors.white,
                //           boxShadow: [
                //             BoxShadow(
                //               color: Colors.grey,
                //               offset: Offset(0.0, 1.0), //(x,y)
                //               blurRadius: 4.0,
                //             ),
                //           ],
                //         ),
                //
                //         margin: EdgeInsets.only(right: 5, left: 5, top: 10),
                //         padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                //         child: InkWell(
                //           onTap: () {
                //             Navigator.push(context, MaterialPageRoute(
                //                 builder: (ctx) =>
                //                     CategoryMall(
                //                       id: category_list[index].id.toString(),text: category_list[index].name,))
                //             );
                //           },
                //           child: Container(
                //             child: Row(
                //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //               children: [
                //                 Row(
                //                   children: [
                //                     Container(
                //                         width: 100,
                //                         // decoration:  BoxDecoration(
                //                         //   color: whiteColor,
                //                         //   shape: BoxShape.circle,
                //                         //   border:  Border.all(
                //                         //     color:  Color(0xFFD1D3FF),
                //                         //     width: 6,
                //                         //   ),
                //                         // ),
                //                         child: Center(
                //                           child: CircleAvatar(
                //                             radius: 45,
                //                             backgroundImage: CachedNetworkImageProvider(category_list[index].image.toString()) as ImageProvider,
                //                           ) ,
                //
                //                         )
                //                     ),
                //
                //                      SizedBox(width: 20,),
                //                     Container(
                //                       width: MediaQuery.of(context).size.width*0.48,
                //                       // color: Colors.red,
                //                       child: Text(category_list[index].name, style: TextStyle(
                //                           fontWeight: FontWeight.w600,
                //                           fontSize: 16),),
                //                     ),
                //                   ],
                //                 ),
                //                 Container(
                //                   child: Icon(Icons.arrow_forward_ios,
                //                     color: blueColor,),
                //                 ),
                //               ],
                //             ),
                //           ),
                //         ),
                //
                //       );
                //     })),
            ),
          ],
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

    category_list.forEach((userDetail) {
      if (userDetail.name!.toLowerCase().contains(text.toLowerCase()) || userDetail.name!.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(userDetail);
    });

    setState(() {});
  }


  Widget bannerAstroMall() {


    List<String> images=[
      "https://picsum.photos/200/300",
      "https://picsum.photos/200/300",
      "https://picsum.photos/200/300",
    ];
    return
      // screenController.poojaModel!.promotionalBanner!.isEmpty ? Container() :
      images.isEmpty ? Container() :

      GetBuilder<PoojaController>(
        init: PoojaController(),
        builder: (controller) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 110.0,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 16 / 9,
                    viewportFraction: 1,
                    onPageChanged: (index, reason) {
                      controller.valueChangeForPoojaListing(index);
                    },
                  ),
                   items: bannerList.map((imageUrl) {
                  //items: images.map((imageUrl) {
                    return ShimmerImageLoader(image:imageUrl.img.toString());
                  }).toList(),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              // CarouselIndicator(
              //   height: 7,
              //   width: 7,
              //   activeColor: primaryColor,
              //   color: Colors.grey,
              //   // count: screenController.poojaModel!.promotionalBanner!.length,
              //   count: images.length,
              //   index: controller.bannerIndexForPoojaListing,
              // ),
            ],
          );
        },
      );


    List<Result> _searchResult = [];
    onSearchTextChanged(String text) async {
      _searchResult.clear();
      if (text.isEmpty) {
        setState(() {});
        return;
      }

      category_list.forEach((userDetail) {
        if (userDetail.name!.toLowerCase().contains(text.toLowerCase()) || userDetail.name!.toLowerCase().contains(text.toLowerCase()))
          _searchResult.add(userDetail);
      });

      setState(() {});
    }

  }


}


