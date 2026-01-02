import 'package:danmusic/models/thumbnail.dart';

class ArtistBasic {
  final String name;
  final String id;
  ArtistBasic({required this.name,required this.id});
}

class ArtistDetail extends ArtistBasic {
  final String subscribers ;
  final List<Thumbnail>  thumbnails;
  
  ArtistDetail(
      {required super.name,
      required super.id,
      required this.subscribers,
      required this.thumbnails});}