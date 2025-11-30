import '../../../models/playlist.dart';
import '/models/playlist_full.dart';
import '/models/song.dart';
import '/services/parsers/parser_song.dart';
import 'package:flutter/material.dart';

class ParserPlaylist {
  static Playlist parsePlaylist(Map<String, dynamic> itemMap) {
    return Playlist(
      playlistId: itemMap['playlistId'] as String,
      title: itemMap['title'] ?? 'Sem Título',
      thumbnails: (itemMap['thumbnails'] as List<dynamic>?)!
          .map((thumb) => thumb['url'] as String)
          .toList(),
      desciption: itemMap['description'] ?? '',
    );
    // Assumindo views como int/String e default 0
  }

  static PlaylistFull parsePlaylistFull(Map<String, dynamic> itemMap) {
    List<dynamic>? tracks = (itemMap['tracks'] as List<dynamic>?);
    tracks = tracks!.map((track) => ParserSong.parseSong(track)).toList();
    try {} catch (e) {
      debugPrint(e.toString());
    }
    return PlaylistFull(
      playlistId: itemMap['id'] as String,
      title: itemMap['title'] ?? 'Sem Título',
      thumbnails: (itemMap['thumbnails'] as List<dynamic>?)!
          .map((thumb) => thumb['url'] as String)
          .toList(),
      desciption: itemMap['description'] ?? '',
      tracks: tracks as List<Song>,

      releted: itemMap['related'],

      duration: itemMap['duration'],
      secondsduration: itemMap['duration_seconds'],
      trackCount: itemMap['trackCount'],
      year: itemMap['year'],
    );
  }
}
