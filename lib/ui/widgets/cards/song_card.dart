import 'package:flutter/material.dart';
import '../../../models/song.dart';
import '../../../services/uteis/format_duration.dart';
import '../../../services/uteis/load_image.dart';

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
      leading: LoadImage.loadWidget(
        widget.song.artUri.toString(),

        errorBuildericon: Icons.music_note,
      ),
      title: Text(
        widget.song.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: widget.song.artist == null
          ? null
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.song.artist!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(width: 5),
                if (widget.song.duration != null)
                  Text(formatDuration(widget.song.duration!)),
              ],
            ),
    );
  }
}
