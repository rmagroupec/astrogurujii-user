
import 'dart:io';

import 'package:flutter/material.dart';

class InAppReviewApps extends StatefulWidget {
  const InAppReviewApps({Key? key}) : super(key: key);

  @override
  InAppReviewExampleAppState createState() => InAppReviewExampleAppState();
}

class InAppReviewExampleAppState extends State<InAppReviewApps> {

  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'In App Review Example',
      home: Scaffold(
        appBar: AppBar(title: const Text('In App Review Example')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

          ],
        ),
      ),
    );
  }
}