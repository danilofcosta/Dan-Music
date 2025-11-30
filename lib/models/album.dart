class Album {
  final String albumId;
  final String playlistId;
  final String name;
  final String artist;
  final int? year;
  final List<String> thumbnails;

  Album({
    required this.albumId,
    required this.playlistId,
    required this.name,
    required this.artist,
    required this.year,
    required this.thumbnails,
  });
}
