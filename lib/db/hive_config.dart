import 'dart:io';
import 'package:danmusic/models/song.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'models_db/song_db.dart';

class HiveConfig {
  static Box<SongDb>? _songBox;

  /// Inicializa o Hive e registra o adapter
  static Future<void> start() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);

    Hive.registerAdapter(SongDbAdapter());

    // Abre a caixa apenas uma vez e guarda na variável
    _songBox = await Hive.openBox<SongDb>('songs');
  }

  /// Adiciona ou atualiza uma música
  static Future<void> addSongDb(SongDb song) async {
    if (_songBox == null) {
      // Caso start() não tenha sido chamado
      await start();
    }
    await _songBox!.put(song.id, song);
  }

  /// Retorna todas as músicas como lista
  static List<SongDb> getAllMusic() {
    if (_songBox == null) {
      throw Exception('HiveConfig não inicializado. Chame HiveConfig.start() primeiro.');
    }
    return _songBox!.values.toList();
  }

  /// Fecha o Hive quando não precisar mais
  static Future<void> close() async {
    await _songBox?.close();
    _songBox = null;
  }
}
