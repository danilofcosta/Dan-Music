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
    return Card(
      child: ListTile(
        leading: SizedBox(
          width: 80,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),

            child: LoadImage.loadWidget(
              widget.song.artUri.toString(),
              fit: BoxFit.contain,

              errorBuildericon: Icons.music_note,
            ),
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
        trailing: widget.song.duration != null
            ? Text(formatDuration(widget.song.duration!))
            : null,
      ),
    );
  }
}
