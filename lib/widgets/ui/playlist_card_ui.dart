import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
 
import '/models/Playlist.dart';

class PlaylistUi extends StatefulWidget {
  final Playlist playlist;
  const PlaylistUi({super.key, required this.playlist});

  @override
  State<PlaylistUi> createState() => _PlaylistUiState();
}

class _PlaylistUiState extends State<PlaylistUi> {
  final AudioHandler _audioHandler = Get.find<AudioHandler>();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        image: DecorationImage(
          image: NetworkImage(widget.playlist.thumbnails.firstOrNull ?? ''),
          fit: BoxFit.fill,
        ),
      ),
      child: FilledButton.icon(
        onPressed: () {
          //_audioHandler.playPlaylistId(widget.playlist.playlistId);
          Navigator.of(context).pushNamed('/player');
        },
        label: Text(widget.playlist.title),
        icon: const Icon(Icons.play_arrow),
      ),
    );
  }
}
