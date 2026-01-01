import 'package:flutter/material.dart';

import '../../models/song.dart';
import '../../services/uteis/load_image.dart';

class SongCard extends StatefulWidget {
  final Song song;
  const SongCard({super.key, required this.song});

  @override
  State<SongCard> createState() => _SongCardState();
}

class _SongCardState extends State<SongCard> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: LoadImage.loadWidget(
          widget.song.artUri.toString(),

          errorBuildericon: Icons.music_note,
        ),
      ),
      title: Text(
        widget.song.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: widget.song.artist == null
          ? null
          : Text(
              widget.song.artist!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
    );
  }
}
