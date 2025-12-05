import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import '../ui/text_conf_ui.dart';
import 'package:flutter/material.dart';

import '../../screens/player_page/player_controller.dart';

class BulidText extends StatelessWidget {
  const BulidText({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PlayerController>();

    return Obx(() {
      MediaItem? mediaItemNow = controller.songNow.value  ;

      return Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Theme.of(context)
              .scaffoldBackgroundColor
              .withValues(alpha: 0.2),
        ),
        child: Column(
          children: [
            TextUi(
              mediaItemNow?.title ?? '',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .fontSize,
              ),
            ),

            if (mediaItemNow?.artist != null)
              TextUi(
                mediaItemNow!.artist!,
                style: TextStyle(
                  fontSize: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .fontSize,
                ),
              ),
          ],
        ),
      );
    });
  }
}
