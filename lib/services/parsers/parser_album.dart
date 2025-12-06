import 'package:audio_service/audio_service.dart';
import 'package:danmusic/models/album.dart';
import 'package:danmusic/services/to_media_item.dart';
import 'package:dart_ytmusic_api/types.dart';

class AlbumParser {
  static Album parseAlbum(AlbumFull albumFull) {
    List<MediaItem> songs = albumFull.songs
        .map((e) => ToMediaItem.songDetailed(e))
        .toList();

    return Album(
      albumId: albumFull.albumId,
      playlistId: albumFull.playlistId,
      name: albumFull.name,
      artist: albumFull.artist.name,
      year: albumFull.year,
      thumbnails: albumFull.thumbnails.map((e) => e.url).toList(),
      songs: songs,
    );
  }
}
