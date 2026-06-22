
import 'dart:developer';

import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Screens/WebServices/model/transaction/Data.dart';
import 'package:astro_gurujii/Screens/chats_screen/ChatHistoryScreen.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../homeScreen/chatLisitngModel.dart';
import '../homeScreen/view_chat_screen.dart';
import 'giftranscsationScreen.dart';

class TransactionHistory extends StatefulWidget {
  @override
  _TransactionHistoryState createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  List<Data> call = [];
  List<Data> videoCall = [];
  List<Data> reportData = [];
  List<Data> chat = [];
  List<Data> question = [];
  List<Data> other = [];
  String currency = '';
  String currencySign = "";
  bool? isLoading;
  HttpServices _httpService = HttpServices();


  ChatListingModelN? chatListingModelN;
  bool loadingChatList = false;


  void chatListing() async {
    setState(() {
      loadingChatList = true;
    });

    var res = await _httpService.chatListingApi();
    if (res?.status == true) {
      setState(() {
        chatListingModelN = res;
        // loadingChatList = false;

        log('---a-sdfdsafdsaf--fdsafdsa ${chatListingModelN?.data?.length}');
        print("doneeee");
      });
    } else {}
  }

  callWebServiceAudio() async {
    setState(() {
      isLoading = true;
    });

    var res = await _httpService.transaction(type: "audio");
    if (res!.result == true) {
      call = res.transactions!.data!;
    }
    setState(() {
      isLoading = false;
    });
  }

  callWebServiceVideo() async {
    setState(() {
      isLoading = true;
    });
    var res = await _httpService.transaction(type: "video");
    if (res!.result == true) {
      videoCall = res.transactions!.data!;
    }
    setState(() {
      isLoading = false;
    });
  }

  reportWebService() async {
    setState(() {
      isLoading = true;
    });

    var res = await _httpService.transaction(type: "report");
    if (res!.result == true) {
      reportData = res.transactions!.data!;
    }
    setState(() {
      isLoading = false;
    });
  }

  callWebServiceChat() async {
    setState(() {
      isLoading = true;
      loadingChatList = true;
    });

    var res = await _httpService.transaction(type: "chat");
    if (res!.result == true) {
      chat = res.transactions!.data!;
      loadingChatList = false;
    }
    setState(() {
      isLoading = false;
      loadingChatList = false;
    });
  }

  callWebServiceQuestion() async {
    setState(() {
      isLoading = true;
    });

    var res = await _httpService.transaction(type: "wallet");
    if (res!.result == true) {
      question = res.transactions!.data!;
    }
    setState(() {
      isLoading = false;
    });
  }

  callWebServiceOther() async {
    setState(() {
      isLoading = true;
    });

    var res = await _httpService.transaction(type: "other");
    if (res!.result == true) {
      other = res.transactions!.data!;
    }
    setState(() {
      isLoading = false;
    });
  }

  void getProfile() async {
    var res = await _httpService.profile_api();
    if (res!.status == true) {
      setState(() {
        currency = res.results!.currency.toString();
        if (currency == "USD") {
          setState(() {
            currencySign = "\u{20B9}";
          });
        } else {
          setState(() {
            currencySign = "\u{20B9}";
          });
        }
      });
    } else {
      Fluttertoast.showToast(msg: res.message!);
    }
  }

  @override
  void initState() {
    chatListing();
    super.initState();
    getProfile();
    callWebServiceAudio();
    callWebServiceQuestion();
    callWebServiceChat();
    callWebServiceVideo();
    callWebServiceOther();
    //reportWebService();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(
            // color: Colors.red,
            image: DecorationImage(
                image: AssetImage("assets/images/bg_screen.png"),
                fit: BoxFit.fitWidth)),
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: whiteColor, //change your color here
            ),
            title: Text(
              "Transaction History",
              style: TextStyle(color: whiteColor),
            ),
            backgroundColor: primaryColor,
            elevation: 0.0,
          ),
          body: Column(
            children: [
              Container(
                color: primaryColor,
                child: TabBar(
                  isScrollable: true,
                  labelStyle: Theme.of(context).tabBarTheme.labelStyle,
                  unselectedLabelStyle:
                      Theme.of(context).tabBarTheme.unselectedLabelStyle,
                  indicatorColor: Colors.black,
                  labelColor: Colors.black,
                  unselectedLabelColor: whiteColor,
                  tabs: [
                    Tab(
                      text: "CALL",
                    ),
                    Tab(
                      text: "CHAT",
                    ),
                    Tab(
                      text: "VIDEO CALL ",
                    ),
                    Tab(
                      text: "WALLET",
                    ),
                    Tab(
                      text: "OTHER",
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  child: TabBarView(children: [
                    call.length != 0
                        ? SingleChildScrollView(
                            child: Column(
                                children: call
                                    .map(
                                      (data) => Container(
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
                                        margin: EdgeInsets.all(3),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        child: Image.asset(
                                                          "assets/astro/call_history.png",
                                                          height: 35,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              child: Text(
                                                                "${capitalize('Order ID #${data.order_id.toString() ?? ''}')}",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                            Container(
                                                              child: Text(
                                                                "${capitalize(data.astro_name.toString())}",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Container(
                                                              child: Text(
                                                                '${data.transaction_date}',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        'Call for ${data.time} min',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        '${currencySign} ${data.amount} (${currencySign} ${data.per_min_charge})',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                MyFonts.bold),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                                margin:
                                                    EdgeInsets.only(top: 20),
                                                child: Text(
                                                  "Paid by Wallet",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                )),
                                            (data.remedy!.length > 0)
                                                ? Container(
                                                    decoration:
                                                        new BoxDecoration(
                                                      borderRadius:
                                                          new BorderRadius
                                                              .circular(6.0),
                                                      color: Color(yColor),
                                                    ),
                                                    alignment:
                                                        Alignment.topLeft,
                                                    margin: EdgeInsets.only(
                                                        top: 10),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        children: [
                                                          Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: Text(
                                                                "Astrologer is suggesting you a " +
                                                                        data.remedy! +
                                                                        " for your better future Get a remedy today at a 10% special discount by applying ${data.remedy_id} from our Astro mall and make your life ecstatic " ??
                                                                    '',
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                              )),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                        ],
                                                      ),
                                                    ))
                                                : Container(),
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList()),
                          )
                        : Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("assets/Icons/no_record_icon.png"),
                                Container(
                                    margin: EdgeInsets.only(top: 40),
                                    child: Text(
                                      "No Record Found",
                                      style: TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.w600),
                                    ))
                              ],
                            ),
                          ),

                    //end call

                    loadingChatList ?Center(child: CircularProgressIndicator(),) :  chat.length != 0
                        ? SingleChildScrollView(
                            child: Column(
                                children: chat
                                    .map(
                                      (data) => Container(
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
                                        margin: EdgeInsets.all(3),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        child: Image.asset(
                                                          "assets/astro/chat_history.png",
                                                          height: 35,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              child: Text(
                                                                "${capitalize('Order ID #${data.order_id.toString() ?? ''}')}",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                            Container(
                                                              child: Text(
                                                                "${data.astro_name.toString()} (${data.per_min_charge! + '/min'})",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Container(
                                                              child: Text(
                                                                '${data.transaction_date}',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        'Chat for ${data.time} min',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        '${currencySign} ${data.amount}',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                MyFonts.bold),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                    margin: EdgeInsets.only(
                                                        top: 20),
                                                    child: Text(
                                                      "Paid by Wallet",
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    )),
                                                InkWell(
                                                  onTap: () {
                                                    // Navigator.push(
                                                    //     context,
                                                    //     MaterialPageRoute(
                                                    //         builder: (ctx) => ChatHistoryScreen(
                                                    //             channelID: data
                                                    //                 .channel_id,
                                                    //             astrologer_id: data
                                                    //                 .astrologer_id,
                                                    //             astrologer_name:
                                                    //                 data
                                                    //                     .astro_name,
                                                    //             gid: data
                                                    //                 .channel_id,
                                                    //             currency: "INR",
                                                    //             astrologer_chat_rate:
                                                    //                 data
                                                    //                     .per_min_charge,
                                                    //             astrologer_image:
                                                    //                 data.astro_image,
                                                    //             wallet: "")));


                                                    var temp = chatListingModelN?.data![0];
    
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (ctx) =>
                                                ChatViewOnly(
                                                  // channelID: data2!.fbChannelId,
    
    
                                                  channelID: temp!.fbChannelId
                                                      .toString(),
                                                  // fbchannelID: data2!.channelId,
                                                  fbchannelID: temp.channelId,
                                                  // astrologer_id: data2!.astroId,
                                                  astrologer_id: temp.astrId,
                                                  name: temp.userName,
                                                  place: "",
                                                  dob: "",
                                                  astroName: temp.astroDisplayName,
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
                                                  review: temp.review
                                                )));
    
                                    //     .then((value) => {getChatStatus()});
                                    // });
                                  },
                                                  child: Container(
                                                      margin: EdgeInsets.only(
                                                          top: 20),
                                                      child: Text(
                                                        "Chat History",
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          color: primaryColor,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      )),
                                                ),
                                              ],
                                            ),
                                            (data.remedy!.length > 0)
                                                ? Container(
                                                    decoration:
                                                        new BoxDecoration(
                                                      borderRadius:
                                                          new BorderRadius
                                                              .circular(6.0),
                                                      color: Color(yColor),
                                                    ),
                                                    alignment:
                                                        Alignment.topLeft,
                                                    margin: EdgeInsets.only(
                                                        top: 10),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        children: [
                                                          Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: Text(
                                                                "Astrologer is suggesting you a " +
                                                                        data.remedy! +
                                                                        " for your better future Get a remedy today at a 10% special discount by applying ${data.remedy_id} from our Astro mall and make your life ecstatic " ??
                                                                    '',
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                              )),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                        ],
                                                      ),
                                                    ))
                                                : Container(),
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList()),
                          )
                        : Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("assets/Icons/no_record_icon.png"),
                                Container(
                                    margin: EdgeInsets.only(top: 40),
                                    child: Text(
                                      "No Record Found",
                                      style: TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.w600),
                                    ))
                              ],
                            ),
                          ),

                    //end chat

                    videoCall.length != 0
                        ? SingleChildScrollView(
                            child: Column(
                                children: videoCall
                                    .map(
                                      (data) => Container(
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
                                        margin: EdgeInsets.all(3),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        child: Image.asset(
                                                          "assets/astro/videocall.png",
                                                          height: 35,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              child: Text(
                                                                "${capitalize('Order ID #${data.order_id.toString() ?? ''}')}",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                            Container(
                                                              child: Text(
                                                                "${data.astro_name.toString()}",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Container(
                                                              child: Text(
                                                                '${data.transaction_date}',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        'Call for ${data.time} min',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        '${currencySign} ${data.amount} (${currencySign} ${data.per_min_charge})',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                MyFonts.bold),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                                margin:
                                                    EdgeInsets.only(top: 20),
                                                child: Text(
                                                  "Paid by Wallet",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                )),
                                            (data.remedy!.length > 0)
                                                ? Container(
                                                    decoration:
                                                        new BoxDecoration(
                                                      borderRadius:
                                                          new BorderRadius
                                                              .circular(6.0),
                                                      color: Color(yColor),
                                                    ),
                                                    alignment:
                                                        Alignment.topLeft,
                                                    margin: EdgeInsets.only(
                                                        top: 10),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        children: [
                                                          Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: Text(
                                                                "Astrologer is suggesting you a " +
                                                                        data.remedy! +
                                                                        " for your better future Get a remedy today at a 10% special discount by applying ${data.remedy_id} from our Astro mall and make your life ecstatic " ??
                                                                    '',
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                              )),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                        ],
                                                      ),
                                                    ))
                                                : Container(),
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList()),
                          )
                        : Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("assets/Icons/no_record_icon.png"),
                                Container(
                                    margin: EdgeInsets.only(top: 40),
                                    child: Text(
                                      "No Record Found",
                                      style: TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.w600),
                                    ))
                              ],
                            ),
                          ),

                    //end videocall

                    question.length != 0
                        ? SingleChildScrollView(
                            child: Column(
                                children: question
                                    .map(
                                      (data) => Container(
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
                                        margin: EdgeInsets.all(3),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        child: Image.asset(
                                                          "assets/login/wallet.png",
                                                          height: 35,
                                                        ),
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            child: Text(
                                                              "Amount",
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ),
                                                          Container(
                                                            child: Text(
                                                              "",
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  child: Column(
                                                    children: [
                                                      (data.amount_type ==
                                                              "Credit")
                                                          ? Text(
                                                              '+${currencySign} ${data.amount.toString()}',
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            )
                                                          : Text(
                                                              '-${currencySign} ${data.amount.toString()}',
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                      Text(
                                                        '${data.transaction_date}',
                                                        style: TextStyle(
                                                            color: Colors.grey),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                                margin:
                                                    EdgeInsets.only(top: 20),
                                                child: Text(
                                                  "${data.amount_type.toString()} - ${data.type.toString()}",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                )),
                                            (data.remedy!.length > 0)
                                                ? Container(
                                                    decoration:
                                                        new BoxDecoration(
                                                      borderRadius:
                                                          new BorderRadius
                                                              .circular(6.0),
                                                      color: Color(yColor),
                                                    ),
                                                    alignment:
                                                        Alignment.topLeft,
                                                    margin: EdgeInsets.only(
                                                        top: 10),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        children: [
                                                          Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: Text(
                                                                "Astrologer is suggesting you a " +
                                                                        data.remedy! +
                                                                        " for your better future Get a remedy today at a 10% special discount by applying ${data.remedy_id} from our Astro mall and make your life ecstatic " ??
                                                                    '',
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                              )),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                        ],
                                                      ),
                                                    ))
                                                : Container(),
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList()),
                          )
                        : Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("assets/Icons/no_record_icon.png"),
                                Container(
                                    margin: EdgeInsets.only(top: 40),
                                    child: Text(
                                      "No Record Found",
                                      style: TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.w600),
                                    ))
                              ],
                            ),
                          ),
                    //end question

                    //report start

                    GiftTransactionScreen(),
                    // other.length != 0
                    //     ? SingleChildScrollView(
                    //         child: Column(
                    //             children: other
                    //                 .map(
                    //                   (data) => Container(
                    //                     decoration: BoxDecoration(
                    //                       color: Colors.white,
                    //                       boxShadow: [
                    //                         BoxShadow(
                    //                           color: Colors.grey,
                    //                           offset: Offset(0.0, 1.0), //(x,y)
                    //                           blurRadius: 4.0,
                    //                         ),
                    //                       ],
                    //                     ),
                    //                     margin: EdgeInsets.all(3),
                    //                     padding: EdgeInsets.symmetric(
                    //                         horizontal: 10, vertical: 15),
                    //                     child: Column(
                    //                       crossAxisAlignment:
                    //                           CrossAxisAlignment.start,
                    //                       children: [
                    //                         Row(
                    //                           crossAxisAlignment:
                    //                               CrossAxisAlignment.start,
                    //                           mainAxisAlignment:
                    //                               MainAxisAlignment
                    //                                   .spaceBetween,
                    //                           children: [
                    //                             Container(
                    //                               child: Row(
                    //                                 children: [
                    //                                   Container(
                    //                                     child: Image.asset(
                    //                                       "assets/astro/report_history.png",
                    //                                       height: 35,
                    //                                     ),
                    //                                   ),
                    //                                   Column(
                    //                                     crossAxisAlignment:
                    //                                         CrossAxisAlignment
                    //                                             .start,
                    //                                     children: [
                    //                                       Container(
                    //                                         child: Text(
                    //                                           "Service Amount",
                    //                                           style: TextStyle(
                    //                                               fontSize: 16,
                    //                                               fontWeight:
                    //                                                   FontWeight
                    //                                                       .w500),
                    //                                         ),
                    //                                       ),
                    //                                       Container(
                    //                                         child: Text(
                    //                                           "",
                    //                                           style: TextStyle(
                    //                                             color:
                    //                                                 Colors.grey,
                    //                                           ),
                    //                                         ),
                    //                                       )
                    //                                     ],
                    //                                   ),
                    //                                 ],
                    //                               ),
                    //                             ),
                    //                             Container(
                    //                               child: Column(
                    //                                 children: [
                    //                                   Text(
                    //                                     '-${currencySign} ${data.amount.toString()}',
                    //                                     style: TextStyle(
                    //                                         fontSize: 16,
                    //                                         fontWeight:
                    //                                             FontWeight
                    //                                                 .w500),
                    //                                   ),
                    //                                   Text(
                    //                                     '${data.transaction_date}',
                    //                                     style: TextStyle(
                    //                                         color: Colors.grey),
                    //                                   )
                    //                                 ],
                    //                               ),
                    //                             ),
                    //                           ],
                    //                         ),
                    //                         Container(
                    //                             margin: EdgeInsets.only(top: 4),
                    //                             child: Text(
                    //                               "Added By: ${data.type.toString()}",
                    //                               style: TextStyle(
                    //                                 fontSize: 16,
                    //                                 fontWeight: FontWeight.w500,
                    //                               ),
                    //                             )),
                    //                         Container(
                    //                             margin:
                    //                                 EdgeInsets.only(top: 20),
                    //                             child: Text(
                    //                               "${data.amount_type.toString()}",
                    //                               style: TextStyle(
                    //                                 fontSize: 18,
                    //                                 color: primaryColor,
                    //                                 fontWeight: FontWeight.w500,
                    //                               ),
                    //                             )),
                    //                         (data.remedy.length > 0)
                    //                             ? Container(
                    //                                 decoration:
                    //                                     new BoxDecoration(
                    //                                   borderRadius:
                    //                                       new BorderRadius
                    //                                           .circular(6.0),
                    //                                   color: Color(yColor),
                    //                                 ),
                    //                                 alignment:
                    //                                     Alignment.topLeft,
                    //                                 margin: EdgeInsets.only(
                    //                                     top: 10),
                    //                                 child: Padding(
                    //                                   padding:
                    //                                       const EdgeInsets.all(
                    //                                           8.0),
                    //                                   child: Column(
                    //                                     children: [
                    //                                       Align(
                    //                                           alignment:
                    //                                               Alignment
                    //                                                   .topLeft,
                    //                                           child: Text(
                    //                                             "Astrologer is suggesting you a " +
                    //                                                     data.remedy +
                    //                                                     " for your better future Get a remedy today at a 10% special discount by applying ${data.remedy_id} from our Astro mall and make your life ecstatic " ??
                    //                                                 '',
                    //                                             textAlign:
                    //                                                 TextAlign
                    //                                                     .left,
                    //                                             style: TextStyle(
                    //                                                 color: Colors
                    //                                                     .black),
                    //                                           )),
                    //                                       SizedBox(
                    //                                         height: 10,
                    //                                       ),
                    //                                     ],
                    //                                   ),
                    //                                 ))
                    //                             : Container(),
                    //                       ],
                    //                     ),
                    //                   ),
                    //                 )
                    //                 .toList()),
                    //       )
                    //     : Container(
                    //         child: Column(
                    //           crossAxisAlignment: CrossAxisAlignment.center,
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: [
                    //             Image.asset("assets/Icons/no_record_icon.png"),
                    //             Container(
                    //                 margin: EdgeInsets.only(top: 40),
                    //                 child: Text(
                    //                   "No Record Found",
                    //                   style: TextStyle(
                    //                       fontSize: 26,
                    //                       fontWeight: FontWeight.w600),
                    //                 ))
                    //           ],
                    //         ),
                    //       ),



                    //end report
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
