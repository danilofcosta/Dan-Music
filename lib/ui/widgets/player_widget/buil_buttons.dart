import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';

import '../../../services/manage_audio/audio_handler.dart';
import '../../screens/player_page/player_controller.dart';
import 'package:flutter/material.dart';

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

          // StreamBuilder<bool>(
          //   stream: audioHandler.isPlayingStream,
          //   builder: (context, snapshot) {
          //     final isPlaying = snapshot.data ?? false;
          //     return FilledButton.icon(
          //       onPressed: () {
          //         isPlaying ? audioHandler.pause() : audioHandler.play();
          //       },

          //       label: isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
          //     );
          //   },
          // )
          // FilledButton.icon(
          //   onPressed: () => audioHandler.play(),
          //   label: Icon(Icons.play_arrow),

          // ),
          AnimatedPlayButton(iconSize: 42),
          FilledButton.icon(
            onPressed: () => audioHandler.skipToNext(),
            label: Icon(Icons.skip_next),
          ),
          // FilledButton(
          //   onPressed: () => audioHandler.shuffle(),
          //   child: Icon(Icons.shuffle),
          // ),
        ],
      ),
    );
  }
}

class AnimatedPlayButton extends StatefulWidget {
  /// size of the icon.
  final double iconSize;

  const AnimatedPlayButton({super.key, this.iconSize = 40.0});

  @override
  State<AnimatedPlayButton> createState() => _AnimatedPlayButtonState();
}

class _AnimatedPlayButtonState extends State<AnimatedPlayButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetX<PlayerController>(
      builder: (controller) {
        final buttonState = controller.buttonState.value;
        final isPlaying = buttonState == PlayButtonState.playing;
        final isLoading = buttonState == PlayButtonState.loading;

        if (isPlaying) {
          _controller.forward();
        } else if (!isLoading) {
          _controller.reverse();
        }

        return IconButton(
          iconSize: widget.iconSize,
          onPressed: () {
            isPlaying ? controller.pause() : controller.play();
          },
          icon: isLoading
              ? const CircularProgressIndicator()
              : AnimatedIcon(
                  icon: AnimatedIcons.play_pause,
                  progress: _controller,
                ),
        );
      },
    );
  }
}
