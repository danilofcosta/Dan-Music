import 'package:danmusic/ui/widgets/cards/song_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/song.dart';
import 'current_playlist_controller.dart';

class CurrentPlaylist extends GetView<CurrentPlaylistController> {
  const CurrentPlaylist({super.key});
  static const String routeName = '/current_playlist';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tocando Agora ',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: Obx(() {
        final playlist = controller.playlist;

        if (playlist.isEmpty) {
          return const Center(child: Text('No songs in the playlist'));
        }

        return ListView.builder(
          itemCount: playlist.length,
          itemBuilder: (context, index) {
            final item = playlist[index];
            return SongCard(
              song: Song.fromMediaItem(item),
              onTap: () => controller.ontap(index),
            );
          },
        );
      }),
    );
  }
}
