import 'package:danmusic/ui/widgets/card_medio.dart';
import 'package:flutter/material.dart';

class BuidListHorizotalCard<T> extends StatelessWidget {
  final String title;
  final List<T> list;

  const BuidListHorizotalCard({
    super.key,
    required this.title,
    required this.list,
  });

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];
              return _buildItem(item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildItem(T item) {
    // Aqui você pode usar o objeto real para popular o CardMedio
    // Exemplo genérico, depois você especializa conforme o tipo:
    return CardMedio(
      image: _getImage(item),
      title: _getTitle(item),
      subtitle: _getSubtitle(item),
      object: item,
    );
  }

  String _getImage(T item) {
    try {
      final dynamic obj = item;
      return obj.thumbnails?.first.url ?? '';
    } catch (_) {
      return '';
    }
  }

  String _getTitle(T item) {
    try {
      final dynamic obj = item;
      return obj.title ?? '';
    } catch (_) {
      return '';
    }
  }

  String _getSubtitle(T item) {
    try {
      final dynamic obj = item;
      return obj.year?.toString() ?? obj.author ?? '';
    } catch (_) {
      return '';
    }
  }
}
