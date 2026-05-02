import 'package:danmusic/services/uteis/helper.dart';
import 'package:get/get.dart';

import '../../../models/home_section.dart';
import '../../../services/uteis/greeting.dart';
import '../../../services/yt_api.dart';

class HomeScreenController extends GetxController {
  final YouTubeMusicService youTubeService = Get.find<YouTubeMusicService>();

  final RxString greeting = 'Welcome back'.obs;
  final RxList<HomeSection> homeSection = <HomeSection>[].obs;

  // Cache
  List<HomeSection>? _cachedHomeSections;

  @override
  void onInit() {
    super.onInit();
    greeting.value = getGreeting();
    initYouTubeMusicService();
  }

  Future<void> initYouTubeMusicService() async {
//    await youTubeService.init();
    getHomeSections();
  }

  Future<void> getHomeSections() async {
    // Retorna cache se existir
    if (_cachedHomeSections != null) {
      homeSection.assignAll(_cachedHomeSections!);
      return;
    }

    try {
      final temp = await youTubeService.getHome();
      if (temp == null || temp.isEmpty) return; // TODO: tratar erro
      
      _cachedHomeSections = temp;
      homeSection.assignAll(temp);
    } catch (error, stackTrace) {
      printErrorDebug('Erro ao acessar a API: $error');
      printErrorDebug(stackTrace);
    }
  }
}
