import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          controller.greeting.value,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: CircularProgressIndicator.adaptive(
          strokeWidth: 5,
          year2023: false,
        ),
      ),
    );
  }
}
