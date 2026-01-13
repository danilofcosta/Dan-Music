import 'dart:isolate';

import 'package:danmusic/services/uteis/helper.dart';
import 'package:flutter/services.dart';
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

  static Future<Map<String, dynamic>> getdata(String videoId) async {
    printInfoDebug("getdata: $videoId com NewPipeExtractor");
    await NewPipeExtractor.init();
    try {
      VideoInfo streams = await NewPipeExtractor.getVideoInfo(videoId);
      printInfoDebug("getdata: ${streams.category}");

      return {
        'cover': streams.thumbnails.last.url,
        'title': streams.name,
        'uploader': streams.uploaderName,

        'url': streams.audioStreams.last.content,
        'isTop': streams.uploaderName.toLowerCase().contains('topic'),
      };

      ///return "";
    } catch (e) {
      try {
        return {};
      } catch (e) {
        throw Exception("Erro ao obter URL do áudio: $e");
      }
    }
  }

  static Future<VideoInfo?> videoInfo(String videoId) async {
    printInfoDebug("getdata: $videoId com NewPipeExtractor");
    await NewPipeExtractor.init();
    try {
      VideoInfo streams = await NewPipeExtractor.getVideoInfo(videoId);
      printInfoDebug("getdata: ${streams.category}");

      return  streams;

      ///return "";
    } catch (e) {
      try {
        return null;
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

  static Future<String> getAudioUrlIsolate(String videoId) async {
    final receivePort = ReceivePort();
    final token = RootIsolateToken.instance!;

    printInfoDebug("getAudioUrlIsolate: $videoId com isolate");
    await Isolate.spawn(isolateEntryPoint, [
      receivePort.sendPort,
      videoId,
      token,
    ], debugName: "youtube_audio_isolate");

    return await receivePort.first as String;
  }
}

void isolateEntryPoint(List<dynamic> args) async {
  final SendPort sendPort = args[0];
  final String videoId = args[1];
  final RootIsolateToken token = args[2];

  BackgroundIsolateBinaryMessenger.ensureInitialized(token);

  // final yt = YoutubeExplode();
  // await NewPipeExtractor.init();

  try {
    final info = await NewPipeExtractor.getVideoInfo(videoId);
    sendPort.send(info.audioStreams.last.content);
  } catch (_) {
    //  final manifest = await yt.videos.streams.getManifest(videoId);
    //  sendPort.send(manifest.audioOnly.first.url.toString());
  } finally {
    // yt.close();
  }
}
