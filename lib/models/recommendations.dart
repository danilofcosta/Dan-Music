import 'package:danmusic/models/song.dart';

class Recommendations {
  final String? playlistId;
  final String? related;
  final String? lyrics;
  final List<Song> tracks;
  Recommendations(this.playlistId, this.related, this.lyrics, this.tracks);
}