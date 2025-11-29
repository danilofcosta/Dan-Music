import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../provaders/player_controller.dart';
import '/services/uteis/load_image.dart';
import '../../../services/uteis/helper.dart';

class BuildCover extends StatelessWidget {
  const BuildCover({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PlayerController>();
    final size = MediaQuery.of(context).size;

    return Obx(() {
      MediaItem? mediaItemNow = controller.songNow.value;

      printInfoDebug(mediaItemNow?.extras.toString());
      // bool istop=mediaItemNow.extras.containsKey('isTop')??false;
      bool istop = false;

      // Tem capa?
      final hasCover =
          mediaItemNow?.artUri != null &&
          mediaItemNow!.artUri.toString().isNotEmpty;

      if (hasCover) {
        return Card(
          elevation: 8.0,
          child: Container(
            width: size.width * 0.8,
            height: size.width * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                fit: BoxFit.contain,
                image:
                    LoadImage.loadProvider(mediaItemNow!.artUri.toString())
                        as ImageProvider,
              ),
            ),
          ),
        );
      }

      /// Sem capa → placeholder
      return Container(
        width: size.width * 0.8,
        height: size.width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Theme.of(
            context,
          ).scaffoldBackgroundColor.withValues(alpha: 0.6),
        ),
        child: Center(
          child: Icon(
            Icons.music_note_outlined,
            size: size.width * 0.4,
            color: Colors.white,
          ),
        ),
      );
    });
  }
}
