import 'package:danmusic/models/song.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../navigation.dart';
import '../../../services/manager_audio/audio_handler.dart';

class PlayerController extends GetxController {
  final DraggableScrollableController draggableController =
      DraggableScrollableController();
  final MyAudioHandler audioHandler = Get.find<MyAudioHandler>();
  final Rx<Song> songNow = Song(id: '', title: '').obs;

  /// true = PlayerFull | false = PlayerMini
  final RxBool playerOpen = false.obs;

  @override
  void onReady() {
    super.onReady();
    _listenerSize();
    listenMediaItem();
  }

  @override
  void dispose() {
    draggableController.dispose();
    super.dispose();
  }

  void _listenerSize() {
    draggableController.addListener(() {
      final size = draggableController.size;

      if (size >= 0.14) {
        playerOpen.value = true;
      } else {
        playerOpen.value = false;
      }
    });
  }

  void setminplayer() {
    Get.back();

    // playerOpen.value = !playerOpen.value;
    return;
    // draggableController.animateTo(
    //   0.10, // size (0.0 a 1.0)
    //   duration: const Duration(milliseconds: 300),
    //   curve: Curves.easeOut,
    // );
  }

  void setMaxplayer() {
    Get.toNamed(RouteName.playeMax);
    return;

    // playerOpen.value = !playerOpen.value;
    // return;

    // draggableController.animateTo(
    //   1, // size (0.0 a 1.0)
    //   duration: const Duration(milliseconds: 300),
    //   curve: Curves.easeOut,
    // );
  }

  void listenMediaItem() {
    audioHandler.mediaItem.listen((item) {
      if (item != null) {
        songNow.value = Song.fromMediaItem(item);
      }
    });
  }

  void playById(Song song) async {
    await audioHandler.playById(song);
  }

  Future<void> uploadQuere(List<Song> songs) async {
    if (songs.isEmpty) return;
    await audioHandler.uploadQuere(songs);
  }

  void playByIndex(int index) {
    audioHandler.playByIndex(index);
  }

  @override
  void onClose() {
    draggableController.dispose();
    super.onClose();
  }
}
