import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/song.dart';
import '../../../services/uteis/format_duration.dart';
import '../../../services/uteis/load_image.dart';
import '../../screens/player/player_controller.dart';

class SongCard extends StatefulWidget {
  final Song song;
  final int? index;
  const SongCard({super.key, required this.song, this.index});

  @override
  State<SongCard> createState() => _SongCardState();
}

class _SongCardState extends State<SongCard> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        final controller = Get.find<PlayerController>();
        controller.playById(widget.song);
      },
      enabled: widget.song.id.length > 0,
      dense: true,
      leading: widget.index != null && widget.song.artUri == null
          ? SizedBox(
              width: 80,
              child: Center(
                child: Text(
                  widget.index!.toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 24),
                ),
              ),
            )
          : SizedBox(
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
    );
  }
}
