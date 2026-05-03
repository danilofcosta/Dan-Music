import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/uteis/load_image.dart';
import '../../widgets/list_horizontal/buid_list_horizotal.dart';
import '../../widgets/list_horizontal/buid_list_horizotal_card.dart';
import 'artist_cotroller.dart';

class ArtistScreen extends StatefulWidget {
  const ArtistScreen({super.key});
  static const routeName = '/artist';

  @override
  State<ArtistScreen> createState() => _ArtistScreenState();
}

class _ArtistScreenState extends State<ArtistScreen> {
  late final ArtistCotroller controller;

  @override
  void initState() {
    super.initState();
    final tag = hashCode.toString();
    controller = (Get.isRegistered<ArtistCotroller>(tag: tag))
        ? Get.find<ArtistCotroller>(tag: tag)
        : Get.put(ArtistCotroller(), tag: tag);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
          child: SafeArea(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                  ),
                );
              }

              final artist = controller.artistFull.value;
              if (artist == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_off_outlined,
                        size: 64,
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Artista não encontrado',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }

              final thumbUrl = (artist.thumbnails != null && artist.thumbnails!.isNotEmpty)
                  ? artist.thumbnails!.last.url
                  : null;

              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    stretch: true,
                    expandedHeight: 300,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    title: Text(
                      artist.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.8),
                                ],
                              ),
                            ),
                          ),
                          if (thumbUrl != null)
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 16,
                                left: 16,
                                right: 16,
                                top: 80,
                              ),
                              child: LoadImage.loadWidget(
                                thumbUrl,
                                fit: BoxFit.contain,
                                errorBuildericon: Icons.person,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            artist.name,
                            style: const TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          if (artist.subscribers != null)
                            Text(
                              '${artist.subscribers} inscritos',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 14,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (artist.songs?.isNotEmpty == true)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                        child: Text(
                          'MÚSICAS',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  if (artist.songs?.isNotEmpty == true)
                    SliverToBoxAdapter(
                      child: BuidListHorizotal(
                        title: 'Músicas',
                        songs: artist.songs!,
                      ),
                    ),
                  if (artist.albums?.isNotEmpty == true)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                        child: Text(
                          'ÁLBUNS',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  if (artist.albums?.isNotEmpty == true)
                    SliverToBoxAdapter(
                      child: BuidListHorizotalCard(
                        title: 'Álbuns',
                        list: artist.albums!,
                      ),
                    ),
                  if (artist.singles?.isNotEmpty == true)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                        child: Text(
                          'SINGLES',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  if (artist.singles?.isNotEmpty == true)
                    SliverToBoxAdapter(
                      child: BuidListHorizotalCard(
                        title: 'Singles',
                        list: artist.singles!,
                      ),
                    ),
                  if (artist.videos?.isNotEmpty == true)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                        child: Text(
                          'VÍDEOS',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  if (artist.videos?.isNotEmpty == true)
                    SliverToBoxAdapter(
                      child: BuidListHorizotal(
                        title: 'Vídeos',
                        songs: artist.videos!,
                      ),
                    ),
                  if (artist.related?.isNotEmpty == true)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                        child: Text(
                          'RELACIONADOS',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  if (artist.related?.isNotEmpty == true)
                    SliverToBoxAdapter(
                      child: BuidListHorizotalCard(
                        title: 'Relacionados',
                        list: artist.related!,
                      ),
                    ),
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
