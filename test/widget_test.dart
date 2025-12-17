import 'package:danmusic/services/manage_audio/manage_audio_url.dart';
import 'package:danmusic/services/ytmusicapi.dart';
import 'package:flutter/rendering.dart';
import 'package:ytmusicapi_dart/ytmusicapi_dart.dart';

void main() async {
 final   yt = await YTMusic.create();
  final homeSections = await yt.getExplore();
  debugPrint(homeSections.toString());
}
