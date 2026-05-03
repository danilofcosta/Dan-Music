import '../../models/thumbnail.dart';

class ParseThumbnail {
  /// Returns the list of thumbnails sorted by resolution (largest last).
  static List<Thumbnail> thumbnail(dynamic jsonData) {
    if (jsonData == null) return [];

    final List<dynamic> list = jsonData is List ? jsonData : [];
    if (list.isEmpty) return [];

    return list
        .whereType<Map<String, dynamic>>()
        .where((t) => t['url'] != null)
        .map(
          (t) => Thumbnail(
            url: (t['url'] as String).trim(),
            width: t['width'] is int ? t['width'] as int : int.tryParse(t['width']?.toString() ?? '') ?? 0,
            height: t['height'] is int ? t['height'] as int : int.tryParse(t['height']?.toString() ?? '') ?? 0,
          ),
        )
        .toList();
  }

  /// Returns the highest-resolution thumbnail URL, or null if unavailable.
  static String? bestUrl(dynamic jsonData) {
    final thumbs = thumbnail(jsonData);
    if (thumbs.isEmpty) return null;
    thumbs.sort((a, b) => (a.width * a.height).compareTo(b.width * b.height));
    return thumbs.last.url;
  }
}
