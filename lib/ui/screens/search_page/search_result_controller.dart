import 'package:danmusic/services/parsers/parser_result_search.dart';
import 'package:danmusic/services/uteis/helper.dart';
import 'package:danmusic/ui/widgets/ui/playlist_card.dart';
import 'package:danmusic/ui/widgets/ui/song_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/search_result.dart';
import '../../../services/ytmusicapi.dart';
import '../../widgets/ui/album_card.dart';
import '../../widgets/ui/artist_card.dart';

class SearchResultController extends GetxController {
  final allResult = <Widget>[].obs;
  final songsResult = <Widget>[].obs;
  final videosResult = <Widget>[].obs;
  final albumsResult = <Widget>[].obs;
  final playlistsResult = <Widget>[].obs;
  final artistsResult = <Widget>[].obs;
  final searchText = ''.obs;

  final selectedFilter = Filtros.all.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as List;

    searchText.value = args[0];
    getSearchallResult(searchText.value);
  }

  void changeFilter(String filter) {
    selectedFilter.value = filter;
  }

  List<Widget> get currentResults {
    switch (selectedFilter.value) {
      case Filtros.songs:
        if (songsResult.isEmpty) {
          getSearchSongsResult(null);
          return songsResult;
        }
        return songsResult;
      case Filtros.albums:
        if (albumsResult.isEmpty) {
          getAlbumsResult(null);
          return albumsResult;
        }
        return albumsResult;
      case Filtros.playlists:
        if (playlistsResult.isEmpty) {
          getplaylistsResult(null);
          return playlistsResult;
        }
        return playlistsResult;
      case Filtros.artists:
        if (artistsResult.isEmpty) {
          getArtistsResult(null);
          return artistsResult;
        }
        return artistsResult;
      case Filtros.videos:
        if (videosResult.isEmpty) {
          getSearchVideosResult(null);
          return videosResult;
        }
        return videosResult;
      default:
        if (allResult.isEmpty) {
          getSearchallResult(null);
          return allResult;
        }
        return allResult;
    }
  }

  void getSearchallResult(String? text) async {
    text ??= searchText.value;
    printInfoDebug("Pesquisando texto digitado por: $text");

    var searchResults = await YouTubeMusicService.getSearchResult(text);
    // var listOf = searchResults.map((w) => ListTile(title: Text(w))).toList();
    List listOf = ParserResultSearch.parseResultSearchdartYtmusicapi(
      searchResults,
    );
    listOf = parseResult(results: listOf as List<SearchResult>) ?? [];

    allResult.assignAll(listOf as List<Widget>);

    // exemplo fake de separação
  }

  void getSearchSongsResult(String? text) async {
    text ??= searchText.value;
    printInfoDebug("Pesquisando músicas por: $text");
    var getSearchSongsResult = await YouTubeMusicService.searchSongs(text);

    List<Widget> _songsResult = getSearchSongsResult
        .map((song) => SongUi(mediaItem: song))
        .toList();
    songsResult.assignAll(_songsResult);
  }

  void getAlbumsResult(String? text) async {
    text ??= searchText.value;
    printInfoDebug("Pesquisando album por: $text");
    var getalbumsResult = await YouTubeMusicService.searcAlbums(text);
    List<Widget> _albumsResult = getalbumsResult
        .map((album) => AlbumCard(album: album))
        .toList();
    albumsResult.assignAll(_albumsResult);
  }

  void getplaylistsResult(String? text) async {
    text ??= searchText.value;
    printInfoDebug("Pesquisando playlist por: $text");
    var getplaylistsResult = await YouTubeMusicService.searchPlaylists(text);
    List<Widget> _playlistsResult = getplaylistsResult
        .map((playlist) => PlaylistCard(playlist: playlist))
        .toList();
    playlistsResult.assignAll(_playlistsResult);
  }

  void getArtistsResult(String? text) async {
    text ??= searchText.value;
    printInfoDebug("Pesquisando artistas por: $text");
    var _getArtistsResult = await YouTubeMusicService.searchArtistsResult(text);

    artistsResult.assignAll(
      _getArtistsResult.map((artist) => ArtistCard(artist: artist)).toList(),
    );
  }

  void getSearchVideosResult(String? text) async {

    text ??= searchText.value;
    printInfoDebug("Pesquisando videos por: $text");
    var _getSearchVideosResult = await YouTubeMusicService.searchVideos(text);

 List<Widget> _videosResult = _getSearchVideosResult
        .map((song) => SongUi(mediaItem: song))
        .toList();
    videosResult.assignAll(_videosResult);


  }
  List<Widget>? parseResult({required List<SearchResult> results}) {
    if (results.isEmpty) {
      return null;
    }

    return results.map((w) {
      switch (w.type) {
        case 'SONG':
        case 'VIDEO':
          final songResult = w as SongDetailedSearchResult;
          return SongUi(mediaItem: songResult.songMedia);
        case 'ALBUM':
          final albumResult = w as AlbumDetailedSearchResult;
          return AlbumCard(album: albumResult.album);
        case 'ARTIST':
          final artistResult = w as ArtistDetailedSearchResult;
          return ArtistCard(artist: artistResult.artist);

        case 'PLAYLIST':
          final playlistResult = w as PlaylistDetailedSearchResult;
          return PlaylistCard(playlist: playlistResult.playlist);

        default:
          return const SizedBox.shrink(); // safe fallback widget
      }
    }).toList();
  }
}

class Filtros {
  Filtros._();
  static const all = 'All';
  static const songs = 'Songs';
  static const albums = 'Albums';
  static const videos = 'videos';
  static const playlists = 'Playlists';
  static const artists = 'Artists';
  static const List<String> values = [
    all,
    songs,
    videos,
    albums,
    playlists,
    artists,
  ];
}
