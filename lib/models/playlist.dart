import 'package:danmusic/models/home_section.dart';
import 'package:danmusic/models/song.dart';
import 'package:danmusic/models/thumbnail.dart';

class Playlist implements HomeContent {
  final String browseId;
  final String title;
  final String? author;
  final String? itemCount;
  final List<Thumbnail>? thumbnails;

  Playlist({
    required this.browseId,
    required this.title,
    this.author,
    this.itemCount,
    this.thumbnails,
  });
}

class PlaylistFull {
  final String id;
  final String title;
  final String? description;
  final String? author;
  final List<Thumbnail> thumbnails;

  final String? durationText;
  final int? secondsduration;
  final int? trackCount;
  final String? year;
  final List? releted;
  final List<Song>? tracks;

  PlaylistFull({
    required this.id,
    required this.title,
    required this.description,
    this.author,
    required this.thumbnails,
    this.durationText,
    this.secondsduration,
    this.trackCount,
    this.year,
    this.releted,
    this.tracks,
  });
}
