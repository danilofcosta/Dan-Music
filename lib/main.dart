import 'package:audio_service/audio_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter_new_pipe_extractor/flutter_new_pipe_extractor.dart';
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
  runApp(MyWidget());
  WidgetsFlutterBinding.ensureInitialized();
  // //runApp(init);

  Get.put<AudioHandler>(await initAudioService(), permanent: true);
  await YouTubeMusicService.init();
  await NewPipeExtractor.init();
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

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(); // animação infinita
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle:0,
          child: child,
        );
      },
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              'https://i.pinimg.com/1200x/15/62/5a/15625aec290c33d31b935c10c42ff0b1.jpg',
            ),
            fit: BoxFit.cover,
          ),
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Image.network(
          'https://i.pinimg.com/1200x/15/62/5a/15625aec290c33d31b935c10c42ff0b1.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
