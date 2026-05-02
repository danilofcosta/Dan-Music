import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '/services/uteis/load_image.dart';
import '../player_controller.dart' show PlayerController;

class BuildCover extends StatelessWidget {
  const BuildCover({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PlayerController>();
    final size = MediaQuery.of(context).size;

    return Obx(() {
      final mediaItemNow = controller.songNow.value;

      final hasCover =
          mediaItemNow.artUri != null &&
          mediaItemNow.artUri.toString().isNotEmpty;

      return Container(
        width: size.width * 0.85,
        height: size.width * 0.85,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: hasCover
              ? Image(
                  image: LoadImage.loadProvider(mediaItemNow.artUri.toString()) as ImageProvider,
                  fit: BoxFit.cover,
                )
              : Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.grey.shade800,
                        Colors.grey.shade900,
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.music_note_outlined,
                      size: 80,
                      color: Colors.white30,
                    ),
                  ),
                ),
        ),
      );
    });
  }
}
