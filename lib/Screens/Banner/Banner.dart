import 'package:astro_gurujii/Screens/Models/HomeDataModel.dart';
import 'package:astro_gurujii/Screens/WebviewScreen.dart';
import 'package:astro_gurujii/Screens/poojaScreen/ui/poojaScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../TalkAstrologer/TalkAstrologers.dart';
import '../controllers/home_page_logic.dart';
import '../mall/ShoppingMall.dart';

class BannerScreen extends StatefulWidget {
  final List<HomeBanner> data;
  final String type;

  BannerScreen({Key? key, required this.data, required this.type}) : super(key: key);

  @override
  _BannerScreenState createState() => _BannerScreenState();
}

class _BannerScreenState extends State<BannerScreen> {
  final controllerHomePageLogic = Get.put(HomePageLogic());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double bannerHeight = (widget.type == "normal") ? screenHeight * 0.17 : screenHeight * 0.13;

    return CarouselSlider.builder(
      itemCount: widget.data.length,
      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
        final banner = widget.data[itemIndex];

        // Use the `onTap` handler to navigate based on the banner's redirection type
        return InkWell(
          onTap: () {
            if (banner.redirectTo == "puja") {
              Navigator.push(context, MaterialPageRoute(builder: (context) => PoojaScreen()));
            } else if (banner.redirectTo == "chat") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TalkAstrologer(
                    astroList: controllerHomePageLogic.astroListChat,
                    appBarName: "Chat with Astrologer",
                    chatKey: "on",
                    talkKey: "",
                    screen: "home",
                    skill_id: "",
                    videoKey: "",
                    callType: "chat",
                  ),
                ),
              );
            } else if (banner.redirectTo == "astromall") {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ShoppingMall()));
            }
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                fit: BoxFit.fill,
                image: CachedNetworkImageProvider(banner.img.toString()),
              ),
            ),
          ),
        );
      },
      options: CarouselOptions(
        autoPlay: true,
        height: bannerHeight,
        viewportFraction: 0.95,
        // Optionally adjust aspect ratio or other carousel options here
      ),
    );
  }
}
