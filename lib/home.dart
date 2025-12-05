import 'package:danmusic/navigator.dart';
//import 'package:danmusic/ui/widgets/ui/mini_player.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: MiniPlayer(),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      
      body: const NavigationRotes(),
    );
  }
}
