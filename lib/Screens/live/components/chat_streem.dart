

import 'dart:collection';

import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatStreem extends StatefulWidget {
  TextEditingController textEditingController;
  ScrollController listScrollController;
  FocusNode focusNode;
  DatabaseReference messageChatReference;
  String channelName;

  ChatStreem({
    Key? key,
    required this.textEditingController,
    required this.listScrollController,
    required this.focusNode,
    required this.messageChatReference,
    required this.channelName,
  }) : super(key: key);

  @override
  State<ChatStreem> createState() => _ChatStreemState();
}

class _ChatStreemState extends State<ChatStreem> {
  String? id;

  bool isShowSticker = false;
  int _limit = 20;
  int _limitIncrement = 20;
  SharedPreferences? prefs;

  String groupChatId = "";
  @override
  void initState() {
    widget.focusNode.addListener(onFocusChange);
    widget.listScrollController.addListener(_scrollListener);
    readLocal();
    super.initState();
  }

  void onFocusChange() {
    if (widget.focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        isShowSticker = false;
      });
    }
  }

  _scrollListener() {
    if (widget.listScrollController.offset >=
            widget.listScrollController.position.maxScrollExtent &&
        !widget.listScrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  readLocal() async {
    prefs = await SharedPreferences.getInstance();
    id = prefs?.getString('id') ?? '';
    if (id.hashCode <= widget.channelName.hashCode) {
      groupChatId = '$id-widget.channelName';
    } else {
      groupChatId = '"12345-$id';
    }

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
      'message': "Joined",
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
  }

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

      widget.messageChatReference = widget.messageChatReference
          .child("GroupLive")
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

      var MessageBodyDetails = HashMap<String, Map>();
      MessageBodyDetails[s1] = reqBody;

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
    return Container(
      height: MediaQuery.of(context).size.height * 0.34,
      width: MediaQuery.of(context).size.width * 0.6,
      clipBehavior: Clip.none,
      child: buildListMessage(),
    );
  }

  Widget buildListMessage() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ScrollConfiguration(
      behavior: ScrollBehavior().copyWith(overscroll: false),
      child: FirebaseAnimatedList(
        physics: ClampingScrollPhysics(),
        query: widget.messageChatReference.orderByChild("date_time"),
        padding: EdgeInsets.all(8.0),
        reverse: true,
        sort: (DataSnapshot a, DataSnapshot b) => b.key!.compareTo(a.key!),
        itemBuilder: (_, DataSnapshot snapshot, Animation<double> animation, int x) {
          final data = snapshot.value as Map<dynamic, dynamic>;
          print("size width");
          print(MediaQuery.of(context).size.width);
           print(MediaQuery.of(context).size.height);
    
          return Container(
            width: width/2.08,
            height: height/21.62,
            child: Row(
              children: [
                // Container(
                //   height: 31,
                //   width: 31,
                //   decoration: BoxDecoration(border: Border.all(width: 2, color: whiteColor), image: DecorationImage(image: NetworkImage(data["name"]))),
                // ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data["name"] , style: TextStyle(color: Colors.white, fontSize: width/47.11, fontFamily: 'poppinsbold', fontWeight: FontWeight.bold)),
                    Text(data["message"] , style: TextStyle(color: Colors.white, fontSize: width/47.11, fontFamily: 'poppins', fontWeight: FontWeight.normal)),
                  ],
                ),
              ],
            ),
            padding: EdgeInsets.fromLTRB(width/28.26, height/186, width/28.26,  height/186),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.30),
              borderRadius: BorderRadius.circular(30.0),
            ),
            margin: EdgeInsets.only(bottom: height/93.0, right: width/28.26, ),
          );
        },
      ),
    );
  }
}
