// SearchResult é uma union de vários tipos, então é uma interface
import 'package:audio_service/audio_service.dart';

import 'package:danmusic/models/artist.dart' show Artistdetail;
import 'package:danmusic/models/playlist_basic.dart';

import 'package:danmusic/models/album.dart';

abstract class SearchResult {
  String get type;
}


class SongDetailedSearchResult implements SearchResult {
  @override
  final String type = 'SONG';
  final MediaItem songMedia;

  SongDetailedSearchResult({
    required this.songMedia,
  });
}

class PlaylistDetailedSearchResult implements SearchResult {
  @override
  final String type = 'PLAYLIST';
  final PlaylistBasic playlist;

  PlaylistDetailedSearchResult({
   required this.playlist,
  });
}



class AlbumDetailedSearchResult implements SearchResult {
  @override
  final String type = 'ALBUM';
  final Album album;

  AlbumDetailedSearchResult({
   required this.album,
  });
}


class ArtistDetailedSearchResult implements SearchResult {
  @override
  final String type = 'ARTIST';
  final Artistdetail artist;

  ArtistDetailedSearchResult({
   required this.artist,
  });
}
