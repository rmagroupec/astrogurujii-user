

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../Models/AstrologerModel.dart';
import '../Models/HomeDataModel.dart';
import '../WebServices/HttpServices.dart';
import 'home_page_state.dart';

class HomePageLogic extends GetxController {
  final HomePageState state = HomePageState();
  final HttpServices _httpServices = HttpServices();

  var astroListChat = <AstroResults>[].obs;
  var astroListVoice = <AstroResults>[].obs;
  var astroListVideo = <AstroResults>[].obs;
  var isLoading = true.obs;
  var bannerData = <HomeBanner>[].obs;
  var banner_ads = <HomeBanner>[].obs;
  var blogData = <Blog>[].obs;
  var astroData = <Astrologer>[].obs;
  var top_astrologer = <Astrologer>[].obs;
  RefreshController refreshController = RefreshController(initialRefresh: false);
  void getAstrologerApiChat() async {

    var res = await _httpServices.astrologer(
        report_id: "",
        expert_astro: "",
        page: "1",
        search: "",
        isChat: "on",
        isVideo: "",
        isVoice: "",
        skill_id: "",
        followAstro: "",
        cat_id: "",
        language_id: "",
        gender: "",
        sort_val: "",
        is_question: "",
        country: "INR");
    if (res!.status == true) {
      astroListChat.value = res.results!;

    }
  }

  void getAstrologerApiVoice() async {
    var res = await _httpServices.astrologer(
        report_id: "",
        expert_astro: "",
        page: "1",
        search: "",
        isChat: "",
        isVideo: "",
        isVoice: "on",
        skill_id: "",
        followAstro: "",
        cat_id: "",
        language_id: "",
        gender: "",
        sort_val: "",
        is_question: "",
        country: "INR");
    if (res!.status == true) {
      try{
        astroListVoice.value = res.results!;
      }catch(e){

      }


    }
  }

  void getAstrologerApiVideo() async {
    var res = await _httpServices.astrologer(
        report_id: "",
        expert_astro: "",
        page: "1",
        search: "",
        isChat: "",
        isVideo: "on",
        isVoice: "",
        skill_id: "",
        followAstro: "",
        cat_id: "",
        language_id: "",
        gender: "",
        sort_val: "",
        is_question: "",
        country: "INR");
    if (res!.status == true) {
      try{
        astroListVideo.value = res.results!;
      }catch(e){

      }

    }
  }


  // @override
  // void onInit() {
  //   // getAstrologerApiChat();
  //   // getAstrologerApiVoice();
  //   // getAstrologerApiVideo();
  //   super.onInit();
  // }
  // @override
  // void onReady() {
  //   // TODO: implement onReady
  //   super.onReady();
  //   getAstrologerApiChat();
  //   getAstrologerApiVoice();
  //   getAstrologerApiVideo();
  // }
  //
}
