import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HomeController extends GetxController with StateMixin {
  late String mapStyle;
  final bottomSheetController = DraggableScrollableController();

  @override
  void onInit() async {
    super.onInit();
    mapStyle = await rootBundle.loadString('assets/eazi_map_theme.json');
    bottomSheetController.addListener(() {
      print(bottomSheetController.size);
    });
  }

  @override
  void onReady() {
    change(null, status: RxStatus.success());
  }
}