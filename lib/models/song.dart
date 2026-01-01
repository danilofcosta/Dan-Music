import 'package:audio_service/audio_service.dart';

import 'artist.dart';

class Song extends MediaItem {
  final String? albumId;
  final  List<ArtistBasic>? artists;

  Song({
    required super.id,
    required super.title,
    this.albumId,
    super.artist,
    super.duration,
    super.album,
    super.artUri, this.artists
  });
}
