import 'package:danmusic/models/search/search_result.dart';
import 'package:danmusic/models/song.dart';
import 'package:danmusic/services/parses/parse_artist.dart';
import 'package:danmusic/services/parses/parse_thumbnail.dart';
import '../../models/artist.dart';
import '../../models/thumbnail.dart';
import '../../models/search/search_album.dart';
import '../../models/search/search_playlist.dart';
import '../../models/search/search_video.dart';
import '../../models/search/search_profile.dart';

class ParseSearchResult {
  static SearchResult parseResult(Map<String, dynamic> data) {
    final type = data['resultType'] as String? ?? '';
    switch (type) {
      case 'artist':
        final thumbnails = ParseThumbnail.thumbnail(data['thumbnails']);

        final rawArtists = data['artists'] ?? data['artist'];

        final List<ArtistBasic> artists = rawArtists == null
            ? <ArtistBasic>[]
            : rawArtists is List
            ? rawArtists.map((e) => ParseArtist.artistBasic(e)).toList()
            : <ArtistBasic>[ParseArtist.artistBasic(rawArtists)];

        if (artists.isEmpty) {
          throw Exception('Nenhum artista encontrado');
        }

        final artistRaw = ParseArtist.artistsToString(artists);
        final subscribers = data['subscribers']?.toString() ?? '0';

        return SearchResult(
          type: type,
          content: ArtistDetail(
            name: artistRaw,
            id: artists.first.id,
            subscribers: subscribers,
            thumbnails: thumbnails,
          ),
        );

      case 'song':
        String? artist;
        int seconds = 0;

        if (data.containsKey('artists') &&
            (data['artists'] as List).isNotEmpty) {
          artist = data['artists'][0]['name'];
        }
        if (data.containsKey('artist')) {
          // ignore: unused_local_variable
          final artist = data['artist'];
        }

        final videoId = (data['videoId'] ?? '').toString();
        final title = (data['title'] ?? '').toString();

        final album = data['album'];
        final views = data['views'].toString();
        final isExplicit = data['isExplicit'] is bool
            ? data['isExplicit'] as bool
            : (data['isExplicit'] == 'true' || data['isExplicit'] == 1);
        final thumbs = ParseThumbnail.thumbnail(data['thumbnails']);
        if (data.containsKey('duration_seconds')) {
          seconds = data['duration_seconds'];
        }

        return SearchResult(
          type: type,
          content: Song(
            id: videoId,
            title: title,
            artist: artist ?? '',
            album: album,
            views: views,
            durationText: data['duration'],

            isExplicit: isExplicit, //
            duration: Duration(seconds: seconds),
            artUri: thumbs.isNotEmpty ? Uri.parse(thumbs.first.url) : null,
          ),
        );

      case 'album':
        final browseId = (data['browseId'] ?? '').toString();
        final playlistId = data['playlistId']?.toString();
        final title = (data['title'] ?? '').toString();
        final typeStr = data['type']?.toString();
        final artistName = data['artist']?.toString();
        final year = data['year']?.toString();
        final isExplicit = data['isExplicit'] is bool
            ? data['isExplicit'] as bool
            : (data['isExplicit'] == 'true' || data['isExplicit'] == 1);

        final thumbnails =
            (data['thumbnails'] as List?)
                ?.whereType<Map<String, dynamic>>()
                .map(
                  (e) => Thumbnail(
                    url: e['url'] ?? '',
                    width: e['width'] ?? 0,
                    height: e['height'] ?? 0,
                  ),
                )
                .toList() ??
            <Thumbnail>[];

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

      case 'playlist':
        final browseId = (data['browseId'] ?? '').toString();
        final title = (data['title'] ?? '').toString();
        final author = data['author']?.toString();
        final itemCount = data['itemCount']?.toString();

        final thumbnails =
            (data['thumbnails'] as List?)
                ?.whereType<Map<String, dynamic>>()
                .map(
                  (e) => Thumbnail(
                    url: e['url'] ?? '',
                    width: e['width'] ?? 0,
                    height: e['height'] ?? 0,
                  ),
                )
                .toList() ??
            <Thumbnail>[];

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

      case 'video':
        final videoId = (data['videoId'] ?? '').toString();
        final title = (data['title'] ?? '').toString();
        final views = data['views']?.toString();
        final duration = data['duration']?.toString();
        final durationSeconds = data['duration_seconds'] is int
            ? data['duration_seconds'] as int
            : int.tryParse(data['duration_seconds']?.toString() ?? '');
        final videoType = data['videoType']?.toString();

        final artistsRaw = data['artists'];
        List<ArtistBasic> videoArtists = [];
        if (artistsRaw is List) {
          videoArtists = artistsRaw
              .whereType<Map<String, dynamic>>()
              .map((a) => ParseArtist.artistBasic(a))
              .toList();
        }

        final thumbnails =
            (data['thumbnails'] as List?)
                ?.whereType<Map<String, dynamic>>()
                .map(
                  (e) => Thumbnail(
                    url: e['url'] ?? '',
                    width: e['width'] ?? 0,
                    height: e['height'] ?? 0,
                  ),
                )
                .toList() ??
            <Thumbnail>[];

        return SearchResult(
          type: type,
          content: SearchVideo(
            videoId: videoId,
            title: title,
            artists: videoArtists,
            views: views,
            duration: duration,
            durationSeconds: durationSeconds,
            videoType: videoType,
            thumbnails: thumbnails,
          ),
        );

      case 'profile':
        final title = (data['title'] ?? '').toString();
        final name = (data['name'] ?? '').toString();
        final browseId = (data['browseId'] ?? '').toString();

        final thumbnails =
            (data['thumbnails'] as List?)
                ?.whereType<Map<String, dynamic>>()
                .map(
                  (e) => Thumbnail(
                    url: e['url'] ?? '',
                    width: e['width'] ?? 0,
                    height: e['height'] ?? 0,
                  ),
                )
                .toList() ??
            <Thumbnail>[];

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

  static List<SearchResult> parseSearchResults(List<dynamic> data) {
    return data.whereType<Map<String, dynamic>>().map(parseResult).toList();
  }
}
