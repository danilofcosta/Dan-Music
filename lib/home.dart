import 'package:danmusic/navigator.dart';
//import 'package:danmusic/ui/widgets/ui/mini_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'theme/confing_css.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     final controller = Get.find<ConfigCss>();
      //     controller.setThemeMode();
      //   },
      //   child: const Icon(Icons.add_road_outlined),
      // ),
      // //
      // floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,

      body: const NavigationRotes(),
    );
  }
}
