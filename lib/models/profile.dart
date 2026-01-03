import 'package:danmusic/models/thumbnail.dart';

class Profile {
  final String title;
  final String name;
  final String browseId;
  final List<Thumbnail>? thumbnails;

  Profile({
    required this.title,
    required this.name,
    required this.browseId,
    this.thumbnails,
  });
}
