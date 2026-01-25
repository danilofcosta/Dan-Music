import 'package:get/get.dart';
import 'package:musicfy/musicfy.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../models/song.dart';
import '../../player/player_controller.dart';

class DeviceLibraryController extends GetxController {
  final RxList<Song> songs = <Song>[].obs;
  final RxMap<String, List<Song>> musicByDirectory = <String, List<Song>>{}.obs;

  final PlayerController playerController = Get.find<PlayerController>();

  @override
  void onReady() {
    super.onReady();
    requestStoragePermission();
  }

  Future<void> requestStoragePermission() async {
    PermissionStatus status;

    // depois você troca isso por verificação de Android 13+
    status = await Permission.storage.request();

    if (status.isGranted) {
      final rawMusicList = await Musicfy().getMusicList();

      final List<Song> convertedSongs = rawMusicList.map((music) {
        return Song(
          id: music['path'],
          title: music['title'],
          artist: '${music['artist']} - ${music['album']}',
        );
      }).toList();

      songs.assignAll(convertedSongs);
      groupSongsByDirectory(rawMusicList);
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  /// Agrupa músicas por diretório
  void groupSongsByDirectory(List<dynamic> rawMusicList) {
    musicByDirectory.clear();

    for (var music in rawMusicList) {
      final String path = music['path'];
      final String directory = path.substring(0, path.lastIndexOf('/'));

      final song = Song(
        id: music['path'],
        title: music['title'],
        artist: '${music['artist']} - ${music['album']}',
      );

      musicByDirectory.putIfAbsent(directory, () => <Song>[]);
      musicByDirectory[directory]!.add(song);
    }

    // 🔹 Ordenar músicas dentro de cada pasta
    for (var entry in musicByDirectory.entries) {
      entry.value.sort(
        (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
      );
    }

    // 🔹 Ordenar as pastas alfabeticamente
    final sortedKeys = musicByDirectory.keys.toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    final Map<String, List<Song>> sortedMap = {};
    for (var key in sortedKeys) {
      sortedMap[key] = musicByDirectory[key]!;
    }

    musicByDirectory.assignAll(sortedMap);
  }

  void playerall() {
    playerController.uploadQuere(songs);
  }
}
