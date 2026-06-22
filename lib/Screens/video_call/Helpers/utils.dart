import 'dart:math';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';


String getAgoraAppId() {
  return "8782e154141a4c0bbc8acaa3004d21f2";
}

checkNoSignleDigit(int no) {
  int len = no.toString().length;
  if (len == 1) {
    return true;
  }
  return false;
}

String generateRandomString(int len) {
  var r = Random();
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
}


Future<bool> handlePermissionsForCall(BuildContext context) async {
  try {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();

    // Check for permanently denied permissions
    if (statuses[Permission.camera]!.isPermanentlyDenied ||
        statuses[Permission.microphone]!.isPermanentlyDenied) {
      showCustomDialog(context, "Permission Required",
          "Camera and/or Microphone Permission Required for Video Call", () {
        Navigator.pop(context);
        openAppSettings();
      });
      return false;
    }

    // If the permission is denied, return false
    if (statuses[Permission.camera]!.isDenied ||
        statuses[Permission.microphone]!.isDenied) {
      return false;
    }

    return true;
  } catch (e) {
    print("Error checking permissions: $e");
    // Handle permission error or any unexpected issues
    showCustomDialog(context, "Permission Error", "An unexpected error occurred.",(){
      Navigator.pop(context);
    });
    return false;
  }
}

void showCustomDialog(BuildContext context, String title, String message,
    Function okPressed) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      // return object of type Dialog

      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title:  Text(
          title,
          style: TextStyle(fontFamily: 'WorkSansMedium'),
        ),
        content:  Text(
          message,
          style: TextStyle(fontFamily: 'WorkSansMedium'),
        ),
        actions: <Widget>[
           ElevatedButton(
            onPressed: () {  },
            child:
             Text("OK", style: TextStyle(fontFamily: 'WorkSansMedium')),

          ),
        ],
      );
    },
  );
}
