import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';

import '../../models/song.dart';
import '../../models/search/search_song.dart';
import 'manage_audio_url.dart';

Future<MyAudioHandler> initAudioService() async {
  final session = await AudioSession.instance;
  await session.configure(AudioSessionConfiguration.speech());
  return await AudioService.init(
    builder: () => MyAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.mycompany.myapp.audio',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );
}

class MediaState {
  final MediaItem? mediaItem;
  final Duration position;

  MediaState(this.mediaItem, this.position);
}

class MyAudioHandler extends BaseAudioHandler with SeekHandler {
  static final item = Song(
    id: 'https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3',
    album: "Science Friday",
    title: "A Salute To Head-Scratching Science",
    artist: "Science Friday and WNYC Studios",
    duration: const Duration(milliseconds: 5739820),
    artUri: Uri.parse(
      'https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg',
    ),
  );

  final AudioPlayer _player = AudioPlayer();
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration> get positionBuffered => _player.bufferedPositionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<bool> get isPlayingStream => _player.playingStream;

  AudioPlayer get player => _player;
  MyAudioHandler() {
    _init();
  }

  Future<void> _init() async {
    // Carrega o áudio
    // await _player.setAudioSource(AudioSource.uri(Uri.parse(_item.id)));

    // // Atualiza MediaItem com duração real
    // mediaItem.add(_item);
    // _player.play();

    // Atualiza PlaybackState continuamente
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
  }

  // CONTROLES
  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> stop() => _player.stop();

  /// Adiciona um `SearchSong` como `MediaItem` ao handler.
  Future<void> addSearchSongAsMediaItem(SearchSong s) async {
    final media = Song.fromSearchSong(s);
    mediaItem.add(media);
  }

  Future<void> playById(Song song) async {
    final url = await ManageAudioURL.getAudioUrlNewpipe(song.id);

    await _player.setAudioSource(AudioSource.uri(Uri.parse(url)));
    mediaItem.add(song);
    _player.play();
  }

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.rewind,
        _player.playing ? MediaControl.pause : MediaControl.play,
        MediaControl.stop,
        MediaControl.fastForward,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
    );
  }
}
