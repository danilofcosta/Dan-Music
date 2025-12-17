import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:danmusic/services/manage_audio/audio_handler.dart';
import 'package:danmusic/ui/widgets/glass_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart' as rxdart;

import '../../../models/durationstate.dart';

Stream<PositionData> positionDataStream(MyAudioHandler handler) {
  return rxdart.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
    handler.positionStream,
    handler.positionBuffered,
    handler.durationStream,
    (position, buffered, duration) =>
        PositionData(position, buffered, duration ?? Duration.zero),
  );
}

BoxDecoration videoLikeDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(24),
  gradient: const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
  ),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.6),
      blurRadius: 30,
      spreadRadius: 5,
      offset: const Offset(0, 12),
    ),
    BoxShadow(
      color: Colors.blueAccent.withOpacity(0.15),
      blurRadius: 60,
      spreadRadius: -10,
    ),
  ],
);

class MusicProgressBar extends StatelessWidget {
  const MusicProgressBar({super.key});

  String _format(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final audioHandler = Get.find<MyAudioHandler>();

    return StreamBuilder<PositionData>(
      stream: positionDataStream(audioHandler),
      builder: (context, snapshot) {
        final data =
            snapshot.data ??
            PositionData(Duration.zero, Duration.zero, Duration.zero);

        final durationMs = data.duration.inMilliseconds
            .clamp(1, double.infinity)
            .toDouble();

        final positionMs = data.position.inMilliseconds
            .clamp(0, durationMs.toInt())
            .toDouble();

        final bufferedMs = data.bufferedPosition.inMilliseconds
            .clamp(0, durationMs.toInt())
            .toDouble();

        return GlassBox(
          child: Column(
            children: [
              Slider(
                min: 0,
                max: durationMs,
                value: positionMs,
                secondaryTrackValue: bufferedMs,
                onChanged: (_) {},
                onChangeEnd: (value) {
                  audioHandler.seek(Duration(milliseconds: value.toInt()));
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Text(
                    _format(data.position),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    _format(data.duration - data.position),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    _format(data.duration),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
