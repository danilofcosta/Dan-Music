import 'package:danmusic/ui/widgets/cards/song_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_library_controller.dart';

class AppLibrary extends StatefulWidget {
  const AppLibrary({super.key});

  @override
  State<AppLibrary> createState() => _AppLibraryState();
}

class _AppLibraryState extends State<AppLibrary> {
  final AppLibraryController controller = Get.find<AppLibraryController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final musics = controller.songsapp.value;
      if (musics.isEmpty) {
       return Center(child: Text('${musics.length} sons'));
        
      }

      return ListView.builder(
        itemCount: musics.length,
        itemBuilder: (context, index) {
          final song = musics[index];
          return SongCard(song: song);
        },
      );
    });
  }
}
