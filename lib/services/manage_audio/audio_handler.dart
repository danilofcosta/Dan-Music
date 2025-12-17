import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:danmusic/services/manage_audio/manage_audio_url.dart';

import '/services/uteis/helper.dart';
import '/services/ytmusicapi.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages, implementation_imports
import 'package:rxdart/src/subjects/behavior_subject.dart';

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

class MyAudioHandler extends BaseAudioHandler
    with QueueHandler, SeekHandler, AudioHandlerMixin {
  late AudioPlayer _player;
  //late final String _cacheDir;
  String _cacheDir = '';

  dynamic currentIndex;
  bool shuffleModeEnabled = false;
  bool isSongLoading = true;
  bool loopModeEnabled = false;

  bool isPlayingUsingLockCachingSource = false;
  BehaviorSubject<MediaItem?> get songNow => mediaItem;
  // AudioPlayer get player => _player;
  String get cacheDir => _cacheDir;

  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration> get positionBuffered => _player.bufferedPositionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<bool> get isPlayingStream => _player.playingStream;

  MyAudioHandler() {
    _player = AudioPlayer(
      // audioLoadConfiguration: const AudioLoadConfiguration(
      //   androidLoadControl: AndroidLoadControl(
      //     minBufferDuration: Duration(seconds: 60), // Aumenta buffer mínimo
      //     maxBufferDuration: Duration(minutes: 3), // Aumenta buffer máximo
      //     bufferForPlaybackDuration: Duration(
      //       seconds: 1,
      //     ), // Reduz tempo para iniciar reprodução
      //     bufferForPlaybackAfterRebufferDuration: Duration(
      //       seconds: 10,
      //     ), // Reduz tempo após rebuffering
      //   ),
      // ),
    );

    _player.errorStream.listen((PlayerException e) {
      printErrorDebug('AudioPlayer Error code: ${e.code}');
      printErrorDebug('AudioPlayer Error message: ${e.message}');
      printErrorDebug('AudioSource index: ${e.index}');
    });

    _createCacheDir();
    _listenToPlaybackForNextSong();
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
  }
  void _listenToPlaybackForNextSong() {
    final playerDurationOffset = 0;
    try {
      _player.positionStream.listen((value) async {
        if (_player.duration != null && _player.duration?.inSeconds != 0) {
          if (value.inMilliseconds >=
              (_player.duration!.inMilliseconds - playerDurationOffset)) {
            await _triggerNext();
          }
        }
      });
    } catch (e) {
      printErrorDebug(e);
    }
  }

  Future<void> _createCacheDir() async {
    // 1. Começa com o diretório temporário padrão
    Directory tempDir = await getTemporaryDirectory();
    _cacheDir = tempDir.path;

    // 2. Tenta usar o diretório de cache externo (Android)
    final externalDirs = await getExternalCacheDirectories();
    if (externalDirs != null && externalDirs.isNotEmpty) {
      _cacheDir = externalDirs.first.path;
    }

    // 3. Monta o caminho final da pasta de músicas em cache
    final cachedSongsDir = Directory('$_cacheDir/cachedSongs');

    // 4. Cria o diretório se não existir
    if (!await cachedSongsDir.exists()) {
      await cachedSongsDir.create(recursive: true);
      printInfoDebug("created cache dir: ${cachedSongsDir.path}");
    }
  }

  Future<AudioSource> _createAudioSource(MediaItem mediaItem) async {
    String audioUrl = mediaItem.id;

    if (audioUrl.startsWith('http')) {
      return AudioSource.uri(Uri.parse(audioUrl), tag: mediaItem);
    }
    if (fileExists(File(audioUrl))) {
      return AudioSource.file(audioUrl, tag: mediaItem);
    }
    audioUrl = await ManageAudioURL.getAudioUrlNewpipe(mediaItem.id);

    return AudioSource.uri(Uri.parse(audioUrl), tag: mediaItem);
  }

  @override
  Future<void> updateQueue(List<MediaItem> queue) async {
    this.queue.add(queue);
  }

  @override
  Future<void> playMediaItem(MediaItem mediaItem) async {
    var currentIndex = queue.value.indexWhere((e) => e.id == mediaItem.id);
    if (currentIndex != -1) {
      // A música já está na fila → tocar ela
      currentIndex = currentIndex;
      await _triggerNext(index: currentIndex);
      //  return super.skipToNext();
    } else {
      // A música não está na fila → adicionar e tocar
      final newQueue = List<MediaItem>.from(queue.value)..add(mediaItem);
      queue.add(newQueue);
      currentIndex = newQueue.length - 1;
      await _triggerNext(index: currentIndex);
    }
  }

  // Comandos padrões
  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() => _player.stop();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> skipToQueueItem(int index) async {
    await _triggerNext(index: index);
    //  return super.skipToNext();
    //  _player.seek(Duration.zero, index: index);
  }

  @override
  Future<void> skipToNext() async {
    await _triggerNext();
    // return super.skipToNext();
  }

  @override
  Future<void> skipToPrevious() async {
    await _triggerPrev();
    //return super.skipToPrevious();
  }

  @override
  Future<void> customAction(String name, [Map<String, dynamic>? extras]) async {
    printInfoDebug('customAction: $name, $extras');
    //  printInfoDebug('customAction: ${player.currentIndex}, $extras');
    switch (name) {
      case 'playByVideoId':
        final String videoId = extras!['VideoId'];
        if (queue.value.isNotEmpty && queue.value.first.id == videoId) {
          return;
        }

        MediaItem songMediaItem = await YouTubeMusicService.getSong(videoId);
        queue.add([songMediaItem]);

        currentIndex = 0;
        songNow.add(songMediaItem);
        // _player.setAudioSource(
        //   AudioSource.uri(
        //     Uri.parse(await ManageAudioURL.getAudioUrlNewpipe(videoId)),
        //     tag: songMediaItem,
        //   ),
        // );
        // await _player.stop();
        final c = await _createAudioSource(songMediaItem);

        await _player.setAudioSource(c);
        _player.play();
        // return;

        List<MediaItem> newQueue = await YouTubeMusicService.getRelatedPlaylist(
          videoId,
        );

        // _player.addAudioSources(
        //   newQueue.map((e) => CustomVideoAudioSource(e.id)).toList(),
        // );

        queue.add([songMediaItem, ...newQueue]);

        //_player.play();

        return;
      case 'getIndex':
        return currentIndex;
      case 'playByIndex':
        final int index = extras!['index'];
        await _triggerNext(index: index);
        return;
      default:
        printErrorDebug('Ação personalizada desconhecida: $name');
    }
  }

  Future<void> _triggerPrev() async {
    currentIndex = (currentIndex - 1 + queue.value.length) % queue.value.length;
    MediaItem songMediaItem = queue.value[currentIndex!];
    songMediaItem = await YouTubeMusicService.getSong(songMediaItem.id);
    mediaItem.add(songMediaItem);

    await _player.setAudioSource(await _createAudioSource(songMediaItem));
    _player.play();
    return;
  }

  Future<void> _triggerNext({int? index}) async {
    if (queue.value.isEmpty) return;
    currentIndex = index ?? (currentIndex + 1) % queue.value.length;
    MediaItem song = queue.value[currentIndex!];

    song = await YouTubeMusicService.getSong(song.id);
    mediaItem.add(song);
    var t = await _createAudioSource(song);
    await _player.setAudioSource(t);

    _player.play();
  }

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        //  MediaControl.rewind,
        MediaControl.skipToPrevious,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.skipToNext,
        MediaControl.stop,
        MediaControl.fastForward,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 2],
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
      queueIndex: currentIndex,
    );
  }
}

mixin AudioHandlerMixin {
  bool fileExists(File file) {
    return file.existsSync();
  }
}
