
class HomeSection {
  final String title;
  final List<dynamic> contents;

  HomeSection({
    required this.title,
    required this.contents,
  });

  HomeSection.fromMap(Map<String, dynamic> map)
      : title = map['title'] as String,
        contents = map['contents'] as List<dynamic>;
}
