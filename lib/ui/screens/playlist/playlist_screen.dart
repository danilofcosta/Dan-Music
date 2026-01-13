import 'package:danmusic/ui/screens/base.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/ui/screens/playlist/playlist_controller.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({super.key});
  static const routeName = '/playlist';
@override
  Widget build(BuildContext context) {
    final tag = hashCode.toString();

    final controller = (Get.isRegistered<PlaylistController>(tag: tag))
        ? Get.find<PlaylistController>(tag: tag)
        : Get.put(PlaylistController(), tag: tag);

    return Obx(() {
      final playlist = controller.playlist.value;
      final playlistFull = controller.playlistfull.value;

      final thumb = playlist.thumbnails?.last.url ?? '';
      final title = playlist.title;
      final description = playlistFull.description;
      final tracks = playlistFull.tracks ?? [];
      final relatedRecommendations = playlistFull.releted;

      return BaseScreen(
        thumb: thumb,
        title: title,
        description: description,
        tracks: tracks,
        relatedRecommendations: relatedRecommendations,
      );
    });
  }
}
