import 'package:danmusic/services/yt_api.dart';
import 'package:danmusic/ui/screens/player/player_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'app.dart';
import 'services/manager_audio/audio_handler.dart';
import 'ui/screens/home/home_screen_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put<MyAudioHandler>(await initAudioService(), permanent: true);
  final youTubeMusicService = YouTubeMusicService();
  await youTubeMusicService.init();
  Get.put<YouTubeMusicService>(youTubeMusicService, permanent: true);
  await startApplicationServices();

  runApp(MyApp());
}

Future<void> startApplicationServices() async {
  Get.lazyPut(() => HomeScreenController(), fenix: true);
  // Tornar o PlayerController permanente para evitar problemas de dispose
  Get.put(PlayerController(), permanent: true);
}
