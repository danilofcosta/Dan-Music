import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../services/manager_audio/audio_handler.dart'
    show MyAudioHandler;

class AnimatedPlayButton extends StatelessWidget {
  final double iconSize;
  const AnimatedPlayButton({super.key, this.iconSize = 20});

  @override
  Widget build(BuildContext context) {
    final player = Get.find<MyAudioHandler>().player;

    return StreamBuilder<PlayerState>(
      stream: player.playerStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        final isPlaying = state?.playing ?? false;
        final processingState = state?.processingState;

        final isLoadingState = processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering;

        return GestureDetector(
          onTap: () {
            if (isPlaying) {
              player.pause();
            } else {
              player.play();
            }
          },
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Container(
              key: ValueKey(
                isLoadingState
                    ? 'loading'
                    : isPlaying
                        ? 'pause'
                        : 'play',
              ),
              width: iconSize + 20,
              height: iconSize + 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Center(
                child: isLoadingState
                    ? SizedBox(
                        width: iconSize * 0.6,
                        height: iconSize * 0.6,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                        ),
                      )
                    : Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        size: iconSize * 0.7,
                        color: Colors.black,
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
