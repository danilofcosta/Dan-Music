import 'package:danmusic/models/album.dart';
import 'package:get/get.dart';

import '../../../services/yt_api.dart';

class AlbumController extends GetxController {
  final YouTubeMusicService youTubeService = Get.find();
  final albumId = ''.obs;

  final album = AlbumFull(
    title: '',
    thumbnails: null,
    isExplicit: false,
    description: '',
    year: 0,
    artists: [],
    trackCount: 0,
    duration: '',
    audioPlaylistId: '',
    tracks: [],
    durationSeconds: 0,
    relatedRecommendations: null,
  ).obs;

  // Cache
  final Map<String, AlbumFull> _cache = {};

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as List;
    final Album? playlist = args[1];
    final String albumId = args[0];

    featData(albumId, playlist);
  }

  void featData(String id, Album? albumPreview) async {
    albumId.value = id;

    // Verifica cache
    if (_cache.containsKey(id)) {
      album.value = _cache[id]!;
      return;
    }

    // Se já veio um álbum parcial (preview), popula o básico
    if (albumPreview != null) {
      album.value = AlbumFull(
        title: albumPreview.title,
        thumbnails: albumPreview.thumbnails,
      );
    }

    // Depois carrega o álbum completo da API
    final AlbumFull? data = await youTubeService.getAlbumFull(
      albumPreview?.browseId ?? id,
    );
    if (data == null) {
      return;
    }
    album.value = data;
    _cache[id] = data;
  }
}
