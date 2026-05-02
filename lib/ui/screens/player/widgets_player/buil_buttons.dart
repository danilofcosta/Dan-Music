import 'package:danmusic/services/manager_audio/audio_handler.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'animated_play_button.dart';

class BuilButtons extends StatelessWidget {
  const BuilButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final audioHandler = Get.find<MyAudioHandler>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => audioHandler.skipToPrevious(),
          icon: const Icon(Icons.skip_previous_rounded),
          iconSize: 36,
          color: Colors.white70,
        ),

        const SizedBox(width: 24),

        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.3),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: AnimatedPlayButton(iconSize: 48),
        ),

        const SizedBox(width: 24),

        IconButton(
          onPressed: () => audioHandler.skipToNext(),
          icon: const Icon(Icons.skip_next_rounded),
          iconSize: 36,
          color: Colors.white70,
        ),
      ],
    );
  }
}



