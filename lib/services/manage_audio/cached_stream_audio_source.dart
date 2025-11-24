import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:danmusic/services/to_media_item.dart';
import 'package:danmusic/services/uteis/newpipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_new_pipe_extractor/flutter_new_pipe_extractor.dart';
import 'package:just_audio/just_audio.dart';

// class CachedStreamAudioSource extends StreamAudioSource {
//   final String videoId;

//   MediaItem? toMediaItem;
//   String? audioUrl;

//   // // --------- 🔧 Correção do erro ---------
//   // MediaItem? _tag; // field privado real

//   // @override
//   // MediaItem? get tag => _tag;

//   // set tag(MediaItem? value) => _tag = value;
//   // // ---------------------------------------

//   CachedStreamAudioSource({required this.videoId});

//   Future<AudioStream> getAudioUrl() async {
//     VideoInfo videoInfo = await DownloaderChannel.getAudioUrl(
//       videoId,
//     ); // Busca a URL do áudio
//     toMediaItem = await ToMediaItem.videoInfo(videoInfo);
//     //  tag =  await ToMediaItem.videoInfo(videoInfo);
//     audioUrl = videoInfo.audioStreams.first.content;
//     printinfoDebug('buscado ${videoInfo.name} - ${videoInfo.id} ');
//     return  videoInfo.audioStreams.first  ;
//   }

//   @override
//   Future<StreamAudioResponse> request([int? start, int? end]) async {
//    // String url = toMediaItem == null ? await getAudioUrl() : audioUrl!;

//     // return LockCachingAudioSource(
//     // //   Uri.parse(url),
//     //   tag: toMediaItem,
//     // ).request(start, end);
//     final client = HttpClient();
//     final request = await client.getUrl(Uri.parse(url));
//     final response = await request.close();

//     final contentLength = response.contentLength;

//     return StreamAudioResponse(
//       sourceLength: contentLength,
//       contentLength: contentLength,
//       offset: start ?? 0,
//       stream: response,
//       contentType: 'audio/mpeg',
//     );
//   }
// }

// void printinfoDebug(dynamic info) {
//   debugPrint('--------------------------------------------- -');

//   debugPrint(info.toString());

//   debugPrint('--------------------------------------------- -');
// }

class CachedStreamAudioSource extends StreamAudioSource {
  final String videoId;

  MediaItem? toMediaItem;
  AudioStream? audioStream;

  CachedStreamAudioSource({required this.videoId});

  /// Busca o AudioStream e cria o MediaItem
  Future<AudioStream> getAudioStream() async {
    if (audioStream != null) return audioStream!;

    VideoInfo videoInfo = await DownloaderChannel.getAudioUrl(videoId);
    toMediaItem = await ToMediaItem.videoInfo(videoInfo);

    // Seleciona o primeiro stream de áudio como padrão
    audioStream = videoInfo.audioStreams.first;
    printinfoDebug('Buscado ${videoInfo.name} - ${videoInfo.id}');
    return audioStream!;
  }

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    final streamInfo = await getAudioStream();
    final url = streamInfo.content;

    final client = HttpClient();
    final request = await client.getUrl(Uri.parse(url));
    final response = await request.close();

    final contentLength = response.contentLength >= 0
        ? response.contentLength
        : null;

    return StreamAudioResponse(
      sourceLength: contentLength,
      contentLength: contentLength,
      offset: start ?? 0,
      stream: response,
      contentType: 'audio/mpeg',
    );
  }
}

void printinfoDebug(dynamic info) {
  debugPrint('---------------------------------------------');
  debugPrint(info.toString());
  debugPrint('---------------------------------------------');
}
