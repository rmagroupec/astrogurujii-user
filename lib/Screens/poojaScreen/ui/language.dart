

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../Setup/SetUp.dart';

class LanguageTogglePooja extends StatefulWidget {
  final VoidCallback? function;

  const LanguageTogglePooja({Key? key, this.function}) : super(key: key);
  @override
  _LanguageTogglePoojaState createState() => _LanguageTogglePoojaState();
}

class _LanguageTogglePoojaState extends State<LanguageTogglePooja> {
  bool isEnglish = true; // Toggle state

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isEnglish = !isEnglish;
        });
        widget.function!();

        print("Language toggled");
      },
      child: Container(
        width: 90,
        height: 25,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.black26,
        ),
        child: Stack(
          children: <Widget>[
            AnimatedPositioned(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              left: isEnglish ? 0 : 40, // Position of the highlight
              right: isEnglish ? 40 : 0,
              child: Container(
                height: 25,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text('EN', style: TextStyle(color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold)),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 10),
                child: Text('HI',

                    style: TextStyle(
                        fontSize: 10,

                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}