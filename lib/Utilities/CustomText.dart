import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class CustomText extends StatelessWidget {
  @required
  String text;
  final String? fontFamily;
  final double? fontSize;
  final Color? color;
  final TextAlign? align;
  final FontWeight? fontWeight;
  final double? letterspace;
  final Locale? locale;
  final TextOverflow? overflow;
  final Paint? foreground;
  TextDecoration? linethrough;
  final int ?maxLines;

  CustomText(
      {Key? key,
        this.overflow,
        this.color,
        this.align,
        this.maxLines,
        this.fontFamily,
        this.letterspace,
        this.fontSize,
        this.fontWeight,
        this.locale,
        this.foreground,
        required this.text,
        this.linethrough})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      style:TextStyle(
          letterSpacing: letterspace,
          foreground: foreground,
          fontSize: fontSize,
          color: color,

          fontWeight: fontWeight,
          decoration: linethrough,
          fontFamily: 'Roboto',
      ),
          softWrap: true,
      textAlign: align,
    );
  }
}
