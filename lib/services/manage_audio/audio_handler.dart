import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/services.dart';
import '/models/playlist_full.dart';
import '/services/manage_audio/cached_stream_audio_source.dart';
import '/services/to_media_item.dart';
import '/services/uteis/helper.dart';
import '/services/ytmusicapi.dart';
import 'package:flutter/material.dart';
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

class MyAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  late AudioPlayer _player;
  late final _cacheDir;

  dynamic currentIndex;
  bool shuffleModeEnabled = false;
  bool isSongLoading = true;

  bool isPlayingUsingLockCachingSource = false;
  BehaviorSubject<MediaItem?> get songNow => mediaItem;
  AudioPlayer get player => _player;
  String get cacheDir => _cacheDir;

  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration> get positionBuffered => _player.bufferedPositionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<bool> get isPlayingStream => _player.playingStream;

  MyAudioHandler() {
    _listenPlayerChanges();

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
    });

    _createCacheDir();
    _notifyAudioHandlerAboutPlaybackEvents();
    _listenForDurationChanges();
  }

  // Escuta mudanças de índice e estado
  void _listenPlayerChanges() {
    /// Atualiza o MediaItem automaticamente
    // _player.currentIndexStream.listen((index) {
    //  /// final q = queue.value;
    //   );

    /// Atualiza estado de playback
  }

  Future<void> _createCacheDir() async {
    _cacheDir = (await getTemporaryDirectory()).path;
    if (!Directory("$_cacheDir/cachedSongs/").existsSync()) {
      Directory("$_cacheDir/cachedSongs/").createSync(recursive: true);
    }
  }

  @override
  Future<void> playMediaItem(MediaItem mediaItem) async {
    final index = queue.value.indexWhere((e) => e.id == mediaItem.id);
    try {
      if (_player.playing) {
        // _player.pause();
      }

      if (index != -1) {
        // A música já está na fila → tocar ela
        skipToQueueItem(index);

        return;
      }

      //VideoInfo videoInfo = await DownloaderChannel.getAudioUrl(mediaItem.id);

      // debugPrint(g);
      // MediaItem mediaItem = await ToMediaItem.videoInfo(videoInfo);
      songNow.add(mediaItem);
      // Download and cache audio while playing it (experimental)
      final audioSource = CachedStreamAudioSource(videoId: mediaItem.id,tag: mediaItem);
      await _player.setAudioSource(audioSource);
      // Delete the cached file
      _player.play();
      // queue.add([mediaItem]);

      List<MediaItem> newQueue = await YouTubeMusicService.getRelatedPlaylist(
        mediaItem.id,
      );

      queue.add([mediaItem, ...newQueue]);

      _player.addAudioSources(
        newQueue.map((e) => CachedStreamAudioSource(videoId: e.id,tag: e)).toList(),
      );
    } catch (e) {
      debugPrint("ERRO NO AUDIO SERVICE: $e");
    }
  }

  Future<void> playPlaylistId(String playlistid) async {
    PlaylistFull? playlist = await YouTubeMusicService.getPlaylist(playlistid);
    try {
      if (_player.playing) {
        _player.pause();
      }
      var audioSources = playlist.tracks!
          .map((e) => CachedStreamAudioSource(videoId: e.videoid))
          .toList();

      await _player.setAudioSources(audioSources);
      // Delete the cached file

      List<MediaItem> queueN = await Future.wait(
        playlist.tracks!.map((e) async {
          return await ToMediaItem.song(e);
        }),
      );

      queue.add(queueN);
      //     mediaItem.add(queueN.first);
      _player.play();
      //debugPrint(playlist.trackCount.toString());
    } catch (e) {
      debugPrint("ERRO NO AUDIO SERVICE: $e");
    }
  }

  // Comandos padrões

  Future<void> shuffle() => _player.shuffle();
  Future<void> repeat() => _player.shuffle();

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() => _player.stop();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> skipToNext() => _player.seekToNext();

  @override
  Future<void> skipToPrevious() => _player.seekToPrevious();

  @override
  Future<void> skipToQueueItem(int index) =>
      _player.seek(Duration.zero, index: index);

  @override
  Future<void> customAction(String name, [Map<String, dynamic>? extras]) async {
    debugPrint('customAction: $name, $extras');
    switch (name) {
      case 'shuffle':
        return shuffle();
      case 'repeat':
        return repeat();
    }
  }
  // Função interna para atualizar o estado

  void _notifyAudioHandlerAboutPlaybackEvents() {
    _player.playbackEventStream.listen(
      (PlaybackEvent event) {
        final playing = _player.playing;
        playbackState.add(
          playbackState.value.copyWith(
            controls: [
              MediaControl.skipToPrevious,
              if (playing) MediaControl.pause else MediaControl.play,
              MediaControl.skipToNext,
            ],
            systemActions: const {MediaAction.seek},
            androidCompactActionIndices: const [0, 1, 2],
            processingState: isSongLoading
                ? AudioProcessingState.loading
                : const {
                    ProcessingState.idle: AudioProcessingState.idle,
                    ProcessingState.loading: AudioProcessingState.loading,
                    ProcessingState.buffering: AudioProcessingState.buffering,
                    ProcessingState.ready: AudioProcessingState.ready,
                    ProcessingState.completed: AudioProcessingState.completed,
                  }[_player.processingState]!,
            repeatMode: const {
              LoopMode.off: AudioServiceRepeatMode.none,
              LoopMode.one: AudioServiceRepeatMode.one,
              LoopMode.all: AudioServiceRepeatMode.all,
            }[_player.loopMode]!,
            shuffleMode: (shuffleModeEnabled)
                ? AudioServiceShuffleMode.all
                : AudioServiceShuffleMode.none,
            playing: playing,
            updatePosition: _player.position,
            bufferedPosition: _player.bufferedPosition,
            speed: _player.speed,
            queueIndex: currentIndex,
          ),
        );

        debugPrint(
          "set ${playbackState.value.queueIndex},${event.currentIndex}",
        );
      },
      onError: (Object e, StackTrace st) async {
        if (e is PlayerException) {
          printErrorDebug('Error code: ${e.code}');
          printErrorDebug('Error message: ${e.message}');
        } else {
          printErrorDebug('An error occurred: $e');
          Duration curPos = _player.position;
          await _player.stop();

          if (isPlayingUsingLockCachingSource &&
              e.toString().contains("Connection closed while receiving data")) {
            await _player.seek(curPos, index: 0);
            await _player.play();
            return;
          }

          customAction("playByIndex", {'index': currentIndex, 'newUrl': true});
          await _player.seek(curPos, index: 0);
        }
      },
    );
  }

  void _listenForDurationChanges() {
    _player.durationStream.listen((duration) async {
      final currQueue = queue.value;
      if (currentIndex == null || currQueue.isEmpty || duration == null) return;
      final currentSong = queue.value[currentIndex];
      if (currentSong.duration == null || currentIndex == 0) {
        final newMediaItem = currentSong.copyWith(duration: duration);
        mediaItem.add(newMediaItem);
      }
    });
  }
  }
