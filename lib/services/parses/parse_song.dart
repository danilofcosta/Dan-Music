import 'package:danmusic/models/artist.dart';
import 'package:danmusic/services/parses/parse_artist.dart';

import '../../models/album.dart';
import '../../models/song.dart';
import '../../models/thumbnail.dart';
import 'parse_album.dart';
import 'parse_thumbnail.dart';

class ParseSong {
  static Song song(Map<String, dynamic> data) {
    final String id = data['videoId']?.toString() ?? '';
    final String title = data['title']?.toString() ?? '';

    // ── Artists ──────────────────────────────────────────────────────────────
    final rawArtists = data['artists'];
    final List<ArtistBasic> artists = _parseArtists(rawArtists);
    final String artistText = ParseArtist.artistsToString(artists);

    // ── Thumbnails ───────────────────────────────────────────────────────────
    final List<Thumbnail> cover = ParseThumbnail.thumbnail(
      data['thumbnails'] ?? data['thumbnail'],
    );

    // ── Album ─────────────────────────────────────────────────────────────────
    AlbumBasic? album;
    final albumRaw = data['album'];
    if (albumRaw != null) {
      if (albumRaw is String) {
        album = AlbumBasic(title: albumRaw);
      } else if (albumRaw is Map<String, dynamic>) {
        album = ParseAlbum.albumBasic(albumRaw);
      }
    }

    // ── Duration ──────────────────────────────────────────────────────────────
    final int? durationSec = data['duration_seconds'] is int
        ? data['duration_seconds'] as int
        : int.tryParse(data['duration_seconds']?.toString() ?? '');

    return Song(
      id: id,
      title: title,
      artist: artistText.isNotEmpty ? artistText : null,
      artUri: cover.isNotEmpty ? Uri.tryParse(cover.first.url) : null,
      artists: artists,
      album: album?.title,
      albumId: album?.albumId,
      durationText: data['duration']?.toString(),
      duration: durationSec != null ? Duration(seconds: durationSec) : null,
      isExplicit: data['isExplicit'] is bool ? data['isExplicit'] as bool : null,
    );
  }

  static List<Song> songs(List<dynamic> data) =>
      data.whereType<Map<String, dynamic>>().map(song).toList();

  // ── Helpers ─────────────────────────────────────────────────────────────────

  static List<ArtistBasic> _parseArtists(dynamic raw) {
    if (raw == null) return [];
    if (raw is List) {
      return raw
          .whereType<Map<String, dynamic>>()
          .map(ParseArtist.artistBasic)
          .toList();
    }
    if (raw is Map<String, dynamic>) {
      return [ParseArtist.artistBasic(raw)];
    }
    if (raw is String) {
      return [ArtistBasic(name: raw, id: '')];
    }
    return [];
  }
}
