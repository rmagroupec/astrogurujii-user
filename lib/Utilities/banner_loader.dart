import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../Setup/app_colors.dart';

class ShimmerBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200]!, // Base color for shimmer
      highlightColor: AppColors.mlightPink, // Highlight color for shimmer
      child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)),
        width: double.infinity,  // Full-width for the banner
        height: 160,  // Height of the banner

      ),
    );
  }
}

class ShimmerBannerChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200]!, // Base color for shimmer
      highlightColor: AppColors.mlightPink, // Highlight color for shimmer
      child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)),
        width: double.infinity,  // Full-width for the banner
        height: 65,  // Height of the banner

      ),
    );
  }
}



class ShimmerAstrologerHome extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return
       SizedBox(
        height: 200,
        width: MediaQuery.of(context).size.width,
         child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: 5, // Show 5 shimmer items as placeholders
          itemBuilder: (context, index) {
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  width: 160,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(height: 10),
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey,
                      ),
                      Container(
                        width: 70,
                        height: 20,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: 100,
                        height: 12,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: 70,
                        height: 12,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: 130,
                        height: 35,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            );
          },
             ),
       );
    }

}



class AstroMallShimmerLoadinng extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Shimmer.fromColors(
        baseColor: Colors.grey[200]!, // Base color for shimmer
        highlightColor: AppColors.mlightPink, // Highlight color for shimmer
        child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)),
        width: double.infinity,  // Full-width for the banner
        height: 150,  // Height of the banner

        ),
        ),
        Container(
          height: 470,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
              itemCount: 3,
              itemBuilder:( (context, index) {
            return Shimmer.fromColors(
              baseColor: Colors.grey[200]!, // Base color for shimmer
              highlightColor: AppColors.mlightPink, // Highlight color for shimmer
              child: Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)),
                width: double.infinity,  // Full-width for the banner
                height: 140,  // Height of the banner

              ),
            );
          })),
        )
      ],
    );
    }

}



  class ShimmerImageLoader extends StatelessWidget {
  final String image;
  ShimmerImageLoader({required this.image});
    @override
    Widget build(BuildContext context) {
      return  CachedNetworkImage(
                imageUrl: image,
                imageBuilder: (context, imageProvider) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.contain
                      ),
                    ),
                  );
                },
                placeholder: (context, url) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[200]!, // Base color for shimmer
                    highlightColor: AppColors.mlightPink,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                    ),
                  );
                },
                errorWidget: (context, url, error) {
                  return Icon(Icons.error, color: Colors.red);
                },

      );
    }
  }


