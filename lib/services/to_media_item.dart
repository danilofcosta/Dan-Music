import 'package:audio_service/audio_service.dart';
import 'package:dart_ytmusic_api/dart_ytmusic_api.dart' show SongDetailed, VideoDetailed;
import '/models/song.dart';

class ToMediaItem {
  // static Future<MediaItem> videoInfo(VideoInfo videoInfo) async {
  //   final Map<String, dynamic> map = {
  //     'id': videoInfo.id,
  //     'originalUrl': videoInfo.originalUrl,
  //     'category': videoInfo.category,
  //     'ismusic': videoInfo.uploaderName.contains("Topic"),
  //   };

  //   Uri artUri = Uri.parse(videoInfo.thumbnails.last.url);
  //   return MediaItem(
  //     id: videoInfo.id,
  //     title: videoInfo.name,
  //     artist: videoInfo.uploaderName.replaceAll('- Topic', ''),
  //     //artUri: Uri.parse(videoInfo.thumbnails.last.url),
  //     artUri: artUri,
  //     duration: Duration(seconds: videoInfo.duration),
  //     extras: map,
  //   );
  // }

  static MediaItem song(Song song) {
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

  static MediaItem songDetailed(SongDetailed song) {
    return MediaItem(
      id: song.videoId,
      title: song.name,
      artist: song.artist.name,
      album: song.album?.name ?? '',
      artUri: Uri.parse(song.thumbnails.last.url),
      duration: song.duration != null ? Duration(seconds: song.duration!) : null,
    );}
  static MediaItem videoDetailed(VideoDetailed song) {
    return MediaItem(
      id: song.videoId,
      title: song.name,
      artist: song.artist.name,
      album: '',
      artUri: Uri.parse(song.thumbnails.last.url),
      duration: song.duration != null ? Duration(seconds: song.duration!) : null,
    );
  }
  }

