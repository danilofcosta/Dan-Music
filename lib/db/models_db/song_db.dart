import 'dart:typed_data';

import 'package:hive/hive.dart';

part 'song_db.g.dart';

@HiveType(typeId: 0)
class SongDb extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String artist;

  @HiveField(3)
  String? album; // pode ser null

  @HiveField(4)
 Uint8List? cover; // bytes da imagem, pode ser null

  @HiveField(5)
  int durationSeconds;

  @HiveField(6)
  String path;

  SongDb({
    required this.id,
    required this.title,
    required this.artist,
    this.album,
    this.cover,
    required this.durationSeconds,
    required this.path,
  });
}
