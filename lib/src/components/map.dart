import 'dart:async';

import 'package:eazi_ride/src/components/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EaziMap extends StatelessWidget {
  final LatLng initialLocation;
  final Set<Marker> markers; 
  final Set<Polyline> polylines; 
  final Function(GoogleMapController controller) onMapCreated;
  final String? style;

  const EaziMap({
    super.key,
    required this.initialLocation,
    this.markers = const {},
    this.polylines = const {},
    required this.onMapCreated,
    this.style
  });

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      compassEnabled: false,
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      myLocationEnabled: true,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height * .4
      ),
      initialCameraPosition: CameraPosition(
        target: initialLocation,
        zoom: 14,
      ),
      style: style,
      markers: markers,
      polylines: polylines,
      onMapCreated: onMapCreated
    );
  }
}

/*class EaziMapController extends GetxController with StateMixin {
  late Completer<GoogleMapController> _controller;
  late String mapStyle;

  @override
  void onInit() async {
    super.onInit();
    _controller = Completer<GoogleMapController>();
    mapStyle = await DefaultAssetBundle.of(Get.context!).loadString('assets/eazi_map_theme.json');
    change(null, status: RxStatus.success());
  }
}*/