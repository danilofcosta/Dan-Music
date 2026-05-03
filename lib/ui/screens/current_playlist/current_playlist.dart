import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/song.dart';
import '../../widgets/cards/equalizer_icon.dart';
import 'current_playlist_controller.dart';

class CurrentPlaylist extends GetView<CurrentPlaylistController> {
  const CurrentPlaylist({super.key});
  static const String routeName = '/current_playlist';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey.shade900, Colors.black],
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
          child: SafeArea(
            child: Column(
              children: [
                // ── Header ────────────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                      ),
                      const Expanded(
                        child: Text(
                          'CURRENT PLAYLIST',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xB3FFFFFF),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      Obx(() => IconButton(
                        onPressed: controller.shuffle,
                        icon: Icon(
                          Icons.shuffle,
                          color: controller.isShuffled.value
                              ? Colors.white
                              : Colors.white38,
                        ),
                      )),
                    ],
                  ),
                ),

                // ── Now-playing banner (reativo) ──────────────────────────────
                Obx(() {
                  final playlist = controller.playlist;
                  final idx = controller.currentIndexObs.value;
                  final hasSong = playlist.isNotEmpty && idx < playlist.length;
                  final currentSong = hasSong
                      ? Song.fromMediaItem(playlist[idx])
                      : null;

                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder: (child, anim) => FadeTransition(
                      opacity: anim,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, -0.15),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
                        child: child,
                      ),
                    ),
                    child: currentSong == null
                        ? const SizedBox.shrink(key: ValueKey('empty-banner'))
                        : Padding(
                            key: ValueKey('banner-${currentSong.id}'),
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.14),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const EqualizerIcon(),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              currentSong.title,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            if (currentSong.artist != null)
                                              Text(
                                                currentSong.artist!,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Colors.white.withValues(alpha: 0.55),
                                                  fontSize: 11,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        '${playlist.length} músicas',
                                        style: TextStyle(
                                          color: Colors.white.withValues(alpha: 0.45),
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                  );
                }),

                const SizedBox(height: 8),

                // ── Track list (reativo) ───────────────────────────────────────
                Expanded(
                  child: Obx(() {
                    final playlist = controller.playlist;
                    final currentIdx = controller.currentIndexObs.value;

                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder: (child, anim) => FadeTransition(
                        opacity: anim,
                        child: child,
                      ),
                      child: playlist.isEmpty
                          ? _EmptyState(key: const ValueKey('empty-list'))
                          : ListView.builder(
                              key: const ValueKey('track-list'),
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                              itemCount: playlist.length,
                              itemBuilder: (context, index) {
                                final song = Song.fromMediaItem(playlist[index]);
                                return PlaylistTile(
                                  key: ValueKey('tile-${song.id}-$index'),
                                  song: song,
                                  index: index,
                                  isPlaying: index == currentIdx,
                                  onTap: () => controller.ontap(index),
                                );
                              },
                            ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Empty state ────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.queue_music,
            size: 64,
            color: Colors.white.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhuma música na fila',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Playlist tile ──────────────────────────────────────────────────────────────

class PlaylistTile extends StatelessWidget {
  final Song song;
  final int? index;
  final bool isPlaying;
  final VoidCallback? onTap ;

  const PlaylistTile({
    Key? key,
    required this.song,
    required this.index,
    required this.isPlaying,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
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
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  // Index / equalizer
                  SizedBox(
                    width: 28,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: isPlaying == true && index == null
                          ? const EqualizerIcon(key: ValueKey('eq'))
                          : Text(
                              '${index! + 1}',
                              key: const ValueKey('num'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.4),
                                fontSize: 13,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Cover art
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      width: 46,
                      height: 46,
                      child: song.artUri != null
                          ? Image.network(
                              song.artUri.toString(),
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => placeholder(),
                            )
                          : placeholder(),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Title + artist
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

                  // Duration
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
        ),
      ),
    );
  }

 
}

 Widget placeholder() => Container(
        color: Colors.grey.shade800,
        child: const Icon(Icons.music_note, color: Colors.white24, size: 22),
      );