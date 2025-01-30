import 'dart:async';

import 'package:eazi_ride/src/components/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EaziMap extends StatelessWidget {
  static const CameraPosition currLoc = CameraPosition(
    target: LatLng(6.577571, 3.349315),
    zoom: 14.4746,
  );

  final EaziMapController controller = Get.put(EaziMapController());

  EaziMap({super.key});

  @override
  Widget build(BuildContext context) {
    return controller.obx(
      (state) {
        return GoogleMap(
          initialCameraPosition: currLoc,
          style: controller.mapStyle,
          onMapCreated: (GoogleMapController controller) {
            
          },
        );
      },
      onLoading: const Loader()
    );
  }
}

class EaziMapController extends GetxController with StateMixin {
  late Completer<GoogleMapController> _controller;
  late String mapStyle;

  @override
  void onInit() async {
    super.onInit();
    _controller = Completer<GoogleMapController>();
    mapStyle = await DefaultAssetBundle.of(Get.context!).loadString('assets/eazi_map_theme.json');
    change(null, status: RxStatus.success());
  }
}