import 'package:danmusic/services/uteis/load_image.dart';
import 'package:danmusic/ui/screens/album_page/album_controller.dart';
import 'package:danmusic/ui/widgets/ui/song_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AlbumPage extends StatefulWidget {
  const AlbumPage({super.key});

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final controler = Get.find<AlbumController>();
      return Scaffold(
        appBar: AppBar(
          title: Text(controler.album.value.name),
          forceMaterialTransparency: true,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Column(
          children: [
            LoadImage.loadWidget(
              controler.album.value.thumbnails.last,
              height: 300,
              fit: BoxFit.cover,
              width: double.maxFinite,
            ),

            Text(controler.album.value.name),
            Text(controler.album.value.artist),

            Expanded(
              child: ListView.builder(
                itemCount: controler.album.value.songs.length,
                itemBuilder: (context, index) {
                  final song = controler.album.value.songs[index];
                  return SongUi(mediaItem: song, index: index + 1);
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
