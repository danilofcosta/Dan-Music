import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../screens/player_page/player_controller.dart';

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

      final durationMs = state.total.inMilliseconds
          .clamp(1, double.infinity)
          .toDouble();

      /// Arredonda a posição para 200ms → evita tremidos
      final positionMs = ((state.current.inMilliseconds / 200).round() * 200)
          .clamp(0, durationMs)
          .toDouble();

      final bufferedMs = state.buffered.inMilliseconds
          .clamp(0, durationMs)
          .toDouble();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Slider(
            value: positionMs,
          //  year2023: false,
            min: 0,
            max: durationMs,
            padding: EdgeInsetsGeometry.all(10),

            /// Quando arrastar
            onChanged: (value) {},

            /// Quando soltar
            onChangeEnd: (value) {
              controller.audioHandler.seek(
                Duration(milliseconds: value.toInt()),
              );
            },

            secondaryTrackValue: bufferedMs,
            focusNode: FocusNode(skipTraversal: true),
            label: 'slider ',
            allowedInteraction: SliderInteraction.tapOnly,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _format(state.current),
                  style: TextStyle(fontWeight: .bold),
                ),
                Text(_format(state.total), style: TextStyle(fontWeight: .bold)),
              ],
            ),
          ),
        ],
      );
    });
  }
}
