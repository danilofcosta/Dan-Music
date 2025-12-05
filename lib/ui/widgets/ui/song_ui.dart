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
  final Function()? onTap;

  SongUi({super.key, this.song, this.mediaItem, this.onTap})
    : assert(
        song != null || mediaItem != null,
        "SongUi precisa de song ou mediaItem!",
      );

  final audio = Get.find<AudioHandler>();
  final player = Get.find<PlayerController>();

  // GETTERS unificam o uso
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
      return InkWell(
        onTap: () {
          if (onTap != null) {
            onTap!();
            return;
          }

          Get.find<PlayerController>().playByVideoId(id);
        },
        child: ListTile(
          selected: player.songNow.value?.id == id,

          leading: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LoadImage.loadWidget(
                  thumbnail,
                  width: 50,
                  height: 50,
                  errorBuildericon: Icons.music_note,
                ),
              ),

              if (player.songNow.value?.id == id)
                Container(
                  width: 50,
                  height: 50,
                  color: Colors.black54,

                  child: Icon(
                    Icons.play_circle_outline_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: 50,
                  ),
                ),
            ],
          ),

          title: TextUi(
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
