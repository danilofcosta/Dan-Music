import 'package:get/get.dart';

import '../../../models/artist.dart';

class ArtistController extends GetxController {
  final artist = FullArtist(
    artistName: 'name',
    topSongs: [],
    topAlbums: [],
    topSingles: [],
    topVideos: [],
    featuredOn: [],
    similarArtists: [],
    artistId: '',
    thumbnail: '',
  ).obs;

  final artistBase = Artistdetail(artistName: '', artistId: '').obs;

  final artistId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    var args = Get.arguments as List;
    artistBase.value = args[0] as Artistdetail;
    artistId.value = args[1] as String;
  }
}
