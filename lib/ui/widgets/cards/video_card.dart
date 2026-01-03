import 'package:flutter/material.dart';
import 'package:danmusic/models/search/search_video.dart';

import '../../../services/uteis/load_image.dart';

class VideoCard extends StatelessWidget {
  final SearchVideo video;
  const VideoCard({super.key, required this.video});

  String _artistsText() {
    if (video.artists == null || video.artists!.isEmpty) return '';
    return video.artists!.map((a) => a.name).join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final thumb = video.thumbnails?.isNotEmpty == true
        ? video.thumbnails!.first.url
        : null;
    return ListTile(
      leading: thumb != null
          ? LoadImage.loadWidget(thumb, errorBuildericon: Icons.videocam)
          : const Icon(Icons.videocam),
      title: Text(video.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: _artistsText().isEmpty
          ? (video.views != null
                ? Text(
                    '${video.views} views',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                : null)
          : Text(_artistsText()),
      trailing: video.duration != null
          ? Text(video.duration!, maxLines: 1, overflow: TextOverflow.ellipsis)
          : null,
    );
  }
}
