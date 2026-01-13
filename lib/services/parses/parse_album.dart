import 'package:danmusic/models/album.dart';
import 'package:danmusic/services/parses/parse_artist.dart';
import 'package:danmusic/services/parses/parse_related_recommendations.dart';
import 'package:danmusic/services/parses/parse_song.dart';
import 'package:danmusic/services/parses/parse_thumbnail.dart';

class ParseAlbum {
  static Album album(Map<String, dynamic> data) {
    return Album(
      albumId: data['browseId'] ?? '',
      browseId: data['browseId'],
      playlistId: data['playlistId'],
      title: data['title'] ?? '',
      type: data['type'],
      artist: data['artist'] != null
          ? ParseArtist.artistBasic(data['artist'])
          : null,
      year: data['year']?.toString(),
      isExplicit: data['isExplicit'],
      thumbnails: ParseThumbnail.thumbnail(data['thumbnails']),
    );
  }

  static AlbumBasic albumBasic(Map<String, dynamic> data) {
    final name = data['name'];
    final id = data['id'];

    return AlbumBasic(title: name, albumId: id);
  }

  static AlbumFull albumFull(Map<String, dynamic> data) {
    final title = data['title'];
    final thumbnails = ParseThumbnail.thumbnail(data['thumbnails']);
    final isExplicit = data['isExplicit'] ?? false;
    final description = data['description'] ?? '';
    final year = data['year'] ?? 0;

    final artists =
        (data['artists'] as List?)
            ?.map((e) => ParseArtist.artistBasic(e))
            .toList() ??
        [];

    final trackCount = data['trackCount'] ?? 0;
    final duration = data['duration'] ?? '';
    final audioPlaylistId = data['audioPlaylistId'] ?? '';

    final tracks =
        (data['tracks'] as List?)?.map((e) => ParseSong.song(e)).toList() ?? [];

    final durationSeconds = data['duration_seconds'] ?? 0;

    final relatedRecommendations = ParseRelatedRecommendations.parse(
      data['related_recommendations'],
    );

    return AlbumFull(
      title: title,
      thumbnails: thumbnails,
      isExplicit: isExplicit,
      description: description,
      year: int.tryParse(year.toString()) ?? null,
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
