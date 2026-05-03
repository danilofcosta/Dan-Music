import 'package:danmusic/models/playlist.dart';
import 'package:danmusic/services/parses/parse_artist.dart';
import 'package:danmusic/services/parses/parse_related_recommendations.dart';
import 'package:danmusic/services/parses/parse_song.dart';
import 'package:danmusic/services/parses/parse_thumbnail.dart';
import 'package:danmusic/services/uteis/helper.dart';

class ParsePlaylist {
  static PlaylistFull parsePlaylistFull(Map<String, dynamic> data) {
    final id = data['id']?.toString() ?? '';
    final title = data['title']?.toString() ?? '';
    final description = data['description']?.toString();
    final durationText = data['duration']?.toString();
    final durationSeconds = data['duration_seconds'] is int
        ? data['duration_seconds'] as int
        : int.tryParse(data['duration_seconds']?.toString() ?? '');
    final trackCount = data['track_count'] is int
        ? data['track_count'] as int
        : int.tryParse(data['track_count']?.toString() ?? '');
    final year = data['year']?.toString();

    final thumbnail = ParseThumbnail.thumbnail(data['thumbnails']);
    final author = ParseArtist.artistBasic(data['author']);

    final List tracks = (data['tracks'] as List?) ?? [];
    final parsedTracks = tracks
        .whereType<Map<String, dynamic>>()
        .map(ParseSong.song)
        .toList();
    printInfoDebug('Playlist "${title}" — ${parsedTracks.length} tracks');

    final related = data['related'];
    final relatedRecommendations = related is List
        ? ParseRelatedRecommendations.parse(
            related.whereType<Map<String, dynamic>>().toList(),
          )
        : null;

    return PlaylistFull(
      id: id,
      title: title,
      description: description,
      author: author.name,
      thumbnails: thumbnail,
      durationText: durationText,
      secondsduration: durationSeconds,
      trackCount: trackCount,
      year: year,
      releted: relatedRecommendations,
      tracks: parsedTracks,
    );
  }
}
