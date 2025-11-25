import '/provaders/confing_css.dart';
import '/screens/file_player.dart';
import '/screens/home_page.dart';
import '/screens/player_page.dart';
import '/screens/playlist_page.dart';
import '/screens/search_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final confingCss = Provider.of<ConfingCss>(context);
    return MaterialApp(
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
      routes: {
        '/': (context) => const HomePage(),
        '/search': (context) => const SearchPage(),
        '/player': (context) => const PlayerPage(),
        '/fileplayer': (context) => const FilePlayer(),
        '/playlist': (context) => const PlaylistPage(),
      },
      initialRoute: '/',
    );
  }
}
