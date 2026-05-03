// import 'dart:io';

// import 'package:danmusic/models/song.dart';
// import 'package:danmusic/services/cache_service.dart';
// import 'package:danmusic/services/manager_audio/manage_audio_url.dart';
// import 'package:danmusic/services/uteis/helper.dart';
// import 'package:path_provider/path_provider.dart';

// import '../../db/hive_config.dart';
// import '../../db/models_db/song_db.dart';

// class AudioDownloader {
//   static Future<void> audioDownloaderList(List<String> videoIds, {int batchSize = 2}) async {
//     for (int i = 0; i < videoIds.length; i += batchSize) {
//       final batch = videoIds.skip(i).take(batchSize).toList();
//       await Future.wait(batch.map((id) => baixarMusica(musicId: id)));
//     }
//   }

//   static Future<File> baixarMusica({required String musicId}) async {
//     final audioUrl = await ManageAudioURL.getAudioUrl(musicId);
//     if (audioUrl == null) throw Exception("URL não encontrada");

//     final cacheManager = AudioCacheManager();
//     File? cachedFile = await cacheManager.getCachedFile(musicId);

//     if (cachedFile == null) {
//       cachedFile = await cacheManager.downloadAndCache(musicId);
//     }

//     if (cachedFile == null) throw Exception("Erro ao baixar música");

//     // Salva no diretório local
//     final Directory dir = await getApplicationDocumentsDirectory();
//     final musicDir = Directory('${dir.path}/savemusic');
//     if (!await musicDir.exists()) await musicDir.create(recursive: true);

//     final String savePath = '${musicDir.path}/$musicId.m4a';
//     final localFile = File(savePath);
//     if (!await localFile.exists()) {
//       await cachedFile.copy(savePath);
//     }

//     // Salva no Hive
//     await HiveConfig.addSongDb(
//       SongDb(
//         id: musicId,
//         title: "Music",
//         artist: "Artist",
//         durationSeconds: 0,
//         path: savePath,
//         cover: null,
//       ),
//     );

//     return localFile;
//   }
// }
