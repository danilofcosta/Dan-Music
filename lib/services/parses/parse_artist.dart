import 'package:danmusic/models/artist.dart';

class ParseArtist {
  static String artistsToString(List<ArtistBasic> artists) {
    return artists.map((a) => a.name).join(', ');
  }

  static ArtistBasic artistBasic(dynamic data) {
    // Quando vem só o nome do artista como String
    if (data is String) {
      return ArtistBasic(
        name: data,
        id: '',
      );
    }

    // Quando vem o objeto completo
    if (data is Map<String, dynamic>) {
      final name = data['name']?.toString() ?? '';
      final id = data['id']?.toString() ?? '';

      return ArtistBasic(
        name: name,
        id: id,
      );
    }

    throw Exception(
      'Formato inválido para ArtistBasic: ${data.runtimeType}',
    );
  }

  static ArtistFull artistFull(Map<String, dynamic> jsondata) {
   final name = jsondata['name'];
    final id = jsondata['id'];
    return ArtistFull();
  }
}
