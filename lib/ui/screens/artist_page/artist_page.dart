import 'package:danmusic/ui/screens/artist_page/artist_controller.dart'
    show ArtistController;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/uteis/load_image.dart';

class ArtistPage extends StatelessWidget {
  const ArtistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final controller = Get.find<ArtistController>();
      return Scaffold(
        // appBar: AppBar(
        //   title: Text('${controller.artistBase.value.artistName} vbn'),
        // ),
        body: CustomScrollView(
          slivers: [
            SliverLayoutBuilder(
              builder: (context, constraints) {
                // Se altura está colapsada → mostra Title normal
                final isCollapsed = constraints.scrollOffset > 250;

                return SliverAppBar(
                  expandedHeight: 350,
                  pinned: true,
                  title: isCollapsed
                      ? Text(controller.artistBase.value.artistName)
                      : null, // Título só quando colapsado

                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    // título some ao colapsar
                    title: !isCollapsed
                        ? Text(controller.artistBase.value.artistName)
                        : null,
                    background: LoadImage.loadWidget(
                      controller.artistBase.value.thumbnail ?? '',
                      height: 200,
                      fit: BoxFit.cover,
                      width: double.maxFinite,
                    ),
                  ),
                );
              },
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      controller.artistBase.value.artistName,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ],
                ),
              ),
            ),
            SliverFillRemaining(),
          ],
        ),
      );
    });
  }
}
