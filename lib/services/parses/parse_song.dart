import 'package:danmusic/models/artist.dart';
import 'package:danmusic/services/parses/parse_artist.dart';

import '../../models/album.dart';
import '../../models/song.dart';
import '../../models/thumbnail.dart';
import 'parse_album.dart';
import 'parse_thumbnail.dart';

class ParseSong {
  static Song song(Map<String, dynamic> jsonData) {
    AlbumBasic? album;
    final List<ArtistBasic> artists = (jsonData['artists'] as List)
        .map<ArtistBasic>((artist) {
          return ParseArtist.artistBasic(artist);
        })
        .toList();

    final String rawArtist = ParseArtist.artistsToString(artists);

    final String id = jsonData['videoId'] ?? '';
    final String title = jsonData['title'] ?? '';

    final List<Thumbnail> cover = ParseThumbnail.thumbnail(
      jsonData['thumbnails'],
    );
    if (jsonData.containsKey('album') && jsonData['album'] != null) {
      if (jsonData['album'].runtimeType == String) {
        final String albumName = jsonData['album'];
        album = AlbumBasic(title: albumName);
      } else {
        album = ParseAlbum.albumBasic(jsonData["album"]);
      }
    }

    return Song(
      id: id,
      title: title,
      artist: rawArtist,
      artUri: cover.isNotEmpty ? Uri.parse(cover.first.url) : null,
      artists: artists,
      album: album?.title,
      albumId: album?.albumId,
    );
  }

  static List<Song> songs(List<Map<String, dynamic>> jsonData) =>
      jsonData.map((songData) => song(songData)).toList();
}
