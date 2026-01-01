import 'package:flutter/material.dart';

import '../../models/song.dart';

class SongCard extends StatefulWidget {
  final Song song;
  const SongCard({super.key, required this.song});

  @override
  State<SongCard> createState() => _SongCardState();
}

class _SongCardState extends State<SongCard> {
  
  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(widget.song.title),
   subtitle: widget.song.artist == null
    ? null
    : Text(widget.song.artist!),

    
    
    
    );
  }
}
