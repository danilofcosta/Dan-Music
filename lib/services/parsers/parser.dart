import '/models/home_section.dart';
import '/services/parsers/parser_playlist.dart';
import '../parsers/parser_song.dart';

class Parser {
  static HomeSection parseHomeSection(dynamic data) {
    // 1. O 'data' geralmente é um Map<String, dynamic>
    final List<dynamic> contentData = data['contents'] as List<dynamic>? ?? [];

    return HomeSection(
      title: data['title'] ?? 'No Title',
      content: contentData
          .map((item) {
            // 2. Usar Map<String, dynamic> para o item, se possível.
            final Map<String, dynamic> itemMap = item as Map<String, dynamic>;

            // 3. Usar `if/else if/else` com `return` para retornar o objeto correto.
            if (itemMap.containsKey('videoId')) {
              // Se for uma Song, retorne um objeto Song
              return ParserSong.parseSong(itemMap);
            } else if (itemMap.containsKey('playlistId')) {
              // 4. Se for uma Playlist, retorne um objeto Playlist ou algo que HomeSection.content aceite.
              // Como você não especificou o objeto, vou retornar null.
              // **ATENÇÃO:** Se retornar null, o `.toList()` falhará. Veja a nota abaixo.
              return ParserPlaylist.parsePlaylist(itemMap); // A ser filtrado.
            }

            // 5. Caso não seja Song nem Playlist, retorne null (ou um valor padrão/desconhecido)
            return null; // A ser filtrado
          })
          // 6. Usar `where` para remover quaisquer valores `null` retornados no .map()
          .where((item) => item != null)
          .toList(),
    );
  }
}
