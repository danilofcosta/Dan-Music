import 'package:danmusic/models/album.dart';
import 'package:danmusic/models/home_section.dart';
import 'package:danmusic/models/song.dart';
import 'package:danmusic/models/thumbnail.dart';

class ArtistBasic implements HomeContent {
  final String name;
  final String id;
  ArtistBasic({required this.name, required this.id});
}

class ArtistDetail implements HomeContent {
  final String name;
  final String browseId;
  final String? shuffleId;
  final String? radioId;

  final String? subscribers;
  final List<Thumbnail> thumbnails;

  ArtistDetail({
    required this.subscribers,
    required this.thumbnails,
    required this.name,
    required this.browseId,
    required this.shuffleId,
    required this.radioId,
  });
}

class ArtistFull {
  final String name;
  final String? description;
  final String? views;
  final String? channelId;
  final String? shuffleId;
  final String? radioId;
  final String? subscribers;
  final bool? subscribed;
  final List<Thumbnail>? thumbnails;
  final List<Song>? songs;
  final String? songsBrowseId;
  final List<Album>? albums;
  final String? albumsBrowseId;
  final String? albumsParams;
  final List<Album>? singles;
  final String? singlesBrowseId;
  final String? singlesParams;
  final List<Song>? videos;
  final String? videosBrowseId;
  final List<ArtistDetail>? related;

  ArtistFull({
    required this.name,
    this.description,
    this.views,
    this.channelId,
    this.shuffleId,
    this.radioId,
    this.subscribers,
    this.subscribed,
    this.thumbnails,
    this.songs,
    this.songsBrowseId,
    this.albums,
    this.albumsBrowseId,
    this.albumsParams,
    this.singles,
    this.singlesBrowseId,
    this.singlesParams,
    this.videos,
    this.videosBrowseId,
    this.related,
  });
}
