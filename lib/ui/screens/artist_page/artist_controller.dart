import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/artist.dart';
import '../../../services/ytmusicapi.dart';

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

  final fix = BoxFit.contain.obs;

  //final artistBase = Artistdetail(artistName: '', artistId: '').obs;

  final artistId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as List;
    final Artistdetail artistBase = args[0] as Artistdetail;
    artist.value = FullArtist(
      artistName: artistBase.artistName,
      artistId: artistBase.artistId,
      thumbnail: artistBase.thumbnail,
      topSongs: [],
      topAlbums: [],
      topSingles: [],
      topVideos: [],
      featuredOn: [],
      similarArtists: [],
    );
    artistId.value = args[1];
    getArtist(artistId.value); // Pass the artistId directly
  }

  void getArtist(String? artistId) async {
    if (artistId == null) return;

    final FullArtist getArtist = await YouTubeMusicService.getArtist(artistId);

    artist.value = getArtist;
  }

  void changeFix() {
    if (fix.value == BoxFit.contain) {
      fix.value = BoxFit.cover;
    } else {
      fix.value = BoxFit.contain;
    }
  }
}
