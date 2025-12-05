import 'package:danmusic/services/manage_audio/manage_audio_url.dart';
import 'package:danmusic/services/uteis/helper.dart';
import 'package:just_audio/just_audio.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'dart:io';

class CustomVideoAudioSource extends StreamAudioSource {
  final String videoId;
  String? audioUrl;
  final http.Client _httpClient = http.Client();

  CustomVideoAudioSource(this.videoId);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    // 1. OBTENÇÃO DA URL (Garanta que só é chamado na primeira requisição)
    if (audioUrl == null) {
      audioUrl = await ManageAudioURL.getAudioUrlNewpipe(videoId);
      printInfoDebug("CustomVideoAudioSource - URL inicial obtida:");
    }

    // Validação da URL
    if (audioUrl == null) {
      throw Exception("Audio URL is null for videoId: $videoId");
    }

    final uri = Uri.parse(audioUrl!);
    final req = http.Request("GET", uri);

    // 2. ENVIAR HEADER RANGE
    if (start != null || end != null) {
      final rangeValue = "bytes=${start ?? 0}-${end ?? ''}";
      req.headers[HttpHeaders.rangeHeader] = rangeValue;
      printInfoDebug("CustomVideoAudioSource - Range Header: $rangeValue");
    }

    // 3. ENVIO E TIMEOUT
    final response = await _httpClient
        .send(req)
        .timeout(const Duration(seconds: 30));

    // 4. VERIFICAÇÃO DO STATUS
    if (response.statusCode != 200 && response.statusCode != 206) {
      throw HttpException("Failed to load audio: HTTP ${response.statusCode}");
    }

    // 5. PARSE DOS TAMANHOS
    // ContentLength: Tamanho do CHUNK (lido de Content-Length do CHUNK)
    final int? contentLength = response.contentLength;

    // SourceLength: Tamanho TOTAL (extraído de Content-Range)
    final int? sourceLength = _parseSourceLength(response);

    printInfoDebug(
      "CustomVideoAudioSource - Status: ${response.statusCode}, SourceLength (Total): $sourceLength, ContentLength (Chunk): $contentLength, Offset: ${start ?? 0}",
    );

    final contentType =
        response.headers[HttpHeaders.contentTypeHeader] ?? "audio/mpeg";
    end ??= contentLength;

    // 6. RETORNO DA RESPOSTA DO STREAM
    return StreamAudioResponse(
      // sourceLength: sourceLength, // Tamanho TOTAL do arquivo
      // contentLength: end! - (start ?? 0), // Tamanho DESTE chunk
      sourceLength: null, // Tamanho TOTAL do arquivo
      contentLength: null, // Tamanho DESTE chunk
      offset: start ?? 0, // Início deste chunk
      contentType: contentType,
      stream: response.stream,
    );
  }

  // --- IMPLEMENTAÇÃO DA FUNÇÃO AUXILIAR ---

  /// Extrai o tamanho total do arquivo (sourceLength) dos cabeçalhos HTTP.
  int? _parseSourceLength(http.StreamedResponse response) {
    final int? contentLength = response.contentLength;

    if (response.statusCode == 206) {
      // Status 206: O tamanho TOTAL (sourceLength) está no Content-Range
      final contentRange = response.headers[HttpHeaders.contentRangeHeader];
      if (contentRange != null) {
        // Ex: Content-Range: bytes 0-100/5000000 -> Extraímos '5000000'
        final parts = contentRange.split('/');
        if (parts.length > 1) {
          return int.tryParse(parts.last);
        }
      }
    } else if (response.statusCode == 200) {
      // Status 200: Content-Length é o tamanho total
      return contentLength;
    }
    // Se o header estiver faltando ou incompleto, retornamos null.
    return null;
  }
}


