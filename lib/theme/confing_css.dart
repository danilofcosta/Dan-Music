import 'package:danmusic/services/uteis/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfigCss extends GetxController {
  /// Imagem de fundo reativa
  final RxString bgImage =
      'https://i.pinimg.com/736x/d1/94/88/d19488320cfdb22b1ad9b8ea61b0c81a.jpg'
          .obs;

  /// Tema reativo
  final Rx<ThemeMode> themeMode = ThemeMode.dark.obs;

  ThemeMode get currentThemeMode => themeMode.value;

  void setThemeMode() {
    printErrorDebug('setThemeMode ${themeMode.value}');
    if (themeMode.value == ThemeMode.system ||
        themeMode.value == ThemeMode.light) {
      themeMode.value = ThemeMode.dark;
    } else {
      themeMode.value = ThemeMode.light;
    }
  }
}
