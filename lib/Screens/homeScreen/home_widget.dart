import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../MatchingDetails.dart';
import '../Models/HomeDataModel.dart';
import '../WebServices/HttpServices.dart';
import '../controllers/home_page_logic.dart';

final controllerHomePageLogic = Get.put(HomePageLogic());
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
final HttpServices httpServices = HttpServices();
List<HomeBanner> bannerData = [];
List<HomeBanner> banner_ads = [];
List<Live> liveData = [];
List<Data> liveAstrologersList = [];
List<Astrologer> astroData = [];
List<Astrologer> top_astrologer = [];
List<Testimonials> testmonialData = [];
List<Blog> blogData = [];
List<ProductCategory> productData = [];
bool _isLoading = true;
bool isSelected = true;
bool _flexibleUpdateAvailable = false;
var walletAmount = "";
var terms = "https://admin.astrogurujii.com/links/termandcondition";
var privacy = "https://admin.astrogurujii.com/links/privacypolicy";
var aboutus = "https://admin.astrogurujii.com/links/aboutus";
var contactus = "https://api.astrogurujii.com/links/contactus";
var shipinganddelivery =
    "https://api.astrogurujii.com/links/shipinganddelivery";
var cancleandrefund = "https://api.astrogurujii.com/links/cancleandrefund";

var notifications_count = 0;
