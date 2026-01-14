import 'package:get/get.dart';
import 'package:danmusic/models/search/search_result.dart';
import 'package:danmusic/services/parses/parse_search_result.dart';
import 'package:danmusic/services/uteis/helper.dart';

import '../../../services/yt_api.dart';

class SearchController extends GetxController {
  final YouTubeMusicService youTubeService = Get.find();

  // INPUT
  final RxString searchQuery = ''.obs;

  // STATE
  final RxBool isLoading = false.obs;
  final RxBool showSuggestions = false.obs;

  // DATA
  final RxList<String> suggestions = <String>[].obs;
  final RxList<SearchResult> searchResults = <SearchResult>[].obs;

  // FILTER
  final RxString selectedFilter = Filtros.all.obs;

  // =============================
  // SUGGESTIONS
  // =============================
  Future<void> fetchSuggestions(String query) async {
    if (query.isEmpty) {
      suggestions.clear();
      showSuggestions.value = false;
      return;
    }

    try {
      final result = await youTubeService.getSearchSuggestions(query);
      suggestions.assignAll(result);
      showSuggestions.value = true;
    } catch (e, s) {
      printErrorDebug('Suggestion error: $e');
      printErrorDebug(s);
      suggestions.clear();
    }
  }

  // =============================
  // SEARCH
  // =============================
  Future<void> search(String query) async {
    if (query.isEmpty) return;

    try {
      isLoading.value = true;
      showSuggestions.value = false;
      searchQuery.value = query;

      // 🔥 limpa dados antigos
      searchResults.clear();

      final rawResults = await youTubeService.search(query);

      final parsed = ParseSearchResult.parseSearchResults(
        rawResults.cast<Map<String, dynamic>>(),
      );

      searchResults.assignAll(parsed);
    } catch (e, s) {
      printErrorDebug('Search error: $e');
      printErrorDebug(s);
      searchResults.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // =============================
  // FILTERED RESULTS
  // =============================
  List<SearchResult> get filteredResults {
    switch (selectedFilter.value) {
      case Filtros.artist:
        return searchResults.where((e) => e.type == 'artist').toList();

      case Filtros.songs:
        return searchResults.where((e) => e.type == 'song').toList();

      case Filtros.albums:
        return searchResults.where((e) => e.type == 'album').toList();

      case Filtros.playlists:
        return searchResults.where((e) => e.type == 'playlist').toList();

      case Filtros.all:
      default:
        return searchResults;
    }
  }

  // =============================
  // UI ACTIONS
  // =============================
  void changeFilter(String filter) {
    selectedFilter.value = filter;
  }

  void clearSearch() {
    searchQuery.value = '';
    suggestions.clear();
    searchResults.clear();
    showSuggestions.value = false;
  }
}

class Filtros {
  Filtros._();
  static const all = 'All';
  static const songs = 'Songs';
  static const albums = 'Albums';
  static const playlists = 'Playlists';
  static const artist = 'Artists';

  static List<String> get filters => [all, songs, albums, playlists, artist];
}
