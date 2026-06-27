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
      groupChatId = '$id-${widget.channelName}';
    } else {
      groupChatId = '${widget.channelName}-$id';
    }

    var user_id = prefs?.getString('id');
    var name = prefs?.getString('name');
    var timestamp = DateTime.now().millisecondsSinceEpoch;
    var messageSenderRef = "GroupLive/" + widget.channelName;
    var messageReceiverRef = "GroupLive/" + widget.channelName;

    widget.messageChatReference =
        widget.messageChatReference.child("Group").child(widget.channelName).push();

    var messagePushId = widget.messageChatReference.key;
    // "joined" events use the same message pipe as chat text — the UI below
    // renders the message field bold regardless of whether it says "joined"
    // or an actual chat line, matching the screenshot.
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
    if (content.trim() == '') {
      Fluttertoast.showToast(
          msg: 'Nothing to send', backgroundColor: Colors.black, textColor: Colors.red);
      return;
    }

    prefs = await SharedPreferences.getInstance();
    id = prefs?.getString('id') ?? '';
    if (id.hashCode <= widget.channelName.hashCode) {
      groupChatId = '$id-${widget.channelName}';
    } else {
      groupChatId = '${widget.channelName}-$id';
    }

    var user_id = prefs?.getString('id');
    var name = prefs?.getString('name');
    var timestamp = DateTime.now().millisecondsSinceEpoch;
    var messageSenderRef = "GroupLive/" + widget.channelName;

    widget.messageChatReference =
        widget.messageChatReference.child("GroupLive").child(widget.channelName).push();

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
        padding: EdgeInsets.all(4.0),
        reverse: true,
        sort: (DataSnapshot a, DataSnapshot b) => b.key!.compareTo(a.key!),
        itemBuilder: (_, DataSnapshot snapshot, Animation<double> animation, int x) {
          final data = snapshot.value as Map<dynamic, dynamic>;
          final name = (data["name"] ?? '').toString();
          final message = (data["message"] ?? '').toString();

          // Flat row — circular initial avatar, name (regular weight),
          // message/event text (bold) underneath. No dark bubble, matching
          // the screenshot's "Divya joined" style notifications.
          return Padding(
            padding: EdgeInsets.only(bottom: height / 186),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: width / 32,
                  backgroundColor: const Color(0xFFE8B43A),
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : '?',
                    style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: width / 56.5),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: width / 30,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        message,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: width / 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}