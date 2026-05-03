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
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_outline,
            size: 64,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            "Perfil em breve",
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 16,
            ),
          ),
        ],
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.grey.shade900, Colors.red],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        floatingActionButton: FloatingActionButton(
          onPressed: () => Get.toNamed(RouteName.search),
          backgroundColor: const Color(0xFF1DB954), // Verde Spotify
          foregroundColor: Colors.white,
          elevation: 4,
          child: const Icon(Icons.search, size: 28),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        // bottomNavigationBar: BottomNavigationBar(
        //   currentIndex: _currentIndex,
        //   onTap: (index) => setState(() => _currentIndex = index),
        //   backgroundColor: Colors.black.withValues(alpha: 0.95),
        //   selectedItemColor: const Color(0xFF1DB954),
        //   unselectedItemColor: Colors.white54,
        //   type: BottomNavigationBarType.shifting,
        //   selectedLabelStyle: const TextStyle(
        //     fontWeight: FontWeight.w600,
        //     fontSize: 12,
        //   ),
        //   unselectedLabelStyle: const TextStyle(fontSize: 12),
        //   items: const [
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.home_filled),
        //       label: "Início",
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.queue_music),
        //       label: "Biblioteca",
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.person_outline),
        //       label: "Perfil",
        //     ),
        //   ],
        // ),
        // body: Stack(
        //   children: [
        //     _pages[_currentIndex],

        //     // Player mini posicionado acima da bottom bar
        //     Positioned(
        //       left: 0,
        //       right: 0,
        //       bottom: 0,
        //       child: const PlayerMini(),
        //     ),
        //   ],
        // ),
        body: _pages[_currentIndex],
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const PlayerMini(),
            BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
              backgroundColor: Colors.black.withValues(alpha: 0.95),
              selectedItemColor: const Color(0xFF1DB954),
              unselectedItemColor: Colors.white54,
              type: BottomNavigationBarType.shifting,
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              unselectedLabelStyle: const TextStyle(fontSize: 12),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_filled),
                  label: "Início",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.queue_music),
                  label: "Biblioteca",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  label: "Perfil",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
