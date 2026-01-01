import 'package:danmusic/ui/screens/player/player_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/uteis/load_image.dart';

class Player extends StatefulWidget {
  static const String routeName = '/player';

  const Player({super.key});

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  final DraggableScrollableController _controller =
      DraggableScrollableController();
  final controller = Get.find<PlayerController>();

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      final size = _controller.size;
      debugPrint(size.toString());
      if (size > 0.14) {
        debugPrint('Player ABERTO');
      } else if (size < 0.35) {
        debugPrint('Player FECHADO');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: DraggableScrollableSheet(
        controller: _controller,
        initialChildSize: 0.10,
        minChildSize: 0.10,
        //maxChildSize: 0.75,
        builder: (context, scrollController) {
          return Container(
            // margin: EdgeInsetsDirectional.only(bottom: 30),
            decoration: BoxDecoration(
              color: Colors.cyan,

              // color: Theme.of(context).scaffoldBackgroundColor,
              border: Border.all(color: Colors.white12),
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListView(
              controller: scrollController,
              children: [
                ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LoadImage.loadWidget(
                      '',

                      errorBuildericon: Icons.music_note,
                    ),
                  ),
                  title: const Text(
                    'ts',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: true == null
                      ? null
                      : const Text(
                          ' widget.song.artist!',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
