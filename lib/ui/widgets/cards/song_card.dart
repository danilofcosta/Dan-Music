import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/song.dart';
import '../../screens/player/player_controller.dart';
import 'equalizer_icon.dart';

class SongCard extends StatefulWidget {
  final Song song;
  final int? index;
  final Function()? onTap;

  const SongCard({super.key, required this.song, this.index, this.onTap});

  @override
  State<SongCard> createState() => _SongCardState();
}

class _SongCardState extends State<SongCard> {
  Widget _placeholder() => Container(
        color: Colors.grey.shade800,
        child: const Icon(Icons.music_note, color: Colors.white24, size: 22),
      );

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final controller = Get.find<PlayerController>();
      final song = widget.song;
      final isPlaying = controller.songNow.value.id == widget.song.id;

      return AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isPlaying
              ? Colors.white.withValues(alpha: 0.12)
              : Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isPlaying
                ? Colors.white.withValues(alpha: 0.25)
                : Colors.white.withValues(alpha: 0.06),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 28,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: isPlaying
                              ? const EqualizerIcon(key: ValueKey('eq'))
                              : Text(
                                  widget.index != null
                                      ? '${widget.index! + 1}'
                                      : '',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.4),
                                    fontSize: 13,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          width: 46,
                          height: 46,
                          child: song.artUri != null
                              ? Image.network(
                                  song.artUri.toString(),
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => _placeholder(),
                                )
                              : _placeholder(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 300),
                              style: TextStyle(
                                color: isPlaying
                                    ? Colors.white
                                    : Colors.white.withValues(alpha: 0.85),
                                fontSize: 14,
                                fontWeight: isPlaying
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                              child: Text(
                                song.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (song.artist != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                song.artist!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.5),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (song.durationText != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            song.durationText!,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.38),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.white.withValues(alpha: 0.38),
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      if (widget.onTap != null) {
                        widget.onTap!();
                        return;
                      }
                      controller.playById(song);
                    },
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
