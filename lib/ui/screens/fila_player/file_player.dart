import 'package:audio_service/audio_service.dart';
import 'package:danmusic/ui/screens/fila_player/fila_controller.dart';
import 'package:get/get.dart';
import '../../../services/manage_audio/audio_handler.dart' show MyAudioHandler;
import '../../widgets/ui/song_ui.dart';
import 'package:flutter/material.dart';

class FilePlayer extends StatefulWidget {
  const FilePlayer({super.key});

  @override
  State<FilePlayer> createState() => _FilePlayerState();
}

class _FilePlayerState extends State<FilePlayer> {
  ScrollController scrollController = ScrollController();
  AudioHandler audioHandler = Get.find<MyAudioHandler>();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FilaController>();

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            "Tocando  Agora ${controller.index} | ${controller.file.length} Musicas",
          ),
        ),
        body: controller.file.isEmpty
            ? Center(child: Text(' NENHUMA MUSICA TOCANDO AGORA'))
            : ListView.builder(
                padding: const EdgeInsets.all(8.0),
                controller: controller.scrollController,
                itemCount: controller.file.length,
                itemExtent: 80,
                itemBuilder: (context, index) {
                  final mediaItem = controller.file[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        // Índice
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          // width: 40,
                          child: Text(
                            '$index',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // Conteúdo expandido
                        Expanded(
                          child: SongUi(
                            mediaItem: mediaItem,
                            onTap: () {
                              controller.playIndex(index);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
