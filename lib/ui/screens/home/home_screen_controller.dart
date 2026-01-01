import 'package:get/get.dart';

import '../../../models/home_section.dart';
import '../../../services/greeting.dart';
import '../../../services/yt_api.dart';

class HomeScreenController extends GetxController {
  final YouTubeMusicService youTubeService = Get.find<YouTubeMusicService>();

  final RxString greeting = 'Welcome back'.obs;
  final RxList<HomeSection> homeSection = <HomeSection>[].obs;

  @override
  void onInit() {
    super.onInit();
    greeting.value = getGreeting();
    initYouTubeMusicService();
  }

  Future<void> initYouTubeMusicService() async {
    await youTubeService.init();
    getHomeSections();
  }

  Future<void> getHomeSections() async {
    final temp = await youTubeService.getHome();
    homeSection.addAll(temp);
  }
}
