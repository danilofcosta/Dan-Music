import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class AudioCacheConfig {
  static const String key = 'audioCache';
  static const Duration stalePeriod = Duration(days: 30);
  static const int maxNrOfCacheObjects = 200;
}

class AudioCacheManager extends CacheManager {
  static final AudioCacheManager _instance = AudioCacheManager._();
  factory AudioCacheManager() => _instance;

  AudioCacheManager._()
      : super(
          Config(
            AudioCacheConfig.key,
            stalePeriod: AudioCacheConfig.stalePeriod,
            maxNrOfCacheObjects: AudioCacheConfig.maxNrOfCacheObjects,
          ),
        );
}
