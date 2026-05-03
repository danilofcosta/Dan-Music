import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../uteis/helper.dart';

final yt = YoutubeExplode();

class ManageAudioURL {
  static Future<String> getAudioUrl(String videoId) async {
    try {
      final manifest = await yt.videos.streamsClient.getManifest(videoId);
      final audioStreams = manifest.audioOnly;
      if (audioStreams.isEmpty) {
        throw Exception("Nenhum stream de áudio disponível para $videoId");
      }
      final audio = audioStreams.sortByBitrate().last;
      return audio.url.toString();
    } catch (e) {
      printErrorDebug("Erro ao obter URL de áudio para $videoId: $e");
      rethrow;
    }
  }
}
