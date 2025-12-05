
import 'package:audio_service/audio_service.dart';
import 'package:danmusic/models/album.dart';
import 'package:danmusic/models/playlist.dart';

class Artistdetail{
  final String artistName;
  final String? artistId;
  final String? thumbnail;

  Artistdetail( {required this.artistName, required this.artistId,  this.thumbnail});

}

class FullArtist extends Artistdetail{
   // final List<ThumbnailFull> thumbnails;
  final List<MediaItem>? topSongs;
  final List<Album>? topAlbums;
  final List<Album>? topSingles;
  final List<MediaItem>? topVideos;
  final List<Playlist>? featuredOn;
  final List<Artistdetail>? similarArtists;

  FullArtist({required super.artistName, required this.topSongs, required this.topAlbums, required this.topSingles, required this.topVideos, required this.featuredOn, required this.similarArtists, required super.artistId, required super.thumbnail});
}