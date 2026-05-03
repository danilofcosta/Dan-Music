import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/song.dart';
import 'home_screen_controller.dart';
import '../../widgets/list_horizontal/buid_list_horizotal.dart';
import '../../widgets/list_horizontal/buid_list_horizotal_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = Get.find<HomeScreenController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.grey.shade900,
            Colors.black,
          ],
        ),
      ),
      child: SafeArea(
        child: Obx(() {
          return CustomScrollView(
            slivers: [
              // App Bar com greeting
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                pinned: true,
                title: Obx(() => Text(
                  controller.greeting.value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                )),
              ),

              // Loading state
              if (controller.homeSection.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                    ),
                  ),
                ),

              // Seções da home
              ...controller.homeSection.map<Widget>((section) {
                // Seção só de músicas
                final songs = section.contents.whereType<Song>().toList();
                if (songs.isNotEmpty) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            section.title.toUpperCase(),
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 12),
                          BuidListHorizotal(
                            title: section.title,
                            songs: songs,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // Seção mista (álbum, artista, playlist, etc)
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          section.title.toUpperCase(),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        BuidListHorizotalCard(
                          title: section.title,
                          list: section.contents,
                        ),
                      ],
                    ),
                  ),
                );
              }),

              // Espaço inferior para o mini player
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          );
        }),
      ),
    );
  }
}
