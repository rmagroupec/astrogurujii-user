import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_page_logic.dart';

class HomePagePage extends StatelessWidget {
  final logic = Get.put(HomePageLogic());
  final state = Get.find<HomePageLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
