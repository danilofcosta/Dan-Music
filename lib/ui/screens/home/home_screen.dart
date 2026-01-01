import 'package:danmusic/models/song.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../player/player.dart';
import '../../widgets/buid_list_horizotal.dart';
import 'home_screen_controller.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = Get.find<HomeScreenController>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(() {
        return Scaffold(
          // appBar: AppBar(
          //   centerTitle: true,
          //   title: Text(
          //     controller.greeting.value,
          //     style: TextStyle(fontWeight: FontWeight.bold),
          //   ),
          // ),
          body: Stack(
            children: [
              controller.homeSection.isEmpty
                  ? ProgressIndicator()
                  : CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: BuidListHorizotal(
                            title: controller.homeSection.first.title,
                            songs: controller.homeSection.first.contents
                                .cast<Song>(),
                          ),
                        ),
                      ],
                    ),

              Player(),
            ],
          ),
        );
      }),
    );
  }
}

class ProgressIndicator extends StatelessWidget {
  const ProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator.adaptive(
        strokeWidth: 5,
        year2023: false,
      ),
    );
  }
}
