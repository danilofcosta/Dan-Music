import 'package:ytmusicapi_dart/ytmusicapi_dart.dart';

import '../models/home_section.dart';
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

  Future<List<HomeSection>> getHome() async {
    if (ytmusic == null) {
      throw Exception('YTMusic not initialized');
    }
    final res = await ytmusic!.getHome();

    return ParseHomeSessions.parseHomeSections(res);
  }

  Future<List<String>> getSearchSuggestions(String query) async {
    if (ytmusic == null) {
      throw Exception('YTMusic not initialized');
    }
    try {
      final dynamic suggestions = await ytmusic!.getSearchSuggestions(query);
      final filteredSuggestions = suggestions
          .map((item) => item is String ? item : null)
          .where((item) => item != null)
          .cast<String>()
          .toList();
        
      return filteredSuggestions;
    } catch (e) {
      printErrorDebug('Error fetching suggestions: $e');
      return [];
    }
  }

  Future<List<dynamic>> search(String query) async {
    if (ytmusic == null) {
      throw Exception('YTMusic not initialized');
    }
    try {
      final results = await ytmusic!.search(query);
      return results;
    } catch (e) {
      printErrorDebug('Error searching: $e');
      return [];
    }
  }

  void close() {
    ytmusic?.close();
  }
}
