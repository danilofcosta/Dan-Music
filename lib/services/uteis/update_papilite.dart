
import 'package:danmusic/services/uteis/load_image.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

Future<Color> updatePalette(String imagePath) async {
  try {
    final provider = LoadImage.loadProvider(imagePath);

    final palette = await PaletteGenerator.fromImageProvider(provider!);
    return palette.dominantColor?.color.withValues(alpha: 0.9) ??
        Colors.black.withValues(alpha: 0.7);
  } catch (e) {
    return Colors.black.withValues(alpha: 0.7);
  }
}
