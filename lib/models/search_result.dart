// SearchResult é uma union de vários tipos, então é uma interface
import 'package:audio_service/audio_service.dart';

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
