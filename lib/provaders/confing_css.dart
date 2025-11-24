import 'package:flutter/material.dart';

class ConfingCss extends ChangeNotifier {
  final String _bgImage =
      'https://i.pinimg.com/1200x/be/9a/12/be9a121566582f4878dafc033e6e541a.jpg';
  ThemeMode _themeMode = ThemeMode.system;

  String get getBgImage => _bgImage;
  ThemeMode get getThemeMode => _themeMode;
  void setThemeMode(ThemeMode themeMode ) {
    _themeMode =  themeMode ;
    notifyListeners();
  }
}
