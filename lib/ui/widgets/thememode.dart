import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/confing_css.dart';

class ThemeSwitcherButton extends StatelessWidget {
  const ThemeSwitcherButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConfigCss>(
      builder: (config) {
        return PopupMenuButton<ThemeMode>(
          icon: const Icon(Icons.color_lens),
          tooltip: 'Alterar Tema',

          itemBuilder: (context) => const [
            PopupMenuItem(value: ThemeMode.light, child: Text('Claro')),
            PopupMenuItem(value: ThemeMode.dark, child: Text('Escuro')),
            PopupMenuItem(value: ThemeMode.system, child: Text('Sistema')),
          ],
        );
      },
    );
  }
}
