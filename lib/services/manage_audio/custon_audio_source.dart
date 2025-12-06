import 'dart:async';
import 'dart:typed_data';
import 'package:danmusic/services/uteis/helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:danmusic/services/manage_audio/manage_audio_url.dart';
class CustomVideoAudioSource extends StreamAudioSource {
  final String videoId;
  late final String _url;

  CustomVideoAudioSource(this.videoId);

  Future<void> _ensureUrl() async {
    _url = await ManageAudioURL.getAudioUrlNewpipe(videoId);
  }

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    await _ensureUrl();

    final request = http.Request("GET", Uri.parse(_url));

    if (start != null && end != null) {
      request.headers['Range'] = "bytes=$start-${end - 1}";
    }

    final response = await request.send();
    final contentLength = response.contentLength;

    return StreamAudioResponse(
      sourceLength: null,
      contentLength: contentLength,
      offset: start ?? 0,
      stream: response.stream,
      contentType: response.headers["content-type"] ?? "audio/webm",
    );
  }
}
