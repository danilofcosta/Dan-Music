import 'package:get/get.dart';

import '/provaders/confing_css.dart';
import 'ui/screens/file_player.dart';
import 'ui/screens/home_page.dart';
import 'ui/screens/player_page/player_page.dart';
import 'ui/screens/playlist_page/playlist_page.dart';
import 'ui/screens/search_page/search_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final confingCss = Provider.of<ConfingCss>(context);
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
      ),
      themeMode: confingCss.getThemeMode,
      // routes: {
      //   Rotas.home: (context) => const HomePage,
      //   Rotas.search: (context) => const SearchPage(),
      //   Rotas.player: (context) => const PlayerPage(),
      //   Rotas.fileplayer: (context) => const FilePlayer(),
      // },
      // initialRoute: Rotas.home,
      home: Home(),
    );
  }
}
