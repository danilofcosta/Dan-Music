import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../models/song.dart';
import '../base.dart';
import 'album_controller.dart';

class AlbumScreen extends StatelessWidget {
  const AlbumScreen({super.key});
  static const routeName = '/album';

  @override
  Widget build(BuildContext context) {
    final tag = hashCode.toString();

    final controller = (Get.isRegistered<AlbumController>(tag: tag))
        ? Get.find<AlbumController>(tag: tag)
        : Get.put(AlbumController(), tag: tag);

    return Obx(() {
      final album = controller.album.value;

      final thumb = album.thumbnails!.last.url;
      final title = album.title;
      final description = album.description;
      final List<Song>? tracks = album.tracks;
      final List? relatedRecommendations = album.relatedRecommendations;

      return BaseScreen(
        thumb: thumb,
        title: title,
        description: description,
        tracks: tracks ?? [],
        relatedRecommendations: relatedRecommendations ,
      );
    });
  }
}
