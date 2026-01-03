import 'package:danmusic/models/thumbnail.dart';

class Playlist {
  final String browseId;
  final String title;
  final String? author;
  final String? itemCount;
  final List<Thumbnail>? thumbnails;

  Playlist({
    required this.browseId,
    required this.title,
    this.author,
    this.itemCount,
    this.thumbnails,
  });
}
