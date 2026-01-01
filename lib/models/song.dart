import 'package:audio_service/audio_service.dart';

class Song extends MediaItem {
  final String? albumId;

  Song({
    required super.id,
    required super.title,
    this.albumId,
    super.artist,
    super.duration,
    super.album,
    super.artUri
  });
}
