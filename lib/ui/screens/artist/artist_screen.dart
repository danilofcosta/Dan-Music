import 'package:danmusic/ui/screens/artist/artist_cotroller.dart';
import 'package:danmusic/ui/widgets/buid_list_horizotal.dart';
import 'package:danmusic/ui/widgets/card_medio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/uteis/load_image.dart';
import '../../../services/uteis/update_papilite.dart';

class ArtistScreen extends StatefulWidget {
  const ArtistScreen({super.key});
  static const routeName = '/artist';
  @override
  State<ArtistScreen> createState() => _ArtistScreenState();
}

class _ArtistScreenState extends State<ArtistScreen> {
  Color _dominantColor = const Color.fromARGB(255, 7, 7, 7);
  String? _currentImg;

  void _updateDominantColor(String img) async {
    if (_currentImg == img) return;
    _currentImg = img;
    final color = await updatePalette(img);
    if (mounted) {
      setState(() {
        _dominantColor = color;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tag = hashCode.toString();

    final controller = (Get.isRegistered<ArtistCotroller>(tag: tag))
        ? Get.find<ArtistCotroller>(tag: tag)
        : Get.put(ArtistCotroller(), tag: tag);

    return Scaffold(
      backgroundColor: _dominantColor.withValues(alpha: 0.5),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final artist = controller.artistFull.value;
        if (artist == null) {
          return const Center(child: Text('Artista não encontrado'));
        }

        if (artist.thumbnails != null && artist.thumbnails!.isNotEmpty) {
          _updateDominantColor(artist.thumbnails!.last.url);
        }

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              // pinned: true,
              stretch: true,
              expandedHeight: 300,
              //   floating: true,
              backgroundColor: _dominantColor,
              title: Text(
                artist.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (artist.thumbnails != null &&
                        artist.thumbnails!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 16,
                          left: 16,
                          right: 16,
                          top: 80,
                        ),
                        child: LoadImage.loadWidget(
                          artist.thumbnails!.last.url,
                          fit: BoxFit.contain,
                          errorBuildericon: Icons.person,
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

            // Infos do artista
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(16),
                color: _dominantColor.withValues(alpha: 0.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      artist.name,
                      style: const TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    if (artist.subscribers != null)
                      Text(
                        '${artist.subscribers} inscritos',
                        style: const TextStyle(color: Colors.white70),
                      ),
                  ],
                ),
              ),
            ),

            // Músicas
            if (artist.songs != null && artist.songs!.isNotEmpty)
              SliverToBoxAdapter(
                child: BuidListHorizotal(
                  title: 'Músicas',
                  songs: artist.songs!,
                ),
              ),

            // Álbuns
            if (artist.albums != null && artist.albums!.isNotEmpty) ...[
              _buildSectionTitle('Álbuns'),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: artist.albums!.length,
                    itemBuilder: (context, index) {
                      final album = artist.albums![index];
                      return CardMedio(
                        image: album.thumbnails?.last.url ?? '',
                        title: album.title,
                        subtitle: album.year ?? '',
                        object: album,
                      );
                    },
                  ),
                ),
              ),
            ],

            // Singles
            if (artist.singles != null && artist.singles!.isNotEmpty) ...[
              _buildSectionTitle('Singles'),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: artist.singles!.length,
                    itemBuilder: (context, index) {
                      final single = artist.singles![index];
                      return CardMedio(
                        image: single.thumbnails?.last.url ?? '',
                        title: single.title,
                        subtitle: single.year ?? '',
                        object: single,
                      );
                    },
                  ),
                ),
              ),
            ],

            // Vídeos
            if (artist.videos != null && artist.videos!.isNotEmpty)
              SliverToBoxAdapter(
                child: BuidListHorizotal(
                  title: 'Vídeos',
                  songs: artist.videos!,
                ),
              ),

            // Artistas Relacionados
            if (artist.related != null && artist.related!.isNotEmpty) ...[
              _buildSectionTitle('Artistas Relacionados'),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: artist.related!.length,
                    itemBuilder: (context, index) {
                      final related = artist.related![index];
                      return CardMedio(
                        image: related.thumbnails.last.url,
                        title: related.name,
                        subtitle: related.subscribers ?? '',
                        object: related,
                      );
                    },
                  ),
                ),
              ),
            ],

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
