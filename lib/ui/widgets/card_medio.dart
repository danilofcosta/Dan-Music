import 'package:danmusic/models/playlist.dart';
import 'package:danmusic/models/search/search_album.dart';
import 'package:danmusic/models/search/search_playlist.dart';
import 'package:danmusic/services/uteis/helper.dart';
import 'package:danmusic/services/uteis/load_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/album.dart';
import '../../models/artist.dart';
import '../../navigation.dart';

class CardMedio extends StatelessWidget {
  final Object? object;
  final String image;
  final String title;
  final String subtitle;

  const CardMedio({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    this.object,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        printErrorDebug('$object  ${object.runtimeType}');
        if (object == null) return;
        printInfoDebug(object.toString());

        switch (object) {
          case ArtistDetail _:
            final artist = object as ArtistDetail;
            Get.toNamed(
              RouteName.artist,
              arguments: [artist.browseId, artist],
              preventDuplicates: false,
            );
            break;

          case Album _:
            final album = object as Album;
            printInfoDebug(album.albumId);
            Get.toNamed(
              RouteName.album,
              arguments: [album.albumId, album],
              preventDuplicates: false,
            );

            break;
          case Playlist _:
            final playlist = object as Playlist;
            Get.toNamed(
              RouteName.playlist,
              arguments: [playlist.browseId, playlist],
              preventDuplicates: false,
            );
            break;

          case SearchAlbum _:
            final searchAlbum = object as SearchAlbum;
            // Converte SearchAlbum para Album para compatibilidade se necessário
            final album = Album(
              albumId: searchAlbum.browseId,
              title: searchAlbum.title,
              thumbnails: searchAlbum.thumbnails,
              year: searchAlbum.year,
            );
            Get.toNamed(RouteName.album, arguments: [album.albumId, album]);
            break;

          case SearchPlaylist _:
            final searchPlaylist = object as SearchPlaylist;
            final playlist = Playlist(
              browseId: searchPlaylist.browseId,
              title: searchPlaylist.title,
              thumbnails: searchPlaylist.thumbnails,
            );
            Get.toNamed(
              RouteName.playlist,
              arguments: [playlist.browseId, playlist],
            );
            break;

          default:
            printErrorDebug(
              'CardMedio não implementado para o tipo: ${object.runtimeType}',
            );
            break;
        }
      },
      child: Container(
        width: 130,

        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 100,
                height: 100,
                child: LoadImage.loadWidget(
                  image,
                  fit: BoxFit.cover,
                  errorBuildericon: Icons.person,
                ),
              ),
            ),
            const SizedBox(height: 8),
            if (title.isNotEmpty || subtitle.isNotEmpty) ...[
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              if (subtitle.isNotEmpty) ...[
                Expanded(
                  child: Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
