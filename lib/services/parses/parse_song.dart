import '../../models/song.dart';

class ParseSong {

  static  Song song (Map<String, dynamic> jsonData){

    final id =jsonData['videoId']?? '';
    final title =jsonData['title']?? '';
    final cover = jsonData['thumbnails']?? '';




    return Song(id: 'id', title: 'title');


  }
}