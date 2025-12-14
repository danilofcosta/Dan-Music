import 'package:danmusic/ui/screens/search_page/search_result_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchResult extends StatefulWidget {
  const SearchResult({super.key});

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  int _selectedIndex = 0;
  final controller = Get.put(SearchResultController());
  final List<String> _filters = [
    Filtros.all,
    Filtros.songs,
    Filtros.albums,
    Filtros.playlists,
    Filtros.artists,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.searchText.value),
        backgroundColor: Colors.grey.shade900,
        elevation: 0,
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
    return SizedBox(
      height: 48,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return Obx(() {
            final filter = _filters[index];
            final isSelected = controller.selectedFilter.value == filter;

            return ChoiceChip(
              label: Text(filter),
              selected: isSelected,
              selectedColor: Colors.grey.shade400,
              backgroundColor: Colors.grey.shade200,
              side: BorderSide(color: Colors.grey.shade400),
              labelStyle: TextStyle(
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.black : Colors.grey.shade700,
              ),
              onSelected: (_) => controller.changeFilter(filter),
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
            return _ResultItem(
              title: results[index],
              subtitle: controller.selectedFilter.value,
            );
          },
        );
      }),
    );
  }
}

/// 🔹 ITEM DE RESULTADO (REUTILIZÁVEL)
class _ResultItem extends StatelessWidget {
  final String title;
  final String subtitle;

  const _ResultItem({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade300,
        child: const Icon(Icons.music_note, color: Colors.black87),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.more_vert),
    );
  }
}
