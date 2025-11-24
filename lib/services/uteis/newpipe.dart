import 'package:flutter_new_pipe_extractor/flutter_new_pipe_extractor.dart';


class DownloaderChannel {
  // Definindo o mesmo MethodChannel usado no Kotlin
  /// Chama o método nativo 'getVideoUrl' e retorna a URL do áudio
  static Future<VideoInfo> getAudioUrl(String videoId) async {
    await NewPipeExtractor.init();

    VideoInfo streams = await NewPipeExtractor.getVideoInfo(    
      videoId
    );


    return streams;
    ///return "";
  }

}
