import 'package:danmusic/navigator.dart';
import 'package:danmusic/services/uteis/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/ytmusicapi.dart';

class SearchPageController extends GetxController {
  final searchController = TextEditingController();
  final searchText = 'searchText'.obs;
  final resuts = [].obs; // list [SearchResult]

  @override
  void onInit() {
    super.onInit();

    // Observa o texto conforme o usuário digita
    searchController.addListener(() {
      searchText.value = searchController.text;
    });
  }

  void clearSearch() {
    searchController.clear();
    searchText.value = '';
    resuts.value = [];
  }

  void setSearchText(String text) {
    searchText.value = text;
    searchController.text = text;
    getSearchSuggestions(text);
  }

  void doSearch() {
    if (searchText.isNotEmpty) {
      printInfoDebug("Pesquisando por: ${searchText.value}");
      // coloque sua lógica de busca aqui
    }
  }

  void openPageResultSearch(String? text) {
    text ??= searchController.text;
    Get.toNamed(
      ScreenNavigationSetup.searchResultScreen,
      arguments: [text],
      id: ScreenNavigationSetup.id,
    );
  }

  void getSearchSuggestions(String text) async {
    printInfoDebug("Pesquisando texto digitado por: $text");
    // coloque sua lógica de busca aqui

    final List<String> searchResults =
        await YouTubeMusicService.getSearchSuggestions(text);
    resuts.value = searchResults; // SearchResults
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
