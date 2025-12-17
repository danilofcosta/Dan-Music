import 'package:danmusic/services/ytmusicapi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/album.dart';
import '../../../models/playlist_full.dart';
import '../../../services/to_media_item.dart';

class AlbumController extends GetxController {
  final album = Album(
    albumId: 'albumId',
    playlistId: 'playlistId',
    name: 'name',
    artist: 'artist',
    year: 2000,
    thumbnails: [''],
  ).obs;

  final albumId = 'albumId'.obs;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as List;
    album.value = args[0] as Album;
    albumId.value = args[1] as String;
    fectdata(albumId.value);
  }

  void fectdata(String albumId) async {
    try {
      album.value = await YouTubeMusicService.getAlbum(albumId);
    } catch (e) {
      PlaylistFull s = await YouTubeMusicService.getPlaylist(
        album.value.playlistId,
      );
      album.value = Album(
        albumId: albumId,
        playlistId: s.playlistId,
        name: s.title,
        artist: s.desciption,
        year: 2,

        thumbnails: s.thumbnails.isNotEmpty
            ? s.thumbnails
            : [album.value.thumbnails[0]],
        songs: s.tracks!.map((e) => ToMediaItem.song(e)).toList(),
      );

      debugPrint(' ${s.tracks!.length}');
    }
  }
}
