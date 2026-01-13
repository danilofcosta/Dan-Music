import 'dart:async';

import 'package:danmusic/ui/screens/artist/artist_cotroller.dart';
import 'package:danmusic/ui/widgets/buid_list_horizotal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/uteis/load_image.dart';
import '../../../services/uteis/update_papilite.dart';
import '../../widgets/buid_list_horizotal_card.dart';

class ArtistScreen extends StatefulWidget {
  const ArtistScreen({super.key});
  static const routeName = '/artist';

  @override
  State<ArtistScreen> createState() => _ArtistScreenState();
}

class _ArtistScreenState extends State<ArtistScreen> {
  Color _dominantColor = const Color.fromARGB(255, 7, 7, 7);
  String? _currentImg;
  Timer? _debounce;
  late final ArtistCotroller controller;

  @override
  void initState() {
    super.initState();

    final tag = hashCode.toString();
    controller = (Get.isRegistered<ArtistCotroller>(tag: tag))
        ? Get.find<ArtistCotroller>(tag: tag)
        : Get.put(ArtistCotroller(), tag: tag);

    ever(controller.artistFull, (artist) {
      if (artist != null &&
          artist.thumbnails != null &&
          artist.thumbnails!.isNotEmpty) {
        _updateDominantColor(artist.thumbnails!.last.url);
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _updateDominantColor(String img) {
    if (_currentImg == img) return;
    _currentImg = img;

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () async {
      final color = await updatePalette(img);
      if (mounted) {
        setState(() {
          _dominantColor = color;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildAppBar(artist),
            _buildHeaderInfo(artist),

            if (artist.songs?.isNotEmpty == true)
              SliverToBoxAdapter(
                child: BuidListHorizotal(
                  title: 'Músicas',
                  songs: artist.songs!,
                ),
              ),

            if (artist.albums?.isNotEmpty == true) ...[
              SliverToBoxAdapter(
                child: BuidListHorizotalCard(
                  title: 'Álbuns',
                  list: artist.albums!,
                ),
              ),
            ],

            if (artist.singles?.isNotEmpty == true) ...[
              SliverToBoxAdapter(
                child: BuidListHorizotalCard(
                  title: 'Singles',
                  list: artist.singles!,
                ),
              ),
            ],

            if (artist.videos?.isNotEmpty == true)
              SliverToBoxAdapter(
                child: BuidListHorizotal(
                  title: 'Vídeos',
                  songs: artist.videos!,
                ),
              ),

            if (artist.related?.isNotEmpty == true) ...[
              SliverToBoxAdapter(
                child: BuidListHorizotalCard(
                  title: 'Relacionados',
                  list: artist.related!,
                ),
              ),
            ],

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        );
      }),
    );
  }

  // ============================= UI SECTIONS ============================= //

  Widget _buildAppBar(dynamic artist) {
    return SliverAppBar(
      stretch: true,
      expandedHeight: 300,
      backgroundColor: _dominantColor,
      title: Text(
        artist.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (artist.thumbnails != null && artist.thumbnails!.isNotEmpty)
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
    );
  }

  Widget _buildHeaderInfo(dynamic artist) {
    return SliverToBoxAdapter(
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
    );
  }

 
}
