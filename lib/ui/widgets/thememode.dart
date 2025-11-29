import '/provaders/confing_css.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeSwitcherButton extends StatelessWidget {
  const ThemeSwitcherButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ConfingCss>(
      builder: (context, confingCss, _) {
        return PopupMenuButton<ThemeMode>(
          icon: const Icon(Icons.color_lens),
          tooltip: 'Alterar Tema',
          onSelected: (ThemeMode mode) {
            confingCss.setThemeMode(mode);
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: ThemeMode.light, child: Text('Claro')),
            const PopupMenuItem(value: ThemeMode.dark, child: Text('Escuro')),
            const PopupMenuItem(
              value: ThemeMode.system,
              child: Text('Sistema'),
            ),
          ],
        );
      },
    );
  }
}
