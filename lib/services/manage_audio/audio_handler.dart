import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:danmusic/services/manage_audio/manage_audio_url.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import '/services/uteis/helper.dart';
import '/services/ytmusicapi.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages, implementation_imports
import 'package:rxdart/src/subjects/behavior_subject.dart';

Future<AudioHandler> initAudioService() async {
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
  late final String _cacheDir;

  dynamic currentIndex;
  bool shuffleModeEnabled = false;
  bool isSongLoading = true;
  bool loopModeEnabled = false;

  bool isPlayingUsingLockCachingSource = false;
  BehaviorSubject<MediaItem?> get songNow => mediaItem;
  AudioPlayer get player => _player;
  String get cacheDir => _cacheDir;

  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration> get positionBuffered => _player.bufferedPositionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<bool> get isPlayingStream => _player.playingStream;

  MyAudioHandler() {
    _player = AudioPlayer(
      audioLoadConfiguration: const AudioLoadConfiguration(
        androidLoadControl: AndroidLoadControl(
          minBufferDuration: Duration(seconds: 50),
          maxBufferDuration: Duration(seconds: 120),
          bufferForPlaybackDuration: Duration(milliseconds: 50),
          bufferForPlaybackAfterRebufferDuration: Duration(seconds: 2),
        ),
      ),
    );

    //  _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
    player.errorStream.listen((PlayerException e) {
      printErrorDebug('AudioPlayer Error code: ${e.code}');
      printErrorDebug('AudioPlayer Error message: ${e.message}');
      printErrorDebug('AudioSource index: ${e.index}');
      if (e.message == 'Source error') {
        printErrorDebug('AudioPlayer Error message: ${e.message}');
      }
    });

    _createCacheDir();
    _listenToPlaybackForNextSong();
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
  }

  Future<void> _createCacheDir() async {
    _cacheDir = (await getTemporaryDirectory()).path;
    if (!Directory("$_cacheDir/cachedSongs/").existsSync()) {
      Directory("$_cacheDir/cachedSongs/").createSync(recursive: true);
    }
  }

  @override
  Future<void> updateQueue(List<MediaItem> queue) async {
    final newQueue = this.queue.value
      ..replaceRange(0, this.queue.value.length, queue);
    this.queue.add(newQueue);
  }

  // @override
  // Future<void> playMediaItem(MediaItem mediaItem) async {
  //   final index = queue.value.indexWhere((e) => e.id == mediaItem.id);
  //   try {
  //     if (_player.playing) {
  //       // _player.pause();
  //     }

  //     if (index != -1) {
  //       // A música já está na fila → tocar ela
  //       skipToQueueItem(index);

  //       return;
  //     }

  //     //VideoInfo videoInfo = await DownloaderChannel.getAudioUrl(mediaItem.id);

  //     // debugPrint(g);
  //     // MediaItem mediaItem = await ToMediaItem.videoInfo(videoInfo);
  //     songNow.add(mediaItem);
  //     // Download and cache audio while playing it (experimental)
  //     final audioSource = CachedStreamAudioSource(
  //       videoId: mediaItem.id,
  //       tag: mediaItem,
  //     );
  //     await _player.setAudioSource(audioSource);
  //     // Delete the cached file
  //     _player.play();
  //     // queue.add([mediaItem]);

  //     List<MediaItem> newQueue = await YouTubeMusicService.getRelatedPlaylist(
  //       mediaItem.id,
  //     );

  //     queue.add([mediaItem, ...newQueue]);

  //     _player.addAudioSources(
  //       newQueue
  //           .map((e) => CachedStreamAudioSource(videoId: e.id, tag: e))
  //           .toList(),
  //     );
  //   } catch (e) {
  //     debugPrint("ERRO NO AUDIO SERVICE: $e");
  //   }
  // }
  @override
  Future<void> playMediaItem(MediaItem mediaItem) async {
    List<MediaItem> newQueue = await YouTubeMusicService.getRelatedPlaylist(
      mediaItem.id,
    );

    queue.add([mediaItem, ...newQueue]);
  }

  // Future<void> playPlaylistId(String playlistid) async {
  //   PlaylistFull? playlist = await YouTubeMusicService.getPlaylist(playlistid);
  //   try {
  //     if (_player.playing) {
  //       _player.pause();
  //     }
  //     var audioSources = playlist.tracks!
  //         .map((e) => CachedStreamAudioSource(videoId: e.videoid))
  //         .toList();

  //     await _player.setAudioSources(audioSources);
  //     // Delete the cached file

  //     List<MediaItem> queueN = await Future.wait(
  //       playlist.tracks!.map((e) async {
  //         return await ToMediaItem.song(e);
  //       }),
  //     );

  //     queue.add(queueN);
  //     //     mediaItem.add(queueN.first);
  //     _player.play();
  //     //debugPrint(playlist.trackCount.toString());
  //   } catch (e) {
  //     debugPrint("ERRO NO AUDIO SERVICE: $e");
  //   }
  // }

  // Comandos padrões

  int _getNextSongIndex() {
    if (queue.value.isEmpty) return 0;
    int index = currentIndex + 1;
    if (index >= queue.value.length) index = 0;
    return index;
  }

  int _getPreviousSongIndex() {
    int index = currentIndex - 1;
    if (index >= queue.value.length) index = 0;
    return index;
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() => _player.stop();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> skipToNext() async {
    if (currentIndex == null) return;
    final index = _getNextSongIndex();
    if (index != currentIndex) {
      if (_player.position != Duration.zero) _player.seek(Duration.zero);
      await customAction("playByIndex", {'index': index});
    } else {
      _player.seek(Duration.zero);
      _player.pause();
    }
  }

  @override
  Future<void> skipToPrevious() async {
    final index = _getPreviousSongIndex();
    if (index != currentIndex) {
      if (_player.position != Duration.zero) _player.seek(Duration.zero);

      await customAction("playByIndex", {'index': index});
    } else {
      _player.seek(Duration.zero);
      _player.pause();
    }
  }

  AudioSource _createAudioSource({
    required String urlAudio,
    required MediaItem mediaItem,
  }) {
    if (urlAudio.contains("http")) {
      return AudioSource.uri(Uri.parse(urlAudio), tag: mediaItem);
      
    }
    return LockCachingAudioSource(
      Uri.parse(urlAudio),
      cacheFile: File("$_cacheDir/${mediaItem.id}.mp3"),
      tag: mediaItem,
    );
  }

  @override
  Future<void> skipToQueueItem(int index) =>
      _player.seek(Duration.zero, index: index);
  Future<void> _triggerNext() async {
    if (loopModeEnabled) {
      await _player.seek(Duration.zero);
      if (!_player.playing) {
        _player.play();
      }
      return;
    }
    skipToNext();
  }

  void seekByIndex(int index) {
    customAction("playByIndex", {"index": index});
  }

  @override
  Future<void> customAction(String name, [Map<String, dynamic>? extras]) async {
    printInfoDebug('customAction: $name, $extras');
    switch (name) {
      case 'playByIndex':
        final songIndex = extras!['index'] as int;
        if (songIndex == -1) {
          printErrorDebug("index invalid: $songIndex");
          return;
        }

        if (currentIndex != null) _player.pause();
        // evita carregamento duplicado
        if (currentIndex == songIndex && _player.playing) {
          printInfoDebug("index set tocando: $songIndex");
          return;
        }

        currentIndex = songIndex;

        MediaItem currentsonf = queue.value[songIndex];

        playbackState.value.copyWith(
          processingState: AudioProcessingState.loading,
        );

        currentsonf = await YouTubeMusicService.getSong(currentsonf.id);

        mediaItem.add(currentsonf);

        if (await fileExist(File('$_cacheDir/${currentsonf.id}.mp3'))) {
          printInfoDebug(
            'arquivo encontrado: $_cacheDir/${currentsonf.id}.mp3',
          );
          await _player.clearAudioSources();

          await _player.setAudioSource(
            _createAudioSource(
              urlAudio: 'file://$_cacheDir/${currentsonf.id}.mp3',
              mediaItem: currentsonf,
            ),
          );
          _player.play();
        }
        // busca o link do áudio online
        printInfoDebug(
          'arquivo nao encontrado: $_cacheDir/${currentsonf.id}.mp3 buscando online',
        );
        String videoInfo = await ManageAudioURL.getAudioUrlNewpipe(
          currentsonf.id,
        );

        await _player.clearAudioSources();

        await _player.setAudioSource(
          _createAudioSource(urlAudio: videoInfo, mediaItem: currentsonf),
        );
        _player.play();
    }
  }

  void _listenToPlaybackForNextSong() {
    // final playerDurationOffset = GetPlatform.isWindows
    //     ? 200
    //     : GetPlatform.isLinux
    //         ? 700
    //         : 0;
    final playerDurationOffset = 0;

    _player.positionStream.listen((value) async {
      if (_player.duration != null && _player.duration?.inSeconds != 0) {
        if (value.inMilliseconds >=
            (_player.duration!.inMilliseconds - playerDurationOffset)) {
          await _triggerNext();
        }
      }
    });
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
      queueIndex: event.currentIndex,
    );
  }
}

mixin AudioHandlerMixin {
  Future<bool> fileExist(File file) async {
    return file.existsSync();
  }
}
