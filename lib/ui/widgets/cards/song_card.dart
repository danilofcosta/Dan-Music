import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/song.dart';
import '../../../services/uteis/format_duration.dart';
import '../../../services/uteis/load_image.dart';
import '../../screens/player/player_controller.dart';

class SongCard extends StatefulWidget {
  final Song song;
  final int? index;
  final Function()? onTap;
  const SongCard({super.key, required this.song, this.index, this.onTap});

  @override
  State<SongCard> createState() => _SongCardState();
}

class _SongCardState extends State<SongCard> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final controller = Get.find<PlayerController>();
      final playingNow = controller.songNow.value.id == widget.song.id;

      return ListTile(
        onTap: () {
          if (widget.onTap != null) {
            widget.onTap!();
            return;
          }
          final controller = Get.find<PlayerController>();
          controller.playById(widget.song);
        },
        enabled: widget.song.id.isNotEmpty,
        dense: !playingNow,
        selected: playingNow,
        selectedTileColor: Theme.of(
          context,
        ).colorScheme.primary.withValues(alpha: .1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),

        // contentPadding: EdgeInsets.zero,
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
    });
  }
}
