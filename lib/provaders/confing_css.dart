import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfigCss extends GetxController {
  /// Imagem de fundo reativa
  final RxString bgImage =
      'https://i.pinimg.com/736x/c8/1c/3b/c81c3b97eb314761ef9a983f2233cc5a.jpg'
          .obs;

  /// Tema reativo
  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  ThemeMode get currentThemeMode => themeMode.value;

  void setThemeMode(ThemeMode mode) {
    themeMode.value = mode;
  }

  @override
  void onInit() {
    super.onInit();
  }
}
