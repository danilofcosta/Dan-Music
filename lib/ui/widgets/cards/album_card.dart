import 'package:flutter/material.dart';
import 'package:danmusic/models/search/search_album.dart';

import '../../../services/uteis/load_image.dart';

class AlbumCard extends StatelessWidget {
  final SearchAlbum album;
  const AlbumCard({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    final thumb = album.thumbnails?.isNotEmpty == true
        ? album.thumbnails!.first.url
        : null;
    return ListTile(
      leading: thumb != null
          ? LoadImage.loadWidget(
              thumb,
              width: 48.0,
              height: 48.0,
              errorBuildericon: Icons.album,
            )
          : const Icon(Icons.album),
      title: Text(album.title, maxLines: 1),
      subtitle: (album.artist ?? album.year) == null
          ? null
          : Text(
              [
                if (album.artist != null) album.artist,
                if (album.year != null) album.year,
              ].join(' • '),
            ),
    );
  }
}
