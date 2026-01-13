import 'package:get/get.dart';

import '../../../models/artist.dart';
import '../../../services/yt_api.dart';

class ArtistCotroller extends GetxController {
  final YouTubeMusicService youTubeService = Get.find<YouTubeMusicService>();
  final Rxn<ArtistFull> artistFull = Rxn<ArtistFull>();
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as List;
    final String artistId = args[0];
    featdata(artistId);
  }

  Future<void> featdata(String artistId) async {
    try {
      isLoading.value = true;
      final data = await youTubeService.getArtistFull(artistId);
      artistFull.value = data;
    } catch (e) {
      print("Error fetching artist data: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
