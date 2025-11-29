import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import '/models/song.dart';
import '../widgets/ui/song_ui.dart';
import 'package:flutter/material.dart';

class FilePlayer extends StatefulWidget {
  const FilePlayer({super.key});

  @override
  State<FilePlayer> createState() => _FilePlayerState();
}

class _FilePlayerState extends State<FilePlayer> {
  ScrollController scrollController = ScrollController();
  AudioHandler audioHandler = Get.find<AudioHandler>();

  List<MediaItem> file = [];
  @override
  void initState() {
    super.initState();
    fechada();
    // Espera o layout ser renderizado para pular ao final
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var file = audioHandler.queue.value;
      var currentIndex = file.indexWhere(
        (e) => e.id == audioHandler.mediaItem.value?.id,
      );

      if (currentIndex >= 0) {
        // Se você souber a altura fixa de cada item
        double itemHeight = 85.0; // ajuste conforme seu SongUi
     //   scrollController.jumpTo(currentIndex * itemHeight);

        // ou, se quiser animação:
        // scrollController.animateTo(
        //   currentIndex * itemHeight,
        //   duration: Duration(milliseconds: 300),
        //   curve: Curves.easeOut,
        // );
      }
    });
  }

  void fechada() async {
    setState(() {
      file = audioHandler.queue.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tocando  Agora ${audioHandler.mediaItem.value?.title} de ${file?.length}",
        ),
      ),
      body: file == null || file.isEmpty
          ? Center(child: Text(' NENHUMA MUSICA TOCANDO AGORA'))
          : ListView(
              padding: const EdgeInsets.all(8.0),
              controller: scrollController,
              shrinkWrap: true,

              children: file
                  .map(
                    (e) => SongUi(
                    mediaItem: e,
                    ),
                  )
                  .toList(),
            ),
    );
  }
}
