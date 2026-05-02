import 'dart:async';
import 'package:danmusic/services/manager_audio/audio_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../player_controller.dart';

class MusicProgressBar extends StatefulWidget {
  const MusicProgressBar({super.key});

  @override
  State<MusicProgressBar> createState() => _MusicProgressBarState();
}

class _MusicProgressBarState extends State<MusicProgressBar> {
  late StreamSubscription<Duration> _positionSub;
  late StreamSubscription<Duration> _bufferSub;
  late StreamSubscription<Duration?> _durationSub;
  final controller = Get.find<PlayerController>();
  MyAudioHandler get player => controller.audioHandler;

  Duration _position = Duration.zero;
  Duration _buffer = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();

    _positionSub = player.positionStream.listen((pos) {
      setState(() {
        _position = pos;
      });
    });

    _bufferSub = player.positionBuffered.listen((buf) {
      setState(() {
        _buffer = buf;
      });
    });

    _durationSub = player.durationStream.listen((dur) {
      if (dur != null) {
        setState(() {
          _duration = dur;
        });
      }
    });
  }

  @override
  void dispose() {
    _positionSub.cancel();
    _bufferSub.cancel();
    _durationSub.cancel();
    super.dispose();
  }

  String _format(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final positionMs = _position.inMilliseconds.toDouble();
    final bufferMs = _buffer.inMilliseconds.toDouble();
    final durationMs = _duration.inMilliseconds.toDouble() == 0
        ? 1
        : _duration.inMilliseconds.toDouble();

    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.white,
            inactiveTrackColor: Colors.white24,
            secondaryActiveTrackColor: Colors.white38,
            thumbColor: Colors.white,
            overlayColor: Colors.white.withValues(alpha: 0.2),
            trackHeight: 2.0,
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 6,
            ),
          ),
          child: Slider(
            value: positionMs.clamp(0, durationMs).toDouble(),
            min: 0,
            max: durationMs.toDouble(),
            onChanged: (_) {},
            secondaryTrackValue: bufferMs.clamp(0, durationMs).toDouble(),
            onChangeEnd: (value) {
              player.seek(Duration(milliseconds: value.toInt()));
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _format(_position),
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
              ),
              Text(
                _format(_duration),
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
