import 'package:danmusic/services/uteis/helper.dart';
import 'package:danmusic/ui/screens/search/seach_controller_result.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../navigation.dart';
import 'search_controller.dart';

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

  List<int> buildFlexWeights(int selectedIndex, int length) {
    return List.generate(length, (index) {
      final diff = (index - selectedIndex).abs();

      if (diff == 0) return 3; // selecionado
      if (diff == 1) return 2; // vizinhos
      return 1; // resto
    });
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

        final _Filtros = Filtros.filters;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 70),
                child: Obx(() {
                  final selectedIndex = _Filtros.indexOf(
                    controller.selectedFilter.value,
                  );

                  final flexWeights = buildFlexWeights(
                    selectedIndex < 0 ? 2 : selectedIndex,
                    _Filtros.length,
                  );

                  return CarouselView.weighted(
                    flexWeights: flexWeights,
                    consumeMaxWeight: false,
                    onTap: (value) {
                      final filtro = _Filtros[value];
                      controller.changeFilter(filtro);
                    },
                    children: List.generate(_Filtros.length, (index) {
                      final filtro = _Filtros[index];
                      final bool isSelected =
                          controller.selectedFilter.value == filtro;

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.blueAccent
                              : Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: Colors.blueAccent.withOpacity(0.5),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : [],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          filtro.toUpperCase(),
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.white70,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: isSelected ? 16 : 13,
                          ),
                        ),
                      );
                    }),
                  );
                }),
              ),
            ),

            Expanded(child: ListView(children: controller.selectedItems)),
          ],
        );
      }),
    );
  }
}
