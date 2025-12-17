import 'package:audio_service/audio_service.dart';
import 'package:danmusic/services/to_media_item.dart';
import 'package:get/get.dart';

import '../screens/player_page/player_controller.dart';
import '/models/song.dart';
import 'ui/song_ui.dart';
import 'package:flutter/material.dart';

class BuidListHorizotal extends StatefulWidget {
  final String title;
  final List<Song>? songs;
  final List<MediaItem>? mediaItems;
  const BuidListHorizotal({
    super.key,
    required this.title,
    this.songs,
    this.mediaItems,
  });

  @override
  State<BuidListHorizotal> createState() => _BuidListHorizotalState();
}

class _BuidListHorizotalState extends State<BuidListHorizotal> {
  List<List<dynamic>> chunks = [];

  @override
  void initState() {
    super.initState();
    generateChunks();
  }

  void generateChunks() {
    final List<dynamic>? songs = widget.songs ?? widget.mediaItems;

    chunks = List.generate(
      3,
      (index) => songs?.skip(index * 3).take(3).toList() ?? [],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.6),
        border: Border.all(
          color: Theme.of(context).textTheme.bodyLarge!.color!,
          width: 2,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    IconButton(
                      tooltip: 'play all',
                      icon: const Icon(Icons.play_arrow),
                      onPressed: () {
                        final controller = Get.find<PlayerController>();

                        if (widget.mediaItems != null) {
                          controller.updateQueuenew(widget.mediaItems!);
                        } else if (widget.songs != null) {
                          controller.updateQueuenew(
                            widget.songs!
                                .map((song) => ToMediaItem.song(song))
                                .toList(),
                          );
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: chunks.length,
              itemBuilder: (context, index) {
                List columnItems = chunks[index];
                return SizedBox(
                  width: 300, // ajuste a largura da coluna
                  //  margin: const EdgeInsets.all(8),
                  //color: Colors.redAccent,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: columnItems.map((item) {
                      if (item is Song) {
                        return SongUi(song: item);
                      }
                      if (item is MediaItem) {
                        return SongUi(mediaItem: item);
                      }
                      return const SizedBox.shrink(); // Fallback for unknown types
                    }).toList(),
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
