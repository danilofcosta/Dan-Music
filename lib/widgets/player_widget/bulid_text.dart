import 'package:audio_service/audio_service.dart';
import 'package:danmusic/provaders/player_provider.dart';
import 'package:danmusic/widgets/ui/text_conf_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BulidText extends StatelessWidget {
  const BulidText({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerProvider>(
      builder: (context, player, _) {
        MediaItem? mediaItemNow = player.songNow;
        return Container(
          margin: const EdgeInsets.all(8.0),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Theme.of(
              context,
            ).scaffoldBackgroundColor.withValues(alpha: 0.2),
          ),
          child: Column(
            children: [
              TextUi(
                mediaItemNow?.title ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize,
                ),
              ),
              ?mediaItemNow?.artist == null
                  ? null
                  : TextUi(
                      mediaItemNow?.artist ?? '',
                      style: TextStyle(
                        fontSize: Theme.of(
                          context,
                        ).textTheme.headlineSmall!.fontSize,
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }
}
