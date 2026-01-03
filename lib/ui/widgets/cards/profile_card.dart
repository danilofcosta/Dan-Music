import 'package:flutter/material.dart';
import 'package:danmusic/models/search/search_profile.dart';

class ProfileCard extends StatelessWidget {
  final SearchProfile profile;
  const ProfileCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final thumb = profile.thumbnails?.isNotEmpty == true
        ? profile.thumbnails!.first.url
        : null;
    return ListTile(
      leading: thumb != null
          ? CircleAvatar(backgroundImage: NetworkImage(thumb))
          : const Icon(Icons.person),
      title: Text(profile.title),
      subtitle: Text(profile.name),
    );
  }
}
