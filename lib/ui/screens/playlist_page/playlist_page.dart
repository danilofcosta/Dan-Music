import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:palette_generator/palette_generator.dart';

import 'package:danmusic/ui/screens/playlist_page/playlist_controller.dart';
import 'package:danmusic/services/uteis/load_image.dart';
import 'package:danmusic/ui/widgets/ui/song_ui.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({super.key});
  static const routeName = '/playlist';

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  // ==============================
  // STATE
  // ==============================
  Color _dominantColor = Colors.black;
  ImageProvider? _lastProvider;

  // ==============================
  // HELPERS
  // ==============================
  Future<void> _updatePalette(String imagePath) async {
    final provider = LoadImage.loadProvider(imagePath);
    if (provider == null || provider == _lastProvider) return;

    _lastProvider = provider;

    final palette = await PaletteGenerator.fromImageProvider(provider);

    if (!mounted) return;

    setState(() {
      _dominantColor =
          palette.dominantColor?.color.withValues(alpha: 9.1) ?? Colors.black;
    });
  }

  // List<String> _generateFallback() => List.generate(20, (i) => 'Item ${i + 1}');

  // ==============================
  // BUILD
  // ==============================
  @override
  Widget build(BuildContext context) {
    final tag = widget.key.hashCode.toString();

    final controller = (Get.isRegistered<PlaylistController>(tag: tag))
        ? Get.find<PlaylistController>(tag: tag)
        : Get.put(PlaylistController(), tag: tag);

    return Scaffold(
      backgroundColor: _dominantColor.withValues(alpha: 0.7),
      // appBar: AppBar(title: const Text('Playlist')),
      body: Obx(() {
        final thumb = controller.playlistfull.value.thumbnails.isEmpty
            ? controller.playlist.value.thumbnails.first
            : controller.playlistfull.value.thumbnails.last;

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              pinned: true,
              stretch: true,
              expandedHeight: 300,
              backgroundColor: _dominantColor,
              title: Text(
                controller.playlist.value.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Builder(
                      builder: (_) {
                        _updatePalette(thumb);
                        return LoadImage.loadWidget(thumb, fit: BoxFit.cover);
                      },
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            _dominantColor.withValues(alpha: 0.7),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // =================================
            // HEADER INFO
            // =================================
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.playlist.value.title,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.playlistfull.value.desciption,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        FilledButton.icon(
                          onPressed: controller.playplaylist,
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Tocar Playlist'),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.favorite_border),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // =================================
            // TRACK LIST (ANIMATED)
            // =================================
            Obx(() {
              final tracks = controller.playlistfull.value.tracks ?? [];

              if (tracks.isEmpty) {
                //  final fallback = _generateFallback();
                // return SliverList(
                //   delegate: SliverChildBuilderDelegate(
                //     (context, index) => ListTile(
                //       leading: const Icon(Icons.music_note),
                //       title: Text(fallback[index]),
                //     ),
                //     childCount: fallback.length,
                //   ),
                // );
                return SliverToBoxAdapter(child: SizedBox.shrink());
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final track = tracks[index];

                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: Duration(milliseconds: 250 + index * 35),
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 16 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: SongUi(song: track),
                  );
                }, childCount: tracks.length),
              );
            }),
          ],
        );
      }),
    );
  }
}
