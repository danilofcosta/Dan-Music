import 'package:audio_service/audio_service.dart';
import 'package:danmusic/app.dart';
import 'package:danmusic/provaders/confing_css.dart';
import 'package:danmusic/provaders/player_provider.dart';
import 'package:danmusic/services/globais_vars.dart';
import 'package:danmusic/services/manage_audio/audio_handler.dart';
import 'package:danmusic/services/ytmusicapi.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  audioHandler = await AudioService.init(
    builder: () => MyAudioHandler(),
    config: AudioServiceConfig(
      androidNotificationChannelId: 'com.mycompany.myapp.channel.audio',
      androidNotificationChannelName: 'Music playback',
    ),
  );
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