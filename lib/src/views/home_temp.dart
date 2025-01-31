import 'dart:async';

import 'package:eazi_ride/src/components/button.dart';
import 'package:eazi_ride/src/components/input.dart';
import 'package:eazi_ride/src/components/loader.dart';
import 'package:eazi_ride/src/components/map.dart';
import 'package:eazi_ride/src/config.dart';
import 'package:eazi_ride/src/controllers/home.dart';
import 'package:eazi_ride/src/services/http.dart';
import 'package:eazi_ride/src/services/ride.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:timeline_tile/timeline_tile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Http http = Get.put(Http());
  final RideService rideService = Get.put(RideService());

  Location location = Location();
  bool locServiceEnabled = false;
  PermissionStatus? locPermissionGranted;
  LocationData? currLocationData;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  late Completer<GoogleMapController> mapController;
  late String mapStyle;

  @override
  void initState() {
    super.initState();
  }

  Future init() async {
    mapStyle = await rootBundle.loadString('assets/eazi_map_theme.json');
    mapController = Completer<GoogleMapController>();

    locServiceEnabled = await location.serviceEnabled();
    if (!locServiceEnabled) {
      locServiceEnabled = await location.requestService();
      if (!locServiceEnabled) {
        return;
      }
    }

    locPermissionGranted = await location.hasPermission();
    if (locPermissionGranted == PermissionStatus.denied) {
      locPermissionGranted = await location.requestPermission();
      if (locPermissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    currLocationData = await location.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            compassEnabled: false,
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * .4, 
            ),
            initialCameraPosition: CameraPosition(
              target: LatLng(
                currLocationData!.latitude!, 
                currLocationData!.longitude!
              ),
              zoom: 14.4746,
            ),
            style: mapStyle,
            markers: markers,
            polylines: polylines,
            onMapCreated: (GoogleMapController ctrl) async {
              await init();

              mapController.complete(ctrl);
            },
          )
        ],
      )
    );
  }

  Widget _buildLocHistoryItem({String? title, String? subtitle, Function()? onTap}) {
    return ListTile(
      // tileColor: colorGrey.withOpacity(.1),
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorGrey.withOpacity(.1),
          borderRadius: BorderRadius.circular(8)
        ),
        child: Icon(Icons.history, size: 30,)
      ),
      title: Text(title ?? '', style: TextStyle(
        fontWeight: FontWeight.w500
      )),
      subtitle: Text(subtitle ?? '', style: TextStyle(
        color: colorGrey
      )),
      onTap: onTap,
    );
  }

  Widget _buildVehicleType({String? title, String? time, int? capacity, String? amount, bool selected = false, Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: selected ? BoxDecoration(
          border: Border.all(color: colorPrimary),
          borderRadius: BorderRadius.circular(8)
        ) : null,
        child: ListTile(
          leading: Container(
            width: 70,
            height: 70,
            color: colorPrimary,
          ),
          title: Text(title ?? ''),
          subtitle: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.watch_later_outlined, size: 16,),
                    const SizedBox(width: 2,),
                    Text(time ?? '', style: TextStyle(
                      fontSize: 12
                    ))
                  ]
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.person_4_outlined, size: 16,),
                    const SizedBox(width: 2,),
                    Text('${capacity ?? 0}', style: TextStyle(
                      fontSize: 12
                    ))
                  ]
                ),
              )
            ],
          ),
          trailing: Text(amount ?? ''),
        )
      ),
    );
  }
}