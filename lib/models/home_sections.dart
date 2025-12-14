import 'package:dart_ytmusic_api/types.dart';
import '../models/album.dart';
sealed class HomeContent {}

class HomeSection {
  final String title;
  final List<dynamic> contents;

  HomeSection({required this.title, required this.contents});

  @override
  String toString() {
    return 'HomeSection(title: $title, contents: $contents)';
  }
}

class ParserHomeSection {
  static List<HomeSection> parseHomeSection(List<dynamic> objs) {
    final List<HomeSection> sections = objs.map((section) {
      final String title = section.title;
      'No Title';
      final List<dynamic> contents = section.contents.map((item) {
        switch (item.runtimeType) {
          case AlbumDetailed _:
            item as AlbumDetailed;
            return Album(
              albumId: item.albumId,
              playlistId: item.playlistId,
              name: item.name,
              artist: item.artist.name,
              year: item.year,
              thumbnails: List<String>.from(item.thumbnails. map((thumb) => thumb.url)),
            );

          default:
            return null;
        }
      }).toList();

      return HomeSection(title: title, contents: contents);
    }).toList();

    return sections;
  }
}
