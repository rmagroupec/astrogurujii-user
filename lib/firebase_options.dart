// lib/firebase_options.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'FirebaseOptions are not configured for this platform.',
        );
    }
  }

  /// 🔹 Android config (from google-services.json)
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyDMOLSzOQbwUsaSg2576yb92UmNMxuf3Xc",
    appId: "1:307653017355:android:2c9023abedc3d234c8ec0e",
    messagingSenderId: "307653017355",
    projectId: "astrogurujii-production",
    storageBucket: "astrogurujii-production.appspot.com",
  );

  /// 🔹 iOS config (from GoogleService-Info.plist)
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "AIzaSyBTjESXaAuZpgxD6lpkv5ZKAK8ET1MBtgk",
    appId: "1:307653017355:ios:263e96197a143379c8ec0e",
    messagingSenderId: "307653017355",
    projectId: "astrogurujii-production",
    storageBucket: "astrogurujii-production.firebasestorage.app",
    iosBundleId: "com.ios.astrogurujiii",
    databaseURL:
        "https://astrogurujii-production-default-rtdb.firebaseio.com",
  );
}
