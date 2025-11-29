import 'package:danmusic/ui/screens/playlist_page/playlist_controller.dart';
import 'package:danmusic/services/uteis/load_image.dart';
import 'package:danmusic/ui/widgets/build_backgrand.dart';
import 'package:danmusic/ui/widgets/ui/song_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlaylistPage extends StatelessWidget {
  const PlaylistPage({super.key});
  static const routeName = '/playlist';

  List<String> generateList() {
    return List<String>.generate(50, (index) => "Item ${index + 1}");


  }


  @override
  Widget build(BuildContext context) {
    final tag = key.hashCode.toString();

    final playlistController = (Get.isRegistered<PlaylistController>(tag: tag))
        ? Get.find<PlaylistController>(tag: tag)
        : Get.put(PlaylistController(), tag: tag);

    final size = MediaQuery.of(context).size;
    final landscape = size.width > size.height;

    return BuildBackgrand(
      child: Scaffold(
        appBar: AppBar(title: Text(playlistController.playlist.value.title)),
        body: Column(
          children: [
            // ==============================
            // 📌 IMAGEM DA PLAYLIST
            // ==============================
            Obx(() {
              final thumb =
                  playlistController.playlistfull.value.thumbnails.isEmpty
                  ? playlistController.playlist.value.thumbnails.first
                  : playlistController.playlistfull.value.thumbnails.last;
              return LoadImage.loadWidget(
                thumb,
                height: 300,
                fit: BoxFit.cover,
                width: size.width,
              );
            }),

            // ==============================
            // BOTÕES
            // ==============================
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8,
                children: [
                  FilledButton.icon(
                    onPressed: () => playlistController.playplaylist(),
                    label: const Icon(Icons.play_arrow),
                  ),

                  FilledButton.icon(
                    onPressed: () {},
                    label: const Icon(Icons.favorite_border),
                  ),
                ],
              ),
            ),

            // ==============================
            // 📌 TÍTULO
            // ==============================
            Obx(
              () => Text(
                playlistController.playlist.value.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // ==============================
            // 📌 DESCRIÇÃO (playlistfull)
            // ==============================
            Obx(
              () => Text(
                playlistController.playlistfull.value.desciption,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            const Divider(color: Colors.white),
            Obx(() {
              final String? duration =
                  playlistController.playlistfull.value.duration;
              final String trackCount = playlistController
                  .playlistfull
                  .value
                  .trackCount
                  .toString();
              final String year = playlistController.playlistfull.value.year
                  .toString();

              return Text(
                '$duration - $trackCount - $year',

                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              );
            }),
            const Divider(color: Colors.white),

            // ==============================
            // 📌 LISTA DE MÚSICAS
            // Atualiza automaticamente
            // ==============================
            Expanded(
              child: Obx(() {
                final tracks =
                    playlistController.playlistfull.value.tracks ?? [];

                if (tracks.isEmpty) {
                  // Lista placeholder até carregar
                  final fallback = generateList();
                  return ListView.builder(
                    itemCount: fallback.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.play_arrow),
                        title: Text(fallback[index]),
                        subtitle: Text(fallback[index]),
                        trailing: const Icon(Icons.more_vert),
                      );
                    },
                  );
                }

                // Lista real carregada
                return ListView.builder(
                  itemCount: tracks.length,
                  itemBuilder: (context, index) {
                    final track = tracks[index];

                    return SongUi(song: track);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
