import 'package:audio_service/audio_service.dart';
import 'package:danmusic/models/home_section.dart';
import 'package:danmusic/models/search/search_song.dart';

class Song extends MediaItem implements HomeContent {
  final String? albumId;
  final List<dynamic>? artists;
  final String? views;
  final String? durationText;
  final bool? isExplicit;
  bool? topic;

  Song({
    required super.id,
    required super.title,
    this.albumId,
    super.artist,
    super.duration,
    super.album,
    super.artUri,
    this.artists,
    this.views,
    this.isExplicit,
    this.durationText,
    this.topic,
  });

  factory Song.fromMediaItem(
    MediaItem item, {
    String? albumId,
    List<dynamic>? artists,
  }) {
    return Song(
      id: item.id,
      title: item.title,
      artist: item.artist,
      album: item.album,
      duration: item.duration,
      artUri: item.artUri,
      albumId: albumId,
      artists: artists,
    );
  }

  factory Song.fromSearchSong(SearchSong s) {
    final artistText = s.artists.isNotEmpty
        ? s.artists.map((a) => a.name).join(', ')
        : null;
    return Song(
      id: s.videoId,
      title: s.title,
      artist: artistText,
      album: s.albumName,
      duration: s.durationSeconds != null
          ? Duration(seconds: s.durationSeconds!)
          : null,
      albumId: s.albumId,
      artists: s.artists,
    );
  }
}
