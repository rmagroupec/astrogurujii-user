import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 4,
                offset: Offset(0, 0),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 5,
                offset: Offset(0, 0),
                spreadRadius: 0,
              ),
            ],
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFF5EE),
                Color(0xFFFFF5EE),
              ],
            ),
          ),
          width: 160,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 10),

              // CircleAvatar placeholder
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2.5),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[400],
                      ),
                    ),
                  ),

                  // Rating placeholder
                  Container(
                    width: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: Colors.grey[400], size: 20),
                          SizedBox(width: 5),
                          Container(
                            width: 20,
                            height: 10,
                            color: Colors.grey[400],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),

              // Name placeholder
              Container(
                width: 100,
                height: 10,
                color: Colors.grey[400],
              ),

              // Experience placeholder
              Container(
                width: 80,
                height: 10,
                color: Colors.grey[400],
              ),

              SizedBox(height: 10),

              // Pricing placeholder
              Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 10,
                      color: Colors.grey[400],
                    ),
                    SizedBox(width: 5),
                    Container(
                      width: 50,
                      height: 10,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10),

              // Chat button placeholder
              Container(
                height: 35,
                width: 130,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Container(
                    width: 50,
                    height: 10,
                    color: Colors.grey[400],
                  ),
                ),
              ),

              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
