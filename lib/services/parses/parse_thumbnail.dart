import '../../models/thumbnail.dart';

class ParseThumbnail {
  static List<Thumbnail> thumbnail(List? jsonData) {

    if (jsonData == null || jsonData.isEmpty) {
      return [];
    }
    return jsonData.map((thumb) {
      return Thumbnail(
        url: thumb['url'],
        width: thumb['width'],
        height: thumb['height'],
      );
    }).toList();
  }
}
