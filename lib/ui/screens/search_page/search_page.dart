import 'package:danmusic/ui/screens/search_page/search_page_controler.dart';
import 'package:danmusic/ui/widgets/ui/album_card.dart';
import 'package:danmusic/ui/widgets/ui/playlist_card.dart';
import 'package:danmusic/ui/widgets/ui/song_ui.dart';
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
      // Supondo que result tenha um campo 'type' para diferenciar os tipos
      if (result is String) {
        return ListTile(
          title: Text(result),
          leading: Icon(Icons.search),
          trailing: IconButton(
            icon: Icon(Icons.arrow_upward_sharp),
            onPressed: () {
              // Lógicant("Clicou no resultado de sugestão: $result");
              controller.setSearchText(result);
            },
          ),
        );
      }
      // Adicione mais condições conforme os tipos de SearchResult que você tem
      return SizedBox.shrink(); // Retorna um widget vazio se o tipo não for reconhecido
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
