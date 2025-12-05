import 'package:danmusic/services/uteis/load_image.dart';
import 'package:danmusic/ui/screens/album_page/album_controller.dart';
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
        body: Column(
          children: [
            LoadImage.loadWidget(
              controler.album.value.thumbnails.first,
              height: 300,
              fit: BoxFit.cover,
              width: double.maxFinite,
            ),

            Text(controler.album.value.name),
            Text(controler.album.value.artist),

        // ListView(
        //   shrinkWrap: true,
        //   children: controler.album.value.songs.map((e) => Text(e.title)).toList(),
        // )
          ],
        ),
      );
    });
  }
}
