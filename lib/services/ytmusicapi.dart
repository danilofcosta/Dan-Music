import 'package:audio_service/audio_service.dart';
import 'package:danmusic/models/album.dart';
//import 'package:danmusic/services/parsers/parser_result_search.dart';
import 'package:ytmusicapi_dart/ytmusicapi_dart.dart' as api1;
import 'package:dart_ytmusic_api/yt_music.dart' as api2;
import 'package:dart_ytmusic_api/types.dart' as api2_types;

//import '../models/search_result.dart';

import '/models/playlist_full.dart';
import '/services/parsers/parser_playlist.dart';
import 'package:flutter/material.dart';

import 'parsers/parser_album.dart';

/// Instância global
YouTubeMusicService youTubeMusicServiceInstance = YouTubeMusicService._();

class YouTubeMusicService {
  api1.YTMusic? _ytmusic;
  late api2.YTMusic _ytmusic2;

  /// Construtor privado
  YouTubeMusicService._();

  /// Inicialização async do serviço
  static Future<bool> init() async {
    youTubeMusicServiceInstance._ytmusic = await api1.YTMusic.create(
      language: 'pt',
    );

    // inicializa a segunda API (esta é síncrona)
    youTubeMusicServiceInstance._ytmusic2 = api2.YTMusic();
    youTubeMusicServiceInstance._ytmusic2.initialize();
    await Future.delayed(Duration(seconds: 3));

    return true;
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
    final List<api2_types.HomeSection> service =
        await youTubeMusicServiceInstance._ytmusic2.getHomeSections();
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
    List<String> s = await youTubeMusicServiceInstance._ytmusic2
        .getSearchSuggestions(textInputAction);
    return s;
  }

  //return ParserResultSearch.parseResultSearchdartYtmusicapi(s);

  static Future<Album> getAlbum(String albumId) async {
    api2_types.AlbumFull resultAlbum = await youTubeMusicServiceInstance
        ._ytmusic2
        .getAlbum(albumId);

    return AlbumParser.parseAlbum(resultAlbum);
  }

  /// Fecha API1
  void close() {
    _ytmusic?.close();
    _ytmusic = null;
    debugPrint("Conexão YTMusic fechada.");
  }
}
