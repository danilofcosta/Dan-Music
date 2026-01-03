import 'package:danmusic/models/thumbnail.dart';

class SearchAlbum {
  final String browseId;
  final String? playlistId;
  final String title;
  final String? type;
  final String? artist;
  final String? year;
  final bool? isExplicit;
  final List<Thumbnail>? thumbnails;

  SearchAlbum({
    required this.browseId,
    this.playlistId,
    required this.title,
    this.type,
    this.artist,
    this.year,
    this.isExplicit,
    this.thumbnails,
  });
}
