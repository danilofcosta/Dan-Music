import 'package:audio_service/audio_service.dart';
import 'package:danmusic/models/artist.dart';
import 'package:danmusic/models/search_result.dart' as models;
import 'package:dart_ytmusic_api/types.dart';

import '../../models/album.dart';
import '../../models/playlist.dart';

class ParserResultSearch {
  static List<models.SearchResult> parseResultSearchdartYtmusicapi(
    List<dynamic> items,
  ) {
    // Converte para List<SearchResult> com segurança
    final List<SearchResult> parsedItems = items
        .whereType<SearchResult>()
        .toList();

    List<models.SearchResult> searchResults = [];
    for (var item in parsedItems) {
      switch (item.type) {
        case 'SONG':
        case 'VIDEO':
          switch (item) {
            case SongDetailed song:
              // Use song as SongDetailed
              searchResults.add(
                models.SongDetailedSearchResult(
                  songMedia: MediaItem(
                    id: song.videoId,
                    title: song.name,
                    artist: song.artist.name,
                    album: song.album?.name ?? '',
                    artUri: Uri.parse(song.thumbnails.last.url),
                    duration: song.duration != null
                        ? Duration(seconds: song.duration!)
                        : null,
                  ),
                ),
              );
              break;
            case VideoDetailed song:
              searchResults.add(
                models.SongDetailedSearchResult(
                  songMedia: MediaItem(
                    id: song.videoId,
                    title: song.name,
                    artist: song.artist.name,
                    album: '',
                    artUri: Uri.parse(song.thumbnails.last.url),
                    duration: song.duration != null
                        ? Duration(seconds: song.duration!)
                        : null,
                  ),
                ),
              );
              break;
            default:
              break;
          }

          break;

        case 'PLAYLIST':
          final playlist = item as PlaylistDetailed;
          searchResults.add(
            models.PlaylistDetailedSearchResult(
              playlist: Playlist(
                playlistId: playlist.playlistId,
                title: playlist.name,
                thumbnails: [playlist.thumbnails.first.url],
                desciption: playlist.artist.name,
              ),
            ),
          );
          break;

        case 'ALBUM':
          final album = item as AlbumDetailed;
          searchResults.add(
            models.AlbumDetailedSearchResult(
              album: Album(
                albumId: album.albumId,
                name: album.name,
                thumbnails: [album.thumbnails.first.url],
                playlistId: album.playlistId,
                artist: album.artist.name,
                year: album.year,
              ),
            ),
          );
          break;

        case 'ARTIST':
          final artist = item as ArtistDetailed;
          searchResults.add(
            models.ArtistDetailedSearchResult(
              artist: Artistdetail(
                artistId: artist.artistId,
                artistName: artist.name,
                thumbnail: artist.thumbnails.first.url,
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
