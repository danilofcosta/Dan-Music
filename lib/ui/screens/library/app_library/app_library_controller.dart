import 'package:audio_service/audio_service.dart';
import 'package:danmusic/models/song.dart';
import 'package:get/get.dart';

import '../../../../db/hive_config.dart';

class AppLibraryController extends GetxController {
  final songsapp = [].obs;
  @override
  void onReady() {
    super.onReady();
    getsongs();
  }

  void getsongs() async {
    final songs = HiveConfig.getAllMusic();
    final tomedia = songs.map((song) {
      return Song(
        id: song.path,
        title: song.title,
        artist: song.artist,
        album: song.album,
        artUri: song.cover != null
            ? Uri.dataFromBytes(song.cover!.toList())
            : null,
      );
    }).toList();
    songsapp.addAll(tomedia);
  }
}
