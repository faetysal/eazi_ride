import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(6.577571, 3.349315),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: GoogleMap(
          initialCameraPosition: _kGooglePlex,
          mapType: MapType.normal,
        ),
      )
    );
  }
}