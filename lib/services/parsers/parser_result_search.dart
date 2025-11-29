import 'package:audio_service/audio_service.dart';
import 'package:danmusic/models/search_result.dart' as models;
import 'package:danmusic/models/song.dart' as models;
import 'package:dart_ytmusic_api/types.dart';
class ParserResultSearch {
  static List<models.SearchResult> parseResultSearchdartYtmusicapi(
    List<dynamic> items,
  ) {
    // Converte para List<SearchResult> com segurança
    final List<SearchResult> parsedItems =  items.whereType<SearchResult>().toList();

    List<models.SearchResult> searchResults = [];

    for (var item in parsedItems) {
      switch (item.type) {
        case 'SONG':
         // SongDetailedSearchResult songDetailedSearchResult = item as SongDetailedSearchResult;

          final SongDetailed song = item as SongDetailed;

          searchResults.add(
            models.SongDetailedSearchResult(
              songMedia: MediaItem(
                id: song.videoId,
                title: song.name,
                artist: song.artist.name,
                album: song.album?.name ?? '',
                artUri: Uri.parse(song.thumbnails.last.url),
                duration: song.duration != null ? Duration(seconds: song.duration!) : null,
              ),
            ),
          );
          break;

        default:
          break;
      }
    }

    return searchResults; 
  }
}
