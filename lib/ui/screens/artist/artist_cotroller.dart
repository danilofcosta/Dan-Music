import 'package:danmusic/services/uteis/helper.dart';
import 'package:get/get.dart';

import '../../../models/artist.dart';
import '../../../services/yt_api.dart';

class ArtistCotroller extends GetxController {
  final YouTubeMusicService youTubeService = Get.find<YouTubeMusicService>();
  final Rxn<ArtistFull> artistFull = Rxn<ArtistFull>();
  final RxBool isLoading = true.obs;

  // Cache
  final Map<String, ArtistFull> _cache = {};

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as List;
    final String artistId = args[0];
    featdata(artistId);
  }

  Future<void> featdata(String artistId) async {
    // Verifica cache
    if (_cache.containsKey(artistId)) {
      artistFull.value = _cache[artistId];
      isLoading.value = false;
      return;
    }

    try {
      isLoading.value = true;
      final data = await youTubeService.getArtistFull(artistId);
      artistFull.value = data;
      if (data != null) _cache[artistId] = data;
    } catch (e) {
      printErrorDebug("Error fetching artist data: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
