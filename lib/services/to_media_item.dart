import 'package:audio_service/audio_service.dart';
import '/models/song.dart';
import 'package:flutter_new_pipe_extractor/flutter_new_pipe_extractor.dart';

class ToMediaItem {
  static Future<MediaItem> videoInfo(VideoInfo videoInfo) async {
    final Map<String, dynamic> map = videoInfo.toJson();
    Uri artUri = Uri.parse(videoInfo.thumbnails.last.url);
    return MediaItem(
      id: videoInfo.id,
      title: videoInfo.name,
      artist: videoInfo.uploaderName,
      //artUri: Uri.parse(videoInfo.thumbnails.last.url),
      artUri: artUri,
      duration: Duration(seconds: videoInfo.duration),
      //  extras: map,
    );
  }

  static Future<MediaItem> song(Song song) async {
    /// final Map<String, dynamic> map = song.toJson();
    return MediaItem(
      id: song.videoid,
      title: song.title,
      artist: song.artist,
      artUri: song.thumbnails?.firstOrNull == null
          ? null
          : Uri.parse(song.thumbnails!.first),
      duration: Duration(seconds: song.secondsduration ?? 0),

      ///extras: e.toJson(),
    );
  }
}
