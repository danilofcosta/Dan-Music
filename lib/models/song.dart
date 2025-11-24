import 'package:danmusic/models/album_info.dart';
import 'package:danmusic/models/artist.dart';




class Song {   
  final String videoid;  
  final String title;  
  final AlbumInfo? albumInfo;
  final String? views;
  final String? artist;
  final List<Artistdetail>? artistdetail;
  final List<String>? thumbnails;
  final bool  isExplicit ;
  final String? duration;
  final int? secondsduration;

  
Song({
    required this.videoid, 
    required this.title, 
    this.albumInfo, 
     this.views, 
    required this.artist, 
    this.thumbnails, // Opcional (não required)
    this.artistdetail, // Opcional (não required)
    this.isExplicit = false, this.duration, this.secondsduration, // Opcional com valor padrão
  });
}