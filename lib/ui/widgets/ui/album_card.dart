import 'package:danmusic/navigator.dart';
import 'package:danmusic/services/uteis/load_image.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import '../../../models/album.dart';

class AlbumCard extends StatelessWidget {
  final Album album;
  const AlbumCard({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(
          ScreenNavigationSetup.albumScreen,
          id: ScreenNavigationSetup.id,
          arguments: [album, album.playlistId],
        );
      },
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: LoadImage.loadWidget(
            album.thumbnails.first,
            width: 50,
            height: 50,
            errorBuildericon: Icons.album,
          ),
        ),
        title: Text(album.name),
        subtitle: Text(album.artist),

        trailing: IconButton(onPressed: () {}, icon: const Icon(Icons.album)),
      ),
    );
  }
}
