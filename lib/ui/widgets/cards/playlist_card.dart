import 'package:flutter/material.dart';
import 'package:danmusic/models/search/search_playlist.dart';

import '../../../services/uteis/load_image.dart' show LoadImage;

class PlaylistCard extends StatelessWidget {
  final SearchPlaylist playlist;
  const PlaylistCard({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    final thumb = playlist.thumbnails?.isNotEmpty == true
        ? playlist.thumbnails!.first.url
        : null;
    return ListTile(
      leading: thumb != null
          ? SizedBox(
              width: 56,
              height: 56,
              child: LoadImage.loadWidget(
                thumb,
                errorBuildericon: Icons.queue_music,
              ),
            )
          : const Icon(Icons.queue_music),
      title: Text(playlist.title),
      subtitle: (playlist.author == null && playlist.itemCount == null)
          ? null
          : Text(
              [
                if (playlist.author != null) playlist.author,
                if (playlist.itemCount != null) '${playlist.itemCount} items ',
              ].join(' • '),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
    );
  }
}
