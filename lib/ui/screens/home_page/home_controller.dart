import 'package:audio_service/audio_service.dart';
import 'package:danmusic/services/ytmusicapi.dart';
import 'package:dart_ytmusic_api/types.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/album.dart';
import '../../../models/playlist_basic.dart';
import '../../../navigator.dart';
import '../../widgets/greeting.dart';

class HomeController extends GetxController {
  final RxInt counter = 0.obs;
  final Rx<MediaItem> videoIdSuggestion = MediaItem(
    id: 'HPTDgfhhJ3s',
    album: 'Album teste',
    title: 'controller.file._value[2].title',
    artist:  "Unappreciated",
    artUri: Uri.parse('https://i.ytimg.com/vi/HPTDgfhhJ3s/hqdefault.jpg'),
  ).obs;

  final RxList<HomeSection> homeSections = <HomeSection>[].obs;

  final RxString welcomeMessage = 'Home Page - GetX Example'.obs;
  final RxList<MediaItem> songsSuggestions = <MediaItem>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    welcomeMessage.value = greeting();

    // songsSuggestions.add(videoIdSuggestion.value);
    await loadApiData();

    loadSongsSuggestions();

    // Inicialização do controlador
  }

  Future<void> loadApiData() async {
    isLoading.value = true;

    //  await Future.delayed(Duration(seconds: 2));
    await YouTubeMusicService.init();
    isLoading.value = false;
  }

  void loadSongsSuggestions() async {
    try {
      List<MediaItem> tempsongsSuggestions =
          await YouTubeMusicService.getRelatedPlaylist(
            videoIdSuggestion.value.id,
          );

      songsSuggestions.assignAll([
        videoIdSuggestion.value,
        ...tempsongsSuggestions,
      ]);
      songsSuggestions.refresh();
      loadHomeData();
      counter.value = 90;
    } catch (e) {
      debugPrint('Erro ao carregar sugestões de músicas: $e');
    }
  }

  void loadHomeData() async {
    List<HomeSection> homeSections = await YouTubeMusicService.homePage();
    this.homeSections.assignAll(homeSections);
    this.homeSections.refresh();
  }

  void openPage(Object sectionItem) {
    String pg;
    var id = '';
    Object object;
    switch (sectionItem.runtimeType) {
      case PlaylistDetailed :
        sectionItem as PlaylistDetailed;
        pg = ScreenNavigationSetup.playlistScreen;
        id = sectionItem.playlistId;
        object = PlaylistBasic(
          playlistId: sectionItem.playlistId,
          title: sectionItem.name,
          thumbnails: [sectionItem.thumbnails.first.url],
          desciption: sectionItem.artist.name,
        );
        break;
      case AlbumDetailed :
        sectionItem as AlbumDetailed;
        pg = ScreenNavigationSetup.albumScreen;
        id = sectionItem.albumId;
        object = Album(
          albumId: sectionItem.albumId,
          playlistId: sectionItem.playlistId,
          name: sectionItem.name,
          artist: sectionItem.artist.name,
          thumbnails: [sectionItem.thumbnails.first.url],
          year: sectionItem.year ,
        );
        break;

      default:
        debugPrint('Tipo de seção desconhecido: ${sectionItem.runtimeType}');
        return; // Sai da função se o tipo for desconhecido
    }

    Get.toNamed(pg, id: ScreenNavigationSetup.id, arguments: [object, id]);
  }
}
