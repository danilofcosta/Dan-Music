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

  // CACHE
  final Map<String, List<String>> _suggestionsCache = {};
  final Map<String, List<SearchResult>> _searchCache = {};

  // =============================
  // SUGGESTIONS
  // =============================
  Future<void> fetchSuggestions(String query) async {
    if (query.isEmpty) {
      suggestions.clear();
      showSuggestions.value = false;
      return;
    }

    // Verifica cache de sugestões
    if (_suggestionsCache.containsKey(query)) {
      suggestions.assignAll(_suggestionsCache[query]!);
      showSuggestions.value = true;
      return;
    }

    try {
      final result = await youTubeService.getSearchSuggestions(query);
      suggestions.assignAll(result);
      _suggestionsCache[query] = result;
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

    // Verifica cache de busca
    if (_searchCache.containsKey(query)) {
      searchResults.assignAll(_searchCache[query]!);
      return;
    }

    try {
      isLoading.value = true;
      showSuggestions.value = false;
      searchQuery.value = query;

      final rawResults = await youTubeService.search(query);

      final parsed = ParseSearchResult.parseSearchResults(
        rawResults.cast<Map<String, dynamic>>(),
      );

      searchResults.assignAll(parsed);
      _searchCache[query] = parsed;
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
    _suggestionsCache.clear();
    _searchCache.clear();
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
