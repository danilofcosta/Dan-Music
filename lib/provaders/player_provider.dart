import 'package:audio_service/audio_service.dart';
import 'package:danmusic/services/globais_vars.dart';
import 'package:flutter/material.dart';

class PlayerProvider with ChangeNotifier {
  String? _playNowId;
  MediaItem? _songNow;
  String get playNowId => _playNowId ?? '';

  MediaItem? get songNow => _songNow;

  PlayerProvider() {
    // Atualiza música atual ao trocar de mediaItem
    audioHandler.mediaItem.listen((item) {
      debugPrint('Tocando musica  ${item?.id} atual');
      //   _playNow = item.id == currentMusic?.videoId;

      _playNowId = item?.id;
      _songNow = item;

      notifyListeners();
    });
  }
}
