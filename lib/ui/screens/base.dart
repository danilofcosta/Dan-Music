import 'package:danmusic/models/song.dart';
import 'package:danmusic/services/uteis/helper.dart';
import 'package:danmusic/ui/widgets/card_medio.dart';
import 'package:danmusic/ui/widgets/cards/song_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/uteis/load_image.dart';
import '../../services/uteis/update_papilite.dart';
import 'player/player_controller.dart';
import 'player/widgets_player/animated_play_button.dart';

class BaseScreen extends StatefulWidget {
  final String thumb;
  final String title;
  final String? description;
  final List<Song> tracks;
  final List? relatedRecommendations;

  const BaseScreen({
    super.key,
    required this.thumb,
    required this.title,
    required this.description,
    required this.tracks,
    this.relatedRecommendations,
  });

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  Color _dominantColor = const Color.fromARGB(255, 7, 7, 7);

  final ScrollController _scrollController = ScrollController();
  bool _showFab = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;

      final shouldShow = currentScroll > maxScroll * 0.2;
      // printInfoDebug("Current Scroll: $currentScroll");
      // printInfoDebug("Max Scroll: $maxScroll");

      if (shouldShow != _showFab) {
        if (!mounted) return;
        setState(() => _showFab = shouldShow);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _updatePalette(String imagePath) async {
    if (!mounted) return;
    final dominantColor = await updatePalette(imagePath);
    if (!mounted) return;
    setState(() => _dominantColor = dominantColor);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updatePalette(widget.thumb);
  }

  bool get hasRecommendations =>
      widget.relatedRecommendations != null &&
      widget.relatedRecommendations!.isNotEmpty;

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PlayerController>();
    return Scaffold(
      floatingActionButton: AnimatedScale(
        scale: _showFab ? 1 : 0,
        //   scale: 1,
        duration: const Duration(milliseconds: 200),
        child: FloatingActionButton.extended(
          onPressed: _scrollToTop,
          label: const Icon(Icons.keyboard_arrow_up),
          // label: const Text("Topo"),
        ),
      ),
      backgroundColor: _dominantColor.withValues(alpha: 0.7),
      body: CustomScrollView(
        controller: _scrollController,
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
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      top: 80,
                    ),
                    child: LoadImage.loadWidget(
                      widget.thumb,
                      fit: BoxFit.contain,
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
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
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
                  Obx(() {
                    // Força a reatividade quando a música muda
                    // ignore: unused_local_variable
                    final dummy = controller.songNow.value;
                    final isCurrentQueue =
                        controller.audioHandler.queue.value == widget.tracks;

                    return Row(
                      children: [
                        FilledButton.icon(
                          onPressed: () async {
                            await controller.uploadQuere(widget.tracks);
                          },
                          style: Theme.of(context)
                              .filledButtonTheme
                              .style
                              ?.copyWith(
                                  elevation: WidgetStateProperty.all(7.0)),
                          icon: isCurrentQueue
                              ? const SizedBox.shrink()
                              : const Icon(Icons.play_arrow),
                          label: isCurrentQueue
                              ? const AnimatedPlayButton(iconSize: 32)
                              : Text(
                                  'Tocar Playlist',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                          autofocus: true,
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.favorite_border),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),

          // ===========================
          // TRACK LIST
          // ===========================
          if (widget.tracks.isEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: Text('Nenhuma faixa encontrada.')),
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
                  child: SongCard(song: track, index: index + 1),
                );
              }, childCount: widget.tracks.length),
            ),

          // ===========================
          // RECOMENDADOS
          // ===========================
          if (hasRecommendations) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Text(
                  'Recomendados',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: widget.relatedRecommendations!.length,
                  itemBuilder: (context, index) {
                    final related = widget.relatedRecommendations![index];
                    return CardMedio(
                      image: related.thumbnails.last.url,
                      title: related.title,
                      subtitle: related.artist?.name ?? '',
                      object: related,
                    );
                  },
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
