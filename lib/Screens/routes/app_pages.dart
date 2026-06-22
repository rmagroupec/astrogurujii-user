import 'package:astro_gurujii/Screens/homeScreen/Home.dart';
import 'package:astro_gurujii/Screens/login/bindings/login_binding.dart';
import 'package:astro_gurujii/Screens/login/views/login_view.dart';
import 'package:astro_gurujii/Screens/otp/bindings/otp_binding.dart';
import 'package:astro_gurujii/Screens/otp/views/otp_view.dart';
import 'package:astro_gurujii/widget/bottom_navigation_bar_custom.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.OTP,
      page: () => OTPView(),
      binding: OtpBinding(),
    ),
    GetPage(
      name: _Paths.BOTTOM,
      page: () => MainHomeScreenWithBottomNavigation(),
    ),
  ];
}
