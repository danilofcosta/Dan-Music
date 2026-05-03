import 'package:danmusic/models/album.dart';
import 'package:danmusic/services/parses/parse_artist.dart';
import 'package:danmusic/services/parses/parse_related_recommendations.dart';
import 'package:danmusic/services/parses/parse_song.dart';
import 'package:danmusic/services/parses/parse_thumbnail.dart';

class ParseAlbum {
  static Album album(Map<String, dynamic> data) {
    return Album(
      albumId: data['browseId']?.toString() ?? '',
      browseId: data['browseId']?.toString(),
      playlistId: data['playlistId']?.toString(),
      title: data['title']?.toString() ?? '',
      type: data['type']?.toString(),
      artist: data['artist'] is Map<String, dynamic>
          ? ParseArtist.artistBasic(data['artist'] as Map<String, dynamic>)
          : null,
      year: data['year']?.toString(),
      isExplicit: data['isExplicit'] is bool ? data['isExplicit'] as bool : null,
      thumbnails: ParseThumbnail.thumbnail(data['thumbnails']),
    );
  }

  static AlbumBasic albumBasic(Map<String, dynamic> data) {
    return AlbumBasic(
      title: data['name']?.toString() ?? '',
      albumId: data['id']?.toString(),
    );
  }

  static AlbumFull albumFull(Map<String, dynamic> data) {
    final title = data['title']?.toString() ?? '';
    final thumbnails = ParseThumbnail.thumbnail(data['thumbnails']);
    final isExplicit = data['isExplicit'] is bool ? data['isExplicit'] as bool : false;
    final description = data['description']?.toString() ?? '';
    final year = int.tryParse(data['year']?.toString() ?? '');
    final trackCount = data['trackCount'] is int ? data['trackCount'] as int : 0;
    final duration = data['duration']?.toString() ?? '';
    final audioPlaylistId = data['audioPlaylistId']?.toString() ?? '';
    final durationSeconds = data['duration_seconds'] is int ? data['duration_seconds'] as int : 0;

    final artists = (data['artists'] as List?)
            ?.whereType<Map<String, dynamic>>()
            .map(ParseArtist.artistBasic)
            .toList() ??
        [];

    final tracks = (data['tracks'] as List?)
            ?.whereType<Map<String, dynamic>>()
            .map(ParseSong.song)
            .toList() ??
        [];

    final relatedRecommendations = ParseRelatedRecommendations.parse(
      (data['related_recommendations'] as List?)?.cast<Map<String, dynamic>>(),
    );

    return AlbumFull(
      title: title,
      thumbnails: thumbnails,
      isExplicit: isExplicit,
      description: description,
      year: year,
      artists: artists,
      trackCount: trackCount,
      duration: duration,
      audioPlaylistId: audioPlaylistId,
      tracks: tracks,
      durationSeconds: durationSeconds,
      relatedRecommendations: relatedRecommendations,
    );
  }
}
