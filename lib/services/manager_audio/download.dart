import 'dart:io';
import 'dart:typed_data';
import 'package:danmusic/services/manager_audio/manage_audio_url.dart';
import 'package:danmusic/services/cache_service.dart';
import 'package:path_provider/path_provider.dart';

import '../../db/hive_config.dart';
import '../../db/models_db/song_db.dart';

class AudioDownloader {
  /// Baixa várias músicas em lotes
  static Future<void> audioDownloaderList(List<String> videoIds, {int batchSize = 2}) async {
    for (int i = 0; i < videoIds.length; i += batchSize) {
      final batch = videoIds.skip(i).take(batchSize).toList();
      await Future.wait(batch.map((id) => baixarMusica(musicId: id)));
    }
  }

  /// Baixa uma música usando cache manager + salva no app + Hive
  static Future<File> baixarMusica({required String musicId}) async {
    final audioUrl = await ManageAudioURL.getAudioUrl(musicId);

    // Tenta obter do cache primeiro, senão faz download
    final file = await AudioCacheManager().getSingleFile(audioUrl);

    // Diretório seguro do app
    final Directory dir = await getApplicationDocumentsDirectory();
    final musicDir = Directory('${dir.path}/savemusic');
    if (!await musicDir.exists()) await musicDir.create(recursive: true);

    // Salva o áudio no caminho local
    final String savePath = '${musicDir.path}/$musicId.m4a';
    final localFile = File(savePath);
    if (!await localFile.exists()) {
      await file.copy(savePath);
    }

    // Salva dados no Hive
    await HiveConfig.addSongDb(
      SongDb(
        id: musicId,
        title: "Music",
        artist: "Artist",
        durationSeconds: 0,
        path: savePath,
        cover: null,
      ),
    );

    return localFile;
  }
}
