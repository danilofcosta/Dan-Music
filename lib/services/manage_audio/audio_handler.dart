import 'package:audio_service/audio_service.dart';
import 'package:danmusic/models/playlist_full.dart';
import 'package:danmusic/services/manage_audio/cached_stream_audio_source.dart';
import 'package:danmusic/services/to_media_item.dart';
import 'package:danmusic/services/uteis/newpipe.dart';
import 'package:danmusic/services/ytmusicapi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_new_pipe_extractor/flutter_new_pipe_extractor.dart';
import 'package:just_audio/just_audio.dart';
// ignore: depend_on_referenced_packages, implementation_imports
import 'package:rxdart/src/subjects/behavior_subject.dart';

class MyAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final _player = AudioPlayer();
  BehaviorSubject<MediaItem?> get songNow => mediaItem;
  AudioPlayer get player => _player;

  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration> get positionBuffered => _player.bufferedPositionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<bool> get isPlayingStream => _player.playingStream;

  MyAudioHandler() {
    _listenPlayerChanges();

    player.errorStream.listen((PlayerException e) {
      print('Error code: ${e.code}');
      print('Error message: ${e.message}');
      print('AudioSource index: ${e.index}');
    });
  }

  // Escuta mudanças de índice e estado
  void _listenPlayerChanges() {
    /// Atualiza o MediaItem automaticamente
    _player.currentIndexStream.listen((index) {
      final q = queue.value;
      if (index != null && index >= 0 && index < q.length) {
        // CachedStreamAudioSource? temp =
        // //     _player.sequence[index] as CachedStreamAudioSource?;
        // if (temp != null) {
        //   //  debugPrint(temp.toMediaItem.toString());
        // }
        if (_player.sequence[index].tag == null) {
          debugPrint(
            '-------------_sequence[index].tag-------------------------------- -',
          );
        }
        CachedStreamAudioSource? temp =   _player.sequence[index] as CachedStreamAudioSource?;
        mediaItem.add(temp?.toMediaItem);
        if (_player.sequence[index].tag != null) {
          debugPrint(
            '-------------_player.sequence[index].tag-------------------------------- -',
          );
        }
      }
    });

    /// Atualiza estado de playback
    _player.playbackEventStream.listen(_broadcastState);
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

      VideoInfo videoInfo = await DownloaderChannel.getAudioUrl(mediaItem.id);

      // debugPrint(g);
      mediaItem = await ToMediaItem.videoInfo(videoInfo);
      songNow.add(mediaItem);
      // Download and cache audio while playing it (experimental)
      final audioSource = LockCachingAudioSource(
        Uri.parse(videoInfo.audioStreams.first.content),
        tag: mediaItem,
      );
      await _player.setAudioSource(audioSource);
      // Delete the cached file
      _player.play();
      // queue.add([mediaItem]);

      List<MediaItem> newQueue = await YouTubeMusicService.getRelatedPlaylist(
        mediaItem.id,
      );

      queue.add([mediaItem, ...newQueue]);

      _player.addAudioSources(
        newQueue.map((e) => CachedStreamAudioSource(videoId: e.id)).toList(),
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
  Future<void> skipToQueueItem(int index) =>
      _player.seek(Duration.zero, index: index);

  @override
  Future<void> skipToPrevious() => _player.seekToPrevious();

  // Função interna para atualizar o estado
  void _broadcastState(PlaybackEvent event) {
    playbackState.add(
      playbackState.value.copyWith(
        controls: [
          MediaControl.pause,
          MediaControl.stop,
          MediaControl.skipToNext,
          MediaControl.skipToPrevious,
        ],
        playing: _player.playing,
        processingState: {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_player.processingState]!,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
      ),
    );
  }
}
