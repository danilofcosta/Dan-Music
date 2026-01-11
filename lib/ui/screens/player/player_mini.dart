import 'package:danmusic/ui/screens/player/player_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/uteis/load_image.dart';

class PlayerMini extends StatelessWidget {
  const PlayerMini({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final controller = Get.find<PlayerController>();
      return Container(
        margin: EdgeInsets.only(left: 12, right: 12),
        decoration: BoxDecoration(
          //   color: Colors.amber,
          borderRadius: BorderRadius.circular(8),

          border: BoxBorder.all(color: Colors.white, width: 2),
        ),

        child: ListTile(
          onTap: () => controller.setMaxplayer(),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LoadImage.loadWidget(
              controller.songNow.value.artUri.toString(),

              errorBuildericon: Icons.music_note,
            ),
          ),
          title: Text(
            controller.songNow.value.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            controller.songNow.value.artist ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    });
  }
}
