import 'package:danmusic/services/uteis/helper.dart';
import 'package:flutter_new_pipe_extractor/flutter_new_pipe_extractor.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

final yt = YoutubeExplode();

class ManageAudioURL {
  // Definindo o mesmo MethodChannel usado no Kotlin
  /// Chama o método nativo 'getVideoUrl' e retorna a URL do áudio
  static Future<String> getAudioUrlNewpipe(String videoId) async {
    printInfoDebug("getAudioUrlNewpipe: $videoId com NewPipeExtractor");
    await NewPipeExtractor.init();
    try {
      VideoInfo streams = await NewPipeExtractor.getVideoInfo(videoId);

      return streams.audioStreams.last.content;

      ///return "";
    } catch (e) {
      try {
        return await getAudioUrl(videoId);
      } catch (e) {
        throw Exception("Erro ao obter URL do áudio: $e");
      }
    }
  }

  static Future<String> getAudioUrl(String videoId) async {
    // String url = "";
    printInfoDebug("getAudioUrl: $videoId com YoutubeExplode");

    // final video = await yt.videos.get(videoId);
    final manifest = await yt.videos.streams.getManifest(
      videoId,
      // You can also pass a list of preferred clients, otherwise the library will handle it:
      ytClients: [YoutubeApiClient.ios, YoutubeApiClient.androidVr],
    );

    // Get the audio streams.
    final audio = manifest.audioOnly;

    //   yt.close();

    return audio.first.url.toString();
  }
}
