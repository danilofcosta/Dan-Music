import 'package:danmusic/models/artist.dart';
import 'package:danmusic/models/album.dart';
import 'package:danmusic/models/song.dart';
import 'package:danmusic/services/parses/parse_album.dart';
import 'package:danmusic/services/parses/parse_song.dart';
import 'package:danmusic/services/parses/parse_thumbnail.dart';

import '../../models/thumbnail.dart';

class ParseArtist {
  // ── String helpers ──────────────────────────────────────────────────────────

  static String artistsToString(List<ArtistBasic> artists) =>
      artists.map((a) => a.name).where((n) => n.isNotEmpty).join(', ');

  // ── Basic ───────────────────────────────────────────────────────────────────

  static ArtistBasic artistBasic(dynamic data) {
    if (data is String) return ArtistBasic(name: data, id: '');

    if (data is Map<String, dynamic>) {
      return ArtistBasic(
        name: data['name']?.toString() ?? '',
        id: (data['id'] ?? data['browseId'])?.toString() ?? '',
      );
    }

    if (data is List) {
      // Accepts List<Map> — picks the first element
      if (data.isNotEmpty && data.first is Map<String, dynamic>) {
        return artistBasic(data.first as Map<String, dynamic>);
      }
      return ArtistBasic(name: '', id: '');
    }

    // Graceful fallback instead of throwing
    return ArtistBasic(name: '', id: '');
  }

  static List<ArtistBasic> artists(List<dynamic> data) =>
      data.map(artistBasic).toList();

  // ── Full ────────────────────────────────────────────────────────────────────

  static ArtistFull artistFull(Map<String, dynamic> data) {
    final String name = data['name']?.toString() ?? '';
    final String? description = data['description']?.toString();
    final String? views = data['views']?.toString();
    final String? channelId = data['channelId']?.toString();
    final String? shuffleId = data['shuffleId']?.toString();
    final String? radioId = data['radioId']?.toString();
    final String? subscribers = data['subscribers']?.toString();
    final bool? subscribed = data['subscribed'] is bool ? data['subscribed'] as bool : null;

    final List<Thumbnail>? thumbnails = data['thumbnails'] != null
        ? ParseThumbnail.thumbnail(data['thumbnails'])
        : null;

    // Songs
    final songsData = data['songs'] as Map<String, dynamic>?;
    final List<Song>? songs = _mapResults(
      songsData?['results'],
      (e) => ParseSong.song(e as Map<String, dynamic>),
    );
    final String? songsBrowseId = songsData?['browseId']?.toString();

    // Albums
    final albumsData = data['albums'] as Map<String, dynamic>?;
    final List<Album>? albums = _mapResults(
      albumsData?['results'],
      (e) => ParseAlbum.album(e as Map<String, dynamic>),
    );
    final String? albumsBrowseId = albumsData?['browseId']?.toString();
    final String? albumsParams = albumsData?['params']?.toString();

    // Singles
    final singlesData = data['singles'] as Map<String, dynamic>?;
    final List<Album>? singles = _mapResults(
      singlesData?['results'],
      (e) => ParseAlbum.album(e as Map<String, dynamic>),
    );
    final String? singlesBrowseId = singlesData?['browseId']?.toString();
    final String? singlesParams = singlesData?['params']?.toString();

    // Videos
    final videosData = data['videos'] as Map<String, dynamic>?;
    final List<Song>? videos = _mapResults(
      videosData?['results'],
      (e) => ParseSong.song(e as Map<String, dynamic>),
    );
    final String? videosBrowseId = videosData?['browseId']?.toString();

    // Related artists
    final relatedData = data['related'] as Map<String, dynamic>?;
    final List<ArtistDetail>? related = _mapResults(
      relatedData?['results'],
      (e) {
        final artist = e as Map<String, dynamic>;
        return ArtistDetail(
          name: artist['title']?.toString() ?? '',
          browseId: artist['browseId']?.toString() ?? '',
          shuffleId: artist['shuffleId']?.toString(),
          radioId: artist['radioId']?.toString(),
          subscribers: artist['subscribers']?.toString() ?? '',
          thumbnails: ParseThumbnail.thumbnail(artist['thumbnails']),
        );
      },
    );

    return ArtistFull(
      name: name,
      description: description,
      views: views,
      channelId: channelId,
      shuffleId: shuffleId,
      radioId: radioId,
      subscribers: subscribers,
      subscribed: subscribed,
      thumbnails: thumbnails,
      songs: songs,
      songsBrowseId: songsBrowseId,
      albums: albums,
      albumsBrowseId: albumsBrowseId,
      albumsParams: albumsParams,
      singles: singles,
      singlesBrowseId: singlesBrowseId,
      singlesParams: singlesParams,
      videos: videos,
      videosBrowseId: videosBrowseId,
      related: related,
    );
  }

  // ── Private helpers ─────────────────────────────────────────────────────────

  static List<T>? _mapResults<T>(dynamic results, T Function(dynamic) mapper) {
    if (results == null) return null;
    if (results is! List) return null;
    return results.map(mapper).toList();
  }
}
