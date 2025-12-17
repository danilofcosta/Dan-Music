import 'package:audio_service/audio_service.dart';
import 'package:danmusic/ui/screens/player_page/player_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/manage_audio/audio_handler.dart' show MyAudioHandler;

class FilaController extends GetxController {
  ScrollController scrollController = ScrollController();
  AudioHandler audioHandler = Get.find<MyAudioHandler>();
  PlayerController playerController = Get.find<PlayerController>();

  final file = <MediaItem>[].obs;
  final index = 0.obs;

  @override
  void onReady() {
    super.onReady();
    _listenQueue();
    _listenIndex();
  }

  @override
  void onClose() {}

  Future<void> _listenIndex() async {
    audioHandler.playbackState.listen((state) {
      index.value = state.queueIndex ?? 0;
      //printInfoDebug(state);
    });
  }

  void playIndex(int index) {
    var currentIndex = file.indexWhere(
      (e) => e.id == playerController.songNow.value?.id,
    );
    if (currentIndex != -1) {
      audioHandler.skipToQueueItem(index);
    }
  }

  void scrollToIndex(int index) {
    final position = index * 80.0; // Assuming each item has a height of 80.0
    scrollController.animateTo(
      position,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _listenQueue() async {
    audioHandler.queue.listen((event) async {
      file.assignAll(event);
    });
  }
}
