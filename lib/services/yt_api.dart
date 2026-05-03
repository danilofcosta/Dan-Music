import 'package:danmusic/models/playlist.dart';
import 'package:danmusic/models/song.dart';
import 'package:danmusic/services/parses/parse_artist.dart';
import 'package:danmusic/services/parses/parse_related_recommendations.dart';
import 'package:danmusic/services/parses/parse_song.dart';
import 'package:ytmusicapi_dart/enums.dart';
import 'package:ytmusicapi_dart/ytmusicapi_dart.dart';

import '../models/album.dart';
import '../models/artist.dart';
import '../models/home_section.dart';
import '../models/recommendations.dart';
import 'parses/parse_album.dart';
import 'parses/parse_playlist.dart';
import 'uteis/helper.dart';

class YouTubeMusicService {
  YTMusic? ytmusic;

  // ─── Init ──────────────────────────────────────────────────────────────────

  Future<void> init() async {
    try {
      ytmusic = await YTMusic.create(language: 'en');
      printInfoDebug('YTMusic initialized');
    } catch (e, s) {
      printErrorDebug('Failed to initialize YTMusic: $e\n$s');
    }
  }

  // ─── Guard ─────────────────────────────────────────────────────────────────

  /// Throws if [ytmusic] has not been initialized yet.
  void _assertReady() {
    if (ytmusic == null) throw StateError('YTMusic is not initialized. Call init() first.');
  }

  // ─── Home ──────────────────────────────────────────────────────────────────

  Future<List<HomeSection>?> getHome() async {
    _assertReady();
    try {
      final res = await ytmusic!.getHome();
      return ParseHomeSessions.parseHomeSections(res);
    } catch (e, s) {
      printErrorDebug('Error fetching home sections: $e\n$s');
      return null;
    }
  }

  // ─── Search ────────────────────────────────────────────────────────────────

  Future<List<String>> getSearchSuggestions(String query) async {
    _assertReady();
    try {
      final dynamic suggestions = await ytmusic!.getSearchSuggestions(query);
      return (suggestions as List)
          .whereType<String>()
          .toList();
    } catch (e, s) {
      printErrorDebug('Error fetching suggestions: $e\n$s');
      return [];
    }
  }

  /// Generic search — returns the raw list from the API.
  Future<List<Map<String, dynamic>>> search(String query) async {
    _assertReady();
    try {
      final results = await ytmusic!.search(query);
      return results.whereType<Map<String, dynamic>>().toList();
    } catch (e, s) {
      printErrorDebug('Error searching: $e\n$s');
      return [];
    }
  }

  /// Typed song search — parses results into [Song] objects.
  Future<List<Song>> searchSong(String query) async {
    _assertReady();
    try {
      final result = await ytmusic!.search(query, filter: SearchFilter.songs);
      return ParseSong.songs(result);
    } catch (e, s) {
      printErrorDebug('Error searching songs: $e\n$s');
      return [];
    }
  }

  // ─── Playlist ──────────────────────────────────────────────────────────────

  Future<PlaylistFull?> getPlaylist(String playlistId) async {
    _assertReady();
    try {
      final playlist = await ytmusic!.getPlaylist(playlistId);
      return ParsePlaylist.parsePlaylistFull(playlist);
    } catch (e, s) {
      printErrorDebug('Error getting playlist: $e\n$s');
      return null;
    }
  }

  // ─── Album ─────────────────────────────────────────────────────────────────

  Future<AlbumFull?> getAlbumFull(String albumId) async {
    _assertReady();
    try {
      final album = await ytmusic!.getAlbum(albumId);
      return ParseAlbum.albumFull(album);
    } catch (e, s) {
      printErrorDebug('Error getting album: $e\n$s');
      return null;
    }
  }

  // ─── Artist ────────────────────────────────────────────────────────────────

  Future<ArtistFull?> getArtistFull(String artistId) async {
    _assertReady();
    try {
      final data = await ytmusic!.getArtist(artistId);
      return ParseArtist.artistFull(data);
    } catch (e, s) {
      printErrorDebug('Error getting artist: $e\n$s');
      return null;
    }
  }

  // ─── Song ──────────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>?> getSong(String songId) async {
    _assertReady();
    try {
      return await ytmusic!.getSong(songId);
    } catch (e, s) {
      printErrorDebug('Error getting song $songId: $e\n$s');
      return null;
    }
  }

  // ─── Watch / Recommendations ───────────────────────────────────────────────

  Future<Recommendations?> getNextSongs({
    String? videoId,
    String? playlistId,
    int limit = 25,
    bool radio = false,
    bool shuffle = false,
  }) async {
    _assertReady();
    try {
      final jsonData = await ytmusic!.getWatchPlaylist(
        videoId: videoId,
        playlistId: playlistId,
        limit: limit,
        radio: radio,
        shuffle: shuffle,
      );
      return ParseRelatedRecommendations.getWatchPlaylist(jsonData);
    } catch (e, s) {
      printErrorDebug('Error getting next songs: $e\n$s');
      return null;
    }
  }
}
