
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

final primaryColor = Color(hexStringToHexInt("#FC7601"));
final blueColor = Color(hexStringToHexInt("#FC7601"));
final greyColor = Color(hexStringToHexInt("#AFAFAF"));
final greenColor = Color(hexStringToHexInt('#219D38'));
final whiteColor = Color(hexStringToHexInt("#ffffff"));
final InActive = Color(hexStringToHexInt("#CED0FB"));
final blackColor = Color(hexStringToHexInt("#000000"));
final greyColor12 = Color(hexStringToHexInt("#707070"));
//final greenColor = Color(hexStringToHexInt("#27AE60"));
final termsColor = Color(hexStringToHexInt("#4F4F4F"));
final otpSendColor = Color(hexStringToHexInt("#686868"));
final pinBoxColor = Color(hexStringToHexInt("#EAECEF"));
final greyColor1 = Color(hexStringToHexInt("#ADADAD"));
final greyColor2 = Color(hexStringToHexInt("#6C6C6C"));
final greyColor3 = Color(hexStringToHexInt("#b5b5b5"));
final yellow = Color(hexStringToHexInt("#FC7601"));
final blackLightcolor = Color(hexStringToHexInt("#4B4B4B"));
final signupcolor = Color(hexStringToHexInt(("#CED0FB")));
final signupgreycolor = Color(hexStringToHexInt("#F5F5F5"));
final redColor = Color(hexStringToHexInt("#FF0303"));
final lightYellow = Color(hexStringToHexInt("#fffcd9"));
final textFormFieldColor = Color(hexStringToHexInt("#FDF7F7"));
final blueGreyColor = hexStringToHexInt('#292b34');

final Color1 = Color(hexStringToHexInt('#EB5757'));
final Color2 = Color(hexStringToHexInt('#F2994A'));
final Color3 = Color(hexStringToHexInt('#F8B01E'));
final Color4 = Color(hexStringToHexInt('#FCDD44'));
final Color5 = Color(hexStringToHexInt('#E3EF5B'));
final Color6 = Color(hexStringToHexInt('#71CB95'));

final card1 = Color(hexStringToHexInt('#FFF6F1'));
final circle1 = Color(hexStringToHexInt('#FFA176'));

final card2 = Color(hexStringToHexInt('#EFFAF4'));
final circle2 = Color(hexStringToHexInt('#6CCF96'));

final card3 = Color(hexStringToHexInt('#FCF2FD'));
final circle3 = Color(hexStringToHexInt('#B766D5'));

final card4 = Color(hexStringToHexInt('#EFFAF4'));
final circle4 = Color(hexStringToHexInt('#FFA176'));

final card5 = Color(hexStringToHexInt('#EEF7FE'));
final circle5 = Color(hexStringToHexInt('#5A9EE8'));

final card6 = Color(hexStringToHexInt('#FFF2F9'));
final circle6 = Color(hexStringToHexInt('#FF85BD'));

final card7 = Color(hexStringToHexInt('#FEF6F2'));
final circle7 = Color(hexStringToHexInt('#F9A179'));

final card8 = Color(hexStringToHexInt('#EFFAF4'));
final circle8 = Color(hexStringToHexInt('#70D39A'));

final card9 = Color(hexStringToHexInt('#FCF2FD'));
final circle9 = Color(hexStringToHexInt('#BB6EDA'));

final primaryColors = Color(hexStringToHexInt("#983F48EE"));

final activeColor = Color(hexStringToHexInt("#3F48EE"));
final offlineColor = Color(hexStringToHexInt("#D9D9D9"));
final busyColor = Color(hexStringToHexInt("#FF0303"));

final testColor1 = Color(hexStringToHexInt("#505050"));

final greyColor44 = Color(hexStringToHexInt("#f5f5f5"));

final tabColor44 = Color(hexStringToHexInt("#c8cbff"));

final blackColor44 = Color(hexStringToHexInt("#65000000"));
final blackColor24 = Color(hexStringToHexInt("#99000000"));

final inActiveColor = hexStringToHexInt('#A9A9A9');
final outlineColor = hexStringToHexInt('#F6CFCE');

final redColor2 = hexStringToHexInt('#FC7601');
final gradientBlue = Color(hexStringToHexInt("#1C68CF"));
// final razorPayTxnKey = "rzp_live_r1vMEsVY2ZveDE";  // old  key
final razorPayTxnKey = "rzp_live_91JPRPBs9lDIZw";
final grayColor = hexStringToHexInt('#808080');
final yColor = hexStringToHexInt('#fcf7f7');
const String apiKey = "AIzaSyBmttZbafnoHuShZ-doazIKcuD7-T8Y8OI";
final testColor = hexStringToHexInt('#a7a6a6');
final pinkColor = hexStringToHexInt('#3F48EE');
final color1 = Color(hexStringToHexInt("#337ab7"));
final color2 = Color(hexStringToHexInt("#d9edf7"));
final color3 = Color(hexStringToHexInt("#dff0d8"));

String capitalize(String s) {
  try {
    if (s == null || s.isEmpty) {
      return "";
    }
    return s[0].toUpperCase() + s.substring(1);
  } catch (e) {
    print("Error: ${e.toString()}");
    return ""; // Return null or a fallback value if desired
  }
}

hexStringToHexInt(String hex) {
  hex = hex.replaceFirst('#', '');
  hex = hex.length == 6 ? 'ff' + hex : hex;
  int val = int.parse(hex, radix: 16);
  return val;
}

double roundDouble(double value, int places) {
  double mod = pow(10.0, places).toDouble();
  return ((value * mod).round().toDouble() / mod);
}
int calc_ranks(ranks) {
  double multiplier = .5;
  return (multiplier * ranks).toInt();
}

chacheImageProvider(String url) {
  CachedNetworkImage(
    imageUrl: url,
    progressIndicatorBuilder: (context, url, downloadProgress) =>
        CircularProgressIndicator(value: downloadProgress.progress),
    errorWidget: (context, url, error) => Icon(Icons.error),
  );
}

enum Availability { loading, available, unavailable }

class MyFonts {
  static String regular = "Poppins-Regular";
  static String bold = "Poppins-Bold";
  static String semibold = "Poppins-SemiBold";
  static String medium = "Poppins-Medium";
  static String font = "Poppins";
}
