import 'package:danmusic/models/artist.dart';
import 'package:danmusic/models/thumbnail.dart';

class SearchVideo {
  final String videoId;
  final String title;
  final List<ArtistBasic>? artists;
  final String? views;
  final String? duration;
  final int? durationSeconds;
  final String? videoType;
  final List<Thumbnail>? thumbnails;

  SearchVideo({
    required this.videoId,
    required this.title,
    this.artists,
    this.views,
    this.duration,
    this.durationSeconds,
    this.videoType,
    this.thumbnails,
  });
}
