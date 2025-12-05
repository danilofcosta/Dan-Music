import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class LoadImage {
  static bool _isUrl(String s) {
    if (s.trim().isEmpty) return false;
    final uri = Uri.tryParse(s);
    return uri != null && uri.hasAbsolutePath && uri.scheme.contains("http");
  }

  static bool _isValidAsset(String s) {
    return s.trim().isNotEmpty &&
        !s.trim().contains(",") &&
        !s.trim().startsWith("/") &&
        s.contains(".");
  }

  // ------------------------------------------------------------------
  // 1️⃣ RETORNA WIDGET (Network, File, Asset, ou fallback seguro)
  // ------------------------------------------------------------------
  static Widget loadWidget(
    String path, {
    double? width,
    double? height,
    IconData errorBuildericon = Icons.music_note_outlined,
    BoxFit fit = BoxFit.cover,
  }) {
    path = path.trim();

    if (path.isEmpty || path == ",") {
      return _fallback(width, height, errorBuildericon);
    }

    if (_isUrl(path)) {
      return CachedNetworkImage(
        imageUrl: path,
        width: width,
        height: height,
        fit: fit,
        progressIndicatorBuilder: (_, _, progress) =>
            _fallback(width, height, errorBuildericon),
        errorWidget: (_, _, _) => _fallback(width, height, errorBuildericon),
      );
    }

    if (File(path).existsSync()) {
      return Image.file(
        File(path),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, _, _) =>
            _fallback(width, height, errorBuildericon),
      );
    }

    if (_isValidAsset(path)) {
      return Image.asset(
        path,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) =>
            _fallback(width, height, errorBuildericon),
      );
    }

    return _fallback(width, height, errorBuildericon);
  }

  // ------------------------------------------------------------------
  // 2️⃣ RETORNA IMAGE PROVIDER (sem risco de quebrar layout)
  // ------------------------------------------------------------------
  static ImageProvider? loadProvider(String path) {
    path = path.trim();

    if (path.isEmpty || path == ",") return null;

    if (_isUrl(path)) {
      return CachedNetworkImageProvider(path,
      
      
      
      
      );
    }

    if (File(path).existsSync()) {
      return FileImage(File(path));
    }

    if (_isValidAsset(path)) {
      return AssetImage(path);
    }

    return null;
  }

  // ------------------------------------------------------------------
  // Fallback
  // ------------------------------------------------------------------
  static Widget _fallback(double? width, double? height, IconData icon) {
    return SizedBox(width: width, height: height, child: Icon(icon));
  }
}
