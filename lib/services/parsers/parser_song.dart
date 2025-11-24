import 'package:danmusic/models/album_info.dart';
import 'package:danmusic/models/artist.dart';
import 'package:danmusic/models/song.dart';

class ParserSong {
  static Song parseSong(Map<String, dynamic> itemMap) {
    
    return Song(
      videoid: itemMap['videoId'] as String,
      title: itemMap['title'] ?? 'Sem Título',
      thumbnails: (itemMap['thumbnails'] as List<dynamic>?)
          ?.map((thumb) => thumb['url'] as String)
          .toList(),
      albumInfo: AlbumInfo(
        albumId: itemMap['album']?['id'] ?? '',
        albumName: itemMap['album']?['name'] ?? '',
      ),

      views: itemMap['views'], // Assumindo views como int/String e default 0
      artistdetail: (itemMap['artists'] as List<dynamic>?)
          ?.map((a) => Artistdetail(artistName: a['name'], artistId: a['id']))
          .toList(),

      duration: itemMap['duration'] ,
      secondsduration: itemMap['duration_seconds'] ,

      artist:
          (itemMap['artists'] as List<dynamic>?)
              // 1. Acesso Condicional e Filtro
              ?.where((a) => a['id'] != null)
              // 2. Mapeamento
              .map((a) => a['name'] as String)
              // 3. Conversão e Junção
              .toList()
              .join(',') ??
          '',
    );
  }
}
