import 'package:agora_rtc_engine/agora_rtc_engine.dart';

import 'package:astro_gurujii/Screens/live/components/bottom_section.dart';
import 'package:astro_gurujii/Screens/live/components/top_section.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Models/GetGiftModel.dart';

class LiveScreenInfo extends StatefulWidget {
  final String screenType;
  final RtcEngine agoraEngine;

  TextEditingController textEditingController;
  ScrollController listScrollController;
  FocusNode focusNode;
  DatabaseReference messageChatReference;
  String channelName;
  final String name;
  var astroid;
  final String astroImage;
  final List<String> numberOfuserJoin;
  List<Data>? dataGifts;
  var id;
  LiveScreenInfo({
    Key? key,
    this.id,
    required this.textEditingController,
    required this.listScrollController,
    required this.focusNode,
    required this.channelName,
    this.astroid,
    required this.dataGifts,
    required this.messageChatReference,
    required this.name,
    required this.astroImage,
    required this.numberOfuserJoin,required this.screenType, required this.agoraEngine,
  }) : super(key: key);

  @override
  State<LiveScreenInfo> createState() => _LiveScreenInfoState();
}

class _LiveScreenInfoState extends State<LiveScreenInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      // appBar: LiveVideoAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: Get.height * 0.953,
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TopSection(
                  id: widget.id,
                  astroid: widget.astroid,
                  astroImage: widget.astroImage,
                  name: widget.name,
                  numberOfuserJoin: widget.numberOfuserJoin,
                  screenType: widget.screenType,
                  agoraEngine: widget.agoraEngine,

                ),
                BottomSection(
                  id: widget.id.toString(),
                  screenType: widget.screenType,

                  dataGifts: widget.dataGifts,
                    textEditingController: widget.textEditingController,
                    listScrollController: widget.listScrollController,
                    focusNode: widget.focusNode,
                    channelName: widget.channelName,
                    messageChatReference: widget.messageChatReference,
                   astroId:  widget.astroid,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
