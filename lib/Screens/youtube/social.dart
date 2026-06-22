import 'package:astro_gurujii/Screens/youtube/YoutubeScreen.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Content extends StatefulWidget {
  const Content({Key? key}) : super(key: key);

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String getThumbnail({
    required String videoId,
    String quality = ThumbnailQuality.standard,
    bool webp = true,
  }) =>
      webp
          ? 'https://i3.ytimg.com/vi_webp/$videoId/$quality.webp'
          : 'https://i3.ytimg.com/vi/$videoId/$quality.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(image: NetworkImage(getThumbnail(videoId: 'PQSagzssvUQ')))),
          ),
        ],
      ),
    );
  }
}

class Social extends StatefulWidget {
  var videoData;



  Social({Key? key,this.videoData}) : super(key: key);

  @override
  State<Social> createState() => _SocialState();
}

class _SocialState extends State<Social> {
  String getThumbnail({
    required String videoId,
    String quality = ThumbnailQuality.standard,
    bool webp = true,
  }) =>
      webp
          ? 'https://i3.ytimg.com/vi_webp/$videoId/$quality.webp'
          : 'https://i3.ytimg.com/vi/$videoId/$quality.jpg';


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
      ),
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: widget.videoData.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>YoutubeScreen(videoId: widget.videoData[index].videoId,)));
              },
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      height: 160,
                      width: widget.videoData.length>1?240:Get.width-30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(22)),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(getThumbnail(videoId: widget.videoData[index].videoId)))),
                    ),
                    ///youtube_icon
                    SvgPicture.asset('assets/astro/youtube_icon.svg'),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
