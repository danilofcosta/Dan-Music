import 'package:danmusic/services/yt_api.dart';
import 'package:danmusic/ui/screens/player/player_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'app.dart';
import 'services/manager_audio/audio_handler.dart';
import 'ui/screens/album/album_controller.dart';
import 'ui/screens/artist/artist_cotroller.dart';
import 'ui/screens/current_playlist/current_playlist_controller.dart';
import 'ui/screens/home/home_screen_controller.dart';
import 'ui/screens/playlist/playlist_controller.dart';
import 'ui/screens/search/seach_controller_result.dart';
import 'ui/screens/search/search_controller.dart';

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
  Get.lazyPut(() => AlbumController(), fenix: true);
  Get.lazyPut(() => ArtistCotroller(), fenix: true);
  Get.lazyPut(() => PlaylistController(), fenix: true); 
   Get.lazyPut(() => SearchResultsController(), fenix: true);
   Get.lazyPut(() => SearchResultsController(), fenix: true);
   Get.lazyPut(() => SearchController(), fenix: true);
   Get.lazyPut(() => CurrentPlaylistController(), fenix: true);


 
  Get.put(PlayerController(), permanent: true);
}
