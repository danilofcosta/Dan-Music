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
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.grey.shade900,
              Colors.black,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Cover image
            GestureDetector(
              onTap: controller.setMaxplayer,
              child: Hero(
                tag: 'mini_cover',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: 48,
                    width: 48,
                    child: LoadImage.loadWidget(
                      song.artUri.toString(),
                      fit: BoxFit.cover,
                      errorBuildericon: Icons.music_note,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Title and artist
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
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    if (song.artist != null)
                      Text(
                        song.artist!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Play/Pause button
            AnimatedPlayButton(iconSize: 28),
          ],
        ),
      );
    });
  }
}
