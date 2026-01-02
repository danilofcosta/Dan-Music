import 'ui/screens/player/player.dart';
import 'ui/screens/home/home_screen.dart';
import 'package:flutter/material.dart';

import 'ui/search/search_screen.dart';

class RouteName {
  static const String home = HomeScreen.routeName;
  static const String player = Player.routeName;
  static const String search = SearchScreen.routeName;
}

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    
    switch (settings.name) {
      case RouteName.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case RouteName.player:
        return MaterialPageRoute(builder: (_) => Player());
      case RouteName.search:
        return MaterialPageRoute(builder: (_) => SearchScreen());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Rota não encontrada'))),
        );
    }
  }
}
