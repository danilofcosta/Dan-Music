import 'package:danmusic/models/album.dart';
import 'package:danmusic/services/to_media_item.dart';
import 'package:dart_ytmusic_api/types.dart';

import '../../models/artist.dart';
import '../../models/playlist.dart';

class ParserArtist {
  static FullArtist artistFull(ArtistFull artist) {
    final topSongs = artist.topSongs
        .map((e) => ToMediaItem.songDetailed(e))
        .toList();
    final topAlbums = artist.topAlbums
        .map(
          (e) => Album(
            albumId: e.albumId,
            playlistId: e.playlistId,
            name: e.name,
            artist: e.artist.name,
            year: e.year,
            thumbnails: e.thumbnails.map((e) => e.url).toList(),
          ),
        )
        .toList();
    final topSingles = artist.topSingles
        .map(
          (e) => Album(
            albumId: e.albumId,
            playlistId: e.playlistId,
            name: e.name,
            artist: e.artist.name,
            year: e.year,
            thumbnails: e.thumbnails.map((e) => e.url).toList(),
          ),
        )
        .toList();

    final topVideos = artist.topVideos
        .map((e) => ToMediaItem.videoDetailed(e))
        .toList();

    final featuredOn = artist.featuredOn
        .map(
          (e) => Playlist(
            playlistId: e.playlistId,
            title: e.name,
            desciption: e.artist.name,
            thumbnails: e.thumbnails.map((e) => e.url).toList(),
          ),
        )
        .toList();

    final similarArtists = artist.similarArtists
        .map(
          (e) => Artistdetail(
            artistId: e.artistId,
            artistName: e.name,
            thumbnail: e.thumbnails.last.url,
          ),
        )
        .toList();

    return FullArtist(
      artistName: artist.name,
      artistId: artist.artistId,
      thumbnail: artist.thumbnails.last.url,
      topSongs: topSongs,
      topAlbums: topAlbums,
      topSingles: topSingles,
      topVideos: topVideos,
      featuredOn: featuredOn,
      similarArtists: similarArtists,
    );
  }
}
