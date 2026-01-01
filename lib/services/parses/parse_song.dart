import '../../models/song.dart';
import '../../models/thumbnail.dart';
import 'parse_thumbnail.dart';

class ParseSong {
  static Song song(Map<String, dynamic> jsonData) {
    final String id = jsonData['videoId'] ?? '';
    final String title = jsonData['title'] ?? '';
    final String artist =' oi';
    final List<Thumbnail> cover = ParseThumbnail.thumbnail(
      jsonData['thumbnails'],
    );

    return Song(id: id, title: title,artist: artist, artUri: Uri.parse(cover.first.url));
  }
}
