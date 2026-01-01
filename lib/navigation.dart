import 'package:danmusic/ui/screens/home/home_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String home = HomeScreen.routeName;

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Rota não encontrada'))),
        );
    }
  }
}
