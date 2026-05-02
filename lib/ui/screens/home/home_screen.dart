import 'package:danmusic/models/song.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/uteis/greeting.dart';
import '../../widgets/list_horizontal/buid_list_horizotal.dart';
import '../../widgets/list_horizontal/buid_list_horizotal_card.dart';
import '../player/player_controller.dart';
import 'home_screen_controller.dart';

class HomeScreen extends StatefulWidget {


  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = Get.find<HomeScreenController>();
  final playerController = Get.find<PlayerController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(() {
        // if (controller.homeSection.isEmpty) {
        //   return const Scaffold(body: ProgressIndicator());
        // }

        return Scaffold(


         

          body: CustomScrollView(
slivers: [
  _buildAppBar(),

  if (controller.homeSection.isEmpty)
    const SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    ),

  ...controller.homeSection
      .map<Widget>((section) => _buildSection(section))
      ,
],

          ),
        );
      }),
    );
  }
Widget _buildAppBar(){


return  SliverAppBar(
    title: Text(getGreeting(), style: const TextStyle(color: Colors.white)),
    pinned: true,
  );


}
  Widget _buildSection(dynamic section) {
    // Seção só de músicas
    final songs = section.contents.whereType<Song>().toList();
    if (songs.isNotEmpty) {
      return SliverToBoxAdapter(
        child: BuidListHorizotal(title: section.title, songs: songs),
      );
    }

    // Seção mista (álbum, artista, playlist, etc)
    return SliverToBoxAdapter(
      child: BuidListHorizotalCard(
        title: section.title,
        list: section.contents,
      ),
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
        // ignore: deprecated_member_use
        year2023: false,
      ),
    );
  }
}
