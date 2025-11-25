import 'dart:io';

import 'package:audio_service/audio_service.dart';
import '/services/globais_vars.dart';
import '/services/to_media_item.dart';
import '/services/uteis/newpipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_new_pipe_extractor/flutter_new_pipe_extractor.dart';
import 'package:just_audio/just_audio.dart';

class CachedStreamAudioSource extends StreamAudioSource {
  final String videoId;

  MediaItem? toMediaItem;
  String? audioUrl;

  // // --------- 🔧 Correção do erro ---------
  MediaItem? _tag; // field privado real

  @override
  MediaItem? get tag => _tag;

  set tag(MediaItem? value) => _tag = value;
  // // ---------------------------------------

  CachedStreamAudioSource({required this.videoId, MediaItem? tag});

  Future<String> getAudioUrl() async {
    VideoInfo videoInfo = await DownloaderChannel.getAudioUrl(
      videoId,
    ); // Busca a URL do áudio
    toMediaItem = await ToMediaItem.videoInfo(videoInfo);
    //  tag =  await ToMediaItem.videoInfo(videoInfo);
    audioUrl = videoInfo.audioStreams.first.content;
    printinfoDebug('buscado ${videoInfo.name} - ${videoInfo.id} ');
    return videoInfo.audioStreams.last.content;
  }

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    String url = toMediaItem == null ? await getAudioUrl() : audioUrl!;

    return LockCachingAudioSource(
      Uri.parse(url),
      cacheFile: File(
        "${audioHandler.cacheDir}/cachedSongs/${toMediaItem?.id}.mp3",
      ),
      tag: tag ?? toMediaItem,
    ).request(start, end);
  }
}

void printinfoDebug(dynamic info) {
  debugPrint('--------------------------------------------- -');

  debugPrint(info.toString());

  debugPrint('--------------------------------------------- -');
}
