import 'package:danmusic/models/album.dart';
import 'package:danmusic/services/parses/parse_artist.dart';
import 'package:danmusic/services/parses/parse_song.dart';

import '../../models/recommendations.dart';
import 'parse_thumbnail.dart';

class ParseRelatedRecommendations {
  /// Parses a list of related items (Albums/Singles). Returns null if empty.
  static List<dynamic>? parse(List<Map<String, dynamic>>? data) {
    if (data == null || data.isEmpty) return null;

    return data
        .map<dynamic?>((e) {
          final type = e['type']?.toString();
          switch (type) {
            case 'Album':
            case 'Single':
              final rawArtists = e['artists'];
              final artist = rawArtists is List && (rawArtists as List).isNotEmpty
                  ? ParseArtist.artistBasic(rawArtists.first)
                  : rawArtists is Map<String, dynamic>
                      ? ParseArtist.artistBasic(rawArtists)
                      : null;
              return Album(
                albumId: e['audioPlaylistId']?.toString() ?? '',
                title: e['title']?.toString() ?? '',
                isExplicit: e['isExplicit'] is bool ? e['isExplicit'] as bool : null,
                artist: artist,
                browseId: e['browseId']?.toString(),
                thumbnails: ParseThumbnail.thumbnail(e['thumbnails']),
              );
            default:
              return null;
          }
        })
        .whereType<dynamic>()
        .where((e) => e != null)
        .toList();
  }

  /// Parses the watch-playlist (getNextSongs) response into [Recommendations].
  static Recommendations getWatchPlaylist(Map<String, dynamic> data) {
    final playlistId = data['playlistId']?.toString();
    final lyrics = data['lyrics']?.toString();
    final related = data['related']?.toString();
    final tracks = ParseSong.songs((data['tracks'] as List?) ?? []);

    return Recommendations(playlistId, related, lyrics, tracks);
  }
}
