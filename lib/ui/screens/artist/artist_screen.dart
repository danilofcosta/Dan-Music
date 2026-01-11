import 'package:danmusic/ui/screens/artist/artist_cotroller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../services/uteis/load_image.dart';
import '../../../services/uteis/update_papilite.dart';

class ArtistScreen extends StatefulWidget {
  const ArtistScreen({super.key});
  static const routeName = '/artist';
  @override
  State<ArtistScreen> createState() => _ArtistScreenState();
}

class _ArtistScreenState extends State<ArtistScreen> {
  Color _dominantColor = const Color.fromARGB(255, 7, 7, 7);
  ImageProvider? _lastProvider;
  final thum =
      'https://i.pinimg.com/736x/e5/c5/b9/e5c5b916d85eb7ba0899e3b925b0f73c.jpg';
  List s = [
    'https://i.pinimg.com/736x/83/05/c1/8305c1d081cd8a963dc52dfce6ef4453.jpg',
    'https://i.pinimg.com/736x/62/1a/41/621a41262a3657683452db0b80660b9e.jpg',
    'https://i.pinimg.com/736x/e5/c5/b9/e5c5b916d85eb7ba0899e3b925b0f73c.jpg',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateDominantColor(thum);
  }

  void _updateDominantColor(String img) async {
    final color = await updatePalette(img);
    setState(() {
      _dominantColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tag = hashCode.toString();

    final controller = (Get.isRegistered<ArtistCotroller>(tag: tag))
        ? Get.find<ArtistCotroller>(tag: tag)
        : Get.put(ArtistCotroller(), tag: tag);
    return Scaffold(
      backgroundColor: _dominantColor.withValues(alpha: 0.5),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            stretch: true,
            expandedHeight: 300,
            floating: true,
            useDefaultSemanticsOrder: true,
            backgroundColor: _dominantColor,
            titleSpacing: 5,
            title: Text(
              'title',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      top: 80,
                    ),
                    child: Builder(
                      builder: (_) {
                        return LoadImage.loadWidget(
                          thum,
                          fit: BoxFit.contain,
                          errorBuildericon: Icons.person,
                        );
                      },
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          _dominantColor.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Infos do artista
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16),
              color: _dominantColor.withValues(alpha: 0.5),
              child: Row(
                children: [
                  Column(
                    children: [
                      Text(
                        'SaKura Hirai ',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Lista de albuns
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: s
                  .map(
                    (e) => CardMedio(image: e, title: 'title', subtitle: 'sub'),
                  )
                  .toList(),
            ),
          ),

          SliverFillRemaining(),
        ],
      ),
    );
  }
}

class CardMedio extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  const CardMedio({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(3),

      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 100,
              height: 100,
              child: LoadImage.loadWidget(
                image,

                fit: BoxFit.cover,
                errorBuildericon: Icons.person,
              ),
            ),
          ),
          if (title.isNotEmpty || subtitle.isNotEmpty) ...[
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: Theme.of(context).textTheme.bodyMedium?.color!,
              ),
            ),

            if (subtitle.isNotEmpty) ...[
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.color!.withValues(alpha: 0.6),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
