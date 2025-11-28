import '/widgets/build_backgrand.dart';
import '/widgets/player_widget/buil_buttons.dart';
import '/widgets/player_widget/build_cover.dart';
import '/widgets/player_widget/bulid_text.dart';
import '/widgets/player_widget/slider_temp.dart';
import 'package:flutter/material.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  @override
  Widget build(BuildContext context) {
    return BuildBackgrand(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Theme.of(
            context,
          ).appBarTheme.backgroundColor?.withValues(alpha: 0.2),
          //   forceMaterialTransparency: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/fileplayer');
          },
          child: const Icon(Icons.queue_music),
        ),

        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BuildCover(),
            BulidText(),
            // const SliderTemp(),
            MusicProgressBar(),
            const BuilButtons(),
          ],
        ),
      ),
    );
  }
}
