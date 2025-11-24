import 'package:cached_network_image/cached_network_image.dart';
import 'package:danmusic/provaders/confing_css.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuildBackgrand extends StatelessWidget {
  final Widget child;

  const BuildBackgrand({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<ConfingCss>(
      builder: (context, confingCss, _) {
        final bgImageUrl = confingCss.getBgImage;

        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            image: bgImageUrl.isNotEmpty
                ? DecorationImage(
                    image: CachedNetworkImageProvider(bgImageUrl),
                    fit: BoxFit.cover,
                    onError: (error, stackTrace) {
                      print('Erro ao carregar background: $error');
                    },
                  )
                : null,
          ),
          child: child,
        );
      },
    );
  }
}
