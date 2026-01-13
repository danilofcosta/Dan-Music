import 'package:danmusic/services/parses/parse_search_result.dart'
    show ParseSearchResult;
import 'package:danmusic/services/yt_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/artist.dart';
import '../../../models/search/search_album.dart';
import '../../../models/search/search_playlist.dart' show SearchPlaylist;
import '../../../models/search/search_profile.dart';
import '../../../models/search/search_result.dart' show SearchResult;
import '../../../models/song.dart';
import '../../../services/uteis/helper.dart';
import '../../widgets/cards/album_card.dart';
import '../../widgets/cards/artist_card.dart';
import '../../widgets/cards/playlist_card.dart';
import '../../widgets/cards/profile_card.dart';
import '../../widgets/cards/song_card.dart';
import 'search_controller.dart';

class SearchResultsController extends GetxController {
  final YouTubeMusicService youTubeService = Get.find<YouTubeMusicService>();
  final RxString query = ''.obs;
  final RxString searchQuery = ''.obs;
  final RxString searchText = ''.obs;
  final RxList<String> suggestions = <String>[].obs;
  final RxList<SearchResult> searchResults = <SearchResult>[].obs;
  final RxList<Widget> selectedItems = <Widget>[].obs;
  final RxList<Widget> all = <Widget>[].obs;
  final RxList<Widget> songs = <Widget>[].obs;
  final RxList<Widget> artist = <Widget>[].obs;
  final RxList<Widget> albums = <Widget>[].obs;
  final RxList<Widget> playlists = <Widget>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool showSuggestions = false.obs;
  final RxString selectedFilter = Filtros.all.obs;
  final RxList<String> currentResults = <String>[].obs;

  Future<void> fetchSuggestions(String query) async {
    if (query.isEmpty) {
      suggestions.clear();
      showSuggestions.value = false;
      return;
    }

    try {
      isLoading.value = true;
      final results = await youTubeService.getSearchSuggestions(query);
      suggestions.value = results;
      showSuggestions.value = true;
    } catch (e, s) {
      printErrorDebug('Error fetching suggestions: $e');
      printErrorDebug(s);
      suggestions.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> search(String query) async {
    if (query.isEmpty) return;

    try {
      isLoading.value = true;
      showSuggestions.value = false;
      searchQuery.value = query;

      final results = await youTubeService.search(query);

      final parsedResults = ParseSearchResult.parseSearchResults(
        results.cast<Map<String, dynamic>>(),
      );

      searchResults.value = parsedResults;
      printInfoDebug('Found ${parsedResults.length} results');
      featdataResults();
    } catch (e, s) {
      printErrorDebug('Error searching: $e');
      printErrorDebug(s);
      searchResults.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  void featdataResults() {
    switch (selectedFilter.value) {
      case Filtros.all:
        if (all.isNotEmpty) {
          selectedItems.assignAll(all);
          break;
        }
        getResultsAll();

        break;

      default:
        break;
    }
  }

  void getResultsAll() async {
    Widget widgetFromResult(SearchResult res) {
      final content = res.content;

      if (content is ArtistDetail) return ArtistCard(artist: content);
      if (content is Song) return SongCard(song: content);
      if (content is SearchAlbum) return AlbumCard(album: content);
      if (content is SearchPlaylist) return PlaylistCard(playlist: content);
      if (content is SearchProfile) return ProfileCard(profile: content);

      // Fallback by declared type
      switch (res.type) {
        case 'artist':
          return ArtistCard(artist: content as ArtistDetail);
        case 'song':
        case 'video':
          return SongCard(song: content as Song);
        case 'album':
          return AlbumCard(album: content as SearchAlbum);
        case 'playlist':
          return PlaylistCard(playlist: content as SearchPlaylist);
        case 'profile':
          return ProfileCard(profile: content as SearchProfile);
        default:
          return ListTile(
            leading: const Icon(Icons.error, color: Colors.redAccent),
            title: Text('Unknown result: ${res.type}'),
          );
      }
    }

    final widgets = searchResults.map(widgetFromResult).toList();

    all.assignAll(widgets);
    selectedItems.assignAll(widgets);
  }

  void clearSearch() {
    searchQuery.value = '';
    suggestions.clear();
    searchResults.clear();
    showSuggestions.value = false;
  }

  void changeFilter(String filter) {
    selectedFilter.value = filter;
    featdataResults();
  }
}
