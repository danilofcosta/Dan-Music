import 'package:ytmusicapi_dart/parsers/browsing.dart';

import '/services/parses/parse_song.dart';

import '../../models/home_section.dart';

class ParseHomeSessions {
  static List<HomeSection> parseHomeSections(List<dynamic> homeSections) {
  
    return homeSections.map<HomeSection>((section) {
      return HomeSection(
        title: section['title'] ?? '',
        contents: _parseContents(
          section['contents'],
        ).where((element) => element != null).cast<dynamic>().toList(),
      );
    }).toList();
  }

  static dynamic _parseContents(List<dynamic> contents) {
    return contents.map((item) {
      return _identifyType(item);
    }).toList();
  }

  static dynamic _identifyType(Map<String, dynamic> item) {
    if (item.containsKey('playlistId')) {
      return [];
    }

    if (item.containsKey('subscribers')) {
      return [];
    }

    if (item.containsKey('videoId') && item.containsKey('album')) {
      return ParseSong.song(item);
    }

    if (item.containsKey('videoId')) {
      return [];
    }

    if (item.containsKey('browseId')) {}

    return [];
  }
}
