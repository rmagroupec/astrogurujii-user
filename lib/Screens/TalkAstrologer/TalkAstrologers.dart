import 'package:astro_gurujii/Screens/AskAQuestion.dart';
import 'package:astro_gurujii/Screens/AstroDetails/AstroDetails.dart';
import 'package:astro_gurujii/Screens/AudiontakeForm.dart';
import 'package:astro_gurujii/Screens/ChatIntakeForm.dart';
import 'package:astro_gurujii/Screens/Login.dart';
import 'package:astro_gurujii/Screens/Models/AstrologerModel.dart';
import 'package:astro_gurujii/Screens/Models/CategoryModel.dart';
import 'package:astro_gurujii/Screens/MyWallet.dart';
import 'package:astro_gurujii/Screens/ReportIntakeForm.dart';
import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Screens/bottomSheet.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:astro_gurujii/Utilities/PrimaryButton.dart';
import 'package:astro_gurujii/widget/astro_badges.dart';
import 'package:astro_gurujii/widget/bottom_navigation_bar_custom.dart';
import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../Utilities/banner_loader.dart';
import '../Models/filter/FilterModel.dart';
import '../controllers/home_page_logic.dart';
import 'bannerModel.dart';

class TalkAstrologer extends StatefulWidget {
  final chatKey;
  final talkKey;
  final videoKey;
  final appBarName;
  final askKey;
  final callType;
  final expert_astro;
  final report;
  final String? reportid;
  var skill_id;
  var followAstro;
  var screen;
  List<AstroResults>? astroList;

  TalkAstrologer(
      {Key? key,
      this.screen,
      this.astroList,
      this.reportid,
      this.followAstro,
      this.skill_id,
      this.report,
      this.expert_astro,
      this.callType,
      this.chatKey,
      this.appBarName,
      this.talkKey,
      this.videoKey,
      this.askKey})
      : super(key: key);

  @override
  _TalkAstrologerState createState() => _TalkAstrologerState();
}

class _TalkAstrologerState extends State<TalkAstrologer> {
  StateSetter? _setState;
  bool _isLoading = true;
  final HttpServices _httpServices = HttpServices();
  List<AstroResults> astroList = [];
  List<CategoryResults> categoryResult = [];
  String wallet = "0.0";
  String? us_name;
  String? us_image;
  bool loading = true;
  bool search_click_status = false;
  String currency = "INR";
  TextEditingController controller = new TextEditingController();
  bool first_lunch = true;
  String _selectedTab = 'skill';

  void getAstrologerApi(
      {String? catId, var gender, var language, var sort}) async {
    var res = await _httpServices.astrologer(
        report_id: widget.reportid ?? '',
        expert_astro: widget.expert_astro ?? '',
        page: "1",
        search: "",
        isChat: widget.chatKey ?? '',
        isVideo: widget.videoKey ?? '',
        isVoice: widget.talkKey ?? '',
        skill_id: widget.skill_id ?? '',
        followAstro: widget.followAstro ?? '',
        cat_id: catId ?? '',
        language_id: language ?? '',
        gender: gender ?? '',
        sort_val: sort ?? '',
        is_question: widget.askKey ?? '',
        country: "INR");
    if (res!.status == true) {
      setState(() {
        astroList = res.results!;
        _isLoading = false;
        _refreshController.refreshCompleted();
      });
    } else {
      Fluttertoast.showToast(msg: res.message!);
      _refreshController.refreshCompleted();
    }
  }

  Future<void> getDataSearchApi(String key, String catId) async {
    var res = await _httpServices.astrologer(
        expert_astro: widget.expert_astro,
        page: "1",
        search: key,
        isChat: widget.chatKey,
        isVideo: widget.videoKey,
        followAstro: widget.followAstro,
        isVoice: widget.talkKey,
        cat_id: catId,
        is_question: widget.askKey.toString(), report_id: '', country: '');
    if (res!.status == true) {
      setState(() {
        if (res.results != null) {
          _searchResult = res.results!;
        }
        _isLoading = false;
      });
    } else {
      _isLoading = false;
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }

  void getProfile() async {
    var res = await _httpServices.profile_api();
    if (res!.status == true) {
      setState(() {
        try {
          currency = "INR";
          wallet = setWallet(
              res.results!.wallet.toString(),
              res.results!.currency.toString(),
              res.results!.wallet_usd.toString());
          us_image = res.results!.profileImg.toString();
          us_name = res.results!.name.toString();
        } catch (e) {
          print('===================' + e.toString());
        }
      });
    } else {
      Fluttertoast.showToast(msg: res.message!);
    }
  }

  Future<void> callNotifyMeApi(String id) async {
    var res = await _httpServices.notifyme(astro_id: id);
    if (res!.status == true) {
      setState(() {
        _isLoading = false;
        Fluttertoast.showToast(msg: res.message!);
      });
    } else {
      _isLoading = false;
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }

  List<Skill> skill = [];
  List<Skill> language = [];
  List<Skill> gender = [];
  List<Skill> sort = [];

  BannerModel? bannerModel;
  bool bannerLoading = false;

  void bannerApi() async {
    setState(() {
      bannerLoading = true;
    });
    await _httpServices.bannerApiFun(widget.callType).then((value) {
      bannerModel = value;
      setState(() {
        bannerLoading = false;
      });
    });
  }

  void getCategoryApi() async {
    var res = await _httpServices.category();
    if (res!.status == true) {
      setState(() {
        if (first_lunch) {
          categoryResult.insert(
              0,
              CategoryResults(
                  image: "",
                  name: "All",
                  createdDate: "",
                  id: "",
                  status: "Active"));
          categoryResult.addAll(res.results!);
          first_lunch = false;
          for (int i = 0; i < res.results!.length; i++) {
            skill.add(Skill(
                name: res.results![i].name,
                id: res.results![i].id.toString(),
                status: false));
          }

          for (int i = 0; i < res.lang!.length; i++) {
            language.add(Skill(
                name: res.lang![i].name,
                id: res.lang![i].sId.toString(),
                status: false));
          }

          gender.add(Skill(name: "Male", id: "Male".toString(), status: false));
          gender.add(
              Skill(name: "Female", id: "Female".toString(), status: false));

          sort.add(Skill(
              name: "Experience : High to Low",
              id: "high_to_low_exp",
              status: false));
          sort.add(Skill(
              name: "Experience : Low to High",
              id: "low_to_high_exp",
              status: false));
          sort.add(Skill(
              name: "Price : High to Low", id: "high_to_low", status: false));
          sort.add(Skill(
              name: "Price : Low to High", id: "low_to_high", status: false));
          sort.add(Skill(
              name: "Rating : High to Low",
              id: "high_to_low_rating",
              status: false));
          sort.add(Skill(
              name: "Rating : Low to High",
              id: "low_to_high_rating",
              status: false));
        }

        _refreshController.refreshCompleted();
        if (categoryResult.length > 0) {
          categoryResult[0].colorStatus = true;
        }
      });
    } else {
      Fluttertoast.showToast(msg: res.message);
      _refreshController.refreshCompleted();
    }
  }

  @override
  void initState() {
    bannerApi();
    getProfile();
    getCategoryApi();

    if (widget.screen == "home" && widget.astroList!.length > 0) {
      setState(() {
        _isLoading = false;
        astroList = widget.astroList!;
      });
    }
    getAstrologerApi(catId: "", language: "", gender: "", sort: "");
    super.initState();
  }

  void _onLeagueRefresh() async {
    getAstrologerApi(catId: "", language: "", gender: "", sort: "");
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final controllerHomePageLogic = Get.put(HomePageLogic());

  int crauselIndex = 0;

  Widget _filterTabItem(
      String tabKey, String label, StateSetter setModalState) {
    return Container(
      height: 60,
      color: (_selectedTab == tabKey) ? Colors.white : Colors.black12,
      child: InkWell(
        onTap: () {
          setModalState(() {
            _selectedTab = tabKey;
          });
        },
        child: Center(
          child: Text(
            label,
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MainHomeScreenWithBottomNavigation()));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: Row(
            children: [
              InkWell(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MainHomeScreenWithBottomNavigation()),
                        (route) => false);
                  },
                  child: Icon(Icons.arrow_back, color: Colors.white)),
              SizedBox(width: 15),
              Text(
                widget.appBarName.toString(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontFamily: "Segoe UI"),
              ),
            ],
          ),
          actions: [
            InkWell(
                onTap: () async {
                  final _prefs = await SharedPreferences.getInstance();
                  if (_prefs.get("is_skip") == "Y") {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => LoginPage()),
                        (route) => false);
                  } else {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => MyWallet()));
                  }
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                        child: CustomText(
                          text: (currency == "USD")
                              ? '\u{0024} ${wallet}'
                              : '\u{20B9} ${wallet}',
                          color: whiteColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    )
                  ],
                )),
            const SizedBox(width: 10),
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
                )),
            const SizedBox(width: 10),
            InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  builder: (context) {
                    return StatefulBuilder(
                      builder:
                          (BuildContext context, StateSetter setModalState) {
                        _setState = setModalState;
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: Scaffold(
                            body: SafeArea(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  "Filter",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: blackColor),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    setModalState(() {
                                                      for (int i = 0;
                                                          i < skill.length;
                                                          i++) {
                                                        skill[i].status = false;
                                                      }
                                                      for (int i = 0;
                                                          i < language.length;
                                                          i++) {
                                                        language[i].status =
                                                            false;
                                                      }
                                                      for (int i = 0;
                                                          i < gender.length;
                                                          i++) {
                                                        gender[i].status = false;
                                                      }
                                                      for (int i = 0;
                                                          i < sort.length;
                                                          i++) {
                                                        sort[i].status = false;
                                                      }
                                                    });
                                                  },
                                                  child: const Text(
                                                    "CLEAR",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Divider(color: Colors.grey),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Column(
                                                  children: [
                                                    _filterTabItem("skill",
                                                        "Skill", setModalState),
                                                    _filterTabItem(
                                                        "language",
                                                        "Languages",
                                                        setModalState),
                                                    _filterTabItem("gender",
                                                        "Gender", setModalState),
                                                    _filterTabItem("sort",
                                                        "Sort by", setModalState),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                  flex: 2,
                                                  child: _widgetfilter()),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    color: Colors.white,
                                    padding: const EdgeInsets.all(5),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        SizedBox(
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  MediaQuery.of(context)
                                                      .padding
                                                      .left -
                                                  MediaQuery.of(context)
                                                      .padding
                                                      .right) *
                                              0.45,
                                          child: ButtonTheme(
                                            child: PrimaryButton(
                                              title: 'CLOSE',
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  MediaQuery.of(context)
                                                      .padding
                                                      .left -
                                                  MediaQuery.of(context)
                                                      .padding
                                                      .right) *
                                              0.45,
                                          child: ButtonTheme(
                                            child: PrimaryButton(
                                              title: 'APPLY',
                                              onPressed: () => applyFilter(),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
              child: SvgPicture.asset(
                'assets/astro/filter.svg',
                height: 20,
                color: whiteColor,
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/background_image.png"),
                  fit: BoxFit.cover)),
          child: (_isLoading)
              ? Center(
                  child: Lottie.asset(
                  'assets/profile/loader.json',
                ))
              : SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: false,
                  header: WaterDropMaterialHeader(),
                  controller: _refreshController,
                  onRefresh: _onLeagueRefresh,
                  child: (astroList.length == 0)
                      ? Center(
                          child: Container(
                          child: CustomText(
                            text:
                                "Sorry!! No Astrologer found\n on this category. Please select other option.",
                            align: TextAlign.center,
                            fontSize: 16,
                            color: blackColor,
                          ),
                        ))
                      : Column(
                          children: [
                            SizedBox(height: 0),
                            (widget.report != "on")
                                ? Container(
                                    height: 45,
                                    width: MediaQuery.of(context).size.width,
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: categoryResult.length,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              for (int i = 0;
                                                  i < categoryResult.length;
                                                  i++) {
                                                setState(() {
                                                  categoryResult[i]
                                                      .colorStatus = false;
                                                });
                                              }
                                              setState(() {
                                                categoryResult[index]
                                                    .colorStatus = true;
                                                getAstrologerApi(
                                                    catId: categoryResult[index]
                                                        .id
                                                        .toString(),
                                                    language: "",
                                                    gender: "",
                                                    sort: "");
                                              });
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: categoryResult[index]
                                                                .colorStatus ==
                                                            true
                                                        ? whiteColor
                                                        : whiteColor,
                                                    border: Border.all(
                                                        color: categoryResult[
                                                                        index]
                                                                    .colorStatus ==
                                                                true
                                                            ? blueColor
                                                            : Color(
                                                                0xFFE0E0E0)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5,
                                                          bottom: 5,
                                                          right: 10,
                                                          left: 10),
                                                  child: Row(
                                                    children: [
                                                      index == 0
                                                          ? Image.asset(
                                                              'assets/images/allIcons.png',
                                                              height: 10,
                                                              width: 10)
                                                          : Image.network(
                                                              categoryResult[
                                                                      index]
                                                                  .image
                                                                  .toString(),
                                                              height: 15,
                                                              width: 15),
                                                      SizedBox(width: 10),
                                                      CustomText(
                                                        text: categoryResult[
                                                                index]
                                                            .name
                                                            .toString(),
                                                        color: categoryResult[
                                                                        index]
                                                                    .colorStatus ==
                                                                true
                                                            ? blackColor
                                                            : Color(0xFF000000),
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  )
                                : SizedBox(),
                            search_click_status
                                ? Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.white,
                                            Colors.grey.shade100
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        border: Border.all(
                                            color: Colors.grey.shade300),
                                        borderRadius:
                                            BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.3),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          vertical: 2.0,
                                          horizontal: 20.0,
                                        ),
                                        dense: true,
                                        title: TextField(
                                          controller: controller,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.only(left: 10),
                                            border: InputBorder.none,
                                            hintText:
                                                'Search Astrologer by name...',
                                            hintStyle: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 16,
                                            ),
                                          ),
                                          onChanged: onSearchTextChanged,
                                        ),
                                        trailing: IconButton(
                                          icon: Icon(
                                            Icons.cancel,
                                            color: Colors.grey.shade600,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              search_click_status =
                                                  !search_click_status;
                                            });
                                            controller.clear();
                                            onSearchTextChanged('');
                                          },
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                            Expanded(
                              child: ListView(children: [
                                Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    bannerLoading == true
                                        ? Container()
                                        : CarouselSlider.builder(
                                            itemCount:
                                                bannerModel!.data!.length,
                                            itemBuilder: (BuildContext context,
                                                int index, int realIndex) {
                                              return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: ShimmerImageLoader(
                                                      image: bannerModel!
                                                          .data![index].img!));
                                            },
                                            options: CarouselOptions(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .26,
                                              viewportFraction: 1.0,
                                              autoPlay: true,
                                              enlargeCenterPage: false,
                                              onPageChanged: (index, reason) {
                                                crauselIndex = index;
                                                setState(() {});
                                              },
                                            ),
                                          ),
                                    bannerLoading == true
                                        ? ShimmerBannerChat()
                                        : (bannerModel!.data != null &&
                                                bannerModel!.data!.isNotEmpty)
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 15),
                                                child: Center(
                                                  child: CarouselIndicator(
                                                    cornerRadius: 100,
                                                    width: 6,
                                                    height: 6,
                                                    count: bannerModel!
                                                        .data!.length,
                                                    index: crauselIndex,
                                                    color: Colors.grey,
                                                    activeColor: Colors.black,
                                                  ),
                                                ),
                                              )
                                            : Center(
                                                child: Text(
                                                    "No banners available")),
                                  ],
                                ),

                                // ─── Main astro list ───────────────────────────
                                controller.text.isEmpty
                                    ? ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            NeverScrollableScrollPhysics(),
                                        itemCount: astroList.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Container(
                                            margin: const EdgeInsets.only(
                                                top: 10, left: 5, right: 5),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.grey,
                                                  offset: Offset(0.0, 1.0),
                                                  blurRadius: 4.0,
                                                ),
                                              ],
                                            ),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (ctx) =>
                                                            AstroDetails(
                                                                astroLogerName:
                                                                    astroList[
                                                                        index]
                                                                        .name,
                                                                categoryId:
                                                                    astroList[
                                                                        index]
                                                                        .id)));
                                              },
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8, bottom: 8),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(width: 10),
                                                        // ── Avatar column ──
                                                        Expanded(
                                                          flex: 1,
                                                          child: InkWell(
                                                            onTap: () {},
                                                            child: Column(
                                                              children: [
                                                                Stack(
                                                                  children: [
                                                                    Align(
                                                                      alignment:
                                                                          AlignmentDirectional
                                                                              .center,
                                                                      child:
                                                                          Container(
                                                                        padding:
                                                                            EdgeInsets.all(3),
                                                                        decoration: BoxDecoration(
                                                                            color: getColorImageBorder(astroList[index], astroList[index].is_busy),
                                                                            shape: BoxShape.circle),
                                                                        child:
                                                                            InkWell(
                                                                          onTap:
                                                                              () {
                                                                            showDialog(
                                                                              context: context,
                                                                              builder: (BuildContext context) {
                                                                                return Dialog(
                                                                                  child: GestureDetector(
                                                                                    onTap: () {
                                                                                      Navigator.of(context).pop();
                                                                                    },
                                                                                    child: Container(
                                                                                      color: Colors.black,
                                                                                      child: Image.network(
                                                                                        astroList[index].profileImg.toString(),
                                                                                        fit: BoxFit.fill,
                                                                                        height: 300,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              },
                                                                            );
                                                                          },
                                                                          child:
                                                                              CircleAvatar(
                                                                            radius:
                                                                                42,
                                                                            backgroundImage:
                                                                                NetworkImage(astroList[index].profileImg.toString()),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              5),
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            98,
                                                                        child:
                                                                            Align(
                                                                          alignment:
                                                                              Alignment.bottomCenter,
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                20,
                                                                            width:
                                                                                55,
                                                                            decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(10),
                                                                                boxShadow: [BoxShadow(color: greyColor12.withOpacity(0.4), blurRadius: 2, spreadRadius: 1, offset: const Offset(1, 2))],
                                                                                color: Colors.black),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.only(left: 4, right: 4),
                                                                              child: Row(
                                                                                children: [
                                                                                  Container(
                                                                                    height: 7,
                                                                                    width: 7,
                                                                                    decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.circular(20),
                                                                                        border: Border.all(color: getColor((widget.callType == "chat") ? astroList[index].isChatOnline! : (widget.callType == "video") ? astroList[index].isVideoOnline! : astroList[index].isVoiceOnline!, astroList[index].is_busy, widget.callType), width: 2),
                                                                                        boxShadow: [BoxShadow(color: greyColor12.withOpacity(0.4), blurRadius: 2, spreadRadius: 1, offset: const Offset(1, 2))],
                                                                                        color: getColor((widget.callType == "chat") ? astroList[index].isChatOnline! : (widget.callType == "video") ? astroList[index].isVideoOnline! : astroList[index].isVoiceOnline!, astroList[index].is_busy, widget.callType)),
                                                                                  ),
                                                                                  SizedBox(width: 5),
                                                                                  Text(
                                                                                    setTitleStatus((widget.callType == "chat") ? astroList[index].isChatOnline! : (widget.callType == "video") ? astroList[index].isVideoOnline! : astroList[index].isVoiceOnline!, astroList[index].is_busy, widget.callType),
                                                                                    style: TextStyle(color: whiteColor, fontSize: 11, fontWeight: FontWeight.normal),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                    height: 7),
                                                                Column(
                                                                  children: [
                                                                    RatingBar
                                                                        .builder(
                                                                      initialRating: double.parse(astroList[index]
                                                                          .avg_rate
                                                                          .toString()),
                                                                      minRating:
                                                                          1,
                                                                      itemSize:
                                                                          18,
                                                                      ignoreGestures:
                                                                          true,
                                                                      direction:
                                                                          Axis.horizontal,
                                                                      allowHalfRating:
                                                                          true,
                                                                      itemCount:
                                                                          5,
                                                                      itemBuilder:
                                                                          (context,
                                                                              _) =>
                                                                              const Icon(Icons.star, color: Colors.amber),
                                                                      onRatingUpdate:
                                                                          (ds) {},
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            4),
                                                                    CustomText(
                                                                      text:
                                                                          "${astroList[index].consult} Orders",
                                                                      color:
                                                                          blackColor,
                                                                      align: TextAlign
                                                                          .start,
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 10),
                                                        // ── Info + button column ──
                                                        Expanded(
                                                          flex: 2,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const SizedBox(
                                                                  height: 7),
                                                              CustomText(
                                                                text: astroList[
                                                                        index]
                                                                    .name
                                                                    .toString(),
                                                                color:
                                                                    blackColor,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              const SizedBox(
                                                                  height: 7),
                                                              CustomText(
                                                                text: astroList[
                                                                        index]
                                                                    .category!
                                                                    .map((e) =>
                                                                        e.name)
                                                                    .toList()
                                                                    .join(', '),
                                                                color:
                                                                    blackColor,
                                                                fontSize: 14,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 2,
                                                              ),
                                                              const SizedBox(
                                                                  height: 7),
                                                              CustomText(
                                                                text: astroList[
                                                                        index]
                                                                    .language!
                                                                    .map((e) =>
                                                                        e.name)
                                                                    .toList()
                                                                    .join(','),
                                                                color:
                                                                    blackColor,
                                                                fontSize: 14,
                                                              ),
                                                              const SizedBox(
                                                                  height: 7),
                                                              CustomText(
                                                                text:
                                                                    "Exp : ${astroList[index].experience} Years",
                                                                color:
                                                                    blackColor,
                                                                fontSize: 14,
                                                              ),
                                                              const SizedBox(
                                                                  height: 7),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  // Price
                                                                  Container(
                                                                    child: Row(
                                                                      children: [
                                                                        (!astroList[index].per_min_chat_offer.isEmpty)
                                                                            ? Text(
                                                                                "${setOfferCallingrate(widget.callType, index)}",
                                                                                style: TextStyle(fontSize: 18, decoration: TextDecoration.lineThrough, color: Colors.black))
                                                                            : Container(),
                                                                        CustomText(
                                                                          text:
                                                                              "${setCallingrate(widget.callType, index)}",
                                                                          fontSize:
                                                                              18,
                                                                          color:
                                                                              blackColor,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  // ── Action button ──
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            12),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        // CHAT button
                                                                        widget.chatKey ==
                                                                                "on"
                                                                            ? InkWell(
                                                                                onTap: () {
                                                                                                                                                        if (astroList[index]
                                                                          .is_busy ==
                                                                          0 &&
                                                                          (astroList[index]
                                                                              .isChatOnline ==
                                                                              "on" || astroList[index].isEmergencyChat)) {
                                                                                    var callRate = (astroList[index].per_min_chat_offer.isEmpty) ? astroList[index].perMinChat.toString() : astroList[index].per_min_chat_offer.toString();
                                                                                    if (setCheckForChat(wallet.toString(), callRate)) {
                                                                                      bottomSheet(us_name!, us_image!, astroList[index].astro_number.toString(), context, astroList[index].id.toString(), (astroList[index].per_min_chat_offer.isEmpty) ? astroList[index].perMinChat.toString() : astroList[index].per_min_chat_offer.toString(), "5", astroList[index].profileImg!, currency, "+91", astroList[index].name!, wallet.toString(), "chat", loading);
                                                                                    } else {
                                                                                      Navigator.push(context, MaterialPageRoute(builder: (ctx) => ChatIntakeForm(wallet: wallet.toString(), rate: callRate, name: astroList[index].name!, profile: astroList[index].profileImg!, astrologer_id: astroList[index].id.toString())));
                                                                                    }
                                                                                  } else {
                                                                                    callNotifyMeApi(astroList[index].id.toString());
                                                                                  }
                                                                                },
                                                                                child: BoostWrap(
                                                                                  show: astroList[index].isBoostChat,
                                                                                  child: EmergencyWrap(
                                                                                    show: astroList[index].isEmergencyChat,
                                                                                    child: Container(
                                                                                      height: MediaQuery.of(context).size.height * 0.045,
                                                                                      decoration: BoxDecoration(
                                                                                        border: Border.all(width: 2, color: setBorderColorChat(astroList[index].isChatOnline!, astroList[index].is_busy)),
                                                                                        borderRadius: BorderRadius.circular(20),
                                                                                      ),
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.only(left: 20, right: 20),
                                                                                        child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                          children: [
                                                                                            Text(
                                                                                              setTitle(astroList[index].isChatOnline!, astroList[index].is_busy, "CHAT NOW"),
                                                                                              style: TextStyle(color: setBorderColorChat(astroList[index].isChatOnline!, astroList[index].is_busy), fontSize: MediaQuery.of(context).size.height * 0.018, fontWeight: FontWeight.bold),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            // TALK / VOICE button
                                                                            : widget.talkKey == "on"
                                                                                ? InkWell(
                                                                                    onTap: () {
                                                                                                                                                            if (astroList[index]
                                                                          .is_busy ==
                                                                          0 &&
                                                                          (astroList[index]
                                                                              .isVoiceOnline ==
                                                                              "on" || astroList[index].isEmergencyCall)) {
                                                                                        var callRate = (astroList[index].per_min_voice_call_offer.isEmpty) ? astroList[index].perMinVoiceCall.toString() : astroList[index].per_min_voice_call_offer.toString();
                                                                                        if (setCheckForChat(wallet.toString(), callRate)) {
                                                                                          bottomSheet(us_name!, us_image!, astroList[index].astro_number.toString(), context, astroList[index].id.toString(), (astroList[index].per_min_voice_call_offer.isEmpty) ? astroList[index].perMinVoiceCall.toString() : astroList[index].per_min_voice_call_offer.toString(), "5", astroList[index].profileImg!, currency, "+91", astroList[index].name!, wallet.toString(), "audio", loading);
                                                                                        } else {
                                                                                          bottomSheet(us_name!, us_image!, astroList[index].astro_number.toString(), context, astroList[index].id.toString(), (astroList[index].per_min_voice_call_offer.isEmpty) ? astroList[index].perMinVoiceCall.toString() : astroList[index].per_min_voice_call_offer.toString(), "5", astroList[index].profileImg!, currency, "+91", astroList[index].name!, wallet.toString(), "audio", loading);
                                                                                        }
                                                                                      } else {
                                                                                        callNotifyMeApi(astroList[index].id.toString());
                                                                                      }
                                                                                    },
                                                                                    child: BoostWrap(
                                                                                      show: astroList[index].isBoostCall,
                                                                                      child: EmergencyWrap(
                                                                                        show: astroList[index].isEmergencyCall,
                                                                                        child: Container(
                                                                                          height: MediaQuery.of(context).size.height * 0.045,
                                                                                          decoration: BoxDecoration(
                                                                                            border: Border.all(width: 2, color: setBorderColorChat(astroList[index].isVoiceOnline!, astroList[index].is_busy)),
                                                                                            borderRadius: BorderRadius.circular(20),
                                                                                          ),
                                                                                          child: Padding(
                                                                                            padding: const EdgeInsets.only(left: 20, right: 20),
                                                                                            child: Row(
                                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                                              children: [
                                                                                                Text(
                                                                                                  setTitle(astroList[index].isVoiceOnline!, astroList[index].is_busy, "Talk NOW"),
                                                                                                  style: TextStyle(color: setBorderColorChat(astroList[index].isVoiceOnline!, astroList[index].is_busy), fontSize: MediaQuery.of(context).size.height * 0.018, fontWeight: FontWeight.bold),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                // ASK button
                                                                                : widget.askKey == "on"
                                                                                    ? InkWell(
                                                                                        onTap: () {
                                                                                          Navigator.push(context, MaterialPageRoute(builder: (_) => AskAQuestion(astro_id: astroList[index].id.toString(), price: astroList[index].perQuestionPrice.toString())));
                                                                                        },
                                                                                        child: Container(
                                                                                          height: 35,
                                                                                          margin: const EdgeInsets.only(right: 30, top: 10),
                                                                                          width: 160,
                                                                                          alignment: Alignment.center,
                                                                                          decoration: BoxDecoration(border: Border.all(color: astroList[index].isChatOnline! == "off" ? Color(0xFFD9D9D9) : blueColor), borderRadius: BorderRadius.circular(30)),
                                                                                          child: Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                            children: [
                                                                                              SvgPicture.asset("assets/images/chat_astro.svg", height: 27),
                                                                                              SizedBox(width: 10),
                                                                                              Text("Ask NOW", style: TextStyle(color: astroList[index].isChatOnline! == "off" ? Color(0xFFAAA8A8) : blueColor, fontSize: 13, fontWeight: FontWeight.w500)),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      )
                                                                                    // REPORT button
                                                                                    : widget.report == "on"
                                                                                        ? InkWell(
                                                                                            onTap: () {
                                                                                              Navigator.push(context, MaterialPageRoute(builder: (_) => ReportIntakeForm(astroId: astroList[index].id.toString(), report_id: widget.reportid!, amount: astroList[index].perQuestionPrice.toString())));
                                                                                            },
                                                                                            child: Container(
                                                                                              height: 35,
                                                                                              margin: const EdgeInsets.only(right: 30, top: 10),
                                                                                              width: 160,
                                                                                              alignment: Alignment.center,
                                                                                              decoration: BoxDecoration(border: Border.all(color: astroList[index].isChatOnline! == "off" ? Color(0xFFD9D9D9) : blueColor), borderRadius: BorderRadius.circular(30)),
                                                                                              child: Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                                children: [
                                                                                                  SvgPicture.asset("assets/images/report.svg", height: 27),
                                                                                                  SizedBox(width: 10),
                                                                                                  Text("Ask Report", style: TextStyle(color: astroList[index].isChatOnline! == "off" ? Color(0xFFAAA8A8) : blueColor, fontSize: 13, fontWeight: FontWeight.w500)),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          )
                                                                                        // VIDEO button
                                                                                        : widget.videoKey == "on"
                                                                                            ? InkWell(
                                                                                                onTap: () {
                                                                                                  if (astroList[index].is_busy == 0 && astroList[index].isVideoOnline! == "on") {
                                                                                                    bottomSheet(us_name!, us_image!, astroList[index].astro_number.toString(), context, astroList[index].id.toString(), (astroList[index].per_min_video_call_offer.isEmpty) ? astroList[index].perMinVideoCall.toString() : astroList[index].per_min_video_call_offer.toString(), "5", astroList[index].profileImg!, currency, "+91", astroList[index].name!, wallet.toString(), "video", loading);
                                                                                                  } else {
                                                                                                    callNotifyMeApi(astroList[index].id.toString());
                                                                                                  }
                                                                                                },
                                                                                                child: BoostWrap(
                                                                                                  show: astroList[index].isBoostVideo,
                                                                                                  child: EmergencyWrap(
                                                                                                    show: astroList[index].isEmergencyCall,
                                                                                                    child: Container(
                                                                                                      height: 35,
                                                                                                      alignment: Alignment.center,
                                                                                                      decoration: BoxDecoration(color: setBorderColorChat(astroList[index].isVideoOnline!, astroList[index].is_busy), borderRadius: BorderRadius.circular(10)),
                                                                                                      child: Row(
                                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                                        children: [
                                                                                                          SizedBox(width: 10),
                                                                                                          Text(setTitle(astroList[index].isVideoOnline!, astroList[index].is_busy, "Video Call"), style: TextStyle(color: whiteColor, fontSize: 13, fontWeight: FontWeight.w500)),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              )
                                                                                            : SizedBox(),
                                                                        (astroList[index].is_busy == 1 && (widget.callType == "audio" || widget.callType == "chat" || widget.callType == "video"))
                                                                            ? Align(
                                                                                alignment: Alignment.center,
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.only(left: 0, top: 3),
                                                                                  child: CustomText(
                                                                                    text: "wait - ${durationToString(astroList[index].watting_time)}",
                                                                                    fontSize: 12,
                                                                                    color: redColor,
                                                                                  ),
                                                                                ))
                                                                            : SizedBox(),
                                                                      ],
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
                                                ],
                                              ),
                                            ),
                                          );
                                        })
                                    // ─── Search results list ───────────────────
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            NeverScrollableScrollPhysics(),
                                        itemCount: _searchResult.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Container(
                                            margin: const EdgeInsets.only(
                                                top: 10, left: 5, right: 5),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.grey,
                                                  offset: Offset(0.0, 1.0),
                                                  blurRadius: 4.0,
                                                ),
                                              ],
                                            ),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (ctx) =>
                                                            AstroDetails(
                                                                astroLogerName:
                                                                    _searchResult[
                                                                        index]
                                                                        .name,
                                                                categoryId:
                                                                    _searchResult[
                                                                        index]
                                                                        .id)));
                                              },
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8, bottom: 8),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(width: 10),
                                                        // ── Avatar column ──
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            child: InkWell(
                                                              onTap: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (ctx) => AstroDetails(
                                                                            astroLogerName: _searchResult[index].name,
                                                                            categoryId: _searchResult[index].id)));
                                                              },
                                                              child: Column(
                                                                children: [
                                                                  Stack(
                                                                    children: [
                                                                      Align(
                                                                        alignment:
                                                                            AlignmentDirectional.center,
                                                                        child:
                                                                            Container(
                                                                          padding:
                                                                              EdgeInsets.all(3),
                                                                          decoration: BoxDecoration(
                                                                              color: getColorImageBorder(_searchResult[index], _searchResult[index].is_busy),
                                                                              shape: BoxShape.circle),
                                                                          child:
                                                                              CircleAvatar(radius: 42, backgroundImage: NetworkImage(_searchResult[index].profileImg.toString())),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            top:
                                                                                5),
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              98,
                                                                          child:
                                                                              Align(
                                                                            alignment:
                                                                                Alignment.bottomCenter,
                                                                            child: Container(
                                                                                height: 20,
                                                                                width: 55,
                                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: greyColor12.withOpacity(0.4), blurRadius: 2, spreadRadius: 1, offset: const Offset(1, 2))], color: Colors.black),
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.only(left: 4, right: 4),
                                                                                  child: Row(
                                                                                    children: [
                                                                                      Container(
                                                                                        height: 7,
                                                                                        width: 7,
                                                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: getColor((widget.callType == "chat") ? _searchResult[index].isChatOnline! : (widget.callType == "video") ? _searchResult[index].isVideoOnline! : _searchResult[index].isVoiceOnline!, _searchResult[index].is_busy, widget.callType), width: 2), boxShadow: [BoxShadow(color: greyColor12.withOpacity(0.4), blurRadius: 2, spreadRadius: 1, offset: const Offset(1, 2))], color: getColor((widget.callType == "chat") ? _searchResult[index].isChatOnline! : (widget.callType == "video") ? _searchResult[index].isVideoOnline! : _searchResult[index].isVoiceOnline!, _searchResult[index].is_busy, widget.callType)),
                                                                                      ),
                                                                                      SizedBox(width: 5),
                                                                                      Text(setTitleStatus((widget.callType == "chat") ? _searchResult[index].isChatOnline! : (widget.callType == "video") ? _searchResult[index].isVideoOnline! : _searchResult[index].isVoiceOnline!, _searchResult[index].is_busy, widget.callType), style: TextStyle(color: whiteColor, fontSize: 11, fontWeight: FontWeight.normal))
                                                                                    ],
                                                                                  ),
                                                                                )),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          7),
                                                                  Column(
                                                                    children: [
                                                                      RatingBar
                                                                          .builder(
                                                                        initialRating: double.parse(_searchResult[index]
                                                                            .avg_rate
                                                                            .toString()),
                                                                        minRating:
                                                                            1,
                                                                        itemSize:
                                                                            18,
                                                                        ignoreGestures:
                                                                            true,
                                                                        direction:
                                                                            Axis.horizontal,
                                                                        allowHalfRating:
                                                                            true,
                                                                        itemCount:
                                                                            5,
                                                                        itemBuilder: (context,
                                                                                _) =>
                                                                            const Icon(Icons.star, color: Colors.amber),
                                                                        onRatingUpdate:
                                                                            (ds) {},
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              4),
                                                                      CustomText(
                                                                        text:
                                                                            "${_searchResult[index].consult} Orders",
                                                                        color:
                                                                            blackColor,
                                                                        align: TextAlign
                                                                            .start,
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 10),
                                                        // ── Info + button column ──
                                                        Expanded(
                                                          flex: 2,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const SizedBox(
                                                                  height: 7),
                                                              CustomText(
                                                                text: _searchResult[
                                                                        index]
                                                                    .name
                                                                    .toString(),
                                                                color:
                                                                    blackColor,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              const SizedBox(
                                                                  height: 7),
                                                              CustomText(
                                                                text: _searchResult[
                                                                        index]
                                                                    .category!
                                                                    .map((e) =>
                                                                        e.name)
                                                                    .toList()
                                                                    .join(', '),
                                                                color:
                                                                    blackColor,
                                                                fontSize: 14,
                                                                maxLines: 2,
                                                              ),
                                                              const SizedBox(
                                                                  height: 7),
                                                              CustomText(
                                                                text: _searchResult[
                                                                        index]
                                                                    .language!
                                                                    .map((e) =>
                                                                        e.name)
                                                                    .toList()
                                                                    .join(','),
                                                                color:
                                                                    blackColor,
                                                                fontSize: 14,
                                                              ),
                                                              const SizedBox(
                                                                  height: 7),
                                                              CustomText(
                                                                text:
                                                                    "Exp : ${_searchResult[index].experience} Years",
                                                                color:
                                                                    blackColor,
                                                                fontSize: 14,
                                                              ),
                                                              const SizedBox(
                                                                  height: 7),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  // Price
                                                                  Container(
                                                                    child: Row(
                                                                      children: [
                                                                        (!_searchResult[index].per_min_chat_offer.isEmpty)
                                                                            ? Text(
                                                                                "${setOfferCallingrate(widget.callType, index)}",
                                                                                style: TextStyle(fontSize: 18, decoration: TextDecoration.lineThrough, color: Colors.black))
                                                                            : Container(),
                                                                        CustomText(
                                                                          text:
                                                                              "${setSearchCallingrate(widget.callType, index)}",
                                                                          fontSize:
                                                                              18,
                                                                          color:
                                                                              blackColor,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  // ── Action button ──
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            12),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        // CHAT button
                                                                        widget.chatKey ==
                                                                                "on"
                                                                            ? InkWell(
                                                                                onTap: () {
                                                                                                                                                          if (_searchResult[index]
                                                                            .is_busy ==
                                                                            0 &&
                                                                            (_searchResult[index]
                                                                                .isChatOnline ==
                                                                                "on" || _searchResult[index].isEmergencyChat)) {
                                                                                    var callRate = (_searchResult[index].per_min_chat_offer.isEmpty) ? _searchResult[index].perMinChat.toString() : _searchResult[index].per_min_chat_offer.toString();
                                                                                    if (setCheckForChat(wallet.toString(), callRate)) {
                                                                                      bottomSheet(us_name!, us_image!, _searchResult[index].astro_number.toString(), context, _searchResult[index].id.toString(), (_searchResult[index].per_min_chat_offer.isEmpty) ? _searchResult[index].perMinChat.toString() : _searchResult[index].per_min_chat_offer.toString(), "5", _searchResult[index].profileImg!, currency, "+91", _searchResult[index].name!, wallet.toString(), "chat", loading);
                                                                                    } else {
                                                                                      Navigator.push(context, MaterialPageRoute(builder: (ctx) => ChatIntakeForm(wallet: wallet.toString(), rate: callRate, name: _searchResult[index].name!, profile: _searchResult[index].profileImg!, astrologer_id: _searchResult[index].id.toString())));
                                                                                    }
                                                                                  } else {
                                                                                    callNotifyMeApi(_searchResult[index].id.toString());
                                                                                  }
                                                                                },
                                                                                child: BoostWrap(
                                                                                  show: _searchResult[index].isBoostChat,
                                                                                  child: EmergencyWrap(
                                                                                    show: _searchResult[index].isEmergencyChat,
                                                                                    child: Container(
                                                                                      height: MediaQuery.of(context).size.height * 0.045,
                                                                                      decoration: BoxDecoration(
                                                                                        border: Border.all(width: 2, color: setBorderColorChat(_searchResult[index].isChatOnline!, _searchResult[index].is_busy)),
                                                                                        borderRadius: BorderRadius.circular(20),
                                                                                      ),
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.only(left: 20, right: 20),
                                                                                        child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                          children: [
                                                                                            Text(
                                                                                              setTitle(_searchResult[index].isChatOnline!, _searchResult[index].is_busy, "CHAT NOW"),
                                                                                              style: TextStyle(color: setBorderColorChat(_searchResult[index].isChatOnline!, _searchResult[index].is_busy), fontSize: MediaQuery.of(context).size.height * 0.018, fontWeight: FontWeight.bold),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            // TALK / VOICE button
                                                                            : widget.talkKey == "on"
                                                                                ? InkWell(
                                                                                    onTap: () {
                                                                                                                                                              if (_searchResult[index]
                                                                            .is_busy ==
                                                                            0 &&
                                                                            (_searchResult[index]
                                                                                .isVoiceOnline ==
                                                                                "on" || _searchResult[index].isEmergencyCall)) {
                                                                                        var callRate = (_searchResult[index].per_min_voice_call_offer.isEmpty) ? _searchResult[index].perMinVoiceCall.toString() : _searchResult[index].per_min_voice_call_offer.toString();
                                                                                        if (setCheckForChat(wallet.toString(), callRate)) {
                                                                                          bottomSheet(us_name!, us_image!, _searchResult[index].astro_number.toString(), context, _searchResult[index].id.toString(), (_searchResult[index].per_min_voice_call_offer.isEmpty) ? _searchResult[index].perMinVoiceCall.toString() : _searchResult[index].per_min_voice_call_offer.toString(), "5", _searchResult[index].profileImg!, currency, "+91", _searchResult[index].name!, wallet.toString(), "audio", loading);
                                                                                        } else {
                                                                                          bottomSheet(us_name!, us_image!, astroList[index].astro_number.toString(), context, astroList[index].id.toString(), (astroList[index].per_min_voice_call_offer.isEmpty) ? astroList[index].perMinVoiceCall.toString() : astroList[index].per_min_voice_call_offer.toString(), "5", astroList[index].profileImg!, currency, "+91", astroList[index].name!, wallet.toString(), "audio", loading);
                                                                                        }
                                                                                      } else {
                                                                                        callNotifyMeApi(_searchResult[index].id.toString());
                                                                                      }
                                                                                    },
                                                                                    child: BoostWrap(
                                                                                      show: _searchResult[index].isBoostCall,
                                                                                      child: EmergencyWrap(
                                                                                        show: _searchResult[index].isEmergencyCall,
                                                                                        child: Container(
                                                                                          height: MediaQuery.of(context).size.height * 0.045,
                                                                                          decoration: BoxDecoration(
                                                                                            border: Border.all(width: 2, color: setBorderColorChat(_searchResult[index].isVoiceOnline!, _searchResult[index].is_busy)),
                                                                                            borderRadius: BorderRadius.circular(20),
                                                                                          ),
                                                                                          child: Padding(
                                                                                            padding: const EdgeInsets.only(left: 20, right: 20),
                                                                                            child: Row(
                                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                                              children: [
                                                                                                Text(
                                                                                                  setTitle(_searchResult[index].isVoiceOnline!, _searchResult[index].is_busy, "Talk NOW"),
                                                                                                  style: TextStyle(color: setBorderColorChat(_searchResult[index].isVoiceOnline!, _searchResult[index].is_busy), fontSize: MediaQuery.of(context).size.height * 0.018, fontWeight: FontWeight.bold),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                // ASK button
                                                                                : widget.askKey == "on"
                                                                                    ? InkWell(
                                                                                        onTap: () {
                                                                                          Navigator.push(context, MaterialPageRoute(builder: (_) => AskAQuestion(astro_id: _searchResult[index].id.toString(), price: _searchResult[index].perQuestionPrice.toString())));
                                                                                        },
                                                                                        child: Container(
                                                                                          height: 35,
                                                                                          margin: const EdgeInsets.only(right: 30, top: 10),
                                                                                          width: 160,
                                                                                          alignment: Alignment.center,
                                                                                          decoration: BoxDecoration(border: Border.all(color: _searchResult[index].isChatOnline! == "off" ? Color(0xFFD9D9D9) : blueColor), borderRadius: BorderRadius.circular(30)),
                                                                                          child: Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                            children: [
                                                                                              SvgPicture.asset("assets/images/chat_astro.svg", height: 27),
                                                                                              SizedBox(width: 10),
                                                                                              Text("Ask NOW", style: TextStyle(color: _searchResult[index].isChatOnline! == "off" ? Color(0xFFAAA8A8) : blueColor, fontSize: 13, fontWeight: FontWeight.w500)),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      )
                                                                                    // REPORT button
                                                                                    : widget.report == "on"
                                                                                        ? InkWell(
                                                                                            onTap: () {
                                                                                              Navigator.push(context, MaterialPageRoute(builder: (_) => ReportIntakeForm(astroId: _searchResult[index].id.toString(), report_id: widget.reportid!, amount: _searchResult[index].perQuestionPrice.toString())));
                                                                                            },
                                                                                            child: Container(
                                                                                              height: 35,
                                                                                              margin: const EdgeInsets.only(right: 30, top: 10),
                                                                                              width: 160,
                                                                                              alignment: Alignment.center,
                                                                                              decoration: BoxDecoration(border: Border.all(color: _searchResult[index].isChatOnline! == "off" ? Color(0xFFD9D9D9) : blueColor), borderRadius: BorderRadius.circular(30)),
                                                                                              child: Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                                children: [
                                                                                                  SvgPicture.asset("assets/images/report.svg", height: 27),
                                                                                                  SizedBox(width: 10),
                                                                                                  Text("Ask Report", style: TextStyle(color: _searchResult[index].isChatOnline! == "off" ? Color(0xFFAAA8A8) : blueColor, fontSize: 13, fontWeight: FontWeight.w500)),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          )
                                                                                        // VIDEO button
                                                                                        : widget.videoKey == "on"
                                                                                            ? InkWell(
                                                                                                onTap: () {
                                                                                                  if (_searchResult[index].is_busy == 0 && _searchResult[index].isVideoOnline! == "on") {
                                                                                                    bottomSheet(us_name!, us_image!, _searchResult[index].astro_number.toString(), context, _searchResult[index].id.toString(), (_searchResult[index].per_min_video_call_offer.isEmpty) ? _searchResult[index].perMinVideoCall.toString() : _searchResult[index].per_min_video_call_offer.toString(), "5", _searchResult[index].profileImg!, currency, "+91", _searchResult[index].name!, wallet.toString(), "video", loading);
                                                                                                  } else {
                                                                                                    callNotifyMeApi(_searchResult[index].id.toString());
                                                                                                  }
                                                                                                },
                                                                                                child: BoostWrap(
                                                                                                  show: _searchResult[index].isBoostVideo,
                                                                                                  child: EmergencyWrap(
                                                                                                    show: _searchResult[index].isEmergencyCall,
                                                                                                    child: Container(
                                                                                                      height: 35,
                                                                                                      alignment: Alignment.center,
                                                                                                      decoration: BoxDecoration(color: setBorderColorChat(astroList[index].isVideoOnline!, _searchResult[index].is_busy), borderRadius: BorderRadius.circular(10)),
                                                                                                      child: Row(
                                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                                        children: [
                                                                                                          SizedBox(width: 10),
                                                                                                          Text(setTitle(_searchResult[index].isVideoOnline!, _searchResult[index].is_busy, "Video Call"), style: TextStyle(color: whiteColor, fontSize: 13, fontWeight: FontWeight.w500)),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              )
                                                                                            : SizedBox(),
                                                                        (_searchResult[index].is_busy == 1 && (widget.callType == "audio" || widget.callType == "chat" || widget.callType == "video"))
                                                                            ? Align(
                                                                                alignment: Alignment.center,
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.only(left: 0, top: 3),
                                                                                  child: CustomText(
                                                                                    text: "wait - ${durationToString(_searchResult[index].watting_time)}",
                                                                                    fontSize: 12,
                                                                                    color: redColor,
                                                                                  ),
                                                                                ))
                                                                            : SizedBox(),
                                                                      ],
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
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                              ]),
                            )
                          ],
                        ),
                ),
      ),
      )
    );
  }

  List<AstroResults> _searchResult = [];

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    astroList.forEach((userDetail) {
      if (userDetail.name!.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(userDetail);
    });
    setState(() {});
  }

  setBorderColorChat(String Online, int is_busy) {
    if (Online == "on" && is_busy == 0) {
      return Colors.red;
    } else if (Online == "off") {
      return offlineColor;
    } else if (is_busy == 1) {
      return busyColor;
    } else {
      return offlineColor;
    }
  }

  String setTitle(String Online, int is_busy, String title) {
    if (Online == "on" && is_busy == 0 && title == "CHAT NOW") {
      return "Chat";
    } else if (Online == "on" && is_busy == 0 && title == "Talk NOW") {
      return "Call";
    } else if (Online == "on" && is_busy == 0 && title == "Video Call") {
      return "Video Call";
    } else if (Online == "off") {
      return "Offline";
    } else if (is_busy == 1) {
      return "Notify me";
    } else {
      return "Busy";
    }
  }

  getCountryCode() async {
    return "INR";
  }

  String setOfferCallingrate(callType, int index) {
    var price = "";
    if (callType == "chat") {
      price = "\u{20B9}${astroList[index].per_min_chat_offer}";
      return price;
    } else if (callType == "video") {
      price = "\u{20B9}${astroList[index].per_min_video_call_offer}";
      return price;
    } else if (callType == "audio") {
      price = "\u{20B9}${astroList[index].per_min_voice_call_offer}";
      return price;
    } else if (callType == "ask") {
      return "";
    } else if (callType == "report") {
      return "";
    }
    return '';
  }

  String setOfferSearchCallingrate(callType, int index) {
    var price = "";
    if (callType == "chat") {
      price = "\u{20B9}${_searchResult[index].per_min_chat_offer}";
      return price;
    } else if (callType == "video") {
      price = "\u{20B9}${_searchResult[index].per_min_video_call_offer}";
      return price;
    } else if (callType == "audio") {
      price = "\u{20B9}${_searchResult[index].per_min_voice_call_offer}";
      return price;
    } else if (callType == "ask") {
      return "";
    } else if (callType == "report") {
      return "";
    }
    return '';
  }

  String setCallingrate(callType, int index) {
    var price = "";
    if (callType == "chat") {
      price = "\u{20B9}${astroList[index].perMinChat}/min";
      return price;
    } else if (callType == "video") {
      price = "\u{20B9}${astroList[index].perMinVideoCall}/min.";
      return price;
    } else if (callType == "audio") {
      price = "\u{20B9}${astroList[index].perMinVoiceCall}/min.";
      return price;
    } else if (callType == "ask") {
      price = "\u{20B9}${astroList[index].perQuestionPrice}/Question.";
      return price;
    } else if (callType == "report") {
      price = "\u{20B9}${astroList[index].report_price}";
      return price;
    }
    return '';
  }

  String setSearchCallingrate(callType, int index) {
    var price = "";
    if (callType == "chat") {
      price = "\u{20B9}${_searchResult[index].perMinChat}/min.";
      return price;
    } else if (callType == "video") {
      price = "\u{20B9}${_searchResult[index].perMinVideoCall}/min.";
      return price;
    } else if (callType == "audio") {
      price = "\u{20B9}${_searchResult[index].perMinVoiceCall}/min.";
      return price;
    } else if (callType == "ask") {
      price = "\u{20B9}${_searchResult[index].perQuestionPrice}/Question.";
      return price;
    } else if (callType == "report") {
      price = "\u{20B9}${_searchResult[index].report_price}";
      return price;
    }
    return '';
  }

  String setWallet(String wallet, String currency, String usdWallet) {
    return "${wallet}";
  }

  String durationToString(int minutes) {
    try {
      var d = Duration(minutes: minutes);
      List<String> parts = d.toString().split(':');
      if (d.inHours > 0) {
        return '${parts[0].padLeft(2, '0')}h ${int.parse(parts[1]).toString()}m';
      } else {
        if (minutes == 0) {
          return '0 m';
        } else {
          return '${int.parse(parts[1]).toString()} m';
        }
      }
    } catch (e) {
      return '5 m';
    }
  }

  bool setCheckForChat(String userWallet, String video_rate) {
    var totalMin = 0.0;
    totalMin = double.parse(userWallet) / double.parse(video_rate);
    if (totalMin < 5) {
      return true;
    }
    return false;
  }

  String setTitleStatus(String Online, int is_busy, String title) {
    if (Online == "on" && is_busy == 0 && title == "chat") {
      return "Online";
    } else if (Online == "on" && is_busy == 0 && title == "audio") {
      return "Online";
    } else if (Online == "on" && is_busy == 0 && title == "video") {
      return "online";
    } else if (Online != "on") {
      return "Offline";
    } else if (is_busy == 1) {
      return "Busy";
    } else {
      return "Busy";
    }
  }

  getColorImageBorder(AstroResults astroResults, int is_busy) {
    var Online = '';
    if (widget.callType == "chat") {
      Online = astroResults.isChatOnline!;
    } else if (widget.callType == "audio") {
      Online = astroResults.isVoiceOnline!;
    } else if (widget.callType == "video") {
      Online = astroResults.isVideoOnline!;
    }
    if (Online == "on" && is_busy == 0) {
      return Colors.green;
    } else if (Online != "on") {
      return Colors.grey;
    } else if (is_busy == 1) {
      return Colors.red;
    } else {
      return Colors.red;
    }
  }

  getColor(String Online, int is_busy, String title) {
    if (Online == "on" && is_busy == 0 && title == "chat") {
      return Colors.green;
    } else if (Online == "on" && is_busy == 0 && title == "audio") {
      return Colors.green;
    } else if (Online == "on" && is_busy == 0 && title == "video") {
      return Colors.green;
    } else if (Online != "on") {
      return Colors.grey;
    } else if (is_busy == 1) {
      return Colors.red;
    } else {
      return Colors.red;
    }
  }

  Widget _widgetfilter() {
    switch (_selectedTab) {
      case 'skill':
        return SkillWidet();
      case 'language':
        return LanguageWidet();
      case 'gender':
        return GenderWidet();
      case 'sort':
        return SortWidet();
      default:
        return Container();
    }
  }

  Widget SkillWidet() {
    return Column(
      children: List.generate(skill.length, (i) {
        return Container(
          child: InkWell(
            onTap: () {
              _setState!(() {
                skill[i].status = !skill[i].status;
              });
            },
            child: Column(
              children: [
                Container(
                  height: 40,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        (skill[i].status == true)
                            ? SvgPicture.asset(
                                'assets/profile/active_checkbox.svg')
                            : SvgPicture.asset(
                                'assets/profile/inactive_checkbox.svg'),
                        SizedBox(width: 10),
                        Text("  " + skill[i].name.toUpperCase(),
                            style:
                                TextStyle(fontSize: 16, color: Colors.black),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10)
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget LanguageWidet() {
    return Column(
      children: List.generate(language.length, (i) {
        return Container(
          child: InkWell(
            onTap: () {
              _setState!(() {
                language[i].status = !language[i].status;
              });
            },
            child: Column(
              children: [
                Container(
                  height: 40,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        (language[i].status == true)
                            ? SvgPicture.asset(
                                'assets/profile/active_checkbox.svg')
                            : SvgPicture.asset(
                                'assets/profile/inactive_checkbox.svg'),
                        SizedBox(width: 10),
                        Text("  " + language[i].name.toUpperCase(),
                            style:
                                TextStyle(fontSize: 16, color: Colors.black),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10)
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget GenderWidet() {
    return Column(
      children: List.generate(gender.length, (i) {
        return Container(
          child: InkWell(
            onTap: () {
              _setState!(() {
                for (int j = 0; j < gender.length; j++) {
                  gender[j].status = false;
                }
                gender[i].status = true;
              });
            },
            child: Column(
              children: [
                Container(
                  height: 40,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        (gender[i].status == true)
                            ? SvgPicture.asset(
                                'assets/profile/active_radio_btn.svg')
                            : SvgPicture.asset(
                                'assets/profile/inactive_radio_btn.svg'),
                        SizedBox(width: 10),
                        Text("  " + gender[i].name.toUpperCase(),
                            style:
                                TextStyle(fontSize: 16, color: Colors.black),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10)
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget SortWidet() {
    return Column(
      children: List.generate(sort.length, (i) {
        return Container(
          child: InkWell(
            onTap: () {
              _setState!(() {
                for (int j = 0; j < sort.length; j++) {
                  sort[j].status = false;
                }
                sort[i].status = true;
              });
            },
            child: Column(
              children: [
                Container(
                  height: 40,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        (sort[i].status == true)
                            ? SvgPicture.asset(
                                'assets/profile/active_radio_btn.svg')
                            : SvgPicture.asset(
                                'assets/profile/inactive_radio_btn.svg'),
                        SizedBox(width: 10),
                        Text("  " + sort[i].name.toUpperCase(),
                            style:
                                TextStyle(fontSize: 16, color: Colors.black),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10)
              ],
            ),
          ),
        );
      }),
    );
  }

  List<String> skillFilter = [];
  List<String> languageFilter = [];
  List<String> genderFilter = [];
  List<String> sortFilter = [];

  applyFilter() {
    skillFilter.clear();
    languageFilter.clear();
    genderFilter.clear();
    sortFilter.clear();

    for (int i = 0; i < skill.length; i++) {
      if (skill[i].status == true) skillFilter.add(skill[i].id.toString());
    }
    for (int i = 0; i < language.length; i++) {
      if (language[i].status == true)
        languageFilter.add(language[i].id.toString());
    }
    for (int i = 0; i < gender.length; i++) {
      if (gender[i].status == true) genderFilter.add(gender[i].id.toString());
    }
    for (int i = 0; i < sort.length; i++) {
      if (sort[i].status == true) sortFilter.add(sort[i].id.toString());
    }

    setState(() {
      String skill = skillFilter.join(',');
      String language = languageFilter.join(',');
      String gender = genderFilter.join(',');
      String sort = sortFilter.join(',');
      Navigator.pop(context);
      getAstrologerApi(
          catId: skill, language: language, gender: gender, sort: sort);
    });
  }
}