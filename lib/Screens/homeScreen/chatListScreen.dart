


import 'package:astro_gurujii/Screens/homeScreen/view_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../Setup/SetUp.dart';
import '../../Setup/app_colors.dart';
import '../../Utilities/CustomText.dart';
import '../ChatIntakeForm.dart';
import '../Models/AstroDetailsModel.dart';
import '../WebServices/HttpServices.dart';
import '../bottomSheet.dart';
import 'chatLisitngModel.dart';

class ChatListScreen extends StatefulWidget {
   const ChatListScreen();

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final HttpServices _httpServices = HttpServices();
  ChatListingModelN? chatListingModelN;

  bool loading = false;
  List<Results> data = [];

  bool _isLoading = true;

  Future<void> callNotifyMeApi({String? id, String? type}) async {
    var res = await _httpServices.notifyme(astro_id: id!);
    if (res!.status == true) {
      setState(() {
        _isLoading = false;
        createSnackBar(res.message!);
        //Fluttertoast.showToast(msg: res.message!);
      });
    } else {
      _isLoading = false;
      Fluttertoast.showToast(msg: "Something went wrong");
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

  void astroDetailsApi(String id) async {
    var res = await _httpServices.astrologer_details(id: id);
    if (res!.status == true) {
      setState(() {
        data = res.results!;
        // translateAbout(data[0]
        //     .about); // Translate the description again when toggling language

        _isLoading = false;
      });
    } else {
      Fluttertoast.showToast(msg: res.message!);
      _isLoading = false;
    }
  }


  void chatListing() async {
    setState(() {
      loading = true;
    });
    var res = await _httpServices.chatListingApi();
    if (res!.status == true) {
      setState(() {
        chatListingModelN = res;
        loading = false;
      });
    } else {}
  }


  String wallet = "0.0";
  String? currency;
  String setWallet(String wallet, String currency, String usdWallet) {
    if (currency == "USD") {
      return "${usdWallet}";
    } else {
      return "${wallet}";
    }
  }
  String? us_name;
  String? us_image;
  void getProfile() async {
    var res = await _httpServices.profile_api();
    if (res!.status == true ) {
      setState(() {
        currency = res.results!.currency.toString();
        wallet = setWallet(res.results!.wallet.toString(),
            res.results!.currency.toString(), res.results!.wallet_usd.toString());
        us_name = res.results!.name.toString();
        us_image = res.results!.profileImg.toString();
      });
    } else {
      Fluttertoast.showToast(msg: res.message!);
    }
  }

  @override
  void initState() {
    chatListing();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // Change the color of the back button to white
        ),
        // centerTitle: true,
        title: Text("My Orders",style: TextStyle(color: whiteColor),),
      ),
        body: loading == true
            ? Center(child: CircularProgressIndicator())
            :
        ListView.builder(
                itemCount: chatListingModelN!.data!.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var temp = chatListingModelN!.data![index];
                  return
                    chatListingModelN!.data!.isEmpty?Container():
                    Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      padding: EdgeInsets.only(
                          top: 15, bottom: 15, left: 10, right: 10),
                      decoration: BoxDecoration(
                        color: Colors.white, // Container background color
                        borderRadius: BorderRadius.circular(
                            20), // Optional: Round corners
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4), // Shadow color
                            spreadRadius: 2, // Spread radius
                            blurRadius: 1, // Blur radius
                            offset: Offset(0, 2), // Offset in x and y direction
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: primaryColor,
                            child: CircleAvatar(
                              radius: 40,
                              backgroundImage:
                                  NetworkImage(temp.astroProfileImg),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              CustomText(
                                // text: "Acharya Anu",
                                text: "${temp.astroDisplayName}",
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              CustomText(
                                text: "${temp.callDate}",
                                fontSize: 16,
                                color: Colors.black38,
                                fontWeight: FontWeight.w400,
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (ctx) => ChatViewOnly(
                                                  // channelID: data2!.fbChannelId,
                                                  channelID: temp.fbChannelId
                                                      .toString(),
                                                  // fbchannelID: data2!.channelId,
                                                  fbchannelID: temp.channelId,
                                                  // astrologer_id: data2!.astroId,
                                                  astrologer_id: temp.astrId,
                                                  name: temp.userName,
                                                  place: "",
                                                  dob: "",
                                                  astroName: temp.astroName,
                                                  // tob: data2!.difference.toString(),
                                                  tob: "",
                                                  gender: "",
                                                  // gid: data2!.fbChannelId,
                                                  gid: temp.fbChannelId,
                                                  currency: "INR",
                                                  astrologer_chat_rate: "",
                                                  astrologer_image:
                                                      temp.astroProfileImg,
                                                  wallet: "",
                                                rating: temp.rating,
                                              )));

                                      //     .then((value) => {getChatStatus()});
                                      // });
                                    },
                                    child: Container(
                                      height: Get.height * 0.04,
                                      width: Get.width * 0.28,
                                      decoration: BoxDecoration(
                                          color: AppColors.appblueColor,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Center(
                                        child: CustomText(
                                          // text: 'Connect',
                                          text: 'View Chat',
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                    // onTap: () {},

                                    onTap: () async {
                                      /// 1 check status astrologer is busy or offline
                                      getProfile();
                                      astroDetailsApi(chatListingModelN!.data![index].astrId);

                                    if (data[0].is_busy == 0 &&
                                          data[0].isChatOnline == "off") {
                                        callNotifyMeApi(
                                            id: data[0].id.toString(), type: "chat");
                                      } else {
                                        var callRate =
                                        (data[0].per_min_chat_offer.isEmpty)
                                            ? data[0].perMinChat.toString()
                                            : data[0].per_min_chat_offer.toString();
                                        if (setCheckForChat(
                                            wallet.toString(), callRate)) {
                                          bottomSheet(
                                              us_name!, us_image!,
                                              data[0].astro_number.toString(),
                                              context,
                                              data[0].id.toString(),
                                              (data[0].per_min_chat_offer.isEmpty)
                                                  ? data[0].perMinChat.toString()
                                                  : data[0]
                                                  .per_min_chat_offer
                                                  .toString(),
                                              "5",
                                              data[0].profileImg!,
                                              currency!,
                                              "+91",
                                              data[0].name!,
                                              wallet.toString(),
                                              "chat",
                                              loading);
                                        } else {

                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (ctx) => ChatIntakeForm(
                                                      wallet: wallet.toString(),
                                                      rate: callRate,
                                                      name: data[0].name!,
                                                      profile: data[0].profileImg!,
                                                      astrologer_id:
                                                      data[0].id.toString())))
                                              .then((value) => {getProfile()});

                                        }
                                      }
                                    },


                                    child: Container(
                                      height: Get.height * 0.04,
                                      width: Get.width * 0.28,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                              color: AppColors.appblueColor)),
                                      child: Center(
                                        child: CustomText(
                                          // text: 'Connect',
                                          text: 'Chat again',
                                          color: AppColors.appblueColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              // CustomText(
                              //   text: "Special offer Chat at Rs 5/min only",
                              //   fontSize: 10,
                              //   color: primaryColor,
                              //   fontWeight: FontWeight.w400,
                              // ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ));
  }

  void createSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Align(
          child: Container(
            //color: Colors.white,
            decoration: BoxDecoration(
                color: primaryColor,
                border: Border.all(width: 2.0, color: primaryColor),
                borderRadius: BorderRadius.circular(20)),
            child: Container(
              height: 100,
              child: Align(
                child: CustomText(
                  text: "${message}".toString(),
                  color: blackColor,
                  align: TextAlign.start,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 2000,
        behavior: SnackBarBehavior.floating,
      ));
  }

}
