import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import '/models/song.dart';
import '../../screens/player_page/player_controller.dart';
import 'text_conf_ui.dart';
import 'package:flutter/material.dart';

import '../../../services/uteis/load_image.dart';

class SongUi extends StatelessWidget {
  final Song? song;
  final MediaItem? mediaItem;
  final int? index;
  final Function()? onTap;

  SongUi({super.key, this.song, this.mediaItem, this.onTap, this.index})
    : assert(
        song != null || mediaItem != null,
        "SongUi precisa de song ou mediaItem!",
      );

  String get id => song?.videoid ?? mediaItem?.id ?? "";
  String get title => song?.title ?? mediaItem?.title ?? "";
  String get artist => song?.artist ?? mediaItem?.artist ?? "";
  String? get duration => durationToString();
  String get album => song?.albumInfo?.albumName ?? mediaItem?.album ?? "";
  String get thumbnail =>
      song?.thumbnails?.firstOrNull ?? mediaItem?.artUri.toString() ?? "";

  String? durationToString() {
    if (song != null) return song?.duration ?? "";

    if (mediaItem?.duration != null) {
      Duration? duration = mediaItem!.duration;

      final minutes = duration!.inMinutes
          .remainder(60)
          .toString()
          .padLeft(2, '0');
      final seconds = duration.inSeconds
          .remainder(60)
          .toString()
          .padLeft(2, '0');
      return "$minutes:$seconds";
    }
    if (mediaItem?.duration == null) {
      return '';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final player = Get.find<PlayerController>();

      return InkWell(
        onTap: () {
          if (onTap != null) {
            onTap!();
            return;
          }

          player.playByVideoId(id);
        },
        child: ListTile(
          selected: player.songNow.value?.id == id,

          leading: Stack(
            children: [
              index == null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LoadImage.loadWidget(
                        thumbnail,
                        width: 50,
                        height: 50,
                        errorBuildericon: Icons.music_note,
                      ),
                    )
                  : SizedBox(
                      width: 50,
                      height: 50,
                      child: Center(
                        child: TextUi(
                          index.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: player.songNow.value?.id == id
                                ? Theme.of(context).colorScheme.primary
                                : null,
                          ),
                        ),
                      ),
                    ),

              // if (player.songNow.value?.id == id)
              //   Container(
              //     width: 50,
              //     height: 50,
              //     color: Colors.black54,

              //     child: SpotifyFireEqualizer(),
              //   ),
            ],
          ),

          title: Row(
            spacing: 2,
            children: [
              Expanded(
                child: TextUi(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: player.songNow.value?.id == id
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              if (player.songNow.value?.id == id) SpotifyFireEqualizer(),
            ],
          ),

          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: TextUi(artist)),
              TextUi(duration!),
            ],
          ),
        ),
      );
    });
  }
}

class SpotifyFireEqualizer extends StatefulWidget {
  final Color color;
  final double height;
  final double width;
  final Duration speed;

  const SpotifyFireEqualizer({
    super.key,
    this.color = Colors.blue,
    this.height = 24,
    this.width = 4,
    this.speed = const Duration(milliseconds: 900),
  });

  @override
  State<SpotifyFireEqualizer> createState() => _SpotifyFireEqualizerState();
}

class _SpotifyFireEqualizerState extends State<SpotifyFireEqualizer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final List<double> _phases = [0, pi / 3, pi * 2 / 3];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.speed)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _barHeight(double phase) {
    // curva senoidal suave (0.3 → 1.0)
    final value = (sin(_controller.value * 2 * pi + phase) + 1) / 2;
    return 0.3 + value * 0.7;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(3, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Container(
                  width: widget.width,
                  height: widget.height * _barHeight(_phases[index]),
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
