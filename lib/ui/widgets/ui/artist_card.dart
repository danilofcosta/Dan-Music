import 'package:danmusic/models/artist.dart';
import 'package:danmusic/services/uteis/load_image.dart';
import 'package:flutter/material.dart';

class ArtistCard extends StatelessWidget {
  final Artistdetail artist;
  const ArtistCard({super.key, required this.artist});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: LoadImage.loadWidget(
          artist.thumbnail ?? '',
          width: 50,
          height: 50,
          errorBuildericon: Icons.person,
        ),
      ),

      title: Text(artist.artistName),
      trailing: Icon(Icons.person),
    );
  }
}
