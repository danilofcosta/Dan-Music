import 'package:danmusic/models/artist.dart';

class ParseArtist {
  static ArtistBasic artistBasic(Map<String, dynamic> jsondata) {
    final name = jsondata['name'];
    final id = jsondata['id'] ?? '';

    return ArtistBasic(name: name, id: id);
  }
}
