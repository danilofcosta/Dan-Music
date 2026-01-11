import 'package:danmusic/models/artist.dart';
import 'package:danmusic/models/song.dart';
import 'package:danmusic/models/thumbnail.dart';
import 'package:danmusic/services/parses/parse_artist.dart' show ParseArtist;

import '../services/parses/parse_related_recommendations.dart'
    show ParseRelatedRecommendations;
import '../services/parses/parse_song.dart';
import '../services/parses/parse_thumbnail.dart';

class Album {
  final String albumId;
  final String? browseId;
  final String? playlistId;
  final String title;
  final String? type;
  final ArtistBasic? artist;
  final String? year;
  final bool? isExplicit;
  final List<Thumbnail>? thumbnails;

  Album({
    required this.albumId,
    this.playlistId,
    required this.title,
    this.type,
    this.artist,
    this.year,
    this.isExplicit,
    this.thumbnails,
    this.browseId,
  });
}

class AlbumFull {
  final String title;
  final List<Thumbnail>? thumbnails;
  final bool? isExplicit;
  final String? description;
  final int? year;
  final List<dynamic>? artists;
  final int? trackCount;
  final String? duration;
  final String? audioPlaylistId;
  final List<Song>? tracks;
  final int? durationSeconds;
  final List<dynamic>? relatedRecommendations;

  AlbumFull({
    required this.title,
    required this.thumbnails,
    this.description,
    this.isExplicit,
    this.artists,

    this.year,
    this.trackCount,
    this.duration,
    this.audioPlaylistId,
    this.tracks,
    this.durationSeconds,
    this.relatedRecommendations,
  });

  factory AlbumFull.fromJson(Map<String, dynamic> data) {
    return AlbumFull(
      title: data['title'],
      thumbnails: ParseThumbnail.thumbnail(data['thumbnails']),
      isExplicit: data['isExplicit'] ?? false,
      description: data['description'] ?? '',
      year: data['year'] ?? 0,
      artists: (data['artists'] as List)
          .map((e) => ParseArtist.artistBasic(e))
          .toList(),
      trackCount: data['trackCount'] ?? 0,
      duration: data['duration'] ?? '',
      audioPlaylistId: data['audioPlaylistId'] ?? '',
      tracks: (data['tracks'] as List).map((e) => ParseSong.song(e)).toList(),
      durationSeconds: data['duration_seconds'] ?? 0,
      relatedRecommendations: ParseRelatedRecommendations.parse(
        data['related_recommendations'],
      ),
    );
  }
}
