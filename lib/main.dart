import 'package:audio_service/audio_service.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/app.dart';
import '/provaders/confing_css.dart';
import 'ui/screens/player_page/player_controller.dart';
import '/services/manage_audio/audio_handler.dart';
import '/services/ytmusicapi.dart';
import 'ui/screens/album_page/album_controller.dart';
import 'ui/screens/fila_player/fila_controller.dart';
import 'ui/screens/search_page/search_page_controler.dart';
import '/ui/screens/home_page/home_controller.dart';
import 'ui/screens/artist_page/artist_controller.dart';
import 'ui/screens/playlist_page/playlist_controller.dart';

Future<void> main() async {
  // runApp(init);
  WidgetsFlutterBinding.ensureInitialized();
  // runApp(init);

  Get.put<AudioHandler>(await initAudioService(), permanent: true);
  await YouTubeMusicService.init();
  await startApplicationServices();
  runApp(MyApp());
}
//!D/BufferPoolAccess , !D/CCodecBuffers  , !D/AudioTrack  ,!I/CCodecConfig(  , !W/Codec2Client( ,!D/CCodecConfig(

Future<void> startApplicationServices() async {
  Get.lazyPut(() => PlayerController(), fenix: true);
  Get.lazyPut(() => PlaylistController(), fenix: true);
  Get.lazyPut(() => SearchPageController(), fenix: true);
  Get.lazyPut(() => ArtistController(), fenix: true);
  Get.lazyPut(() => AlbumController(), fenix: true);
  Get.lazyPut(() => FilaController(), fenix: true);
  Get.lazyPut(() => HomeController(), fenix: true);
  Get.lazyPut(() => ConfigCss(), fenix: true);
}

Widget init = Scaffold(
  body: Container(
    // duration: Duration(seconds: 2),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      image: DecorationImage(
        image: NetworkImage(
          'https://i.pinimg.com/736x/c3/ac/e0/c3ace0cb123506f8bea38a07ac4e5180.jpg',
        ),
        fit: BoxFit.fill,
      ),
    ),
    child: Text('Carregando...'),
  ),
);
