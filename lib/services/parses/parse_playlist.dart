import 'package:danmusic/models/playlist.dart';
import 'package:danmusic/services/parses/parse_artist.dart';
import 'package:danmusic/services/parses/parse_song.dart';
import 'package:danmusic/services/parses/parse_thumbnail.dart';
import 'package:danmusic/services/uteis/helper.dart';

import '../../models/song.dart';

class ParsePlaylist {
  static PlaylistFull parsePlaylistFull(Map<String, dynamic> data) {
    final durationSeconds = data['duration_seconds'];
    final durationText = data['duration'];
    final id = data['id'];
    final title = data['title'];
    final thumbnail = ParseThumbnail.thumbnail(data['thumbnails']);
    final description = data['description'];
    final author = ParseArtist.artistBasic(data['author']);
    final trackCount = data['track_count'];
    final year = data['year'];
    final related = data['related'];
    
    final List<Song> tracks = (data['tracks'] as List<dynamic>)
        .map((e) => ParseSong.song(e as Map<String, dynamic>))
        .toList();
      printInfoDebug('Tracks: ${tracks.length}');

    return PlaylistFull(
      id: id,
      title: title,
      description: description,
      author: author.name,
      thumbnails: thumbnail,
      durationText: durationText,
      secondsduration: durationSeconds,
      trackCount: trackCount,
      year: year,
      releted: related,
      tracks: tracks,
    );
  }
}
