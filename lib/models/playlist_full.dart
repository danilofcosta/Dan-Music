import '/models/Playlist.dart';
import '/models/song.dart';

class PlaylistFull extends Playlist {
  final String duration;
  final int secondsduration;
  final int trackCount;
  final String year;
  final List? releted;
  final List<Song>? tracks;
  final String? videoId;

  PlaylistFull({
    required super.playlistId,
    required super.title,
    required super.thumbnails,
    required super.desciption,
    required this.duration,
    required this.secondsduration,
    required this.trackCount,
    required this.year,
    this.releted,
    this.tracks,
    this.videoId,
  });
}
