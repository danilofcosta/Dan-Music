import 'package:danmusic/ui/widgets/cards/song_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/song.dart';
import '../../../widgets/play_playlist.dart';
import 'device_library_controller.dart';

class DeviceLibrary extends StatefulWidget {
  const DeviceLibrary({super.key});

  @override
  State<DeviceLibrary> createState() => _DeviceLibraryState();
}

class _DeviceLibraryState extends State<DeviceLibrary> {
  final DeviceLibraryController controller =
      Get.find<DeviceLibraryController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: PlayPlaylistBt(playlist: controller.songs),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      body: Obx(() {
        final directories = controller.musicByDirectory.keys.toList();

        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${controller.songs.length} ♫',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              Expanded(
                child: directories.isEmpty
                    ? const Center(child: Text("Nenhuma música encontrada"))
                    : ListView.builder(
                        itemCount: directories.length,
                        itemBuilder: (context, index) {
                          final dir = directories[index];
                          final musics = controller.musicByDirectory[dir]!;
                          final folderName = dir.split('/').last;

                          return ListTile(
                            leading: Icon(
                              Icons.folder,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            title: Text(folderName),
                            subtitle: Text('${musics.length} músicas'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              Get.to(
                                () => FolderSongsPage(
                                  folderName: folderName,
                                  songs: musics,
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class FolderSongsPage extends StatelessWidget {
  final String folderName;
  final List<Song> songs;

  const FolderSongsPage({
    super.key,
    required this.folderName,
    required this.songs,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(folderName)),
      floatingActionButton: PlayPlaylistBt(playlist: songs),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];

                return SongCard(song: song);
              },
            ),
          ),
        ],
      ),
    );
  }
}
