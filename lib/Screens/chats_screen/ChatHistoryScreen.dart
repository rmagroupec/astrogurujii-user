
import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Screens/WebviewScreen.dart';
import 'package:astro_gurujii/Screens/chats_screen/chat/audio_play_pop_up.dart';
import 'package:astro_gurujii/Screens/chats_screen/image/ImageModel.dart';
import 'package:astro_gurujii/Screens/video_call/Helpers/utils.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Loading.dart';

class ChatHistoryScreen extends StatelessWidget {
  final String? channelID;
  final String? astrologer_id;
  final String? astrologer_name;
  final String? gid;
  final String? currency;
  final String? astrologer_chat_rate;
  final String? astrologer_image;
  final String? wallet;

  ChatHistoryScreen(
      {Key? key,
      this.channelID,
      this.astrologer_id,
      this.astrologer_name,
      this.gid,
      this.currency,
      this.astrologer_chat_rate,
      this.astrologer_image,
      this.wallet})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatScreen(
          channelID: channelID,
          astrologer_id: astrologer_id,
          astrologer_name: astrologer_name,
          gid: gid,
          currency: currency,
          astrologer_chat_rate: astrologer_chat_rate,
          astrologer_image: astrologer_image,
          wallet: wallet),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String? channelID;
  final String? astrologer_id;
  final String? astrologer_name;
  final String? gid;
  final String? currency;
  final String? astrologer_chat_rate;
  final String? astrologer_image;
  final String? wallet;

  ChatScreen(
      {Key? key,
      this.channelID,
      this.astrologer_id,
      this.astrologer_name,
      this.gid,
      this.currency,
      this.astrologer_chat_rate,
      this.astrologer_image,
      this.wallet})
      : super(key: key);

  @override
  State createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {


  String? peerId;
  String? peerAvatar;
  String? id;
  HttpServices _httpService = HttpServices();
  int _limit = 20;
  int _limitIncrement = 20;
  String? groupChatId = "";
  SharedPreferences? prefs;
  DatabaseReference? RootRef;
  DatabaseReference? messageChatReference;
  File? imageFile;
  bool isLoading = false;
  bool isShowSticker = false;
  String? imageUrl = "";
  Timer? timer;
  Timer? meetingTimer;
  var meetingDurationTxt = "00:00".obs;
  var mins = 0;
  int meetingDuration = 0;

  String? imageName = 'Upload Image';
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  _scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  Timer? _timer;

  _callTimerApi() {
    /* videoCallCoinsDeductCall();*/
    _timer = Timer.periodic(Duration(seconds: 59), (timer) {
      //videoCallCoinsDeductCall();
    });
  }

  Future<ImageModel> _uploadImage(File file) async {
    final prefs = await SharedPreferences.getInstance();
    String? fileName = file.path.split('/').last;
    Dio dio = Dio();
    // print("===="+file.path);

    FormData data = FormData.fromMap({
      "token": prefs.getString('userID'),
      "image": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
        // contentType:  MediaType("image", "jpeg")
      ),
    });
    try {
      Response response = await dio.post(
          'https://api.astrogurujii.com/user_api/upload_a_image',
          options: Options(
              contentType: 'multipart/form-data', validateStatus: (_) => true),
          data: data);
      return ImageModel.fromJson(response.data);
    } catch (e) {
      //print("00000000000000"+e.toString?());

      throw Exception('Error uploading image: $e'); 
    }
  }

  Future<void> EndChatWebservice() async {
    id = prefs!.getString('userID')! ?? '';
    var res = await _httpService.change_connection_request_status(
        channel_id: widget.channelID!, status: "end_user");
    if (res!.status == true) {
      // Close dialog
      timeree!.cancel();
      //show(context);
    } else {
      //  EndChatWebservice();
    }
  }

  var userNames = "";
  var astr_comment = "";
  Future<void> ratingDetailsWebservice() async {
    id = prefs!.getString('userID') ?? '';
    var res = await _httpService.review_list_by_channel_id(
      id: widget.channelID!,
    );
    if (res!.status == true) {
      setState(() {
        review_controler.text = res.results![0].review!;
        userNames = res.results![0].name!;
        userimage = res.results![0].profileImg!;
        rating_point = double.parse(res.results![0].rating!.toString());
        astr_comment = res.results![0].astrComment.toString();
      });
    } else {
      //  EndChatWebservice();
    }
  }

  @override
  void dispose() {
    //print("\n============ ON DISPOSE ===============\n");
    super.dispose();
    meetingTimer!.cancel();
    _timer!.cancel();
  }

  Future<void> checkForNewStatus() async {
    var res =
        await _httpService.call_initiate_status(channel_id: widget.channelID!);
    if (res!.status == true) {
      if (res.results!.status == "accept_astro") {
      } else if (res.results!.status == "reject_astro") {
        timeree!.cancel();
        Navigator.pop(context);
      } else if (res.results!.status == "end_astro") {
        try {
          timeree!.cancel();

          meetingTimer!.cancel();
          //show(context);
        } catch (e) {}
      }
    } else {
      //  EndChatWebservice();
    }
  }

  Timer? timeree;
  @override
  void initState() {
    focusNode.addListener(onFocusChange);
    listScrollController.addListener(_scrollListener);
    //timeree = Timer.periodic(Duration(seconds: 2), (Timer t) => checkForNewStatus());
    ratingDetailsWebservice();
    getProfile();
    //startMeetingTimer();
    readLocal();
    //_callTimerApi();
    super.initState();
//https://stackoverflow.com/questions/65056272/how-to-configure-firebase-messaging-with-latest-version-in-flutter
    /* FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {

      }
    });*/

    /*final fbm = FirebaseMessaging.instance;
    fbm.requestPermission();
    fbm.configure(onMessage: (msg) {
      print("====jksjjs==>"+msg["data"]["type"]);

      String? noti_type=msg["data"]["type"];


      if(noti_type=="end_astro"){
        Navigator.pop(context);
        */ /*Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => BottomNavigation()));*/ /*
      }

      return;
    }, onLaunch: (msg) {
      print("skaklskls"+msg.toString?());
      return;
    }, onResume: (msg) {
      print("skaklskls"+msg.toString?());
      return;
    });*/
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        isShowSticker = false;
      });
    }
  }

  readLocal() async {
    prefs = await SharedPreferences.getInstance();
    id = prefs!.getString('id') ?? '';
    if (id.hashCode <= peerId.hashCode) {
      groupChatId = '$id-$peerId';
    } else {
      groupChatId = '$peerId-$id';
    }

    //FirebaseFirestore.instance.collection('users').doc(id).update({'chattingWith': peerId});
    //group_id:4    user_id:3  reciver_id:6
    RootRef = FirebaseDatabase.instance
        .ref()
        .child("Group")
        .child(widget.gid!)
        .child(prefs!.getString('id')!)
        .child(widget.astrologer_id!);

    // FirebaseFirestore.instance.collection('users').doc(id).update({'chattingWith': peerId});
    //  RootRef.push().set({
    //    'text': "arvind",
    //    'email': "arvind@gmail.com",
    //    'imageUrl': "defalt.png",
    //    'senderName': "arvind",
    //    'senderPhotoUrl': "sender.png",
    //  });

    var user_id = prefs!.getString('id');
    var name = prefs!.getString('name');
    var timestamp = DateTime.now().millisecondsSinceEpoch;

    var messageSenderRef = "Group/" +
        widget.gid! +
        "/" +
        prefs!.getString('id')! +
        "/" +
        widget.astrologer_id!;

    var messageReceiverRef = "Group/" +
        widget.gid! +
        "/" +
        widget.astrologer_id! +
        "/" +
        prefs!.getString('id')!;

    messageChatReference = RootRef!.child("Group")
        .child(widget.gid!)
        .child(prefs!.getString('id')!)
        .child(widget.astrologer_id!)
        .push();

    var messagePushId = messageChatReference!.key;
    var gender = prefs!.getString('gender');
    var dob = prefs!.getString('dob');
    var birth_place = prefs!.getString('birth_place');
    var birth_time = prefs!.getString('birth_time');

    var senderMessage = " Name : " +
        name! +
        "\n Gender : " +
        gender! +
        "\n BirthDate : " +
        dob! +
        "\n Birth Time : " +
        birth_time! +
        "\n Birth Location : " +
        birth_place!;
    Map reqBody = {
      'date': "",
      'from': user_id,
      'mRecipientOrSenderStatus': 0,
      'message': senderMessage,
      'message_id': messagePushId,
      'date_time': timestamp,
      'name': name,
      'time': "",
      'to': widget.astrologer_id,
      'type': "text",
    };

    var s1 = "$messageSenderRef/$messagePushId";
    var s2 = "$messageReceiverRef/$messagePushId";

    var MessageBodyDetails = HashMap<String?, Map>();
    MessageBodyDetails[s1] = reqBody;
    MessageBodyDetails[s2] = reqBody;

    // FirebaseDatabase.instance.reference().update(MessageBodyDetails);

    setState(() {
      // readData();
    });
  }

  void readData() {
    FirebaseDatabase.instance.ref().once().then((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      // Handle snapshot.value if needed
    });

    RootRef!.child(widget.gid!).once().then((DatabaseEvent event) {
      DataSnapshot data = event.snapshot;
      setState(() {
        var retrievedName = data.value;
      });
    });
  }


  Future getImage() async {
    /*  ImagePicker imagePicker = ImagePicker();
    File _imageFile;


    _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (_imageFile != null) {
      imageFile = File(_imageFile.path);
      if (imageFile != null) {
        setState(() {
          isLoading = false;
        });
        var res= _uploadImage(imageFile).then((user) {
          setState(() {

            imageName = user.file_name;
            imageUrl = user.url;
            uploadFile(imageUrl+imageName);
          });
        });

      }
    }*/
  }

  void getSticker() {
    // Hide keyboard when sticker appear
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  Future uploadFile(String? file) async {
    onSendMessage(file, 1);
    /* String? fileName = DateTime.now().millisecondsSinceEpoch.toString?();
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(imageFile);

    try {
      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        isLoading = false;

      });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.message ?? e.toString?());
    }*/
  }

  Future<void> onSendMessage(String? content, int type) async {
    // type: 0 = text, 1 = image, 2 = sticker

    //var  messageSenderRef="Group/" +peerId+"/"
    var message_type = "text";
    if (type == 0) {
      message_type = "text";
    } else if (type == 1) {
      message_type = "image";
    }

    if (content!.trim() != '') {
      textEditingController.clear();

      prefs = await SharedPreferences.getInstance();
      id = prefs!.getString!('id') ?? '';
      if (id.hashCode <= peerId.hashCode) {
        groupChatId = '$id-$peerId';
      } else {
        groupChatId = '$peerId-$id';
      }

      /* //FirebaseFirestore.instance.collection('users').doc(id).update({'chattingWith': peerId});
      //group_id:4    user_id:3  reciver_id:6
      RootRef=FirebaseDatabase.instance.reference()
          .child("Group").child(widget.gid).child(prefs!.getString('id')).child(widget.astrologer_id);
*/

      var user_id = prefs!.getString('id');
      var name = prefs!.getString('name');
      var timestamp = DateTime.now().millisecondsSinceEpoch;
      var messageSenderRef = "Group/" +
          widget.gid! +
          "/" +
          prefs!.getString('id')! +
          "/" +
          widget.astrologer_id!;

      var messageReceiverRef = "Group/" +
          widget.gid! +
          "/" +
          widget.astrologer_id! +
          "/" +
          prefs!.getString('id')!;

      messageChatReference = RootRef!.child("Group")
          .child(widget.gid!)
          .child(prefs!.getString('id')!)
          .child(widget.astrologer_id!)
          .push();

      var messagePushId = messageChatReference!.key;
      Map<String, dynamic> reqBody = {
        'date': "",
        'from': user_id,
        'mRecipientOrSenderStatus': 0,
        'message': content,
        'message_id': messagePushId,
        'date_time': timestamp,
        'name': name,
        'time': "",
        'to': widget.astrologer_id,
        'type': message_type,
      };

      var s1 = "$messageSenderRef/$messagePushId";
      var s2 = "$messageReceiverRef/$messagePushId";

      Map<String, Object?> messageBodyDetails = {
  s1: reqBody,
  s2: reqBody,
};

      FirebaseDatabase.instance.ref().update(messageBodyDetails);

      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(
          msg: 'Nothing to send',
          backgroundColor: Colors.black,
          textColor: Colors.red);
    }
  }

  final HttpServices _httpServices = HttpServices();
  var userimage = "https://api.astrogurujii.com/images/i/user_d.jpg";
  void getProfile() async {
    // print("hjghfjgjh");
    var res = await _httpServices.profile_api();
    if (res!.status == true) {
      setState(() {
        userimage = res.results!.profileImg!;
      });
    } else {
      Fluttertoast.showToast(msg: res.message!);
    }
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      //FirebaseFirestore.instance.collection('users').doc(id).update({'chattingWith': null});
      // Navigator.pop(context);
    }

    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    //var comments = RootRef.orderByChild('date_time').limitToLast(10);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: whiteColor,
        title: Container(
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 10,
            ),
            color: whiteColor,
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: CircleAvatar(
                          radius: 25,
                          backgroundImage:
                              CachedNetworkImageProvider(userimage),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 150,
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  capitalize(widget.astrologer_name!),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
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
        ),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              // List of messages

              /*  Container(
                height: 40,
                color: Colors.pink,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("    Time: "+meetingDurationTxt.value,style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w400),),
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: (){

                          EndChatWebservice();
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 30),
                          child: Text(
                            "End",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),*/

              Expanded(child: buildListMessage()),
              // buildFirebaseList(),
              // Sticker

              // Input content
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildInputRating(),
              ),
            ],
          ),

          // Loading
          buildLoading()
        ],
      ),
    );
  }

  Widget buildInputRating() {
    return Card(
      color: card9,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Container(
              color: card9,
              padding: EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              child: CircleAvatar(
                                radius: 25,
                                backgroundImage:
                                    CachedNetworkImageProvider(userimage),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 150,
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        userNames.toString(),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: RatingBar.builder(
                                        itemSize: 25,
                                        glowColor: Color(0xfff19425),
                                        initialRating: rating_point,
                                        ignoreGestures: true,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemBuilder: (context, _) {
                                          return Icon(
                                            Icons.star,
                                            color: Color(0xfff19425),
                                          );
                                        },
                                        onRatingUpdate: (rating) {
                                          setState(() {
                                            rating_point = rating;
                                          });
                                        }),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            margin: EdgeInsets.only(left: 0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                review_controler.text,
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                        (astr_comment.length > 0)
                            ? Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    color: card8,
                                    child: Column(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: 0),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              widget.astrologer_name!,
                                              style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 0),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              astr_comment,
                                              style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox()
                      ],
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                show(context);
              },
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(Icons.more_vert)),
            )
          ],
        ),
      ),
    );
  }

  Widget buildSticker() {
    return Expanded(
      child: Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                TextButton(
                  onPressed: () => onSendMessage('mimi1', 2),
                  child: Image.asset(
                    'images/mimi1.gif',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage('mimi2', 2),
                  child: Image.asset(
                    'images/mimi2.gif',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage('mimi3', 2),
                  child: Image.asset(
                    'images/mimi3.gif',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
            Row(
              children: <Widget>[
                TextButton(
                  onPressed: () => onSendMessage('mimi4', 2),
                  child: Image.asset(
                    'images/mimi4.gif',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage('mimi5', 2),
                  child: Image.asset(
                    'images/mimi5.gif',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage('mimi6', 2),
                  child: Image.asset(
                    'images/mimi6.gif',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
            Row(
              children: <Widget>[
                TextButton(
                  onPressed: () => onSendMessage('mimi7', 2),
                  child: Image.asset(
                    'images/mimi7.gif',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage('mimi8', 2),
                  child: Image.asset(
                    'images/mimi8.gif',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage('mimi9', 2),
                  child: Image.asset(
                    'images/mimi9.gif',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            )
          ],
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        ),
        decoration: BoxDecoration(
            border: Border(top: BorderSide(color: greyColor44, width: 0.5)),
            color: Colors.white),
        padding: EdgeInsets.all(5.0),
        height: 180.0,
      ),
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: false ? const Loading() : Container(),
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          /*Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.image),
                onPressed: getImage,
                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),*/
          /* Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.face),
                onPressed: getSticker,
                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),
*/
          // Edit text
          SizedBox(
            width: 9,
          ),
          /* Flexible(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: greyColor44,
                borderRadius:  BorderRadius.circular(32),
              ),
              child: Align(
                alignment:Alignment.centerLeft ,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15,right: 5),
                  child: TextField(
                    onSubmitted: (value) {
                      onSendMessage(textEditingController.text, 0);
                    },
                    style: TextStyle(color: blackColor, fontSize: 15.0),
                    controller: textEditingController,


                    decoration: InputDecoration.collapsed(
                      border: InputBorder.none,
                      hintText: 'Type your message...',
                      hintStyle: TextStyle(color: greyColor),
                    ),
                    focusNode: focusNode,
                  ),
                ),
              ),
            ),
          ),*/

          // Button send message
          /* Material(
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: greyColor44,
                borderRadius:  BorderRadius.circular(32),
              ),
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => {},
                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),*/
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: greyColor44, width: 0.5)),
          color: Colors.white),
    );
  }

  // Widget buildListMessage() {
  //   return Flexible(
  //     child: FirebaseAnimatedList(
  //       query: FirebaseDatabase.instance.ref().child("your_child_path").orderByChild("date_time"),
  //       padding: EdgeInsets.all(8.0),
  //       reverse: true,
  //       controller: listScrollController,
  //       sort: (DataSnapshot a, DataSnapshot b) => b.key.compareTo(a.key),
  //       itemBuilder: (_, DataSnapshot snapshot, Animation<double> animation, int x) {
  //         if (snapshot.value == null) return SizedBox.shrink();

  //         Map<String?, dynamic> data = Map<String?, dynamic>.from(snapshot.value as Map);

  //         return (data["from"] == id)
  //             ? Row(
  //           mainAxisAlignment: MainAxisAlignment.end,
  //           children: <Widget>[
  //             data["type"] == "text"
  //                 ? Container(
  //               child: Text(
  //                 data["message"],
  //                 style: TextStyle(color: blackColor),
  //               ),
  //               padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
  //               width: 200.0,
  //               decoration: BoxDecoration(
  //                   color: greyColor44,
  //                   borderRadius: BorderRadius.circular(8.0)),
  //               margin: EdgeInsets.only(bottom: 10.0, right: 10.0),
  //             )
  //                 : data["type"] == "image"
  //                 ? Container(
  //               child: Image.network(
  //                 data["message"],
  //                 width: 200.0,
  //                 height: 200.0,
  //                 fit: BoxFit.cover,
  //               ),
  //               margin: EdgeInsets.only(bottom: 10.0, right: 10.0),
  //             )
  //                 : Container(
  //               child: Image.asset(
  //                 'images/${data["message"]}.gif',
  //                 width: 100.0,
  //                 height: 100.0,
  //                 fit: BoxFit.cover,
  //               ),
  //               margin: EdgeInsets.only(bottom: 10.0, right: 10.0),
  //             ),
  //           ],
  //         )
  //             : Row(
  //           children: <Widget>[
  //             CircleAvatar(
  //               backgroundImage: NetworkImage(widget.astrologer_image),
  //               radius: 18,
  //             ),
  //             SizedBox(width: 10),
  //             data["type"] == "text"
  //                 ? Container(
  //               child: Text(
  //                 data["message"],
  //                 style: TextStyle(color: Colors.white),
  //               ),
  //               padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
  //               width: 200.0,
  //               decoration: BoxDecoration(
  //                   color: primaryColor,
  //                   borderRadius: BorderRadius.circular(8.0)),
  //             )
  //                 : data["type"] == "image"
  //                 ? Container(
  //               child: Image.network(
  //                 data["message"],
  //                 width: 200.0,
  //                 height: 200.0,
  //                 fit: BoxFit.cover,
  //               ),
  //               margin: EdgeInsets.only(left: 10.0),
  //             )
  //                 : Container(
  //               child: Image.asset(
  //                 'images/${data["message"]}.gif',
  //                 width: 100.0,
  //                 height: 100.0,
  //                 fit: BoxFit.cover,
  //               ),
  //               margin: EdgeInsets.only(left: 10.0),
  //             ),
  //           ],
  //         );
  //       },
  //     ),
  //   );
  // }

Widget buildListMessage() {
  return  Flexible(
            child: Stack(
            children: [
              Positioned.fill(
                child: Container(color: redColor,)
              ),
              FirebaseAnimatedList(
                  query: FirebaseDatabase.instance.ref().child("your_child_path").orderByChild("date_time"),
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                  reverse: true,
                  controller: listScrollController,
                  sort: (DataSnapshot a, DataSnapshot b) =>
                      b.key!.compareTo(a.key!),
                  itemBuilder: (_, DataSnapshot snapshot,
                      Animation<double> animation, int x) {
                    if (snapshot.value == null || snapshot.value is! Map) {
                      return SizedBox(); // Prevent null errors
                    }

                    final messageData =
                        Map<String?, dynamic>.from(snapshot.value as Map);

                    bool isMe = messageData["from"] == id;

                    return Row(
                      mainAxisAlignment: isMe
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: <Widget>[
                        Flexible(
                          child: Container(
                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                            padding: EdgeInsets.all(12.0),
                            margin: EdgeInsets.only(
                              bottom: 10.0,
                              right: isMe ? 10.0 : 0,
                              left: isMe ? 0 : 10.0,
                            ),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey
                                      .withOpacity(0.1), // Shadow color
                                  spreadRadius: 2, // Spread radius
                                  blurRadius: 2, // Blur radius
                                  offset: Offset(
                                      0, 1), // Changes position of shadow
                                ),
                              ],
                              color: isMe
                                  ? Color.fromARGB(255, 243, 166, 73)
                                      .withOpacity(0.5)
                                  : Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(isMe ? 12.0 : 0),
                                topRight: Radius.circular(isMe ? 0 : 12.0),
                                bottomLeft: Radius.circular(12.0),
                                bottomRight: Radius.circular(12.0),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                messageData["type"] == "text"
                                    ? Text(
                                        messageData["message"] ?? "",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12.0,
                                            wordSpacing: 1,
                                            fontWeight: FontWeight.w600),
                                      )
                                    : messageData["type"] == "image"
                                        ? GestureDetector(
                                            onTap: () {
                                               Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (_) =>
                                                                        WebviewScreen(
                                                                          url:  messageData["message"].toString(),
                                                                        )));
                                                          },
                                            
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Image.network(
                                                messageData["message"] ?? "",
                                                width: 200.0,
                                                height: 200.0,
                                                fit: BoxFit.cover,
                                                loadingBuilder: (context, child,
                                                    loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  }
                                                  return Center(
  child: CircularProgressIndicator(
    value: loadingProgress.expectedTotalBytes != null
        ? loadingProgress.cumulativeBytesLoaded /
            loadingProgress.expectedTotalBytes!
        : null,
  ),
);

                                                },
                                                errorBuilder: (context, error,
                                                        stackTrace) =>
                                                    Icon(
                                                  Icons.broken_image,
                                                  size: 100,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          )
                                        : messageData["type"] == "audio"
                                            ? buildAudioPlaybackButton(
                                                messageData["message"]
                                                        .toString() ??
                                                    "")
                                            : Image.asset(
                                                'images/${messageData["message"]}.gif',
                                                width: 100.0,
                                                height: 100.0,
                                                fit: BoxFit.cover,
                                              ),
                                SizedBox(height: 5.0),
                                Text(
                                  DateFormat('hh:mm a').format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          (messageData["date_time"] ??
                                              DateTime.now()
                                                  .millisecondsSinceEpoch))),
                                  style: TextStyle(
                                      color:
                                          isMe ? Colors.grey : Colors.black54,
                                      fontSize: 9.0,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
            ],
          ));
        // : SizedBox();
  }
   Widget buildAudioPlaybackButton(String? mp3File) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: IconButton(
          icon: Icon(Icons.play_arrow, color: primaryColor),
          onPressed: () {
            if (mp3File != null || mp3File != "") {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AudioPlayerPopup(
                    mp3File: mp3File!,
                  );
                },
              );
            } else {
              Fluttertoast.showToast(
                  msg: "Kindly wait for a while, audio file is loading.");
            }
          },
        ),
      ),
    );
  }


  void startMeetingTimer() {
    meetingTimer = Timer.periodic(
      const Duration(seconds: 1),
      (meetingTimer) {
        int min = (meetingDuration ~/ 60);
        int sec = (meetingDuration % 60).toInt();

        meetingDurationTxt.value = min.toString() + ":" + sec.toString() + "";

        if (checkNoSignleDigit(min)) {
          meetingDurationTxt.value =
              "0" + min.toString() + ":" + sec.toString() + "";
        }
        if (checkNoSignleDigit(sec)) {
          if (checkNoSignleDigit(min)) {
            meetingDurationTxt.value =
                "0" + min.toString() + ":0" + sec.toString() + "";
          } else {
            meetingDurationTxt.value =
                min.toString() + ":0" + sec.toString() + "";
          }
        }
        setState(() {
          mins = min;
          meetingDuration = meetingDuration + 1;
        });
      },
    );
  }

  Future<void> callAliForRaiting(double rating_point, String? text) async {
    var res = await _httpService.add_rating(
        channel_id: widget.channelID!,
        rating: rating_point.toString(),
        review: text!);
    if (res!.status == true) {
      setState(() {});
    } else {
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }

  double rating_point = 0.0;
  TextEditingController review_controler = TextEditingController();
  show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          content: StatefulBuilder(
            // You need this, notice the parameters below:
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Please rate your experience',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RatingBar.builder(
                      itemSize: 30,
                      glowColor: Color(0xfff19425),
                      initialRating: rating_point,
                      itemBuilder: (context, _) {
                        return Icon(
                          Icons.star,
                          color: Color(0xfff19425),
                        );
                      },
                      onRatingUpdate: (rating) {
                        setState(() {
                          rating_point = rating;
                        });
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Additional comments',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: EdgeInsets.only(left: 10, bottom: 5),
                    child: TextFormField(
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      minLines: null,
                      maxLines:
                          null, // If this is null, there is no limit to the number of lines, and the text container will start with enough vertical space for one line and automatically grow to accommodate additional lines as they are entered.
                      expands: true,
                      controller: review_controler,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Review Here",
                          hintStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (rating_point < 1) {
                          Fluttertoast.showToast(
                              msg: "Please give your valuable feedback");
                        } else {
                          Navigator.pop(context);
                          callAliForRaiting(
                              rating_point, review_controler.text);
                        }
                      });
                    },
                    child: Container(
                        height: 45,
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xffFC7601),
                              Color(0xffFC7601),
                              Color(0xffFC7601),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          //  color:Color(0xFFff8542),
                        ),
                        child: Text(
                          "SUBMIT",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700),
                        )),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
