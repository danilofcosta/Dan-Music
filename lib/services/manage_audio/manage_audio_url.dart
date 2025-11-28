import 'package:flutter_new_pipe_extractor/flutter_new_pipe_extractor.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
   final yt = YoutubeExplode();
class ManageAudioURL {
  // Definindo o mesmo MethodChannel usado no Kotlin
  /// Chama o método nativo 'getVideoUrl' e retorna a URL do áudio
  static Future<String> getAudioUrlNewpipe(String videoId) async {
    await NewPipeExtractor.init();

    VideoInfo streams = await NewPipeExtractor.getVideoInfo(
      videoId
    );

    return streams.audioStreams.last.content;
    ///return "";
  }


  static Future<String> getAudioUrl(String videoId) async {
   // String url = "";
 

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
