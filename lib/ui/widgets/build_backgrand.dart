import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import '../../theme/confing_css.dart';
import 'package:flutter/material.dart';

class BuildBackgrand extends StatelessWidget {
  final Widget child;

  const BuildBackgrand({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
        final bgImageUrl = Get.find<ConfigCss>().bgImage.value;

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
                      debugPrint('Erro ao carregar background: $error');
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
