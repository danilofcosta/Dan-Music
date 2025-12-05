import 'package:audio_service/audio_service.dart';
import 'package:danmusic/ui/screens/player_page/player_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilaController extends GetxController {
  ScrollController scrollController = ScrollController();
  AudioHandler audioHandler = Get.find<AudioHandler>();
  PlayerController playerController = Get.find<PlayerController>();

  final file = <MediaItem>[].obs;
  final index = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _listenQueue();
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
