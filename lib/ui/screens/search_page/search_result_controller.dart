import 'dart:math';

import 'package:danmusic/services/uteis/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/ytmusicapi.dart';

class SearchResultController extends GetxController {
  final allResult = <String>[].obs;
  final songsResult = <String>[].obs;
  final albumsResult = <String>[].obs;
  final playlistsResult = <String>[].obs;
  final artistsResult = <String>[].obs;
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

  List<String> get currentResults {
    switch (selectedFilter.value) {
      case Filtros.songs:
        return songsResult;
      case Filtros.albums:
        return albumsResult;
      case Filtros.playlists:
        return playlistsResult;
      case Filtros.artists:
        return artistsResult;
      default:
        return allResult;
    }
  }

  void getSearchallResult(String? text) async {
    text ??= searchText.value;
    printInfoDebug("Pesquisando texto digitado por: $text");

    var searchResults = await YouTubeMusicService.getSearchSuggestions(text);
    searchResults.map((w) => ListTile(title: Text(w))).toList();

    allResult.assignAll(searchResults);

    // exemplo fake de separação
    songsResult.assignAll(searchResults.take(5));
    albumsResult.assignAll(searchResults.skip(5).take(5));
    playlistsResult.assignAll(searchResults.skip(10).take(5));
    artistsResult.assignAll(searchResults.skip(15).take(5));
  }
}

class Filtros {
  Filtros._();
  static const all = 'All';
  static const songs = 'Songs';
  static const albums = 'Albums';
  static const playlists = 'Playlists';
  static const artists = 'Artists';
}
