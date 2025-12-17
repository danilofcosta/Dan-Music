import 'package:audio_service/audio_service.dart';
import 'package:danmusic/models/album.dart';
import 'package:danmusic/models/playlist_basic.dart';
import 'package:danmusic/services/to_media_item.dart';
import 'package:danmusic/services/uteis/helper.dart';
//import 'package:danmusic/services/parsers/parser_result_search.dart';
import 'package:ytmusicapi_dart/ytmusicapi_dart.dart' as api1;
import 'package:dart_ytmusic_api/yt_music.dart' as api2;
import 'package:dart_ytmusic_api/types.dart' as api2_types;

//import '../models/search_result.dart';

import '../models/artist.dart';
import '/models/playlist_full.dart';
import '/services/parsers/parser_playlist.dart';
import 'package:flutter/material.dart';

import 'parsers/parser_album.dart';
import 'parsers/parser_artist.dart';

/// Instância global
YouTubeMusicService youTubeMusicServiceInstance = YouTubeMusicService._();

class YouTubeMusicService {
  api1.YTMusic? _ytmusic;
  late api2.YTMusic _ytmusic2;

  /// Construtor privado
  YouTubeMusicService._();

  /// Inicialização async do serviço
  static Future<bool> init() async {
    printInfoDebug('iniciando a api');
    try {
      youTubeMusicServiceInstance._ytmusic = await api1.YTMusic.create();

      // inicializa a segunda API (esta é síncrona)
      youTubeMusicServiceInstance._ytmusic2 = api2.YTMusic();
     await youTubeMusicServiceInstance._ytmusic2.initialize();
  //   await Future.delayed(Duration(seconds: 5));
      return true;
    } catch (e) {
      printErrorDebug('iniciando a api : $e');
      return false;
    }
  }

  /// Getter seguro da API principal
  static api1.YTMusic get ytmusic {
    final api = youTubeMusicServiceInstance._ytmusic;
    if (api == null) {
      throw Exception(
        'YouTubeMusicService NÃO FOI inicializado. '
        'Chame YouTubeMusicService.init() primeiro.',
      );
    }
    return api;
  }

  /// Homepage
  static Future<List<api2_types.HomeSection>> homePage() async {
    final api2Instance = youTubeMusicServiceInstance._ytmusic2;

    final List<api2_types.HomeSection> service = await api2Instance
        .getHomeSections();
    return service;

    //  return service.map(Parser.parseHomeSection).toList();
  }

  /// Playlist completa
  static Future<PlaylistFull> getPlaylist(String playlistId) async {
    final service = await ytmusic.getPlaylist(playlistId);
    return ParserPlaylist.parsePlaylistFull(service);
  }

  /// Recomendados / "UpNext" da outra lib
  static Future<List<MediaItem>> getRelatedPlaylist(String videoId) async {
    final api2Instance = youTubeMusicServiceInstance._ytmusic2;

    final List<api2_types.UpNextsDetails> upNextsDetailsList =
        await api2Instance.getUpNexts(videoId);

    final List<MediaItem> newQueue = upNextsDetailsList
        .map(
          (e) => MediaItem(
            id: e.videoId,
            title: e.title,
            artist: e.artists.name,
            album: e.album == null ? "" : e.album?.name, // se existir
            artUri: Uri.parse(e.thumbnails.first.url),
            duration: Duration(seconds: e.duration), // se existir
          ),
        )
        .toList();
    //  debugPrint(newQueue.toString());
    return newQueue;
  }

  static Future<MediaItem> getSong(String videoId) async {
    api2_types.SongFull song = await youTubeMusicServiceInstance._ytmusic2
        .getSong(videoId);
    return MediaItem(
      id: song.videoId,
      title: song.name,
      artist: song.artist.name,
      album: "",
      artUri: Uri.parse(song.thumbnails.last.url),
      duration: Duration(seconds: song.duration),
      extras: {
        'Type': song.type,
        'VideoId': song.videoId,
        'artist': song.artist.artistId,
      },
    );
  }

  static Future<List<String>> getSearchSuggestions(
    String textInputAction,
  ) async {
    List<String> SearchSuggestions = await youTubeMusicServiceInstance._ytmusic2
        .getSearchSuggestions(textInputAction);
    return SearchSuggestions;
  }

  static Future<List<api2_types.SearchResult>> getSearchResult(
    String query,
  ) async {
    List<api2_types.SearchResult> getSearchResult =
        await youTubeMusicServiceInstance._ytmusic2.search(query);

    return getSearchResult;
  }

  static Future<List<MediaItem>> searchSongs(String query) async {
    List<api2_types.SongDetailed> searchResults =
        await youTubeMusicServiceInstance._ytmusic2.searchSongs(query);
    return searchResults.map((song) => ToMediaItem.songDetailed(song)).toList();
  }

  static Future<List<MediaItem>> searchVideos(String query) async {
    List<api2_types.VideoDetailed> searchResults =
        await youTubeMusicServiceInstance._ytmusic2.searchVideos(query);
    return searchResults
        .map((song) => ToMediaItem.videoDetailed(song))
        .toList();
  }

  static Future<List<Album>> searcAlbums(String query) async {
    List<api2_types.AlbumDetailed> searchResults =
        await youTubeMusicServiceInstance._ytmusic2.searchAlbums(query);
    return searchResults
        .map((album) => AlbumParser.parseAlbumDetailed(album))
        .toList();
  }

  static Future<List<PlaylistBasic>> searchPlaylists(String query) async {
    List<api2_types.PlaylistDetailed> searchResults =
        await youTubeMusicServiceInstance._ytmusic2.searchPlaylists(
          query,
        ); // This is the original search result

    return searchResults
        .map(
          (pl) => PlaylistBasic(
            playlistId: pl.playlistId,
            title: pl.name,
            thumbnails: pl.thumbnails
                .map((thumb) => thumb.url)
                .toList(), // Correctly map thumbnails
            desciption:
                pl.artist.name, // Assuming artist name is the description
          ),
        )
        .toList();
  }

  static Future<List<Artistdetail>> searchArtistsResult(String query) async {
    List<api2_types.ArtistDetailed> searchResults =
        await youTubeMusicServiceInstance._ytmusic2.searchArtists(query);

    var _searchResults = searchResults
        .map(
          (artist) => Artistdetail(
            artistId: artist.artistId,
            artistName: artist.name,
            thumbnail: artist.thumbnails.first.url,
          ),
        )
        .toList();

    return _searchResults;
  }

  static Future<Album> getAlbum(String albumId) async {
    api2_types.AlbumFull resultAlbum = await youTubeMusicServiceInstance
        ._ytmusic2
        .getAlbum(albumId);

    return AlbumParser.parseAlbum(resultAlbum);
  }

  static Future<FullArtist> getArtist(String artistId) async {
    api2_types.ArtistFull resultArtist = await youTubeMusicServiceInstance
        ._ytmusic2
        .getArtist(artistId);

    return ParserArtist.artistFull(resultArtist);
  }

  /// Fecha API1
  void close() {
    _ytmusic?.close();
    _ytmusic = null;
    debugPrint("Conexão YTMusic fechada.");
  }
}
