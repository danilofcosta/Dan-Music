import '/services/globais_vars.dart';
import 'package:flutter/material.dart';

class BuilButtons extends StatelessWidget {
  const BuilButtons({super.key});

  @override
  Widget build(BuildContext context) {
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

          StreamBuilder<bool>(
            stream: audioHandler.isPlayingStream,
            builder: (context, snapshot) {
              final isPlaying = snapshot.data ?? false;
              return FilledButton.icon(
                onPressed: () {
                  isPlaying ? audioHandler.pause() : audioHandler.play();
                },

                label: isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
              );
            },
          ),

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
