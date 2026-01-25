import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../services/manager_audio/audio_handler.dart'
    show MyAudioHandler;
class AnimatedPlayButton extends StatelessWidget {
  final double iconSize;
  const   AnimatedPlayButton({super.key, this.iconSize = 20});

  @override
  Widget build(BuildContext context) {
    final player = Get.find<MyAudioHandler>().player;

    return StreamBuilder<PlayerState>(
      stream: player.playerStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        final isPlaying = state?.playing ?? false;
        final processingState = state?.processingState;

        Widget icon;

        if (processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          icon = SizedBox(
            width: iconSize,
            height: iconSize,
            child: const CircularProgressIndicator(strokeWidth: 2),
          );
        } else {
          icon = Icon(
            isPlaying ? Icons.pause : Icons.play_arrow,
            size: iconSize,
          );
        }

        return GestureDetector(
          onTap: () {
            if (isPlaying) {
              player.pause();
            } else {
              player.play();
            }
          },
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Container(
              key: ValueKey(
                processingState == ProcessingState.loading ||
                        processingState == ProcessingState.buffering
                    ? 'loading'
                    : isPlaying
                        ? 'pause'
                        : 'play',
              ),
              child: icon,
            ),
          ),
        );
      },
    );
  }
}
