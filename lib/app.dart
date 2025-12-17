import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'theme/confing_css.dart';
import 'home.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final configCss = Get.find<ConfigCss>();

    return Obx(() {
      return GetMaterialApp(
        title: 'DanMusic',
        debugShowCheckedModeBanner: false,
        enableLog: true,

        theme: ThemeData.light(useMaterial3: true).copyWith(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
        ),

        darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
        ),

        themeMode: configCss.themeMode.value,
        home: Home(),
      );
    });
  }
}
