import 'package:danmusic/models/search_result.dart';
import 'package:danmusic/services/parses/parse_search_result.dart';
import 'package:danmusic/services/uteis/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/yt_api.dart';
import '../widgets/artist_card.dart';
import 'search_controller.dart' show Filtros;

class SearchResultsController extends GetxController {
  final YouTubeMusicService youTubeService = Get.find<YouTubeMusicService>();
  final RxString query = ''.obs; //TODO: '
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

  @override
  void onInit() {
    super.onInit();
  }

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
    final widgets = searchResults.map((res) {
      switch (res.type) {
        case 'artist':
          return ArtistCard(artist: res.content);
        default:
          return Icon(Icons.error, color: Colors.redAccent);
      }
    }).toList();

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

// NOTE: `Filtros` is defined in `search_controller.dart`; avoid duplicate symbol here.

class SearchResultsScreen extends StatefulWidget {
  final String query;
  const SearchResultsScreen({super.key, required this.query});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  late final SearchResultsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(SearchResultsController());
    controller.search(widget.query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Results for "${widget.query}"')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.selectedItems.isEmpty) {
          return const Center(child: Text('No results'));
        }

        return ListView(children: controller.selectedItems);
      }),
    );
  }
}
