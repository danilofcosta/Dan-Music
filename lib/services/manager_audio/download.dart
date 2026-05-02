import 'dart:io';
import 'dart:typed_data';
import 'package:danmusic/services/manager_audio/manage_audio_url.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

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

  /// Baixa uma música e salva no app + Hive
  static Future<File> baixarMusica({required String musicId}) async {
    // Pega informações do vídeo
    // final VideoInfo? videoInfo = await ManageAudioURL.videoInfo(musicId);
    // if (videoInfo == null) throw Exception("Vídeo não encontrado $musicId");

    // if (videoInfo.audioStreams.isEmpty) throw Exception("Não há streams de áudio disponíveis");

    // final AudioStream audio = videoInfo.audioStreams.first;
    final audio = await ManageAudioURL.getAudioUrl(musicId);
    final Uri uri = Uri.parse(audio);

    // Download do áudio
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception("Erro ao baixar áudio: ${response.statusCode}");
    }

    // Diretório seguro do app
    final Directory dir = await getApplicationDocumentsDirectory();
    final musicDir = Directory('${dir.path}/savemusic');
    if (!await musicDir.exists()) await musicDir.create(recursive: true);

    // Salva o áudio
    final String savePath = '${musicDir.path}/$musicId.m4a';
    final file = File(savePath);
    await file.writeAsBytes(response.bodyBytes);

    // Baixa a capa (se existir)
    Uint8List? coverBytes;
    // if (videoInfo.thumbnails.isNotEmpty) {
    //   final String? artworkUrl = videoInfo.thumbnails.last.url;
    //   if (artworkUrl != null) {
    //     coverBytes = await _downloadArtworkBytes(artworkUrl);
    //   }
    // }

    // Salva dados no Hive
    await HiveConfig.addSongDb(
      SongDb(
        id: musicId,
        title: "Music",
        artist: "Artist",
        durationSeconds: 0,
        path: savePath,
        cover: coverBytes,
      ),
    );

    return file;
  }

  /// Baixa a capa e retorna bytes
  static Future<Uint8List?> _downloadArtworkBytes(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) return response.bodyBytes;
    } catch (e) {
      print("Erro ao baixar capa: $e");
    }
    return null;
  }
}
