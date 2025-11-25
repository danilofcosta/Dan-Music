import 'dart:async';
import '/services/format_duration.dart';
import '/services/globais_vars.dart';
import 'package:flutter/material.dart';

class SliderTemp extends StatefulWidget {
  const SliderTemp({super.key});

  @override
  State<SliderTemp> createState() => _SliderTempState();
}

class _SliderTempState extends State<SliderTemp> {
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  Duration _buffered = Duration.zero;

  late final StreamSubscription _positionSub;
  late final StreamSubscription _durationSub;
  late final StreamSubscription _bufferedSub;

  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    _positionSub = audioHandler.positionStream.listen((pos) {
      if (!mounted) return;
      setState(() => _position = pos);
    });

    _durationSub = audioHandler.durationStream.listen((dur) {
      if (!mounted) return;
      setState(() {
        _duration = dur ?? Duration.zero;
        if (_duration == Duration.zero) {
          _position = Duration.zero;
          _buffered = Duration.zero;
        }
      });
    });

    _bufferedSub = audioHandler.positionBuffered.listen((buf) {
      if (!mounted) return;
      setState(() => _buffered = buf);
    });
  }

  @override
  void dispose() {
    _positionSub.cancel();
    _durationSub.cancel();
    _bufferedSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double durationMs = _duration.inMilliseconds.toDouble().clamp(
      1.0,
      double.infinity,
    );
    final double positionMs = _position.inMilliseconds.toDouble().clamp(
      0.0,
      durationMs,
    );
    final double bufferedMs = _buffered.inMilliseconds.toDouble().clamp(
      0.0,
      durationMs,
    );

    if (_duration == Duration.zero) {
      return Container(
        margin: const EdgeInsets.all(12),
        child: LinearProgressIndicator(
          minHeight: 8,
          valueColor: AlwaysStoppedAnimation(
            Theme.of(context).colorScheme.primary,
          ),
          backgroundColor: Theme.of(
            context,
          ).colorScheme.onSurface.withValues(alpha: 0.2),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(12),
      child: Column(
        children: [
          Slider(
            year2023: false,
            value: positionMs,
            min: 0,
            max: durationMs,
            secondaryTrackValue: bufferedMs,
            onChanged: (value) async {
              audioHandler.seek(Duration(milliseconds: value.toInt()));
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatDuration(_position),
                strutStyle: const StrutStyle(
                  height: 1.5,
                  fontWeight: FontWeight.bold,
                ),
                //   style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                formatDuration(_duration),
                strutStyle: const StrutStyle(
                  height: 1.5,
                  fontWeight: FontWeight.bold,
                ),
                //    style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
