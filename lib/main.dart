

import 'package:astro_gurujii/Screens/SplashScreen.dart';
import 'package:astro_gurujii/Screens/mall/Products.dart';
import 'package:astro_gurujii/Screens/routes/app_pages.dart';
import 'package:astro_gurujii/firebase_options.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';

import 'Setup/SetUp.dart';


const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', 'High Importance Notifications',
    importance: Importance.high, playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _fireBaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling background message ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);

 FirebaseMessaging.onBackgroundMessage(_fireBaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);


  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => Products(),
          ),
        ],
        child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Astro Gurujii',
            getPages: AppPages.routes,
            theme: ThemeData(
                splashColor: Color(redColor2),
                primaryColor: Color(redColor2),
                appBarTheme: AppBarTheme(
                    backgroundColor: Color(redColor2),
                    foregroundColor:
                        blackColor //here you can give the text color
                    )),
            home: SplashScreen(),

        ));
  }
}
