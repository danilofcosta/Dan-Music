import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'navigation.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'DanMusic',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: Colors.white,

        appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
      ),

      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
        colorScheme: const ColorScheme.dark(
          primary: Color.fromARGB(255, 210, 126, 31), // roxo principal
        ),
      ),
      //themeMode: Get.find<ConfigCss>().themeMode.value,
      themeMode: ThemeMode.dark,
      initialRoute: RouteName.home,
      onGenerateRoute: AppRoutes.generateRoute,
      enableLog: true,
      //  builder: (context, child) => Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 5,
      height: 50,
      child: const Icon(Icons.ac_unit_rounded),
    );
  }
}
