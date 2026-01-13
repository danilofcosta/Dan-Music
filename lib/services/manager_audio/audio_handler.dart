import 'dart:collection';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:danmusic/services/manager_audio/instance_test_audio.dart';
import 'package:danmusic/services/uteis/helper.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../../models/song.dart';
import '../yt_api.dart';
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
  int? currentIndex;
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
    sequenceStateStreamListen();
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
  }

  Future<void> playByIndex(int index) async {
    if (index == currentIndex) return;
    await _player.seek(Duration.zero, index: index);
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

  @override
  Future<void> skipToNext() => _player.seekToNext();
  @override
  Future<void> skipToPrevious() => _player.seekToPrevious();

  void sequenceStateStreamListen() async {
    player.sequenceStateStream.listen((event) async {
      printInfoDebug(event.currentIndex);
      if (queue.value.isEmpty) return;
      final song = queue.value[event.currentIndex ?? 0];
      if (currentIndex != event.currentIndex && event.currentIndex != null) {
        final Map<String, dynamic> data = await ManageAudioURL.getdata(song.id);
        final songn = song.copyWith(artUri: Uri.parse(data['cover']));
        mediaItem.add(songn);
        currentIndex = event.currentIndex;

        if (event.currentIndex == queue.value.length ||
            event.currentIndex == queue.value.length) {
          nextsogs(song);
        }
      }
    });
  }

  Future<void> uploadQuere(List<Song> songs) async {
    queue.value = songs;
    // currentIndex = 0;
    final list = songs.map((e) => e.id).toList();
    final f = songs.map((e) => ApiAudioSource(e.id)).toList();
    _player.setAudioSources(songs.map((e) => ApiAudioSource(e.id)).toList());
    play();
  }

  Future<void> playById(Song song) async {
    return;
    if (song.id.isEmpty) {
      printErrorDebug("ID da música está vazio $song");
      printErrorDebug("Erro ao tentar reproduzir música");
      return;
    }

    final Map<String, dynamic> data = await ManageAudioURL.getdata(song.id);
    final url = data['url'];
    final cover = data['cover'];

    final songn = song.copyWith(id: url, artUri: Uri.parse(cover));
    mediaItem.add(songn);

    await _player.setAudioSource(AudioSource.uri(Uri.parse(url)));

    //  mediaItem.add(songn);
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
        MediaAction.skipToPrevious,
        MediaAction.skipToNext,
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

  Future<void> nextsogs(MediaItem song) async {
    final YouTubeMusicService youTubeService = Get.find<YouTubeMusicService>();
    final newQuere = await youTubeService.getNextSongs(song.id);
  }
}
