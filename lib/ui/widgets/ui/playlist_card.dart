import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/playlist.dart';
import '../../../navigator.dart';
import '../../../services/uteis/load_image.dart';

class PlaylistCard extends StatelessWidget {
  final Playlist playlist;
  const PlaylistCard({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(
          ScreenNavigationSetup.playlistScreen,
          id: ScreenNavigationSetup.id,
          arguments: [playlist, playlist.playlistId],
        );
      },
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: LoadImage.loadWidget(
            playlist.thumbnails.first,
            width: 50,
            height: 50,
            errorBuildericon: Icons.playlist_play,
          ),
        ),
        title: Text(playlist.title),
        subtitle: Text(playlist.desciption),
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.playlist_play),
        ),
      ),
    );
  }
}
