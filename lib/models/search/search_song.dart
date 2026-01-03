import 'package:danmusic/models/artist.dart';

class SearchSong {
  final String videoId;
  final String title;
  final List<ArtistBasic> artists;
  final String? albumName;
  final String? albumId;
  final String? duration;
  final int? durationSeconds;
  final bool? isExplicit;

  SearchSong({
    required this.videoId,
    required this.title,
    required this.artists,
    this.albumName,
    this.albumId,
    this.duration,
    this.durationSeconds,
    this.isExplicit,
  });
}
