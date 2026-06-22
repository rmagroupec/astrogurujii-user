import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {

    //new
  static const Color primaryOrange = Color(0xFFFC7601);
  static const Color primaryOrangeop = Color(0xFF64FC7601);
  static const Color textFieldCOlor = Color(0xFFFDF7F7);


  static const Color color1Pink = Color(0xFFEC008C);
  static const Color color2Pink = Color(0xFFFC6767);


  static const Color color1green = Color(0xFF81FF8A);
  static const Color color2green = Color(0xFF64965E);
  static const Color yellowColor = Color(0xFFFFB900);
  static const Color appGreenColor = Color(0xFF157C04);
  static const Color appblueColor = Color(0xFF0050C8);
  static const Color showMoreColor = Color(0xFF2296F1);






  ///Common
  static const Color primary = Color(0xFF1a222d);
  static const Color secondary = Color(0xFFd74315);
  static const Color accent = Color(0xFFd74315);
  static const Color lightPink = Color(0x81EAB8E3);
  static const Color mlightPink = Color(0xFFFFDDC7);
  static const Color mBGColor = Color.fromRGBO(50, 53, 122,1 );
  ///Background
  static const Color background = Color(0xFF1a222d);
  static const Color background1 = Color(0xFFE5E5E5);
  static const Color backgroundLighter = Color(0xFF1f2837);
  static const Color backgroundDarker = Color(0xff111821);

  ///Shadow
  static const Color shadow = Color(0x25606060);

  ///Border
  static const Color border = Color(0xFF606060);

  ///Divider
  static const Color divider = Color(0xFF606060);

  ///Text
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color whats = Color(0xFFcF2F2F2);
  static const Color textBlack = Color(0xFF000000);
  static const Color textBlue = Color(0xFF0000FF);
  static const Color twoBlue = Color(0xFF0050C8);
  static const Color textBlue2 = Color(0xFFCCDBEE);
  static const Color textPink = Color(0xFFFF9C9C);
  static const Color textDisable = Color(0xFF89a3b1);
  static const Color grey2 = Color(0xFF394750);
  static const Color grey2_5 = Color(0xFF607686);
  static const Color grey3 = Color(0xFF94A6B3);
  static const Color grey4 = Color(0xFFDADCDD);
  static const Color grey5 = Color(0xFFEEF0F1);
  static const Color grey1 = Color(0xFF232323);
  static const Color dividerColor = Color(0xFFEEF0F1);
  static const Color colorD9D9D9 = Color(0xFFD9D9D9);
  static const Color color7BBCB6 = Color(0xFF7BBCB6);
  static const Color colorFFA467 = Color(0xFFFFA467);
  static const Color pechOrage = Color(0xFFFBAB66);
  static const Color colorF2EEF7 = Color(0xFFF2EEF7);
  static const Color lightPurple = Color(0xFFCCBADE);
  static const Color purpleColor = Color(0xFFFC7601);
  static const Color appthemeColor = Color(0xFFFC7601);
  static const Color orangeColor = Color(0xFFFC7601);
  static const Color norangeColor = Color(0xFFDE8047);
  static const Color nblacksColor = Color(0xFF181818);
  static const Color colorFDFDFD = Color(0xFFFDFDFD);
  static const Color colorFFF9ED = Color(0xFFFFF9ED);
  static const Color colorB3B3B3 = Color(0xFFB3B3B3);
  static const Color color666666 = Color(0xFF666666);
  static const Color color4470AD = Color(0xFF4470AD);
  static const Color color4470ADf = Color(0x9D4470AD);
  static const Color lightOrange = Color(0xFFFFDDB5);
  static const Color lightOrangeopp64 = Color(0xFF32FFDDB5);
  static const Color colorECF1F9 = Color(0xFFECF1F9);
  static const Color lightgreen = Color(0xFFEBFAF8);
  static const Color color9B3838 = Color(0xFF9B3838);
  static const Color colorred = Color(0xFFCE4D00);
  static const Color color387F75 = Color(0xFF387F75);
  static const Color color1A1A1A = Color(0xFF1A1A1A);
  static const Color color607686 = Color(0xFF607686);
  static const Color color94A6B3 = Color(0xFF94A6B3);
  static const Color lightuser = Color(0xFFFFDDB5);
  static const Color lightastro = Color(0xFFEEF0F1);

  static const Color colorchat_test = Color(0xFF607686);

  ///TextField
  static const Color textFieldEnabledBorder = Color(0xFF919191);
  static const Color textFieldFocusedBorder = Color(0xFFd74315);
  static const Color textFieldDisabledBorder = Color(0xFF919191);
  static const Color textFieldCursor = Color(0xFF919191);

  ///Button
  static const Color buttonBGWhite = Color(0xFFcdd0d5);
  static const Color buttonBGTint = Color(0xFFd74315);
  static const Color buttonBorder = Color(0xFFd74315);
  static const Color lightreject = Color(0xFFFFE2E2);
  static const Color green = Color(0xFF7BBCB6);

  /// Tabs
  static const Color imageBG = Color(0xFF919191);

  ///BottomNavigationBar
  static const Color bottomNavigationBar = Color(0xFF919191);
  static const Color color191919 = Color(0xFF191919);

  ///BAse Url
  static const appMainUrl = 'http://134.209.152.191:5001/';
  //static const appMainUrl = 'https://stage-webservice.lifeguru.app/';

  Widget space({double? h, double? w}) {
    return SizedBox(
      height: h,
      width: w,
    );
  }
}

// final card1 = Color(hexStringToHexInt('#FFF6F1'));
// final circle1 = Color(hexStringToHexInt('#FFA176'));
//
// final card2 = Color(hexStringToHexInt('#EFFAF4'));
// final circle2 = Color(hexStringToHexInt('#6CCF96'));
//
// final card3 = Color(hexStringToHexInt('#FCF2FD'));
// final circle3 = Color(hexStringToHexInt('#B766D5'));
//
// final card4 = Color(hexStringToHexInt('#EFFAF4'));
// final circle4 = Color(hexStringToHexInt('#FFA176'));
//
// final card5 = Color(hexStringToHexInt('#EEF7FE'));
// final circle5 = Color(hexStringToHexInt('#5A9EE8'));
//
// final card6 = Color(hexStringToHexInt('#FFF2F9'));
// final circle6 = Color(hexStringToHexInt('#FF85BD'));
//
// final card7 = Color(hexStringToHexInt('#FEF6F2'));
// final circle7 = Color(hexStringToHexInt('#F9A179'));
//
// final card8 = Color(hexStringToHexInt('#EFFAF4'));
// final circle8 = Color(hexStringToHexInt('#70D39A'));
//
// final Color1 = Color(hexStringToHexInt('#EB5757'));
// final Color2 = Color(hexStringToHexInt('#F2994A'));
// final Color3 = Color(hexStringToHexInt('#F8B01E'));
// final Color4 = Color(hexStringToHexInt('#FCDD44'));
// final Color5 = Color(hexStringToHexInt('#E3EF5B'));
// final Color6 = Color(hexStringToHexInt('#71CB95'));
//
// final card9 = Color(hexStringToHexInt('#FCF2FD'));
// final circle9 = Color(hexStringToHexInt('#BB6EDA'));
// hexStringToHexInt(String hex) {
//   hex = hex.replaceFirst('#', '');
//   hex = hex.length == 6 ? 'ff' + hex : hex;
//   int val = int.parse(hex, radix: 16);
//   return val;
// }
