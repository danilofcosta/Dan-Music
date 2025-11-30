import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import '../../../services/uteis/load_image.dart';
import '/models/song.dart';
import '../../../provaders/player_controller.dart';
import 'text_conf_ui.dart';
import 'package:flutter/material.dart';

class SongUi extends StatelessWidget {
  final Song? song;
  final MediaItem? mediaItem;

  SongUi({super.key, this.song, this.mediaItem})
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
      Duration? _duration = mediaItem!.duration;

      final minutes = _duration!.inMinutes
          .remainder(60)
          .toString()
          .padLeft(2, '0');
      final seconds = _duration!.inSeconds
          .remainder(60)
          .toString()
          .padLeft(2, '0');
      return "$minutes:$seconds";
    }
    if (mediaItem?.duration == null) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return InkWell(
        onTap: () {
          int index = audio.queue.value.indexWhere((e) => e.id == id);

          if (index == -1) {
            audio.playMediaItem(
              MediaItem(
                id: id,
                title: title,
                artUri: Uri.parse(thumbnail),
                artist: artist,
                album: album,
              ),
            );
            return;
          }

          audio.customAction("playByIndex", {"index": index});
        },

        child: ListTile(
          selected: player.playNowId == id,

          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LoadImage.loadWidget(
              thumbnail,
              width: 50,
              height: 50,
              errorBuildericon: Icons.music_note,
            ),
          ),

          title: TextUi(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: player.playNowId == id
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
