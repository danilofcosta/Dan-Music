import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../navigation.dart';
import 'screens/home/home_screen.dart';
import 'screens/library/library.dart';
import 'screens/player/player_mini.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  static const String routeName = '/';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    HomeScreen(),
    Library(),
    Center(child: Text("teste")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(RouteName.search),
        child: const Icon(Icons.search),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      persistentFooterButtons: [PlayerMini()],
      persistentFooterDecoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      backgroundColor: const Color(0xFF121212),
        selectedItemColor: const Color(0xFF1DB954), // verde Spotify
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.shifting,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: "Início",
          ), BottomNavigationBarItem(
            icon: Icon(Icons.queue_music),
            label: "Sua biblioteca",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Buscar"),
          
        ],
      ),
      body: _pages[_currentIndex],
    );
  }
}
