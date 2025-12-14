import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:palette_generator/palette_generator.dart';

import 'package:danmusic/services/uteis/load_image.dart';
import 'package:danmusic/ui/screens/album_page/album_controller.dart';
import 'package:danmusic/ui/widgets/ui/song_ui.dart';

class AlbumPage extends StatefulWidget {
  const AlbumPage({super.key});

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  // ==============================
  // STATE
  // ==============================
  Color _dominantColor = Colors.black;
  ImageProvider? _lastProvider;

  // ==============================
  // PALETTE HELPER
  // ==============================
  Future<void> _updatePalette(String imagePath) async {
    final provider = LoadImage.loadProvider(imagePath);
    if (provider == null || provider == _lastProvider) return;

    _lastProvider = provider;

    final palette = await PaletteGenerator.fromImageProvider(provider);

    if (!mounted) return;

    setState(() {
      _dominantColor = palette.dominantColor?.color ?? Colors.black;
    });
  }

  // ==============================
  // BUILD
  // ==============================
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AlbumController>();

    return Obx(() {
      final album = controller.album.value;
      final thumb = album.thumbnails.isNotEmpty ? album.thumbnails.last : '';

      return Scaffold(
        backgroundColor: _dominantColor.withValues(alpha: 0.5),
        // appBar: AppBar(title: const Text('Album')),
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // =================================
            // SLIVER APP BAR (ALBUM)
            // =================================
            SliverAppBar(
              pinned: true,
              stretch: true,
              expandedHeight: 300,
              backgroundColor: _dominantColor.withValues(alpha: 0.2),
              title: Text(
                album.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
                            _dominantColor.withValues(alpha: 0.9),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // =================================
            // ALBUM INFO
            // =================================
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      album.name,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      album.artist,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Reproduzir'),
                    ),
                  ],
                ),
              ),
            ),

            // =================================
            // TRACK LIST (ANIMATED)
            // =================================
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final song = album.songs[index];

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
                  child: SongUi(mediaItem: song, index: index + 1),
                );
              }, childCount: album.songs.length),
            ),
          ],
        ),
      );
    });
  }
}
