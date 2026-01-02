import 'package:danmusic/models/artist.dart';
import 'package:flutter/material.dart';

class ArtistCard extends StatefulWidget {
  final ArtistDetail artist;
  const ArtistCard({super.key, required this.artist});

  @override
  State<ArtistCard> createState() => _ArtistCardState();
}

class _ArtistCardState extends State<ArtistCard> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(widget.artist.thumbnails[0].url),
      ),
      title: Text(widget.artist.name),
      subtitle: widget.artist.subscribers.isEmpty
          ? null
          : Text(widget.artist.subscribers),
    );
  }
}
