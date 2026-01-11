import 'package:danmusic/models/artist.dart';
import 'package:flutter/material.dart';
import 'package:danmusic/models/search/search_album.dart';
import 'package:get/get.dart';

import '../../../models/album.dart';
import '../../../navigation.dart';
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
      onTap: () {
        final albumNew = Album(
          albumId: album.browseId,
          thumbnails: album.thumbnails,
          title: album.title,
          artist: ArtistBasic(name:' album.artist'
          , id: 'album.browseId'),
          year: album.year,
        );

        Get.toNamed(RouteName.album, arguments: [album.browseId, albumNew]);
      },
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
