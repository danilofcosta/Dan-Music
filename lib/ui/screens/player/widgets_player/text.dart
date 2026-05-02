import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../player_controller.dart' show PlayerController;

class BulidText extends StatelessWidget {
  const BulidText({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PlayerController>();

    return Obx(() {
      final mediaItemNow = controller.songNow.value;

      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            mediaItemNow.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          if (mediaItemNow.artist != null)
            Text(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              mediaItemNow.artist!,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
        ],
      );
    });
  }
}
