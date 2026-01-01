import 'ui/screens/player/player.dart';
import 'ui/screens/home/home_screen.dart';
import 'package:flutter/material.dart';

class RouteName {
  static const String home = HomeScreen.routeName;
  static const String player = Player.routeName;
}

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case RouteName.player:
        return MaterialPageRoute(builder: (_) => const Player());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Rota não encontrada'))),
        );
    }
  }
}
