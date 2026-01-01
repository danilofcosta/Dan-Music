import 'package:audio_service/audio_service.dart';
import 'package:danmusic/services/manager_audio/audio_handler.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';

import 'animated_play_button.dart';

class BuilButtons extends StatelessWidget {
  const BuilButtons({super.key});

  @override
  Widget build(BuildContext context) {
    AudioHandler audioHandler = Get.find<MyAudioHandler>();

    return Container(
      margin: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 12,
        children: [
          FilledButton.icon(
            onPressed: () => audioHandler.skipToPrevious(),
            label: Icon(Icons.skip_previous),
          ),

          AnimatedPlayButton(iconSize: 42),
          FilledButton.icon(
            onPressed: () => audioHandler.skipToNext(),
            label: Icon(Icons.skip_next),
          ),
       
        ],
      ),
    );
  }
}



