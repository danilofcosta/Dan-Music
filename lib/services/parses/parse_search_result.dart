import 'package:danmusic/models/search/search_result.dart';
import 'package:danmusic/models/song.dart';
import 'package:danmusic/services/parses/parse_artist.dart';
import 'package:danmusic/services/parses/parse_thumbnail.dart';
import '../../models/artist.dart';
import '../../models/search/search_album.dart';
import '../../models/search/search_playlist.dart';
import '../../models/search/search_profile.dart';

class ParseSearchResult {
  static SearchResult parseResult(Map<String, dynamic> data) {
    final type = data['resultType']?.toString() ?? '';

    switch (type) {
      // ── Artist ──────────────────────────────────────────────────────────────
      case 'artist':
        final thumbnails = ParseThumbnail.thumbnail(data['thumbnails']);
        final shuffleId = data['shuffleId']?.toString();
        final radioId = data['radioId']?.toString();
        final browseId = data['browseId']?.toString();

        final rawArtists = data['artists'] ?? data['artist'];
        final List<ArtistBasic> artists = rawArtists == null
            ? []
            : rawArtists is List
                ? rawArtists.map((e) => ParseArtist.artistBasic(e)).toList()
                : [ParseArtist.artistBasic(rawArtists)];

        final artistName = artists.isNotEmpty
            ? ParseArtist.artistsToString(artists)
            : data['title']?.toString() ?? '';
        final subscribers = data['subscribers']?.toString();

        return SearchResult(
          type: type,
          content: ArtistDetail(
            name: artistName,
            subscribers: subscribers,
            thumbnails: thumbnails,
            browseId: browseId ?? (artists.isNotEmpty ? artists.first.id : ''),
            shuffleId: shuffleId,
            radioId: radioId,
          ),
        );

      // ── Song ────────────────────────────────────────────────────────────────
      case 'song':
        final videoId = data['videoId']?.toString() ?? '';
        final title = data['title']?.toString() ?? '';
        final views = data['views']?.toString();
        final isExplicit = data['isExplicit'] is bool
            ? data['isExplicit'] as bool
            : (data['isExplicit'] == 'true' || data['isExplicit'] == 1);
        final thumbs = ParseThumbnail.thumbnail(data['thumbnails']);
        final durationSec = data['duration_seconds'] is int
            ? data['duration_seconds'] as int
            : int.tryParse(data['duration_seconds']?.toString() ?? '') ?? 0;

        // Resolve artist name from 'artists' list or 'artist' string
        final String? artistName = _resolveArtistName(data);

        final albumRaw = data['album'];
        final String? albumName = albumRaw is Map<String, dynamic>
            ? albumRaw['name']?.toString()
            : albumRaw?.toString();

        return SearchResult(
          type: type,
          content: Song(
            id: videoId,
            title: title,
            artist: artistName,
            album: albumName,
            views: views,
            durationText: data['duration']?.toString(),
            isExplicit: isExplicit,
            duration: Duration(seconds: durationSec),
            artUri: thumbs.isNotEmpty ? Uri.tryParse(thumbs.first.url) : null,
          ),
        );

      // ── Album ───────────────────────────────────────────────────────────────
      case 'album':
        final browseId = data['browseId']?.toString() ?? '';
        final playlistId = data['playlistId']?.toString();
        final title = data['title']?.toString() ?? '';
        final typeStr = data['type']?.toString();
        final artistName = data['artist']?.toString();
        final year = data['year']?.toString();
        final isExplicit = data['isExplicit'] is bool
            ? data['isExplicit'] as bool
            : (data['isExplicit'] == 'true' || data['isExplicit'] == 1);
        final thumbnails = ParseThumbnail.thumbnail(data['thumbnails']);

        return SearchResult(
          type: type,
          content: SearchAlbum(
            browseId: browseId,
            playlistId: playlistId,
            title: title,
            type: typeStr,
            artist: artistName,
            year: year,
            isExplicit: isExplicit,
            thumbnails: thumbnails,
          ),
        );

      // ── Playlist ────────────────────────────────────────────────────────────
      case 'playlist':
        final browseId = data['browseId']?.toString() ?? '';
        final title = data['title']?.toString() ?? '';
        final author = data['author']?.toString();
        final itemCount = data['itemCount']?.toString();
        final thumbnails = ParseThumbnail.thumbnail(data['thumbnails']);

        return SearchResult(
          type: type,
          content: SearchPlaylist(
            browseId: browseId,
            title: title,
            author: author,
            itemCount: itemCount,
            thumbnails: thumbnails,
          ),
        );

      // ── Video ───────────────────────────────────────────────────────────────
      case 'video':
        final videoId = data['videoId']?.toString() ?? '';
        final title = data['title']?.toString() ?? '';
        final views = data['views']?.toString();
        final durationSec = data['duration_seconds'] is int
            ? data['duration_seconds'] as int
            : int.tryParse(data['duration_seconds']?.toString() ?? '') ?? 0;

        final artistsRaw = data['artists'];
        final List<ArtistBasic> videoArtists = artistsRaw is List
            ? artistsRaw
                .whereType<Map<String, dynamic>>()
                .map(ParseArtist.artistBasic)
                .toList()
            : [];
        final artistText = ParseArtist.artistsToString(videoArtists);
        final thumbnails = ParseThumbnail.thumbnail(data['thumbnails']);

        return SearchResult(
          type: type,
          content: Song(
            id: videoId,
            title: title,
            artist: artistText.isNotEmpty ? artistText : null,
            views: views,
            duration: Duration(seconds: durationSec),
            durationText: data['duration']?.toString(),
            artUri: thumbnails.isNotEmpty ? Uri.tryParse(thumbnails.first.url) : null,
            artists: videoArtists,
          ),
        );

      // ── Profile ─────────────────────────────────────────────────────────────
      case 'profile':
        final title = data['title']?.toString() ?? '';
        final name = data['name']?.toString() ?? '';
        final browseId = data['browseId']?.toString() ?? '';
        final thumbnails = ParseThumbnail.thumbnail(data['thumbnails']);

        return SearchResult(
          type: type,
          content: SearchProfile(
            title: title,
            name: name,
            browseId: browseId,
            thumbnails: thumbnails,
          ),
        );

      default:
        return SearchResult(type: type, content: null);
    }
  }

  static List<SearchResult> parseSearchResults(List<dynamic> data) =>
      data.whereType<Map<String, dynamic>>().map(parseResult).toList();

  // ── Private helpers ─────────────────────────────────────────────────────────

  static String? _resolveArtistName(Map<String, dynamic> data) {
    final artistsList = data['artists'];
    if (artistsList is List && artistsList.isNotEmpty) {
      final first = artistsList.first;
      if (first is Map<String, dynamic>) return first['name']?.toString();
    }
    final artist = data['artist'];
    if (artist is String) return artist;
    return null;
  }
}
