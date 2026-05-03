import 'package:danmusic/models/song.dart';
import 'package:danmusic/ui/widgets/cards/card_medio.dart';
import 'package:danmusic/ui/widgets/cards/song_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/manager_audio/download.dart';
import '../../services/uteis/load_image.dart';
import '../screens/player/player_controller.dart';

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
  final ScrollController _scrollController = ScrollController();
  bool _showFab = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;
      final shouldShow = currentScroll > maxScroll * 0.2;
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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.grey.shade900,
            Colors.black,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: AnimatedSlide(
          offset: _showFab ? Offset.zero : const Offset(0, 2),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          child: AnimatedOpacity(
            opacity: _showFab ? 1 : 0,
            duration: const Duration(milliseconds: 300),
            child: FloatingActionButton(
              onPressed: _scrollToTop,
              heroTag: 'scrollTop_${widget.title}',
              backgroundColor: const Color(0xFF1DB954),
              foregroundColor: Colors.white,
              elevation: 8,
              child: const Icon(Icons.keyboard_arrow_up),
            ),
          ),
        ),
        body: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            // APP BAR
            SliverAppBar(
              pinned: true,
              stretch: true,
              expandedHeight: 320,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Thumbnail image
                    Hero(
                      tag: widget.thumb,
                      child: LoadImage.loadWidget(
                        widget.thumb,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Gradient overlays
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.center,
                          colors: [
                            Colors.black.withValues(alpha: 0.4),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.center,
                          colors: [
                            Colors.black.withValues(alpha: 0.95),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    // Play button overlay
                    Center(
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1DB954),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: () {
                            final controller = Get.find<PlayerController>();
                            controller.uploadQuere(widget.tracks);
                          },
                          icon: const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // HEADER INFO
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    if (widget.description != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        widget.description!,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              final controller = Get.find<PlayerController>();
                              controller.uploadQuere(widget.tracks);
                            },
                            icon: const Icon(Icons.play_arrow, size: 20),
                            label: const Text('Reproduzir'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1DB954),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                            ),
                          ),
                          child: IconButton(
                            onPressed: () async {
                              // await AudioDownloader.audioDownloaderList(
                              //   widget.tracks.map((e) => e.id).toList(),
                              // );
                            },
                            icon: const Icon(Icons.download, size: 20),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        '${widget.tracks.length} faixas',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // TRACK LIST
            if (widget.tracks.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.music_off,
                          size: 64,
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhuma faixa encontrada.',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final track = widget.tracks[index];
                    return TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: Duration(milliseconds: 300 + (index * 30).clamp(0, 500)),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: SongCard(song: track, index: index + 1),
                    );
                  }, childCount: widget.tracks.length),
                ),
              ),

            // RECOMENDADOS
            if (hasRecommendations) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
                  child: Row(
                    children: [
                      Text(
                        'Recomendados',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 220,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemCount: widget.relatedRecommendations!.length,
                    itemBuilder: (context, index) {
                      final related = widget.relatedRecommendations![index];
                      return SizedBox(
                        width: 140,
                        child: CardMedio(
                          image: related.thumbnails.last.url,
                          title: related.title,
                          subtitle: related.artist?.name ?? '',
                          object: related,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],

            // Espaço inferior para o mini player
            const SliverToBoxAdapter(child: SizedBox(height: 110)),
          ],
        ),
      ),
    );
  }
}
