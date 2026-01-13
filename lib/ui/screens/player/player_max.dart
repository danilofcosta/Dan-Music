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
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // Header
            Row(
              children: [
                IconButton(
                  onPressed: controller.setminplayer,
                  icon: const Icon(Icons.keyboard_arrow_down),
                ),

                // Área central que pode encolher
                Expanded(
                  child: Obx(() {
                    return Text(
                      controller.songNow.value.album ?? 'sem album',
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(fontSize: 12),
                    );
                  }),
                ),

                IconButton(
                  onPressed: controller.setminplayer,
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),

            Spacer(),

            BuildCover(),

            const SizedBox(height: 12),

            BulidText(),

            const SizedBox(height: 8),

            MusicProgressBar(),

            const SizedBox(height: 12),

            BuilButtons(),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Spacer(),
                  FloatingActionButton(
                    heroTag: null,

                    onPressed: () {
                      Get.toNamed(
                        RouteName.currentPlaylist,

                        preventDuplicates: false,
                      );
                    },
                    child: const Icon(Icons.playlist_play_outlined),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
