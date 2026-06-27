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
    required this.channelName,
    required this.screenType,
  }) : super(key: key);

  @override
  State<BottomSection> createState() => _BottomSectionState();
}

class _BottomSectionState extends State<BottomSection> {
  bool muted = true;
  String? id;
  SharedPreferences? prefs;
  String groupChatId = "";

  TextEditingController textTobeSend = TextEditingController();

  // TODO: these two stats ("viewers/min" and "gifts-or-diamonds/min") and the
  // hourglass badge count aren't backed by an API in the current code. Wired
  // here as local placeholders — swap in real values once an endpoint exists.
  int usersPerMinute = 0;
  int giftsPerMinute = 0;
  int hourglassBadgeCount = 0;

  Future<void> onSendMessage(String content, int type) async {
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() == '') {
      Fluttertoast.showToast(
          msg: 'Nothing to send',
          backgroundColor: Colors.black,
          textColor: Colors.red);
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
    var messageReceiverRef = "GroupLive/" + widget.channelName;

    widget.messageChatReference =
        widget.messageChatReference.child("Group").child(widget.channelName).push();

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
  }

  void _openGiftSheet() {
    GiftBottomSheets.showGistBottomSheet(
      screenType: widget.screenType,
      id: widget.id.toString(),
      context: context,
      dataGifts: widget.dataGifts,
      astroId: widget.astroId.toString(),
    );
  }

  void _shareApp() {
    Share.share(
        "https://play.google.com/store/apps/details?id=com.user.astrogurujii&hl=en_IN");
  }

  void _onPhoneTap() {
    // TODO: hook up to whatever the phone icon should trigger
    // (e.g. request a private/paid call). Left as a share fallback for now.
    _shareApp();
  }

  void _onSendRailTap() {
    // TODO: hook up the rail's send/share icon to its real action.
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    const double inputBarHeight = 56;

    return Container(
      height: height * 0.5,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(0, 0, 0, 0),
            Colors.black.withOpacity(0.3),
          ],
        ),
      ),
      child: Stack(
        children: [
          // ── Left column: Send Gift button + activity feed ──
          Positioned(
            left: 12,
            right: width * 0.22,
            bottom: inputBarHeight + 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _SendGiftButton(onTap: _openGiftSheet),
                const SizedBox(height: 10),
                ChatStreem(
                  textEditingController: widget.textEditingController,
                  listScrollController: widget.listScrollController,
                  focusNode: widget.focusNode,
                  channelName: widget.channelName,
                  messageChatReference: widget.messageChatReference,
                ),
              ],
            ),
          ),

          // ── Right vertical icon rail ──
          Positioned(
            right: 10,
            bottom: inputBarHeight + 12,
            child: _RightIconRail(
              hourglassBadgeCount: hourglassBadgeCount,
              usersPerMinute: usersPerMinute,
              giftsPerMinute: giftsPerMinute,
              onSendTap: _onSendRailTap,
              onGiftTap: _openGiftSheet,
              onPhoneTap: _onPhoneTap,
            ),
          ),

          // ── Bottom "Say hi..." input bar ──
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: inputBarHeight,
              padding: EdgeInsets.symmetric(horizontal: width / 28.26, vertical: 8),
              color: Colors.black.withOpacity(0.30),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: width / 42.44),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(width / 14.33),
                      ),
                      child: TextFormField(
                        maxLines: 1,
                        controller: textTobeSend,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: width / 28.26,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          hintText: "Say hi...",
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          hintStyle: TextStyle(
                            color: Colors.black54,
                            fontSize: width / 28.26,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: width / 42.40),
                  InkWell(
                    onTap: () {
                      onSendMessage(textTobeSend.text.toString(), 0);
                      textTobeSend.clear();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(9),
                      decoration:
                          const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                      child: Icon(Icons.send, color: Colors.white, size: width / 19.27),
                    ),
                  ),
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
  }
}

// ── "Send Gift" pill button ───────────────────────────────────────────────────

class _SendGiftButton extends StatelessWidget {
  final VoidCallback onTap;
  const _SendGiftButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.card_giftcard, color: Colors.black87, size: 16),
            SizedBox(width: 6),
            Text(
              'Send Gift',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Right-edge vertical icon rail (send, gift, hourglass+badge, phone, stats) ──

class _RightIconRail extends StatelessWidget {
  final int hourglassBadgeCount;
  final int usersPerMinute;
  final int giftsPerMinute;
  final VoidCallback onSendTap;
  final VoidCallback onGiftTap;
  final VoidCallback onPhoneTap;

  const _RightIconRail({
    required this.hourglassBadgeCount,
    required this.usersPerMinute,
    required this.giftsPerMinute,
    required this.onSendTap,
    required this.onGiftTap,
    required this.onPhoneTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _RailIcon(icon: Icons.near_me_outlined, faded: true, onTap: onSendTap),
        const SizedBox(height: 14),
        _RailIcon(icon: Icons.card_giftcard, onTap: onGiftTap),
        const SizedBox(height: 14),
        _RailIcon(
          icon: Icons.hourglass_bottom,
          badgeCount: hourglassBadgeCount,
          onTap: () {},
        ),
        const SizedBox(height: 14),
        _RailIcon(icon: Icons.call, onTap: onPhoneTap),
        const SizedBox(height: 12),
        _StatChip(icon: Icons.people, label: '$usersPerMinute/m'),
        const SizedBox(height: 4),
        _StatChip(icon: Icons.favorite, iconColor: Colors.redAccent, label: '$giftsPerMinute/m'),
      ],
    );
  }
}

class _RailIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool faded;
  final int? badgeCount;

  const _RailIcon({
    required this.icon,
    required this.onTap,
    this.faded = false,
    this.badgeCount,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(faded ? 0.12 : 0.22),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white.withOpacity(faded ? 0.6 : 1), size: 18),
          ),
          if (badgeCount != null && badgeCount! > 0)
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                child: Text(
                  '$badgeCount',
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;

  const _StatChip({required this.icon, required this.label, this.iconColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: iconColor, size: 13),
        const SizedBox(width: 3),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }
}