import 'package:audio_service/audio_service.dart';
import '/provaders/player_provider.dart';
import '/services/globais_vars.dart';
import '/services/manage_audio/audio_handler.dart';
import '/services/uteis/load_image.dart';
import '/widgets/ui/text_conf_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({super.key});

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerProvider>(
      builder: (context, player, _) {
        MediaItem? mediaItemNow = player.songNow;
        return AnimatedContainer(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Theme.of(
              context,
            ).scaffoldBackgroundColor.withValues(alpha: 0.6),
          ),
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          duration: const Duration(milliseconds: 300),
          child: ListTile(
            onTap: () => Navigator.of(context).pushNamed('/player'),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: LoadImage.loadWidget(
                mediaItemNow?.artUri?.toString() ?? '',
                width: 50,
                height: 50,
                errorBuildericon: Icons.music_note_outlined,
              ),
            ),
            title: TextUi(
              mediaItemNow?.title ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: TextUi(mediaItemNow?.artist ?? ''),
            trailing: IconButton(
              icon: const Icon(Icons.skip_next),
              onPressed: () => audioHandler.skipToNext(),
            ),
          ),
        );
      },
    );
  }
}
