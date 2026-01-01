import 'package:ytmusicapi_dart/ytmusicapi_dart.dart';

import 'parses/parse_home_section.dart' show ParseHomeSessions;
import 'uteis/helper.dart';


class YouTubeMusicService {
  YTMusic? ytmusic;

  Future<void> init() async {
    try {
      ytmusic = await YTMusic.create(language: 'en');
      printInfoDebug('YTMusic initialized');
    } catch (e, s) {
      printErrorDebug('Failed to initialize YTMusic: $e');
      printErrorDebug(s);
    }
  }

  Future<void> getHome() async {
    if (ytmusic == null) {
      throw Exception('YTMusic not initialized');
    }
    final res = await ytmusic!.getHome();

    printErrorDebug(res);
    ParseHomeSessions.parseHomeSections(res);
  }

  void close() {
    ytmusic?.close();
  }
}
