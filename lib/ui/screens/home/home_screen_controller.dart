import 'package:get/get.dart';

import '../../../services/greeting.dart';
import '../../../services/yt_api.dart';

class HomeScreenController extends GetxController {
  final controller = Get.find<YouTubeMusicService>();

  final greeting = 'welcome to back'.obs;

  @override
  void onInit() {
    super.onInit();
    greeting.value = getGreeting();
    initYouTubeMusicService();

  }

  void initYouTubeMusicService() async {
    await controller.init();
    controller.getHome();

  }
}
