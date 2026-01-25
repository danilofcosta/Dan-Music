import 'package:audio_service/audio_service.dart';
import 'package:danmusic/services/uteis/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/song.dart';
import '../screens/player/player_controller.dart';
import '../screens/player/widgets_player/animated_play_button.dart';

class PlayPlaylistBt extends StatelessWidget {
  final List<Song> playlist;
  const PlayPlaylistBt({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    final PlayerController controller = Get.find<PlayerController>();

    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: StreamBuilder<List<MediaItem>>(
        stream: controller.audioHandler.queue,
        builder: (context, snapshot) {
          final List<MediaItem> queue = snapshot.data ?? [];

          final bool isCurrentPlaylist = _isCurrentPlaylist(queue);

          if (isCurrentPlaylist) {
            return const Padding(
              padding: EdgeInsets.all(8),
              child: AnimatedPlayButton(iconSize: 30),
            );
          }

          return IconButton(
            icon: const Icon(Icons.play_arrow, size: 30),
            onPressed: playlist.isEmpty
                ? null
                : () => controller.uploadQuere(playlist),
          );
        },
      ),
    );
  }

  bool _isCurrentPlaylist(List<MediaItem> queue) {
    if (queue.isEmpty || playlist.isEmpty) return false;
    return queue.first.id == playlist.first.id;
  }
}
