import 'package:danmusic/models/thumbnail.dart';

class SearchProfile {
  final String title;
  final String name;
  final String browseId;
  final List<Thumbnail>? thumbnails;

  SearchProfile({
    required this.title,
    required this.name,
    required this.browseId,
    this.thumbnails,
  });
}
