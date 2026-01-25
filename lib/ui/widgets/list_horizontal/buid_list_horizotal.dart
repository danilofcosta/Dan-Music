import 'package:danmusic/ui/widgets/cards/song_card.dart';
import 'package:get/get.dart';

import '../../screens/player/player_controller.dart';
import '/models/song.dart';
import 'package:flutter/material.dart';

class BuidListHorizotal extends StatefulWidget {
  final String title;
  final List<Song> songs;
  const BuidListHorizotal({
    super.key,
    required this.title,
    required this.songs,
  });

  @override
  State<BuidListHorizotal> createState() => _BuidListHorizotalState();
}

class _BuidListHorizotalState extends State<BuidListHorizotal> {
  List<List<Song>> chunks = [];

  @override
  void initState() {
    super.initState();
    chunks = List.generate(
      3,
      (index) => widget.songs.skip(index * 3).take(3).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.6),
        // border: Border.all(
        //   color: Theme.of(context).textTheme.bodyLarge!.color!,
        //   width: 2,
        // ),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Text(
                  widget.title,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  tooltip: 'Play All Songs',
                  icon: const Icon(Icons.play_arrow, color: Colors.white),
                  onPressed: () async {
                    final controller = Get.find<PlayerController>();
                    await controller.uploadQuere(widget.songs);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: chunks.length,
              itemBuilder: (context, index) {
                List<Song> columnItems = chunks[index];
                return SizedBox(
                  width: 300, // ajuste a largura da coluna
                  //  margin: const EdgeInsets.all(8),
                  //color: Colors.redAccent,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: columnItems
                        .map(
                          (song) => SongCard(song: song), // cada Song
                        )
                        .toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
