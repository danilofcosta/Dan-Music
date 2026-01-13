import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';

import '../player/player_controller.dart';

class CurrentPlaylistController extends GetxController {
  final RxList<MediaItem> playlist = <MediaItem>[].obs;
  final PlayerController player = Get.find<PlayerController>();

  @override
  void onInit() {
    super.onInit();

    // Sincroniza com a fila atual do player
    final queue = player.audioHandler.queue.value;
    if (queue.isNotEmpty) {
      playlist.assignAll(queue);
    }

    // Se quiser manter sempre sincronizado:
    player.audioHandler.queue.listen((List<MediaItem> newQueue) {
      playlist.assignAll(newQueue);
    });
  }

  void ontap(int index) {
    player.playByIndex(index);
  }
}
