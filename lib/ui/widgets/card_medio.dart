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

        switch (object) {
          case ArtistDetail _:
            final artist = object as ArtistDetail;
            Get.toNamed(RouteName.artist, arguments: [artist.browseId, artist]);
            break;

          case Album _:
            final album = object as Album;
            Get.toNamed(RouteName.album, arguments: [album.albumId, album]);
            break;
          default:
            print('CardMedio não implementado');
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
                Text(
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
              ],
            ],
          ],
        ),
      ),
    );
  }
}
