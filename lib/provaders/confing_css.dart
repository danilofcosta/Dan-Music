import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfigCss extends GetxController {
  /// Imagem de fundo reativa
  final RxString bgImage =
      'https://i.pinimg.com/736x/f9/12/9b/f9129baee7a2cd7262eedfada3d9f557.jpg'
          .obs;

  /// Tema reativo
  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  ThemeMode get currentThemeMode => themeMode.value;

  void setThemeMode(ThemeMode mode) {
    themeMode.value = mode;
  }

}
