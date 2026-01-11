import 'package:danmusic/services/uteis/helper.dart';
import 'package:get/get.dart';

import '../../../models/playlist.dart';
import '../../../services/yt_api.dart';
import '../player/widgets_player/player_controller.dart';

class PlaylistController extends GetxController {
  final audiohander = Get.find<PlayerController>();
   final YouTubeMusicService youTubeService = Get.find<YouTubeMusicService>();
  final playlist = Playlist(browseId: '', title: '').obs;

  late final playlistfull = PlaylistFull(id:'', title: '', description: '', thumbnails: [] ).obs;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as List;
    final Playlist? playlist = args[1];
    final playlistId = args[0];

    fetchPlaylistDetails(playlist, playlistId);
  }

  // @override
  void fetchPlaylistDetails(Playlist? playlist_, String playlistId) async {
    
    if (playlist_ != null) {
      playlist.value = playlist_;

      final playlistFull = await youTubeService.getPlaylist(playlistId);
      if (playlistFull == null) {
        return printErrorDebug('Erro ao carregar a playlist');
      }
      playlistfull.value = playlistFull ;
    }
  }

  void playplaylist() async {
    //   if (playlistfull.value.tracks!.isNotEmpty) {
    //     final List<MediaItem> quere = await Future.wait(
    //       playlistfull.value.tracks!.map((e) async {
    //         return ToMediaItem.song(e);
    //       }).toList(),
    //     );
    //     audiohander.updateQueuenew(quere);
    //   }
  }
}
