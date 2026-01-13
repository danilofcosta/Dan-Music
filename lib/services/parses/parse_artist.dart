import 'package:danmusic/models/album.dart';
import 'package:danmusic/models/artist.dart';
import 'package:danmusic/models/song.dart';
import 'package:danmusic/services/parses/parse_album.dart';
import 'package:danmusic/services/parses/parse_song.dart';
import 'package:danmusic/services/parses/parse_thumbnail.dart';

import '../../models/thumbnail.dart';

class ParseArtist {
  static String artistsToString(List<ArtistBasic> artists) {
    return artists.map((a) => a.name).join(', ');
  }

  static ArtistBasic artistBasic(dynamic data) {
    // Quando vem só o nome do artista como String
    if (data is String) {
      return ArtistBasic(name: data, id: '');
    }

    // Quando vem o objeto completo
    if (data is Map<String, dynamic>) {
      final name = data['name']?.toString() ?? '';
      final id = data['id']?.toString() ?? '';

      return ArtistBasic(name: name, id: id);
    }

    throw Exception('Formato inválido para ArtistBasic: ${data.runtimeType}');
  }

  static ArtistFull artistFull(Map<String, dynamic> jsondata) {
    final String name = jsondata['name'] ?? '';
    final String? description = jsondata['description'];
    final String? views = jsondata['views'];
    final String? channelId = jsondata['channelId'];
    final String? shuffleId = jsondata['shuffleId'];
    final String? radioId = jsondata['radioId'];
    final String? subscribers = jsondata['subscribers'];
    final bool? subscribed = jsondata['subscribed'];

    final List<Thumbnail>? thumbnails = jsondata['thumbnails'] != null
        ? ParseThumbnail.thumbnail(jsondata['thumbnails'])
        : null;

    final songsData = jsondata['songs'];
    final List<Song>? songs = songsData != null && songsData['results'] != null
        ? (songsData['results'] as List)
            .map((e) => ParseSong.song(e as Map<String, dynamic>))
            .toList()
        : null;
    final String? songsBrowseId = songsData?['browseId'];

    final albumsData = jsondata['albums'];
    final List<Album>? albums =
        albumsData != null && albumsData['results'] != null
            ? (albumsData['results'] as List)
                .map((e) => ParseAlbum.album(e as Map<String, dynamic>))
                .toList()
            : null;
    final String? albumsBrowseId = albumsData?['browseId'];
    final String? albumsParams = albumsData?['params'];

    final singlesData = jsondata['singles'];
    final List<Album>? singles =
        singlesData != null && singlesData['results'] != null
            ? (singlesData['results'] as List)
                .map((e) => ParseAlbum.album(e as Map<String, dynamic>))
                .toList()
            : null;
    final String? singlesBrowseId = singlesData?['browseId'];
    final String? singlesParams = singlesData?['params'];

    final videosData = jsondata['videos'];
    final List<Song>? videos =
        videosData != null && videosData['results'] != null
            ? (videosData['results'] as List)
                .map((e) => ParseSong.song(e as Map<String, dynamic>))
                .toList()
            : null;
    final String? videosBrowseId = videosData?['browseId'];

    final relatedData = jsondata['related'];
    final List<ArtistDetail>? related =
        relatedData != null && relatedData['results'] != null
            ? (relatedData['results'] as List).map((e) {
                final artist = e as Map<String, dynamic>;
                return ArtistDetail(
                  name: artist['title'] ?? '',
                  browseId: artist['browseId'] ?? null,
                  shuffleId: artist['shuffleId'] ?? null,
                  radioId: artist['radioId'] ?? null,
                  subscribers: artist['subscribers'] ?? '',
                  thumbnails: ParseThumbnail.thumbnail(artist['thumbnails']),
                );
              }).toList()
            : null;

    return ArtistFull(
      name: name,
      description: description,
      views: views,
      channelId: channelId,
      shuffleId: shuffleId,
      radioId: radioId,
      subscribers: subscribers,
      subscribed: subscribed,
      thumbnails: thumbnails,
      songs: songs,
      songsBrowseId: songsBrowseId,
      albums: albums,
      albumsBrowseId: albumsBrowseId,
      albumsParams: albumsParams,
      singles: singles,
      singlesBrowseId: singlesBrowseId,
      singlesParams: singlesParams,
      videos: videos,
      videosBrowseId: videosBrowseId,
      related: related,
    );
  }
}
