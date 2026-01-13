import 'package:danmusic/models/playlist.dart';
import 'package:danmusic/models/song.dart';
import 'package:danmusic/services/parses/parse_artist.dart';
import 'package:danmusic/services/parses/parse_song.dart';
import 'package:ytmusicapi_dart/ytmusicapi_dart.dart';

import '../models/album.dart';
import '../models/artist.dart';
import '../models/home_section.dart';
import 'parses/parse_album.dart';
import 'parses/parse_playlist.dart';
import 'uteis/helper.dart';

class YouTubeMusicService {
  YTMusic? ytmusic;

  Future<void> init() async {
    try {
      ytmusic = await YTMusic.create(language: 'en');
      printInfoDebug('YTMusic initialized');
    } catch (e, s) {
      printErrorDebug('Failed to initialize YTMusic: $e');
      printErrorDebug(s);
    }
  }

  Future<List<HomeSection>> getHome() async {
    if (ytmusic == null) {
      throw Exception('YTMusic not initialized');
    }
    final res = await ytmusic!.getHome();

    return ParseHomeSessions.parseHomeSections(res);
  }

  Future<List<String>> getSearchSuggestions(String query) async {
    if (ytmusic == null) {
      throw Exception('YTMusic not initialized');
    }
    try {
      final dynamic suggestions = await ytmusic!.getSearchSuggestions(query);
      final filteredSuggestions = suggestions
          .map((item) => item is String ? item : null)
          .where((item) => item != null)
          .cast<String>()
          .toList();

      return filteredSuggestions;
    } catch (e) {
      printErrorDebug('Error fetching suggestions: $e');
      return [];
    }
  }

  Future<List<dynamic>> search(String query) async {
    if (ytmusic == null) {
      throw Exception('YTMusic not initialized');
    }
    try {
      final results = await ytmusic!.search(query);
      return results;
    } catch (e) {
      printErrorDebug('Error searching: $e');
      return [];
    }
  }

  Future<PlaylistFull?> getPlaylist(String playlistId) async {
    if (ytmusic == null) {
      throw Exception('YTMusic not initialized');
    }
    try {
      final playlist = await ytmusic!.getPlaylist(playlistId);
      return ParsePlaylist.parsePlaylistFull(playlist);
    } catch (e, stack) {
      printErrorDebug('Error getting playlist: $e');
      printErrorDebug('StackTrace:\n$stack');
      return null;
    }
  }

  Future<AlbumFull?> getAlbumFull(String albumId) async {
    if (ytmusic == null) {
      throw Exception('YTMusic not initialized');
    }

    try {
      final album = await ytmusic!.getAlbum(albumId);
      return ParseAlbum.albumFull(album);
    } catch (e, s) {
      printErrorDebug('Error getting album full: $e');
      printErrorDebug(s);
      return null;
    }
  }

  Future<ArtistFull?> getArtistFull(String artistId) async {
    if (ytmusic == null) {
      throw Exception('YTMusic not initialized');
    }
    try {
      final data = await ytmusic!.getArtist(artistId);

      return ParseArtist.artistFull(data);
    } catch (e, s) {
      printErrorDebug(e);
      printErrorDebug(s);
    }
    return null;
  }

  Future<Song> getSong(String songId) async {
    if (ytmusic == null) {
      throw Exception('YTMusic not initialized');
    }
    final jsonData = await ytmusic!.getSong(songId);
    return ParseSong.song(jsonData);
  }

  Future<void> getNextSongs(String songId) async {
    if (ytmusic == null) {
      throw Exception('YTMusic not initialized');
    }
    final jsonData = await ytmusic!.getSongRelated(songId);
    //return ParseSong.song(jsonData);
  }
}
