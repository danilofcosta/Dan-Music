import 'package:audio_service/audio_service.dart';
import 'package:danmusic/services/globais_vars.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  final item = MediaItem(
    id: 'https://luan.xyz/files/audio/ambient_c_motion.mp3',
    album: 'Album name',
    title: 'Track title',
    artist: 'Artist name',
    artUri: Uri.parse(
      'https://i.pinimg.com/1200x/9f/4d/16/9f4d16c85b6a0064166f426c48e7811a.jpg',
    ),
  );

  @override
  void initState() {
    super.initState();
    // audioHandler.playMediaItem(item); // toca automaticamente ao abrir
  }

  Widget _buildCover(MediaItem? mediaItem) {
    final url = mediaItem?.artUri?.toString() ?? "";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: CachedNetworkImage(
        imageUrl: url,
        height: 340,
        width: 340,
        //fit: BoxFit.contain,
        fadeInDuration: const Duration(milliseconds: 150),
        fadeOutDuration: const Duration(milliseconds: 150),
        imageBuilder: (_, img) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),

            image: DecorationImage(image: img, fit: BoxFit.cover),
          ),
        ),
        placeholder: (_, _) => const SizedBox(
          height: 300,
          width: 300,
          child: Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (_, _, _) => Container(
          height: 300,
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey.shade900,
          ),
          child: const Icon(Icons.music_note, size: 80),
        ),
      ),
    );
  }

  Widget _buildProgressBar(PlaybackState state) {
    final pos = state.updatePosition;
    final dur = audioHandler.mediaItem.value?.duration ?? Duration.zero;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(_fmt(pos)), Text(_fmt(dur))],
          ),
        ),
      ],
    );
  }

  String _fmt(Duration d) {
    String two(int n) => n.toString().padLeft(2, "0");
    final m = two(d.inMinutes.remainder(60));
    final s = two(d.inSeconds.remainder(60));
    return "$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Player")),
      body: StreamBuilder<MediaItem?>(
        stream: audioHandler.mediaItem,
        builder: (context, mediaSnap) {
          final media = mediaSnap.data ?? item;

          return StreamBuilder<PlaybackState>(
            stream: audioHandler.playbackState,
            builder: (context, playSnap) {
              final state = playSnap.data ?? PlaybackState();
              final playing = state.playing;

              return Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 30),

                    // CAPA
                    _buildCover(media),

                    const SizedBox(height: 30),

                    // TÍTULO
                    Text(
                      media.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // ARTISTA
                    Text(
                      media.artist ?? "Artista desconhecido",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),

                    const SizedBox(height: 20),

                    // BARRA DE PROGRESSO
                    _buildProgressBar(state),

                    const SizedBox(height: 20),

                    // BOTÕES
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          iconSize: 42,
                          color: Colors.white,
                          icon: const Icon(Icons.skip_previous),
                          onPressed: audioHandler.skipToPrevious,
                        ),
                        const SizedBox(width: 20),

                        IconButton(
                          iconSize: 60,
                          color: Colors.white,
                          icon: Icon(
                            playing ? Icons.pause_circle : Icons.play_circle,
                          ),
                          onPressed: () {
                            playing
                                ? audioHandler.pause()
                                : audioHandler.play();
                          },
                        ),

                        const SizedBox(width: 20),

                        IconButton(
                          iconSize: 42,
                          color: Colors.white,
                          icon: const Icon(Icons.skip_next),
                          onPressed: audioHandler.skipToNext,
                        ),
                      ],
                    ),

                    const Spacer(),

                    // ADICIONAR À FILA
                    ElevatedButton.icon(
                      onPressed: () => audioHandler.addQueueItem(media),
                      icon: const Icon(Icons.add),
                      label: const Text("Adicionar à fila"),
                    ),

                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/fileplayer'),
                      icon: const Icon(Icons.list_alt),
                      label: const Text("fileplayer"),
                    ),
                    const Spacer(),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
