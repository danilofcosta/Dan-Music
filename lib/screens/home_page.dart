import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';

import '/models/Playlist.dart';
import '/models/home_section.dart' show HomeSection;
import '/models/song.dart';
import '/services/ytmusicapi.dart';
import '/widgets/buid_list_horizotal.dart';
import '/widgets/build_backgrand.dart';
import '../widgets/greeting.dart';
import '/widgets/thememode.dart';
import '/widgets/ui/mini_player.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<HomeSection> data = [];

  @override
  void initState() {
    super.initState();
    fechada();
  }

  void fechada() async {
    // Lógica para fechar a conexão
    List<HomeSection> temp = await YouTubeMusicService.homePage();
    setState(() {
      data = temp;
    });
    // debugPrint(data.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: MiniPlayer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // bottomNavigationBar: buildMiniPlayer(),
      //bottomSheet: buildMiniPlayer(),
      //  bottomSheetScrimBuilder: (_, _) => Container(child: Text('data')),
      body: BuildBackgrand(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.menu),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent.withValues(alpha: 0.7),
              title: Text(
                greeting(),

                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/player');
                  },
                  icon: Image.asset('assets/lupa.png', width: 24, height: 24),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
                ThemeSwitcherButton(),
              ],
              pinned: true,

              forceMaterialTransparency: true,
            ),
            if (data.isEmpty)
              const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()),
              ),
            SliverToBoxAdapter(
              child: IconButton.filledTonal(
                onPressed: () async {
                  await Get.find<AudioHandler>().playMediaItem(
                    MediaItem(
                      id: 'l20M2NArfq8',
                      title: 'Teste',
                      artist: 'Teste',
                      artUri: Uri.parse(
                        'https://i.pinimg.com/736x/7d/fb/50/7dfb50e22c3cea76e6b36e3c3d19ddea.jpg',
                      ),
                      //   duration: const Duration(seconds: 5),
                    ),
                  );
                  Get.find<AudioHandler>().customAction("playByIndex", {
                    "index": 0,
                  });
                },
                icon: Icon(Icons.ac_unit),
              ),
            ),
            if (data.isNotEmpty)
              SliverToBoxAdapter(
                child: BuidListHorizotal(
                  title: data.first.title,
                  songs: data.first.content.whereType<Song>().toList(),
                ),
              ),

            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final HomeSection section = data[index];
                if (index == 0) return const SizedBox.shrink();
                return Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            section.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    //  Row(children: [Text(section.content.length.toString())]),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: CarouselView.weighted(
                        flexWeights: const <int>[6, 3],
                        shrinkExtent: 8.0,
                        elevation: 5,
                        onTap: (value) {
                          final d = section.content[value];
                          if (d is Song) {
                            // audioHandler.playMediaItem(
                            //   MediaItem(id: d.videoid, title: d.title),
                            // );
                            Navigator.of(context).pushNamed('/player');
                            return;
                          }
                          if (d is Playlist) {
                            Navigator.of(
                              context,
                            ).pushNamed('/playlist', arguments: d);

                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute<void>(
                            //     builder: (context) =>
                            //         PlaylistPage(playlistModel: d),
                            //   ),
                            // );
                            //audioHandler.playPlaylistId(d.playlistId);
                          }
                          // Navigator.of(context).pushNamed('/player');

                          return;
                        },

                        consumeMaxWeight: false,
                        children: List.generate(section.content.length, (i) {
                          final sectionContent = section.content[i];
                          return Container(
                            decoration: BoxDecoration(
                              // color: Colors.amber,
                              image: DecorationImage(
                                // colorFilter: ColorFilter.linearToSrgbGamma(),
                                image: NetworkImage(
                                  sectionContent.thumbnails.first,
                                ),
                                fit: BoxFit.cover,
                                // opacity: 0.7,
                              ),
                            ),
                            child: Text(sectionContent.title),
                          );
                        }),
                      ),
                    ),
                  ],
                );
              }, childCount: data.length),
            ),

            SliverFillRemaining(),
          ],
        ),
      ),
    );
  }
}
