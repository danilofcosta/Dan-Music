import 'package:audio_service/audio_service.dart';
import 'package:danmusic/ui/screens/player_page/player_controller.dart';
import 'package:danmusic/services/to_media_item.dart';
import 'package:get/get.dart';
import '../../../models/playlist_basic.dart';
import '../../../models/playlist_full.dart';
import '../../../services/ytmusicapi.dart';

class PlaylistController extends GetxController {
  final audiohander = Get.find<PlayerController>();
  final playlist = PlaylistBasic(
    title: "Titulo",
    playlistId: "pleylistId",
    thumbnails: [''],
    desciption: "",
  ).obs;

  late final playlistfull = PlaylistFull(
    playlistId: playlist.value.playlistId,
    title: playlist.value.title,
    thumbnails: [],
    desciption: '',
    tracks: [],
    duration: null,
  ).obs;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as List;
    final PlaylistBasic? playlist = args[0];
    final playlistId = args[1];

    fetchPlaylistDetails(playlist, playlistId);
  }

  // @override
  void fetchPlaylistDetails(PlaylistBasic? playlist_, String playlistId) async {
    if (playlist_ != null) {
      playlist.value = playlist_;

      final playlistFull = await YouTubeMusicService.getPlaylist(playlistId);
      playlistfull.value = playlistFull;
    }
  }

  void playplaylist() async {
    if (playlistfull.value.tracks!.isNotEmpty) {
      final List<MediaItem> quere = await Future.wait(
        playlistfull.value.tracks!.map((e) async {
          return ToMediaItem.song(e);
        }).toList(),
      );
      audiohander.updateQueuenew(quere);
    }
  }
}
