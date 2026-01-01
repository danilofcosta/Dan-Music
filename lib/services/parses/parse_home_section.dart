import '/services/parses/parse_song.dart';

import '../../models/home_section.dart';

class ParseHomeSessions {
  static List<HomeSection> parseHomeSections(
    List<dynamic> homeSections,
  ) {
    return homeSections.map<HomeSection>((section) {
      return HomeSection(
        title: section['title'] ?? '',
        contents: _parseContents(
          List<Map<String, dynamic>>.from(section['contents'] ?? []),
        ),
      );
    }).toList();
  }

  static List _parseContents(
    List<Map<String, dynamic>> contents,
  ) {
    return contents.map((item) {
      return _identifyType(item);
    }).toList();
  }

  static dynamic _identifyType(Map<String, dynamic> item) {
    if (item.containsKey('playlistId')) {
      return HomeContentType.playlist;
    }

    if (item.containsKey('subscribers')) {
      return HomeContentType.artist;
    }

    if (item.containsKey('videoId') && item.containsKey('album')) {

      return ParseSong.song(item);
      
      
    }

    if (item.containsKey('videoId')) {
      return HomeContentType.video;
    }

    if (item.containsKey('browseId')) {
      return HomeContentType.album;
    }

    return HomeContentType.unknown;
  }
}

enum HomeContentType {
  album,
  playlist,
  artist,
  song,
  video,
  unknown,
}

class HomeContent {
  final String title;
  final HomeContentType type;
  final Map<String, dynamic> raw;

  HomeContent({
    required this.title,
    required this.type,
    required this.raw,
  });
}
