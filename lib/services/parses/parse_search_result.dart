import 'package:danmusic/models/search_result.dart';
import 'package:danmusic/services/parses/parse_artist.dart';
import '../../models/artist.dart';
import '../../models/thumbnail.dart';

class ParseSearchResult {
  static SearchResult parseResult(Map<String, dynamic> data) {
    switch (data['resultType']) {
      case "artist":
        String id;
        String name;

        var artists = data["artists"] ?? data["artist"];
        if (artists is List) {
          artists = (data['artists'] as List).map<ArtistBasic>((artist) {
            return ParseArtist.artistBasic(artist);
          }).toList();

          name = ParseArtist.artistsToString(artists as List<ArtistBasic>);
          id = artists.first.id;
        } else {
          name = artists;
          id = '';
        }

        final subscribers = data["subscribers"] ?? '';

        final thumbnails = (data["thumbnails"] as List)
            .map<Thumbnail>(
              (e) => Thumbnail(
                url: e["url"],
                width: e["width"],
                height: e["height"],
              ),
            )
            .toList();

        return SearchResult(
          type: data['resultType'],
          content: ArtistDetail(
            name: name,
            id: id,
            subscribers: subscribers,
            thumbnails: thumbnails,
          ),
        );

      default:
        return SearchResult(type: data['resultType'], content: null);
    }
  }

  static List<SearchResult> parseSearchResults(List<dynamic> data) {
    return data.whereType<Map<String, dynamic>>().map(parseResult).toList();
  }
}
