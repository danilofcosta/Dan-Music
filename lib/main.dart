
import '/app.dart';
import '/provaders/confing_css.dart';
import '/provaders/player_provider.dart';
import '/services/globais_vars.dart';
import '/services/manage_audio/audio_handler.dart';
import '/services/ytmusicapi.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  audioHandler = await initAudioService();

  await YouTubeMusicService.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PlayerProvider()),
        ChangeNotifierProvider(create: (_) => ConfingCss()),
      ],
      child: const MyApp(),
    ),
  );
}
//!D/BufferPoolAccess , !D/CCodecBuffers  , !D/AudioTrack  ,!I/CCodecConfig(  , !W/Codec2Client( ,!D/CCodecConfig(