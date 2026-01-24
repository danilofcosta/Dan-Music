import 'package:flutter/material.dart';
import 'package:musicfy/musicfy.dart';
import 'package:permission_handler/permission_handler.dart';

class DeviceLibrary extends StatefulWidget {
  const DeviceLibrary({super.key});

  @override
  State<DeviceLibrary> createState() => _DeviceLibraryState();
}

class _DeviceLibraryState extends State<DeviceLibrary> {
  List<dynamic> musicList = [];

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  void requestPermission() async {
    PermissionStatus status = await Permission.audio.request();
    if (status.isGranted) {
      musicList = await Musicfy().getMusicList();
      // Handle music list
    } else {
      // Handle permission denial
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text('Musics ${musicList.length}'),
            Spacer(),
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed:(){})
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: musicList.length,
            itemBuilder: (context, index) {
              final music = musicList[index];
              return ListTile(
                title: Text(music['title']),
                subtitle: Text('${music['artist']} - ${music['album']}'),
                leading: Icon(Icons.music_note),
              );
            },
          ),
        ),
      ],
    );
  }
}
