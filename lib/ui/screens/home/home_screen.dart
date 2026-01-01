import 'dart:io';

import 'package:danmusic/models/song.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            controller.greeting.value,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: controller.homeSection.isEmpty
            ? ProgressIndicator()
            : CustomScrollView(slivers: [
              SliverToBoxAdapter(child: BuidListHorizotal(
               title: controller.homeSection.value.first.title, songs:  controller.homeSection.value.first.contents.cast<Song>(),

              ),)
            ]),
      );
    });
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
