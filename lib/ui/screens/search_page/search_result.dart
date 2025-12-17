import 'package:danmusic/ui/screens/search_page/search_result_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchResult extends StatefulWidget {
  const SearchResult({super.key});

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  final controller = Get.put(SearchResultController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.searchText.value,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge!.color!,
            fontWeight: FontWeight.w600,
            fontSize: 18,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 5,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFilters(),
          const SizedBox(height: 12),
          _buildResults(),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    final filters = Filtros.values.toList();

    return SizedBox(
      height: 48,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return Obx(() {
            final filter = filters[index];
            final isSelected = controller.selectedFilter.value == filter;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              child: ChoiceChip(
                label: Text(filter),
                selected: isSelected,
                autofocus: isSelected,
                elevation: 5,
                padding: EdgeInsetsDirectional.all(8),
                pressElevation: 8,
                // avatar: Text('data'),
                // selectedColor: Theme.of(context).primaryColor,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                side: BorderSide(color: Colors.grey.shade400),
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Theme.of(context).textTheme.bodyLarge!.color!
                      : Colors.grey.shade700,
                ),
                onSelected: (_) => controller.changeFilter(filter),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildResults() {
    return Expanded(
      child: Obx(() {
        final results = controller.currentResults;

        if (results.isEmpty) {
          return const Center(child: Text('Nenhum resultado encontrado'));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          itemCount: results.length,
          itemBuilder: (context, index) {
            Widget result = results[index];
            return result;
          },
        );
      }),
    );
  }
}
