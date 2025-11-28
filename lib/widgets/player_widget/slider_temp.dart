import 'package:danmusic/models/durationstate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../provaders/player_controller.dart';

class MusicProgressBar extends StatelessWidget {
  const MusicProgressBar({super.key});

  String _format(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PlayerController>();

    return Obx(() {
      final state = controller.progressBarStatus.value;
      final double durationMs = state.total.inMilliseconds.toDouble().clamp(
        1.0,
        double.infinity,
      );
      final double positionMs = state.current.inMilliseconds.toDouble().clamp(
        0.0,
        durationMs,
      );
      final double bufferedMs = state.buffered.inMilliseconds.toDouble().clamp(
        0.0,
        durationMs,
      );
      //  debugPrint(positionMs.toString());

      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// Slider de progresso
          Slider(
          value: positionMs,
            min: 0,
            max: durationMs,
            year2023: false,

            /// Seek na música
            onChanged: (value) {
              debugPrint(value.toString());
              // controller.audioHandler.seek(
              //   Duration(milliseconds: value.toInt()),
              // );
            },
            onChangeEnd: (value) {
              controller.audioHandler.seek(
                Duration(milliseconds: value.toInt()),
              );
            },
            secondaryTrackValue: bufferedMs,
          ),

          /// Tempo atual / total
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_format(state.current)),
                Text(_format(state.total)),
              ],
            ),
          ),
        ],
      );
    });
  }
}
