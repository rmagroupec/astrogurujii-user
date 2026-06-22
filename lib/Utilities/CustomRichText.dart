import 'package:flutter/material.dart';

class CustomRichText extends StatelessWidget {
  @required
  String text;
  final String? fontFamily;
  final double? fontSize;
  final double? labelTextScale;
  final Color? color;
  final TextAlign? align;
  final FontWeight? fontWeight;
  final double? letterspace;
  final Locale? locale;
  final TextOverflow? overflow;
  final Paint? foreground;
  TextDecoration? linethrough;
  final int ?maxLines;

  CustomRichText(
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
        this.linethrough,
        this.labelTextScale})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
          text: '$text',
          style: TextStyle(
              color: color, fontWeight: fontWeight, fontSize: fontSize),
          children: [
            TextSpan(
                text: ' *',
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: fontWeight,
                    fontSize: fontSize))
          ]),
      maxLines: maxLines,
    );
  }
}
