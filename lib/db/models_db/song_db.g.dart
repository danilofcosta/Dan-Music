// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_db.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SongDbAdapter extends TypeAdapter<SongDb> {
  @override
  final int typeId = 0;

  @override
  SongDb read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SongDb(
      id: fields[0] as String,
      title: fields[1] as String,
      artist: fields[2] as String,
      album: fields[3] as String?,
      cover: fields[4] as Uint8List?,
      durationSeconds: fields[5] as int,
      path: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SongDb obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.artist)
      ..writeByte(3)
      ..write(obj.album)
      ..writeByte(4)
      ..write(obj.cover)
      ..writeByte(5)
      ..write(obj.durationSeconds)
      ..writeByte(6)
      ..write(obj.path);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SongDbAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
