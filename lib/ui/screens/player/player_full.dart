import 'package:flutter/material.dart';

class PlayerFull extends StatefulWidget {
  final scrollController;
  const PlayerFull({super.key, this.scrollController});

  @override
  State<PlayerFull> createState() => _PlayerFullState();
}

class _PlayerFullState extends State<PlayerFull> {
  @override
  Widget build(BuildContext context) {
    return Icon(Icons.dark_mode_rounded);
  }
}
