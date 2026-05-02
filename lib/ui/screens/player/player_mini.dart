import 'package:danmusic/ui/screens/player/player_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/uteis/load_image.dart';
import 'widgets_player/animated_play_button.dart';

class PlayerMini extends StatelessWidget {
  const PlayerMini({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PlayerController>();

    return Obx(() {
      final song = controller.songNow.value;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).cardColor.withValues(alpha: 0.5),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: controller.setMaxplayer,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: LoadImage.loadWidget(
                    song.artUri.toString(),
                    fit: BoxFit.cover,
                    errorBuildericon: Icons.music_note,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: InkWell(
                onTap: controller.setMaxplayer,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      song.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      song.artist ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 8),

            AnimatedPlayButton(iconSize: 26),
          ],
        ),
      );
    });
  }
}
