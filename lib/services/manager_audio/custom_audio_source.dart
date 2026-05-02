


import 'dart:io';

import 'package:danmusic/services/manager_audio/manage_audio_url.dart';
import 'package:just_audio/just_audio.dart';
class CustomAudioSource extends StreamAudioSource {
  final String musicId;

  CustomAudioSource(this.musicId);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    // Busca sempre um link novo (porque ele expira)
    // final VideoInfo? videoInfo = await ManageAudioURL.videoInfo(musicId);
    // if (videoInfo == null) {
    //   throw Exception("Vídeo não encontrado");
    // }

    // final AudioStream audio = videoInfo.audioStreams.first;
final audio = await ManageAudioURL.getAudioUrl(musicId);
    // A URL direta do áudio
    final Uri uri = Uri.parse(audio);

    // Monta headers para suporte a streaming parcial (seek)
    final headers = <String, String>{};
    if (start != null || end != null) {
      final range =
          'bytes=${start ?? 0}-${end ?? ''}';
      headers[HttpHeaders.rangeHeader] = range;
    }

    final httpClient = HttpClient();
    final request = await httpClient.getUrl(uri);

    headers.forEach((key, value) {
      request.headers.set(key, value);
    });

    final response = await request.close();

    final contentLength = response.contentLength == -1
        ? -1
        : response.contentLength;

    return StreamAudioResponse(
      sourceLength: -1,
      contentLength: contentLength,
      offset: start,
      contentType: "audio/mp4",
      stream: response.map((event) => event),
    );
  }
}
