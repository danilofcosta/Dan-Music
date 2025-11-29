import 'package:flutter/material.dart';

class ConfingCss extends ChangeNotifier {
  final String _bgImage =
      'https://i.pinimg.com/736x/57/4c/93/574c932a137c5d7506b704179afb5195.jpg';
  ThemeMode _themeMode = ThemeMode.system;

  String get getBgImage => _bgImage;
  ThemeMode get getThemeMode => _themeMode;
  void setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }
}
