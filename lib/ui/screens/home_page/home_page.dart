import 'package:danmusic/navigator.dart';
import 'package:danmusic/services/uteis/load_image.dart';
import 'package:danmusic/ui/widgets/ui/mini_player.dart';
import 'package:dart_ytmusic_api/types.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/buid_list_horizotal.dart';
import '../../widgets/build_backgrand.dart';
import '/ui/screens/home_page/home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return BuildBackgrand(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Theme.of(
                  context,
                ).scaffoldBackgroundColor.withAlpha(153),
                centerTitle: true,
                title: Text(
                  controller.welcomeMessage.value,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                floating: true,
                snap: true,
              ),

              if (controller.isLoading.value)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                )
              else if (controller.songsSuggestions.isNotEmpty)
                SliverToBoxAdapter(
                  child: BuildListHorizontal(
                    title: 'Sugestoes',
                    items: controller.songsSuggestions,
                  ),
                ),
              if (controller.homeSections.isNotEmpty)
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final section = controller.homeSections[index];
                    if (section.contents.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return buildSectionCarousel(section, context);
                  }, childCount: controller.homeSections.length),
                ),

              SliverFillRemaining(
                hasScrollBody: false,
                child: Container(height: 150),
              ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,

          floatingActionButton: Container(
            margin: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              spacing: 8,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    Get.toNamed(
                      ScreenNavigationSetup.searchScreen,
                      id: ScreenNavigationSetup.id,
                    );
                  },
                  child: const Icon(Icons.search),
                ),
                MiniPlayer(),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget buildSectionCarousel(HomeSection section, BuildContext context) {
    final String title = section.title;
    final double rIn = 8;
    final double paddingExt = 3;
    final List<dynamic> contents = section.contents;

    return Container(
      margin: EdgeInsets.all(paddingExt),
      padding: EdgeInsets.all(paddingExt),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(rIn + paddingExt),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.all(rIn),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200),
            child: CarouselView.weighted(
              flexWeights: const <int>[4, 3, 2],
              shrinkExtent: 8.0,
              elevation: 5,
              onTap: (value) => controller.openPage(contents[value]),

              // consumeMaxWeight: false,
              children: List.generate(contents.length, (i) {
                final sectionContent = contents[i];

                return Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: sectionContent.thumbnails.last.url != null

                            ? LoadImage.loadWidget(
                                sectionContent.thumbnails.last.url!,
                                fit: BoxFit.cover,
                                errorBuildericon: Icons.image,
                              )
                            : Container(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      sectionContent.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
