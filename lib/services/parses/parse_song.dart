import 'package:danmusic/models/artist.dart';
import 'package:danmusic/services/parses/parse_artist.dart';

import '../../models/song.dart';
import '../../models/thumbnail.dart';
import 'parse_thumbnail.dart';

class ParseSong {
  static Song song(Map<String, dynamic> jsonData) {
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

    return Song(
      id: id,
      title: title,
      artist: rawArtist,
      artUri: Uri.parse(cover.first.url),
      artists: artists,
    );
  }
}
