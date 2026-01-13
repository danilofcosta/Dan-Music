import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets_player/buil_buttons.dart';
import 'widgets_player/build_cover.dart';
import 'player_controller.dart' show PlayerController;
import 'widgets_player/slider_temp.dart';
import 'widgets_player/text.dart';

class PlayerMax extends StatefulWidget {
  const PlayerMax({super.key});

  @override
  State<PlayerMax> createState() => _PlayerMaxState();
}

class _PlayerMaxState extends State<PlayerMax> {
  final controller = Get.find<PlayerController>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: SizedBox(
        width: width,
        height: height,

        child: Column(
          spacing: 5,
          children: [
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      controller.setminplayer();
                    },
                    icon: Icon(Icons.keyboard_arrow_down),
                  ),
                  Text('Tocando a playlisy ... ${controller.songNow.value.id}'),
                  IconButton(
                    onPressed: () {
                      controller.setminplayer();
                    },
                    icon: Icon(Icons.more_vert),
                  ),
                ],
              ),
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

            //Spacer(),
          ],
        ),
      ),
    );
  }
}
