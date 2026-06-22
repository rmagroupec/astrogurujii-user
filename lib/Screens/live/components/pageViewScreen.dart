import 'package:agora_rtc_engine/agora_rtc_engine.dart';

import 'package:astro_gurujii/Screens/live/components/LiveScreenInfo.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../Models/GetGiftModel.dart';

class PageViewScreen extends StatefulWidget {
  final String screenType;
  final RtcEngine agoraEngine;


  TextEditingController textEditingController;
  ScrollController listScrollController;
  FocusNode focusNode;
  DatabaseReference messageChatReference;
  String channelName;
  var astroid;
  final String name;
  final String astroImage;
  final List<String> numberOfuserJoin;
  List<Data>? dataGifts;
  var id;
  PageViewScreen({
    Key? key,
    this.id,
    required this.textEditingController,
    required this.dataGifts,
    required this.listScrollController,
    this.astroid,
    required this.focusNode,
    required this.messageChatReference,
    required this.channelName,
    required this.name,
    required this.astroImage,
    required this.agoraEngine,
    required this.numberOfuserJoin, required this.screenType,
  }) : super(key: key);

  @override
  State<PageViewScreen> createState() => _PageViewScreenState();
}

class _PageViewScreenState extends State<PageViewScreen> {


  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: PageController(
        initialPage: 1,
      ),
      scrollDirection: Axis.horizontal, // or Axis.vertical
      children: [
        Container(color: Colors.transparent, child: SizedBox()),
        LiveScreenInfo(
          id: widget.id,
          textEditingController: widget.textEditingController,
          listScrollController: widget.listScrollController,
          astroid: widget.astroid,
          focusNode: widget.focusNode,
          channelName: widget.channelName,
          messageChatReference: widget.messageChatReference,
          astroImage: widget.astroImage,
          name: widget.name,
          dataGifts: widget.dataGifts,
          numberOfuserJoin: widget.numberOfuserJoin,
          screenType: widget.screenType,
          agoraEngine: widget.agoraEngine,
        ),
      ],
    );
  }
}
