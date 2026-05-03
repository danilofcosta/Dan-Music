import 'package:audio_service/audio_service.dart';
import 'package:danmusic/models/song.dart';
import 'package:get/get.dart';

import '../player/player_controller.dart';

class CurrentPlaylistController extends GetxController {
  final RxList<MediaItem> playlist = <MediaItem>[].obs;

  /// Índice reativo da música tocando agora.
  final RxInt currentIndexObs = 0.obs;

  /// Se a fila está embaralhada.
  final RxBool isShuffled = false.obs;

  final PlayerController player = Get.find<PlayerController>();

  @override
  void onInit() {
    super.onInit();
    _syncPlaylist();
    _syncCurrentIndex();
  }

  // ── Sincroniza a fila ──────────────────────────────────────────────────────

  void _syncPlaylist() {
    final queue = player.audioHandler.queue.value;
    if (queue.isNotEmpty) playlist.assignAll(queue);

    player.audioHandler.queue.listen((newQueue) {
      playlist.assignAll(newQueue);
    });
  }

  // ── Descobre o índice atual via songNow ────────────────────────────────────

  void _syncCurrentIndex() {
    ever(player.songNow, (song) {
      final idx = playlist.indexWhere((item) => item.id == song.id);
      if (idx != -1) currentIndexObs.value = idx;
    });

    ever(playlist, (_) {
      final song = player.songNow.value;
      final idx = playlist.indexWhere((item) => item.id == song.id);
      if (idx != -1) currentIndexObs.value = idx;
    });
  }

  // ── Ações ──────────────────────────────────────────────────────────────────

  void ontap(int index) => player.playByIndex(index);

  // ── Shuffle ────────────────────────────────────────────────────────────────

  Future<void> shuffle() async {
    if (playlist.length < 2) return;

    final currentIdx = currentIndexObs.value;
    final currentItem = playlist[currentIdx];

    // Copia a lista, remove a música atual e embaralha o resto
    final rest = List<MediaItem>.from(playlist)..removeAt(currentIdx)..shuffle();

    // Música atual fica na posição 0; restante embaralhado depois
    final newOrder = <MediaItem>[currentItem, ...rest];

    // Converte MediaItem → Song e recarrega sem pausar
    final songs = newOrder.map((item) => Song.fromMediaItem(item)).toList();
    await player.audioHandler.shuffleQueue(songs);

    isShuffled.value = !isShuffled.value;
  }
}
