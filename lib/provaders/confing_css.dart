import 'package:flutter/material.dart';

class ConfingCss extends ChangeNotifier {
  final String _bgImage =
      'https://i.pinimg.com/736x/e3/ad/f8/e3adf86992adc7c7d4b08ca86dd53d13.jpg';
  ThemeMode _themeMode = ThemeMode.system;

  String get getBgImage => _bgImage;
  ThemeMode get getThemeMode => _themeMode;
  void setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }
}
