import 'package:danmusic/models/song.dart';
import 'package:danmusic/ui/screens/player/player_mini.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../navigation.dart';
import '../../widgets/buid_list_horizotal.dart';
import '../../widgets/buid_list_horizotal_card.dart';
import '../player/player_controller.dart';
import 'home_screen_controller.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/';

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
        if (controller.homeSection.isEmpty) {
          return const Scaffold(body: ProgressIndicator());
        }

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () => Get.toNamed(RouteName.search),
            child: const Icon(Icons.search),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          persistentFooterButtons: [ PlayerMini()],
          persistentFooterDecoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          body: CustomScrollView(
            slivers: controller.homeSection
                .map<Widget>((section) => _buildSection(section))
                .toList(),
          ),
        );
      }),
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
