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

  // Cache por filtro
  final RxList<Widget> all = <Widget>[].obs;
  final RxList<Widget> songs = <Widget>[].obs;
  final RxList<Widget> artist = <Widget>[].obs;
  final RxList<Widget> albums = <Widget>[].obs;
  final RxList<Widget> playlists = <Widget>[].obs;

  final RxBool isLoading = false.obs;
  final RxString selectedFilter = Filtros.all.obs;

  /* ================= BUSCA PRINCIPAL ================= */

  Future<void> search(String query) async {
    if (query.isEmpty) return;

    try {
      isLoading.value = true;
      searchQuery.value = query;

      final results = await youTubeService.search(query);
      final parsedResults = ParseSearchResult.parseSearchResults(
        results.cast<Map<String, dynamic>>(),
      );

      searchResults.assignAll(parsedResults);

      // Limpa caches
      all.clear();
      songs.clear();
      artist.clear();
      albums.clear();
      playlists.clear();

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
    switch (selectedFilter.value) {
      case Filtros.all:
        if (all.isNotEmpty) {
          selectedItems.assignAll(all);
        } else {
          getResultsAll();
        }
        break;

      case Filtros.songs:
        if (songs.isNotEmpty) {
          selectedItems.assignAll(songs);
        } else {
          getResultsSongs();
        }
        break;

      case Filtros.artist:
        if (artist.isNotEmpty) {
          selectedItems.assignAll(artist);
        } else {
          getResultsArtist();
        }
        break;

      case Filtros.albums:
        if (albums.isNotEmpty) {
          selectedItems.assignAll(albums);
        } else {
          getResultsAlbums();
        }
        break;

      case Filtros.playlists:
        if (playlists.isNotEmpty) {
          selectedItems.assignAll(playlists);
        } else {
          getResultsPlaylists();
        }
        break;

      default:
        printErrorDebug('Filtro inválido: ${selectedFilter.value}');
        break;
    }
  }

  /* ================= MÉTODOS POR FILTRO ================= */

  void getResultsSongs() async {
    isLoading.value = true;
    try {
      final result = await youTubeService.searchSong(searchQuery.value);
      final widgets = result.map((e) => SongCard(song: e)).toList();

      songs.assignAll(widgets);
      selectedItems.assignAll(widgets);
    } catch (e, s) {
      printErrorDebug(e);
      printErrorDebug(s);
    } finally {
      isLoading.value = false;
    }
  }

  void getResultsArtist() {
    final widgets = searchResults
        .where((r) => r.content is ArtistDetail)
        .map((r) => ArtistCard(artist: r.content as ArtistDetail))
        .toList();

    artist.assignAll(widgets);
    selectedItems.assignAll(widgets);
  }

  void getResultsAlbums() {
    final widgets = searchResults
        .where((r) => r.content is SearchAlbum)
        .map((r) => AlbumCard(album: r.content as SearchAlbum))
        .toList();

    albums.assignAll(widgets);
    selectedItems.assignAll(widgets);
  }

  void getResultsPlaylists() {
    final widgets = searchResults
        .where((r) => r.content is SearchPlaylist)
        .map((r) => PlaylistCard(playlist: r.content as SearchPlaylist))
        .toList();

    playlists.assignAll(widgets);
    selectedItems.assignAll(widgets);
  }

  void getResultsAll() {
    Widget widgetFromResult(SearchResult res) {
      final content = res.content;

      if (content is ArtistDetail) return ArtistCard(artist: content);
      if (content is Song) return SongCard(song: content);
      if (content is SearchAlbum) return AlbumCard(album: content);
      if (content is SearchPlaylist) {
        return PlaylistCard(playlist: content);
      }
      if (content is SearchProfile) {
        return ProfileCard(profile: content);
      }

      return const ListTile(
        leading: Icon(Icons.error, color: Colors.red),
        title: Text('Unknown result'),
      );
    }

    final widgets = searchResults.map(widgetFromResult).toList();

    all.assignAll(widgets);
    selectedItems.assignAll(widgets);
  }
}
