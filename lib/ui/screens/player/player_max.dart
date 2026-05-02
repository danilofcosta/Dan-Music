import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../navigation.dart';
import 'widgets_player/buil_buttons.dart';
import 'widgets_player/build_cover.dart';
import 'player_controller.dart' show PlayerController;
import 'widgets_player/slider_temp.dart';
import 'widgets_player/text.dart';

class PlayerMax extends StatefulWidget {
  const PlayerMax({super.key});
  static const String routeName = '/playermax';

  @override
  State<PlayerMax> createState() => _PlayerMaxState();
}

class _PlayerMaxState extends State<PlayerMax> {
  final controller = Get.find<PlayerController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Obx(() {
      final song = controller.songNow.value;
      final hasArt = song.artUri != null && song.artUri.toString().isNotEmpty;

      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: hasArt
                  ? [Colors.grey.shade900, Colors.black]
                  : [
                      Theme.of(context).primaryColor.withValues(alpha: 0.3),
                      Colors.black,
                    ],
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
            child: SafeArea(
              child: Column(
                children: [
                  // Header with navigation
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: controller.setminplayer,
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            song.album != null
                                ? 'NOW PLAYING \n ${song.album} '
                                : 'NOW PLAYING',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            // TODO: Show options menu
                          },
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: size.height * 0.05),

                  // Cover Art with shadow
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: BuildCover(),
                  ),

                  const SizedBox(height: 32),

                  // Song Info
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: BulidText(),
                  ),

                  const Spacer(),

                  // Progress Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: MusicProgressBar(),
                  ),

                  const SizedBox(height: 16),

                  // Playback Controls
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: BuilButtons(),
                  ),

                  const SizedBox(height: 24),

                  // Playlist button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            // TODO: Add to favorites
                          },
                          icon: const Icon(
                            Icons.favorite_border,
                            color: Colors.white70,
                          ),
                        ),
                        FloatingActionButton.small(
                          heroTag: 'playermax',
                          backgroundColor: Colors.white24,
                          onPressed: () {
                            Get.toNamed(
                              RouteName.currentPlaylist,
                              preventDuplicates: false,
                            );
                          },
                          child: const Icon(
                            Icons.playlist_play_outlined,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            // TODO: Share
                          },
                          icon: const Icon(Icons.share, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
