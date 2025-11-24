import 'package:audio_service/audio_service.dart';
import 'package:danmusic/models/song.dart';
import 'package:danmusic/provaders/player_provider.dart';
import 'package:danmusic/services/globais_vars.dart';
import 'package:danmusic/widgets/ui/text_conf_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SongUi extends StatefulWidget {
  final Song song;
  const SongUi({super.key, required this.song});

  @override
  State<SongUi> createState() => _SongUiState();
}

class _SongUiState extends State<SongUi> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerProvider>(
      builder: (context, player, _) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          // margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: ListTile(
            selected: player.playNowId == widget.song.videoid,

            onTap: () {
              audioHandler.playMediaItem(
                MediaItem(
                  id: widget.song.videoid,
                  title: widget.song.title,
                  artUri: Uri.parse(widget.song.thumbnails?.firstOrNull ?? ''),
                  artist: widget.song.artist,
                  album: widget.song.albumInfo?.albumName ?? '',
                ),
              );
              // Navigator.of(context).pushNamed('/player');
              //debugPrintStack(label: 'Tocando musica');
            },
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                widget.song.thumbnails?.firstOrNull ?? '',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey,
                    child: const Icon(Icons.music_note, color: Colors.white),
                  );
                },
              ),
            ),
            title: TextUi(
              widget.song.title,
              style: TextStyle(
                color: player.playNowId == widget.song.videoid
                    ? Theme.of(context).colorScheme.primary
                    // ? Colors.amber
                    : null,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: TextUi(widget.song.artist ?? '')),

                TextUi(widget.song.duration ?? ''),
              ],
            ),
          ),
        );
      },
    );
  }
}
