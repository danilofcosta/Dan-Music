import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import '/app.dart';
import '/provaders/confing_css.dart';
import 'provaders/player_controller.dart';
import '/services/manage_audio/audio_handler.dart';
import '/services/ytmusicapi.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
   Get.put<AudioHandler>(await initAudioService(), permanent: true);

  await YouTubeMusicService.init();
  await startApplicationServices();
  runApp(
    MultiProvider(
      providers: [
      //  ChangeNotifierProvider(create: (_) => PlayerProvider()),
        ChangeNotifierProvider(create: (_) => ConfingCss()),
      ],
      child: const MyApp(),
    ),
  );
}
//!D/BufferPoolAccess , !D/CCodecBuffers  , !D/AudioTrack  ,!I/CCodecConfig(  , !W/Codec2Client( ,!D/CCodecConfig(7



Future<void> startApplicationServices() async {
  Get.lazyPut(() => PlayerController(), fenix: true);
 
}