import 'package:get/get.dart';

import '../../../models/artist.dart';
import '../../../services/yt_api.dart';

class ArtistCotroller extends GetxController {
  final YouTubeMusicService youTubeService = Get.find<YouTubeMusicService>();

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as List;
    final ArtistDetail? artistDetail = args[1];
    final artistid = args[0];
    featdata(artistDetail!, artistid);
  }

  void featdata(ArtistDetail artistDetail, String artistid) async {
    var data = await youTubeService.getartistFull(artistid);
    print("featdata");
  }
}
