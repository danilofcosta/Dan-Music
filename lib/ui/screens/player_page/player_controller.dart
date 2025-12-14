import 'package:audio_service/audio_service.dart';
import 'package:danmusic/services/uteis/helper.dart';
import 'package:get/get.dart';

import '../../../models/durationstate.dart';

class PlayerController extends GetxController with BasicComanos {
  RxString playNowId = ''.obs;
  @override
  AudioHandler audioHandler = Get.find<AudioHandler>();

  Rx<MediaItem?> songNow = Rx<MediaItem?>(null);
  Rx<PlayButtonState> buttonState = PlayButtonState.paused.obs;

  

  final progressBarStatus = ProgressBarState(
    buffered: Duration.zero,
    current: Duration.zero,
    total: Duration.zero,
  ).obs;

 // DateTime _lastUpdate = DateTime.now();

  @override
  void onInit() {
    super.onInit();
    listenAudioHandler();
  }

  void updateQueuenew(List<MediaItem> queue) async {
    await audioHandler.updateQueue(queue);
    audioHandler.customAction('playByIndex', {'index': 0});
  }

  void playByVideoId(String videoId) async {
    await audioHandler.customAction('playByVideoId', {'VideoId': videoId});
  }

  void listenMediaItem() {
    audioHandler.mediaItem.listen((item) {
      if (item?.duration != null) {
        progressBarStatus.update((val) {
          val!.total = item!.duration!;
        });
      }
      songNow.value = item;
      playNowId.value = item?.id ?? '';
    });
  }

  void listenProgressBarStatus() {


    
    audioHandler.playbackState.listen((state) {
     // final now = DateTime.now();

      // /// throttle – atualiza apenas a cada 150ms
      // if (now.difference(_lastUpdate).inMilliseconds < 150) return;
      // _lastUpdate = now;
      printErrorDebug(state.position.toString());

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

  void _listenForChangesInPlayerState() {
    audioHandler.playbackState.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;

      if (processingState == AudioProcessingState.loading ||
          processingState == AudioProcessingState.buffering) {
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

  void play() => audioHandler.play();
  void pause() => audioHandler.pause();
}
