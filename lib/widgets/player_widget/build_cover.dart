import 'package:audio_service/audio_service.dart';
import '/provaders/player_provider.dart';
import '/services/uteis/load_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuildCover extends StatelessWidget {
  const BuildCover({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<PlayerProvider>(
      builder: (context, player, _) {
        MediaItem? mediaItemNow = player.songNow;

        return mediaItemNow?.artUri?.toString() != null
            ? Card(
                elevation: 8.0,
                child: Container(
                  width: size.width * 0.8,
                  height: size.width * 0.8,

                  // margin: const EdgeInsets.all(8.0),
                  // foregroundDecoration: BoxDecoration(),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      //  alignment: Alignment.center,
                      fit: BoxFit.cover,
                      image:
                          LoadImage.loadProvider(
                                mediaItemNow?.artUri?.toString() ?? '',
                              )
                              as ImageProvider,
                    ),
                  ),
                ),
              )
            : Container(
                width: size.width * 0.8,
                height: size.width * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Theme.of(
                    context,
                  ).scaffoldBackgroundColor.withValues(alpha: 0.6),
                ),
                child: Center(
                  child: Icon(
                    Icons.music_note_outlined,
                    size: size.width * 0.4,
                    color: Colors.white,
                  ),
                ),
              );
      },
    );
  }
}
