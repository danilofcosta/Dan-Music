import 'package:danmusic/models/song.dart';
import 'package:danmusic/ui/widgets/cards/song_card.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

import '../../services/uteis/load_image.dart';
import '../../services/uteis/update_papilite.dart';

class BaseScreen extends StatefulWidget {
  final String thumb;
  final String title;
  final String? description;
  final List<Song> tracks;

  const BaseScreen({
    super.key,
    required this.thumb,
    required this.title,
    required this.description,
    required this.tracks,
  });

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  Color _dominantColor = const Color.fromARGB(255, 7, 7, 7);
  ImageProvider? _lastProvider;

  Future<void> _updatePalette(String imagePath) async {
    if (!mounted) return;
    final dominantColor = await updatePalette(imagePath);
    setState(() {
      _dominantColor = dominantColor;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updatePalette(widget.thumb);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _dominantColor.withValues(alpha: 0.7),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ===========================
          // APP BAR
          // ===========================
          SliverAppBar(
            pinned: true,
            stretch: true,
            expandedHeight: 300,
            backgroundColor: _dominantColor,
            title: Text(
              widget.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      top: 80,
                    ),
                    child: Builder(
                      builder: (_) {
                        return LoadImage.loadWidget(
                          widget.thumb,
                          fit: BoxFit.contain,
                        );
                      },
                    ),
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

          // ===========================
          // HEADER INFO
          // ===========================
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (widget.description != null)
                    SizedBox(
                      height: 30,
                      child: SingleChildScrollView(
                        child: Text(widget.description!),
                      ),
                    ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      FilledButton.icon(
                        onPressed: () {},
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

          // ===========================
          // TRACK LIST
          // ===========================
          if (widget.tracks.isEmpty)
            const SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('Nenhuma faixa encontrada.'),
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final track = widget.tracks[index];

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
                  child: SongCard(song: track),
                );
              }, childCount: widget.tracks.length),
            ),
        ],
      ),
    );
  }
}
