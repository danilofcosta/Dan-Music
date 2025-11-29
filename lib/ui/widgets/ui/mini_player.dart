import 'package:audio_service/audio_service.dart';
import 'package:danmusic/navigator.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../provaders/player_controller.dart';
import '/services/uteis/load_image.dart';
import 'text_conf_ui.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PlayerController>();
    final audioHandler = Get.find<AudioHandler>();

    return Obx(() {
      MediaItem? mediaItemNow = controller.songNow.value;

      return AnimatedContainer(
        // margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Theme.of(
            context,
          ).scaffoldBackgroundColor.withValues(alpha: 0.6),
        ),
        child: ListTile(
          onTap: () {
            Get.toNamed(
              ScreenNavigationSetup.playerScreen,
              id: ScreenNavigationSetup.id,
            );
          },

          /// CAPA DO ÁLBUM
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: LoadImage.loadWidget(
              mediaItemNow?.artUri?.toString() ?? '',
              width: 50,
              height: 50,
              errorBuildericon: Icons.music_note_outlined,
            ),
          ),

          /// TÍTULO
          title: TextUi(
            mediaItemNow?.title ?? '',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),

          /// ARTISTA
          subtitle: TextUi(mediaItemNow?.artist ?? ''),

          /// BOTÃO NEXT
          trailing: IconButton(
            icon: const Icon(Icons.skip_next),
            onPressed: () => audioHandler.skipToNext(),
          ),
        ),
      );
    });
  }
}
