import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../models/durationstate.dart';

class PlayerController extends GetxController  with BasicComanos {
  //String? playNowId;
  // MediaItem? songNow;

  RxString playNowId = ''.obs;
  AudioHandler get audioHandler => Get.find<AudioHandler>();  
  Rx<MediaItem?> songNow = Rx<MediaItem?>(null);

  Rx<PlayButtonState> buttonState = PlayButtonState.paused.obs;
  


  final progressBarStatus = ProgressBarState(
    buffered: Duration.zero,
    current: Duration.zero,
    total: Duration.zero,
  ).obs;

  @override
  void onInit() {
    super.onInit();
    listenAudioHandler();
  }

  void listenMediaItem() {
    audioHandler.mediaItem.listen((item) {
      debugPrint('Tocando música ${item?.id}');

      if (item?.duration != null) {
        progressBarStatus.update((val) {
          val!.total = item!.duration!;
        });
      }


    songNow.value = item; // <-- AQUI AGORA ATUALIZA DE VERDADE
    playNowId.value = item?.id ?? '';
      // <--- reconstrói widgets GetBuilder, se usar.
    });
  }

  void listenProgressBarStatus() {
    /// playbackState
    audioHandler.playbackState.listen((state) {
      final old = progressBarStatus.value;
      progressBarStatus.update((val) {
        val!.buffered = state.bufferedPosition;
        val.current = state.position;
        val.total = old.total;
      });
    });
  }

  void listenAudioHandler() {
    listenMediaItem();
    listenProgressBarStatus();
_listenForChangesInPlayerState();
  }


/// Listen for changes in the player state and update the button state accordingly.
/// This method is currently not being used.
  void _listenForChangesInPlayerState() { // TODO: This method is not being used.
    audioHandler.playbackState.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == AudioProcessingState.loading || processingState == AudioProcessingState.buffering) {
        buttonState.value = PlayButtonState.loading;
      } else if (!isPlaying || processingState == AudioProcessingState.error) {
        buttonState.value = PlayButtonState.paused;
      } else if (processingState != AudioProcessingState.completed) {
        buttonState.value = PlayButtonState.playing;
      } else {
        audioHandler.seek(Duration.zero);
        audioHandler.pause();
      }
    });
  }
}



enum PlayButtonState { paused, playing, loading }
mixin BasicComanos {

AudioHandler get audioHandler => Get.find<AudioHandler>();


  void play() async {
    await audioHandler.play();
  }
   void pause() async {
    await audioHandler.pause();
  }
}