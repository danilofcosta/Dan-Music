import 'package:danmusic/services/ytmusicapi.dart';
import 'package:flutter/rendering.dart';

void main() async {
  await YouTubeMusicService.init();
  List homeSections = await YouTubeMusicService.homePage();

  debugPrint(homeSections.toString());
}
