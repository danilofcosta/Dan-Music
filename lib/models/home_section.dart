import 'package:danmusic/models/album.dart';
import 'package:danmusic/models/artist.dart';
import 'package:danmusic/models/playlist.dart';
import 'package:danmusic/models/song.dart';
import 'package:danmusic/models/thumbnail.dart';
import 'package:danmusic/services/parses/parse_song.dart';

abstract class HomeContent {}

class HomeSection<T extends HomeContent> {
  final String title;
  final List<T> contents;

  HomeSection({required this.title, required this.contents});
}

class ParseHomeSessions {
  static List<HomeSection<HomeContent>> parseHomeSections(
    List<dynamic> homeSections,
  ) {
    return homeSections.map((section) {
      if (section is! Map<String, dynamic>) {
        return HomeSection<HomeContent>(title: '', contents: []);
      }

      final title = section['title'] as String? ?? '';
      final contentsList = section['contents'] as List<dynamic>? ?? [];

      final parsedContents = contentsList
          .map((item) {
            if (item is! Map<String, dynamic>) return null;
            final parse = _parseContentItem(item);
            return parse;
          })
          .whereType<HomeContent>()
          .toList();

      return HomeSection<HomeContent>(title: title, contents: parsedContents);
    }).toList();
  }

  static dynamic _parseContentItem(Map<String, dynamic> item) {
    // Detecta o tipo baseado nas chaves presentes
    if (item.containsKey('playlistId')) {
      // É uma playlist
      return Playlist(
        browseId: item['browseId'] as String? ?? item['playlistId'],
        title: item['title'] as String? ?? '',
        author: _extractAuthorName(item['author']),
        itemCount: item['count'] as String?,
        thumbnails: _parseThumbnails(item['thumbnails']),
      );
    } else if (item.containsKey('videoId')) {
      // Pode ser uma música ou vídeo
      if (item.containsKey('album')) {
        // É uma música (tem album)
        final album = item['album'] as Map<String, dynamic>?;
        return ParseSong.song(item);
      } else {
        // É um vídeo
        return  ParseSong.song(item);
      }
    } else if (item.containsKey('browseId')) {
      // Pode ser artista ou álbum
      if (item.containsKey('subscribers')) {
        // É um artista
        return ArtistDetail(
          name: item['title'] as String? ?? '',
          browseId: item['browseId'] as String? ?? '',
          subscribers: item['subscribers'] as String?,
          thumbnails: _parseThumbnails(item['thumbnails']) ?? [],
          shuffleId: null,
          radioId: null,
        );
      } else {
        // É um álbum
        return Album(
          albumId: item['browseId'] as String? ?? '',
          browseId: item['browseId'] as String?,
          title: item['title'] as String? ?? '',
          year: item['year'] as String?,
          thumbnails: _parseThumbnails(item['thumbnails']),
        );
      }
    }
    return null;
  }

  static String? _extractAuthorName(dynamic authorData) {
    if (authorData is List<dynamic> && authorData.isNotEmpty) {
      final firstAuthor = authorData.first;
      if (firstAuthor is Map<String, dynamic>) {
        return firstAuthor['name'] as String?;
      }
    }
    return null;
  }

  static List<ArtistBasic>? _parseArtists(dynamic artistsData) {
    if (artistsData is! List<dynamic>) return null;

    return artistsData
        .map((artist) {
          if (artist is Map<String, dynamic>) {
            return ArtistBasic(
              name: artist['name'] as String? ?? '',
              id: artist['id'] as String? ?? '',
            );
          }
          return null;
        })
        .whereType<ArtistBasic>()
        .toList();
  }

  static List<Thumbnail>? _parseThumbnails(dynamic thumbnailsData) {
    if (thumbnailsData is! List<dynamic>) return null;

    return thumbnailsData
        .map((thumb) {
          if (thumb is Map<String, dynamic>) {
            final url = thumb['url'] as String? ?? '';
            final width = (thumb['width'] as num?)?.toInt() ?? 0;
            final height = (thumb['height'] as num?)?.toInt() ?? 0;
            return Thumbnail(url: url, width: width, height: height);
          }
          return null;
        })
        .whereType<Thumbnail>()
        .toList();
  }

  static Uri? _getFirstThumbnailUri(dynamic thumbnailsData) {
    if (thumbnailsData is List<dynamic> && thumbnailsData.isNotEmpty) {
      final firstThumb = thumbnailsData.first;
      if (firstThumb is Map<String, dynamic>) {
        final url = firstThumb['url'] as String?;
        if (url != null) {
          try {
            return Uri.parse(url);
          } catch (e) {
            return null;
          }
        }
      }
    }
    return null;
  }
}
