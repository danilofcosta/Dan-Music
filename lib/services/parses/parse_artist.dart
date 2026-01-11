import 'package:danmusic/models/artist.dart';

class ParseArtist {
  static String artistsToString(List<ArtistBasic> artists) {
    return artists.map((a) => a.name).join(', ');
  }

  static ArtistBasic artistBasic(Map<String, dynamic> jsondata) {
    final name = jsondata['name'];
    final id = jsondata['id'] ?? '';

    return ArtistBasic(name: name, id: id);
  }

  static ArtistFull artistFull(Map<String, dynamic> jsondata) {
    final id = jsondata;

    return ArtistFull();
  }
}
