import 'package:danmusic/ui/screens/player/player_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'player_max.dart';
import 'player_mini.dart';

class Player extends StatelessWidget {

  Player({super.key});

  final PlayerController controller = Get.find<PlayerController>();

  @override
  Widget build(BuildContext context) {
    return Obx((){ return controller.playerOpen.value ? const PlayerMax() : const PlayerMini();});
    // return // Player flutuante
    // DraggableScrollableSheet(
    //   controller: controller.draggableController,
    //   initialChildSize: 0.10,
    //   minChildSize: 0.10,
    //   maxChildSize: 1,
    //   snap: true,
    //   expand: true,
    //   snapSizes: [],
    //   builder: (context, scrollController) {
    //     return Container(
    //       decoration: const BoxDecoration(
    //         color: Colors.cyan,
    //         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    //       ),
    //       child: Obx(
    //         () => ListView(
    //           controller: scrollController,
    //           physics: const ClampingScrollPhysics(),
    //           children: [
    //             controller.playerOpen.value
    //                 ? const PlayerMax()
    //                 : const PlayerMini(),
    //           ],
    //         ),
    //       ),
    //     );
    //   },
    // );
  }
}
