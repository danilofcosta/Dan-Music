import 'package:danmusic/ui/screens/player/widgets_player/player_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'player_full.dart';
import 'player_mini.dart';

class Player extends StatefulWidget {
  static const String routeName = '/player';

  const Player({super.key});

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  final controller = Get.find<PlayerController>();

  @override
  void initState() {
    super.initState();

    // _controller.addListener(() {
    //   final size = _controller.size;
    //   debugPrint(size.toString());
    //   if (size > 0.14) {
    //     debugPrint('Player ABERTO');
    //   } else if (size < 0.35) {
    //     debugPrint('Player FECHADO');
    //   }
    // });
  }

  @override
  void dispose() {
    controller.draggableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: DraggableScrollableSheet(
        controller: controller.draggableController,
        initialChildSize: 0.10,
        minChildSize: 0.10,
        maxChildSize: 1,
        
        builder: (context, scrollController) {
          return Container(
            // margin: EdgeInsetsDirectional.only(bottom: 30),
            decoration: BoxDecoration(
              color: Colors.cyan,

              // color: Theme.of(context).scaffoldBackgroundColor,
              border: Border.all(color: Colors.white12),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Obx(() {
              return ListView(
                controller: scrollController,
                children: [
                  controller.playerOpen.value
                      ? const PlayerFull()
                      : const PlayerMini(),
                ],
              );
            }),
          );
        },
      ),
    );
  }
}
