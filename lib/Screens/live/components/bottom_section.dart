import 'dart:collection';

import 'package:astro_gurujii/Screens/live/components/chat_streem.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/GetGiftModel.dart';
import 'gift_bottm_sheet.dart';

class BottomSection extends StatefulWidget {
  final String screenType;

  TextEditingController textEditingController;
  ScrollController listScrollController;

  FocusNode focusNode;
  DatabaseReference messageChatReference;
  String channelName;
  String astroId;
  var id;

  List<Data>? dataGifts;
  BottomSection({
    Key? key,
    required this.textEditingController,
    required this.listScrollController,
    required this.focusNode,
    required this.dataGifts,
    required this.astroId,
    required this.id,
    required this.messageChatReference,
    required this.channelName, required this.screenType,
  }) : super(key: key);

  @override
  State<BottomSection> createState() => _BottomSectionState();
}

class _BottomSectionState extends State<BottomSection> {
  bool muted = true;
  String? id;

  bool isShowSticker = false;
  int _limit = 20;
  int _limitIncrement = 20;
  SharedPreferences? prefs;

  String groupChatId = "";

  TextEditingController textTobeSend = TextEditingController();

  Future<void> onSendMessage(String content, int type) async {
    // type: 0 = text, 1 = image, 2 = sticker

    //var  messageSenderRef="Group/" +peerId+"/"
    var message_type = "text";
    if (type == 0) {
      message_type = "text";
    } else if (type == 1) {
      message_type = "image";
    }

    if (content.trim() != '') {
      // textEditingController.clear();

      prefs = await SharedPreferences.getInstance();
      id = prefs?.getString('id') ?? '';
      if (id.hashCode <= widget.channelName.hashCode) {
        groupChatId = '$id-${widget.channelName}';
      } else {
        groupChatId = '${widget.channelName}-$id';
      }

      /* //FirebaseFirestore.instance.collection('users').doc(id).update({'chattingWith': peerId});
      //group_id:4    user_id:3  reciver_id:6
      RootRef=FirebaseDatabase.instance.reference()
          .child("Group").child(widget.gid).child(prefs?.getString('id')).child(widget.astrologer_id);
*/

      var user_id = prefs?.getString('id');
      var name = prefs?.getString('name');
      var timestamp = DateTime.now().millisecondsSinceEpoch;
      var messageSenderRef = "GroupLive/" + widget.channelName;

      var messageReceiverRef = "GroupLive/" + widget.channelName;

      widget.messageChatReference = widget.messageChatReference
          .child("Group")
          .child(widget.channelName)
          .push();

      var messagePushId = widget.messageChatReference.key;
      Map reqBody = {
        'date': "",
        'from': user_id,
        'message': content,
        'message_id': messagePushId,
        'date_time': timestamp,
        'name': name,
        'time': "",
      };

      var s1 = "$messageSenderRef/$messagePushId";
      var s2 = "$messageReceiverRef/$messagePushId";

      var MessageBodyDetails = HashMap<String, Map>();
      MessageBodyDetails[s1] = reqBody;
      MessageBodyDetails[s2] = reqBody;

      FirebaseDatabase.instance.ref().update(MessageBodyDetails);

      // listScrollController.animateTo(0.0,
      //     duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(
          msg: 'Nothing to send',
          backgroundColor: Colors.black,
          textColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
     double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    print("Channel name=====>>> ${widget.channelName}");
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        // color: Colors.red,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(0, 0, 0, 0),
            Colors.black.withOpacity(0.3),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width/1.65,
            child: ChatStreem(
                textEditingController: widget.textEditingController,
                listScrollController: widget.listScrollController,
                focusNode: widget.focusNode,
                channelName: widget.channelName,
                messageChatReference: widget.messageChatReference),
          ),
          Container(
            height: height/17.00,
            width: width,
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.30),),
            child: Container(
              
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: width/141.33,),
                  Container(
                    height: height/27.35,
                                width: width/12.47,
                                decoration: BoxDecoration(color: whiteColor,borderRadius: BorderRadius.circular(50),),
                                child: Icon(Icons.message, color: Colors.yellow,),
                   
                  ),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  /*InkWell(
                    onTap: () {
                      _onSpeakerOff();
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle),
                      child: muted != true
                          ? Image.asset(
                              'assets/Icons/volume_off.png',
                              height: 25,
                              width: 25,
                            )
                          : Image.asset(
                              'assets/Icons/volume.png',
                              height: 25,
                              width: 25,
                            ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),*/

                  Container(
                    height: height/22.50,
                    width: MediaQuery.of(context).size.width*0.56,
                    padding: EdgeInsets.symmetric(horizontal: width/42.44),
                    decoration: BoxDecoration(
                        color: Colors.white,

                        borderRadius: BorderRadius.circular(width/14.33)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            
                            SizedBox(
                              width: width/42.40,
                            ),
                            SizedBox(
                              width:
                              MediaQuery.of(context).size.width * 0.36,
                              child: TextFormField(
                                maxLines: 1,
                                controller: textTobeSend,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: width/28.26,
                                    fontFamily: 'Segoe UI',
                                    fontWeight: FontWeight.w400,
                                    decoration: TextDecoration.none),
                                decoration: InputDecoration(
                                  hintText: "Type Your Message",
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  hintStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: width/28.26,
                                      fontFamily: 'Segoe UI',
                                      fontWeight: FontWeight.w400,
                                      decoration: TextDecoration.none),
                                ),
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            onSendMessage(textTobeSend.text.toString(), 0);
                            textTobeSend.clear();
                          },
                          child: Container(
                            // height: 10,
                              padding: EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle),
                              child: Icon(
                                Icons.send,
                                color: Colors.white,
                                size: width/19.27,
                              )),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: width/141.33,
                  ),
                  InkWell(
                    onTap: () {
                      // GiftBottomSheets.showGistBottomSheet(
                      //   screenType: widget.screenType,
                      //     id: widget.id.toString(),
                      //     context: context,

                      //   dataGifts: widget.dataGifts, astroId: widget.astroId.toString(),);
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: ShapeDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0.00, -1.00),
                          end: Alignment(0, 1),
                          colors: [Colors.white, Colors.white],
                        ),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              width: 0.40, color: Color(0xFFFF0000)),
                          borderRadius: BorderRadius.circular(width/21.2,),
                        ),
                      ),
                      child: Icon(Icons.favorite, color: redColor,)
                    ),
                  ),
                  SizedBox(
                    width: width/141.33,
                  ),
                  InkWell(
                    onTap: () {
                      GiftBottomSheets.showGistBottomSheet(
                        screenType: widget.screenType,
                          id: widget.id.toString(),
                          context: context,

                        dataGifts: widget.dataGifts, astroId: widget.astroId.toString(),);
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: ShapeDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0.00, -1.00),
                          end: Alignment(0, 1),
                          colors: [Colors.white, Colors.white],
                        ),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              width: 0.40, color: Color(0xFFFF0000)),
                          borderRadius: BorderRadius.circular(width/21.2),
                        ),
                      ),
                      child: Image.asset(
                        'assets/Icons/gift_icon.png',
                        height: 25,
                        width: 25,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width/141.33,
                  ),
                  InkWell(
                    onTap: () {
                     Share.share("https://play.google.com/store/apps/details?id=com.user.astrogurujii&hl=en_IN");
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: ShapeDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0.00, -1.00),
                          end: Alignment(0, 1),
                          colors: [Colors.white, Colors.white],
                        ),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              width: 0.40, color: Color(0xFFFF0000)),
                          borderRadius: BorderRadius.circular(width/21.2),
                        ),
                      ),
                      child: Icon(Icons.share, color: Colors.yellow,)
                    ),
                  ),
                  SizedBox(
                    width: width/141.33,
                  )

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onSpeakerOff() {
    setState(() {
      muted = !muted;
    });

    // widget.engine?.setEnableSpeakerphone(muted);
  }
}
