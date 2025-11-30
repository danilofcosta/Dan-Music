import 'package:danmusic/models/album.dart';
import 'package:danmusic/services/uteis/load_image.dart';
import 'package:flutter/material.dart';

class AlbumCard extends StatelessWidget {
  final Album album;
  const AlbumCard({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
    );
  }
}
