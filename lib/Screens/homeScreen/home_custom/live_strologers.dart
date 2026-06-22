import 'package:astro_gurujii/Screens/live/LiveVideoCallScreen.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../Models/live_listing/live_listing_reponse.dart';

class LiveAstrologerCard extends StatelessWidget {
  final List<Data> liveAstrologersList;

  LiveAstrologerCard({required this.liveAstrologersList});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: screenHeight * 0.3,  // Adjusted height for better layout
      child: GridView.builder(
        itemCount: liveAstrologersList.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 1.6,  // Improved aspect ratio for better card design
          crossAxisSpacing: 8,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              if (liveAstrologersList[index].isLive == "1") {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => LiveVideoCallScreen(
                //       screenType: "home",
                //       id: liveAstrologersList[index].sId,
                //       channelName: liveAstrologersList[index].channelId!,
                //       astroid: liveAstrologersList[index].astrologerId!.sId!,
                //       name: liveAstrologersList[index].astrologerId!.displayName!,
                //       astroImage: liveAstrologersList[index].astrologerId!.profileImg!,
                //       numberOfuserJoin: liveAstrologersList[index].users,
                //       profile: "",
                //     ),
                //   ),
                // ).then((value) {});
              } else {
                Fluttertoast.showToast(msg: "User is not live");
              }
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              width: screenWidth * 0.6,  // Adjust width for a balanced design
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent.withOpacity(0.6), Colors.blue.withOpacity(0.2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 3,
                    blurRadius: 6,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                          imageUrl: liveAstrologersList[index].astrologerId!.profileImg.toString(),
                          width: screenWidth,
                          height: screenHeight * 0.18,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: liveAstrologersList[index].isLive == "1"
                                ? Colors.redAccent
                                : Colors.grey.shade600,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            liveAstrologersList[index].isLive == "1" ? 'Live' : 'Upcoming',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Text(
                      liveAstrologersList[index].astrologerId!.displayName.toString(),
                      maxLines: 1,
                     
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    child: Text(
                      liveAstrologersList[index].isLive == "0"
                          ? "${liveAstrologersList[index].startTime} - ${liveAstrologersList[index].endTime}"
                          : "",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
