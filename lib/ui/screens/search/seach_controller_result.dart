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

  final RxString searchQuery = ''.obs;
  final RxList<SearchResult> searchResults = <SearchResult>[].obs;
  final RxList<Widget> selectedItems = <Widget>[].obs;

  // Cache por filtro (armazena widgets já construídos)
  final Map<String, List<Widget>> _cache = {};

  final RxBool isLoading = false.obs;
  final RxString selectedFilter = Filtros.all.obs;

  // Cache de busca por query
  final Map<String, List<SearchResult>> _searchCache = {};

  /* ================= BUSCA PRINCIPAL ================= */

  Future<void> search(String query) async {
    if (query.isEmpty) return;

    // Verifica cache de busca
    if (_searchCache.containsKey(query)) {
      searchResults.assignAll(_searchCache[query]!);
      _cache.clear();
      featdataResults();
      return;
    }

    try {
      isLoading.value = true;
      searchQuery.value = query;

      final results = await youTubeService.search(query);
      final parsedResults = ParseSearchResult.parseSearchResults(
        results.cast<Map<String, dynamic>>(),
      );

      searchResults.assignAll(parsedResults);
      _searchCache[query] = parsedResults;
      _cache.clear();

      featdataResults();
    } catch (e, s) {
      printErrorDebug('Error searching: $e');
      printErrorDebug(s);
    } finally {
      isLoading.value = false;
    }
  }

  /* ================= CONTROLE DE FILTRO ================= */

  void changeFilter(String filter) {
    selectedFilter.value = filter;
    featdataResults();
  }

  void featdataResults() {
    final filter = selectedFilter.value;
    if (_cache.containsKey(filter)) {
      selectedItems.assignAll(_cache[filter]!);
      return;
    }

    final widgets = _buildWidgetsForFilter(filter);
    _cache[filter] = widgets;
    selectedItems.assignAll(widgets);
  }

  /* ================= CONSTRUÇÃO DE WIDGETS POR FILTRO ================= */

  List<Widget> _buildWidgetsForFilter(String filter) {
    switch (filter) {
      case Filtros.songs:
        return searchResults
            .where((r) => r.content is Song)
            .map((r) => SongCard(song: r.content as Song))
            .toList();

      case Filtros.artist:
        return searchResults
            .where((r) => r.content is ArtistDetail)
            .map((r) => ArtistCard(artist: r.content as ArtistDetail))
            .toList();

      case Filtros.albums:
        return searchResults
            .where((r) => r.content is SearchAlbum)
            .map((r) => AlbumCard(album: r.content as SearchAlbum))
            .toList();

      case Filtros.playlists:
        return searchResults
            .where((r) => r.content is SearchPlaylist)
            .map((r) => PlaylistCard(playlist: r.content as SearchPlaylist))
            .toList();

      case Filtros.all:
      default:
        return searchResults.map((res) {
          final content = res.content;
          if (content is ArtistDetail) return ArtistCard(artist: content);
          if (content is Song) return SongCard(song: content);
          if (content is SearchAlbum) return AlbumCard(album: content);
          if (content is SearchPlaylist) return PlaylistCard(playlist: content);
          if (content is SearchProfile) return ProfileCard(profile: content);
          return const ListTile(
            leading: Icon(Icons.error, color: Colors.red),
            title: Text('Unknown result'),
          );
        }).toList();
    }
  }
}
