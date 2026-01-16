
import 'package:danmusic/models/album.dart';
import 'package:danmusic/models/artist.dart';
import 'package:danmusic/models/playlist.dart';
import 'package:danmusic/services/parses/parse_artist.dart';
import 'package:danmusic/services/parses/parse_song.dart';
import 'package:danmusic/services/parses/parse_thumbnail.dart';

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
        author: _extractAuthorName(item['author'])?? item['description'],
        itemCount: item['count'] as String?,
        thumbnails: ParseThumbnail.thumbnail(item['thumbnails']),
      );
    } else if (item.containsKey('videoId')) {
      // Pode ser uma música ou vídeo
      if (item.containsKey('album')) {
        // É uma música (tem album)
       // final album = item['album'] as Map<String, dynamic>?;
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
          thumbnails: ParseThumbnail.thumbnail(item['thumbnails']) ,
          shuffleId: null,
          radioId: null,
        );
      } else {
        // É um álbum
       final ArtistBasic? artist =ParseArtist.artistBasic(item['artists']??item['artist']);
       final rawartist =artist !=null ? ParseArtist.artistsToString([artist]):null;
      
        return Album(
          albumId: item['browseId'] as String? ?? '',
          browseId: item['browseId'] as String?,
          title: item['title'] as String? ?? '',
          year: item['year'] as String?,
          thumbnails: ParseThumbnail.thumbnail(item['thumbnails']),
          artist: artist
          ,rawArtist: rawartist

          
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
}
