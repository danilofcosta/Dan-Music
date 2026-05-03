import 'package:flutter/material.dart';

class FadeSwitcher extends StatelessWidget {
  final Widget child;
  final Object? switchKey;
  final Duration duration;

  const FadeSwitcher({
    super.key,
    required this.child,
    this.switchKey,
    this.duration = const Duration(milliseconds: 400),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      transitionBuilder: (child, anim) => FadeTransition(
        opacity: anim,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -0.15),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
          child: child,
        ),
      ),
      child: switchKey != null
          ? KeyedSubtree(key: ValueKey(switchKey), child: child)
          : child,
    );
  }
}