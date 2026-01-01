import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets_player/buil_buttons.dart';
import 'widgets_player/build_cover.dart';
import 'widgets_player/player_controller.dart' show PlayerController;
import 'widgets_player/slider_temp.dart';
import 'widgets_player/text.dart';

class PlayerFull extends StatefulWidget {
  const PlayerFull({super.key});

  @override
  State<PlayerFull> createState() => _PlayerFullState();
}

class _PlayerFullState extends State<PlayerFull> {
  final controller = Get.find<PlayerController>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Container(
        width: width,
        height: height,
        color: Colors.red,

        child: Column(
          spacing: 5,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    controller.setminplayer();
                  },
                  icon: Icon(Icons.keyboard_arrow_down),
                ),
                Text('Tocando a playlisy ...'),
                IconButton(
                  onPressed: () {
                    controller.setminplayer();
                  },
                  icon: Icon(Icons.more_vert),
                ),
              ],
            ),
            //  Spacer(flex: 2),
            BuildCover(),
            BulidText(), MusicProgressBar(),
            BuilButtons(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Spacer(),
                  FloatingActionButton(
                    onPressed: () {},
                    child: const Icon(Icons.playlist_play_outlined),
                  ),
                ],
              ),
            ),

            Spacer(),
          ],
        ),
      ),
    );
  }
}
