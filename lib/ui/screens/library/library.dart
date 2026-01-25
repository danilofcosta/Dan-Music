import 'package:flutter/material.dart';

import 'app_library/app_library.dart' show AppLibrary;
import 'device_library/device_library.dart';

class Library extends StatelessWidget {
  const Library({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Biblioteca'),
          backgroundColor: Colors.black,
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: TabBar(
              indicatorColor: Colors.greenAccent,
              labelColor: Colors.greenAccent,
              unselectedLabelColor: Colors.white54,
              tabs: [
                Tab(text: "lib"),
                Tab(text: "base2"),
                Tab(text: "Do Dispositivo"),
              ],
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            AppLibrary(),
            Center(
              child: Text("base2", style: TextStyle(color: Colors.white)),
            ),
            DeviceLibrary(),
          ],
        ),
      ),
    );
  }
}
