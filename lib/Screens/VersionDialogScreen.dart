
import 'package:astro_gurujii/Screens/WebServices/model/setting/SettingModel.dart';
import 'package:flutter/material.dart';

import 'dart:io';
// import 'package:launch_review/launch_review.dart';

class VersionDialogScreen extends StatefulWidget {
  final SettingModel appVersion;
  VersionDialogScreen({required this.appVersion});
  @override
  _VersionDialogScreenState createState() => _VersionDialogScreenState();
}


class _VersionDialogScreenState extends State<VersionDialogScreen> {

  _shareApp() {
    // LaunchReview.launch();
  }

  dialogContent(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              top: 16.0,
              bottom: 16,
              left: 16,
              right: 16,
            ),
            decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // To make the card compact
              children: <Widget>[
                SizedBox(height: 16.0),
                Text(
                  "The system has not been updated with the latest security patches.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  "Prompt update is recommended to ensure app security.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ((widget.appVersion.results!.user_android_man_int < widget.appVersion.results!.user_android_cur_int && Platform.isAndroid)||(widget.appVersion.results!.user_ios_man_int < widget.appVersion.results!.user_ios_cur_int && Platform.isIOS))?Container(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);// To close the dialog
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 10,
                              bottom: 10,
                              left: 20,
                              right: 20
                          ),
                          child: Text("Skip",style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.grey
                          ),
                        ),
                      ),
                    ):Container(),
                    Container(
                      child: InkWell(
                        onTap: () {
                          _shareApp();
                          //ExtendedNavigator.rootNavigator.pop();// To close the dialog
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Text("Update Now",style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.green
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}
