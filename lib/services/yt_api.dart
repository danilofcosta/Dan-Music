import 'package:ytmusicapi_dart/ytmusicapi_dart.dart';

import '../models/home_section.dart';
import 'parses/parse_home_section.dart' show ParseHomeSessions;
import 'uteis/helper.dart';

class YouTubeMusicService {
  YTMusic? ytmusic;

  Future<void> init() async {
    try {
      ytmusic = await YTMusic.create(language: 'pt');
      printInfoDebug('YTMusic initialized');
    } catch (e, s) {
      printErrorDebug('Failed to initialize YTMusic: $e');
      printErrorDebug(s);
    }
  }

  Future<List<HomeSection>> getHome() async {
    if (ytmusic == null) {
      throw Exception('YTMusic not initialized');
    }
    final res = await ytmusic!.getHome();

    return ParseHomeSessions.parseHomeSections(res);
  }

  void close() {
    ytmusic?.close();
  }
}
