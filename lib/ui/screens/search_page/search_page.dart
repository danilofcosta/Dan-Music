import 'package:danmusic/services/to_media_item.dart';
import 'package:danmusic/ui/screens/search_page/search_page_controler.dart';
import 'package:danmusic/ui/widgets/ui/album_card.dart';
import 'package:danmusic/ui/widgets/ui/playlist_card.dart';
import 'package:danmusic/ui/widgets/ui/song_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/ui/artist_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final controller = Get.put(SearchPageController());

  void _onSearch(String text) {
    // Aqui você faz a lógica de busca
    debugPrint('Pesquisando: $text');
  }

  List<Widget> buildSearchResults() {
    if (controller.resuts.isEmpty) {
      return [Center(child: Text('Nenhum resultado encontrado'))];
    }

    return controller.resuts.map((result) {
      switch (result.type) {
        case 'SONG':
          return SongUi(mediaItem: result.songMedia);

        case 'ARTIST':
          return ArtistCard(artist: result.artist);
        case 'ALBUM':
          return AlbumCard(album: result.album);
        case 'PLAYLIST':
          return PlaylistCard(playlist: result.playlist);

        default:
          return ListTile(title: Text(result.type.toString()));
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(title: const Text('Pesquisar'), centerTitle: true),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: controller.searchController,
                onSubmitted: _onSearch,
                autocorrect: true,
                enableSuggestions: true,
                autofocus: true,
                maxLength: 100,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  // counterText: 'sss',
                  hintText: 'O que deseja encontrar?',
                  filled: true,
                  //   fillColor: Colors.grey.shade200,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  //  prefixIcon: const Icon(Icons.search),
                  suffixIcon: controller.searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              controller.searchController.clear();
                            });
                          },
                        )
                      : const Icon(Icons.mic),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (_) async {
                  if (controller.searchController.text.isEmpty) return;
                  debugPrint(controller.searchController.text);
                  controller.search(controller.searchController.text);
                },
              ),

              const SizedBox(height: 20),

              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: buildSearchResults(),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
