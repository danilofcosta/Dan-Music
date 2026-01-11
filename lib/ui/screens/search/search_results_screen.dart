import 'package:danmusic/ui/screens/search/seach_controller_result.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../navigation.dart';

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
      appBar: AppBar(
        title: Text('Results for "${widget.query}"'),
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(RouteName.search);
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
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
