import 'package:danmusic/models/album.dart';
import 'package:danmusic/services/parses/parse_artist.dart';
import 'package:danmusic/services/parses/parse_song.dart';

import '../../models/recommendations.dart';
import 'parse_thumbnail.dart';

class ParseRelatedRecommendations {
  static List<dynamic>? parse(List<Map<String, dynamic>>? data) {
    if (data == null || data.isEmpty) return null;

    final List<dynamic> results = data
        .map((e) {
          switch (e['type']) {
            case 'Album':
            case 'Single':
              return Album(
                albumId: e['audioPlaylistId'],

                title: e['title'],
                isExplicit: e['isExplicit'],
                artist:
                    (e['artists'] is List && (e['artists'] as List).isNotEmpty)
                    ? ParseArtist.artistBasic(e['artists'][0])
                    : (e['artists'] is Map<String, dynamic>
                          ? ParseArtist.artistBasic(e['artists'])
                          : null),
                browseId: e['browseId'],

                thumbnails: ParseThumbnail.thumbnail(e['thumbnails']),
              );

            default:
              return null;
          }
        })
        .where((element) => element != null)
        .toList();

    return results;
  }

  static Recommendations getWatchPlaylist(Map<String, dynamic> data) {
    final playlistId = data['playlistId'];
    final lyrics = data['lyrics'];
    final related = data['related'];
    final tracks = ParseSong.songs(data['tracks']);

    return Recommendations(playlistId, related, lyrics, tracks);
  }
}
