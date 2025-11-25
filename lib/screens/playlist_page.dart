import '/models/playlist.dart';
import '/models/playlist_full.dart';
import '/services/ytmusicapi.dart';
import '/widgets/build_backgrand.dart';
import 'package:flutter/material.dart';

class PlaylistPage extends StatefulWidget {
  final Playlist? playlistModel;
  const PlaylistPage({super.key, this.playlistModel});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  bool isLoading = false;
  PlaylistFull? playlistFull;
  @override
  void initState() {
    super.initState();
    checkPlaylistId();
    // featdata();
  }

  void checkPlaylistId() {
    // if (widget.playlistId != null) return;
    final playlistId = ModalRoute.of(context)!.settings.arguments as Playlist;
    if (playlistId != null) {
      featdata();
    }
  }

  void featdata() async {
    //  if (widget.playlistId == null) return;
    //  playlistFull = await YouTubeMusicService.getPlaylist(widget.playlistId!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // playlistId = ModalRoute.of(context)!.settings.arguments as String;
    return BuildBackgrand(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(),
        body: playlistFull == null
            ? Center(child: CircularProgressIndicator())
            : buildPlaylist(),
      ),
    );
  }

  Widget buildPlaylist() {
    return Container();
  }
}
