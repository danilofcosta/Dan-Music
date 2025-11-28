import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import '/models/song.dart';
import '../../provaders/player_controller.dart';
import '/widgets/ui/text_conf_ui.dart';
import 'package:flutter/material.dart';

class SongUi extends StatelessWidget {
  final Song song;

  SongUi({super.key, required this.song});

  final audio = Get.find<AudioHandler>();
  final player = Get.find<PlayerController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        child: ListTile(
          selected: player.playNowId == song.videoid,

          onTap: () {
            int index = audio.queue.value
                .indexWhere((e) => e.id == song.videoid);

            if (index == -1) {
              audio.playMediaItem(
                MediaItem(
                  id: song.videoid,
                  title: song.title,
                  artUri: Uri.parse(song.thumbnails?.firstOrNull ?? ''),
                  artist: song.artist,
                  album: song.albumInfo?.albumName ?? '',
                ),
              );
              return;
            }

            audio.customAction("playByIndex", {"index": index});
          },

          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              song.thumbnails?.firstOrNull ?? '',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 50,
                height: 50,
                color: Colors.grey,
                child: const Icon(Icons.music_note, color: Colors.white),
              ),
            ),
          ),

          title: TextUi(
            song.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: player.playNowId == song.videoid
                  ? Theme.of(context).colorScheme.primary
                  : null,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: TextUi(song.artist ?? '')),
              TextUi(song.duration ?? ''),
            ],
          ),
        ),
      );
    });
  }
}
