import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'search_controller.dart' as sc;
import 'search_results_screen.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = '/search';
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late sc.SearchController controller;
  late TextEditingController textController;

  @override
  void initState() {
    super.initState();
    controller = Get.put(sc.SearchController());
    textController = TextEditingController();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void handleSearch() {
    final query = textController.text.trim();
    if (query.isNotEmpty) {
      Get.to(() => SearchResultsScreen(query: query));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search'), elevation: 0),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: textController,
                decoration: InputDecoration(
                  hintText: 'Search songs, artists...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: textController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            textController.clear();
                            controller.clearSearch();
                            setState(() {});
                          },
                        )
                      : Icon(Icons.mic), // add microfone button here
                  // TODO: Add microphone button
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                  setState(() {});
                  controller.fetchSuggestions(value);
                },
                onSubmitted: (value) => handleSearch(),
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.suggestions.isEmpty) {
                  return Center(
                    child: Text(
                      textController.text.isEmpty ? '' : 'No suggestions',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: controller.suggestions.length,
                  itemBuilder: (context, index) {
                    final suggestion = controller.suggestions[index];
                    return ListTile(
                      leading: const Icon(Icons.history),
                      title: Text(suggestion),
                      onTap: () {
                        textController.text = suggestion;
                        controller.clearSearch();
                        handleSearch();
                      },
                      trailing: IconButton(
                        onPressed: () {
                          textController.text = suggestion;
                        },
                        icon: Icon(Icons.arrow_circle_up),
                      ),
                      onLongPress: () async {
                        await Clipboard.setData(
                          ClipboardData(text: suggestion),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('$suggestion copied')),
                        );
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
