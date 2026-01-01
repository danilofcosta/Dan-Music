import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlayerController extends GetxController {
  final DraggableScrollableController controllerDraggableScrollableController =
      DraggableScrollableController();
      final playerOpen = false.obs;

  @override
  void onReady() {
    super.onReady();
    _listenerSize();
  }

  void listenerSizeClose() {
    controllerDraggableScrollableController.dispose();
  }

  void _listenerSize() {
    controllerDraggableScrollableController.addListener(() {
      final size = controllerDraggableScrollableController.size;
      debugPrint(size.toString());
      if (size > 0.14) {
        debugPrint('Player ABERTO');
        playerOpen.value=true;
      } else if (size < 0.35) {
        debugPrint('Player FECHADO');
          playerOpen.value=false;
      }
    });
  }
}