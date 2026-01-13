import 'package:danmusic/models/artist.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../navigation.dart';
import '../../../services/uteis/load_image.dart';

class ArtistCard extends StatefulWidget {
  final ArtistDetail artist;
  const ArtistCard({super.key, required this.artist});

  @override
  State<ArtistCard> createState() => _ArtistCardState();
}

class _ArtistCardState extends State<ArtistCard> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Get.toNamed(
          RouteName.artist,
          arguments: [widget.artist.browseId, widget.artist],
        );
      },
      leading: CircleAvatar(
        backgroundImage: LoadImage.loadProvider(
          widget.artist.thumbnails.last.url,
        ),
      ),
      title: Text(
        widget.artist.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: widget.artist.subscribers == null
          ? null
          : Text(
              widget.artist.subscribers!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
    );
  }
}
