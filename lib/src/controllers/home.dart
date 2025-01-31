import 'dart:async';
import 'dart:math';

import 'package:eazi_ride/src/config.dart';
import 'package:eazi_ride/src/services/ride.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:uuid/uuid.dart';

class HomeController extends GetxController with StateMixin {
  Location location = Location();
  bool locServiceEnabled = false;
  PermissionStatus? locPermissionGranted;
  LocationData? currLocationData;
  // Set<Marker> markers = {};
  Rx<Set<Marker>> markers = Rx<Set<Marker>>({});
  // Set<Polyline> polylines = {};
  Rx<Set<Polyline>> polylines = Rx<Set<Polyline>>({});
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  late Completer<GoogleMapController> mapController;
  late String mapStyle;

  final bottomSheetController = DraggableScrollableController();
  final RxDouble locationPickerPos = RxDouble(-150);
  final Rx<RideState> rideState = RideState.initial.obs;

  late FocusNode fromFocus;
  late TextEditingController fromController;
  String? fromId;

  late FocusNode toFocus;
  late TextEditingController toController;
  String? toId;

  RxList predictions = RxList.empty();
  ActiveField? activeField; 

  final RideService rideService = Get.find();
  String? locationToken;
  final uuid = const Uuid();

  Rx<RideType> rideType = RideType.regular.obs;
  RxDouble maxBottomSheetSize = RxDouble(1);

  @override
  void onInit() async {
    super.onInit();
    mapController = Completer<GoogleMapController>();

    fromFocus = FocusNode();
    fromFocus.addListener(() {
      if (fromFocus.hasFocus) {
        activeField = ActiveField.from;
      }
    });
    fromController = TextEditingController();

    toFocus = FocusNode();
    toFocus.addListener(() {
      if (toFocus.hasFocus) {
        activeField = ActiveField.to;
      }
    });
    toController = TextEditingController();

    mapStyle = await rootBundle.loadString('assets/eazi_map_theme.json');
    bottomSheetController.addListener(() {
      if (bottomSheetController.size >= .8) {
        if (rideState.value == RideState.initial) {
          rideState.value = RideState.selectLocation;
          locationPickerPos.value = kToolbarHeight;
        }
      } else {
        if (rideState.value == RideState.selectLocation) {
          rideState.value = RideState.initial;
          locationPickerPos.value = -150;
        }
      }
    });
  }

  @override
  void onReady() async {
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

    change(markers, status: RxStatus.success());
  }

  @override
  void onClose() {
    fromFocus.dispose();
    fromController.dispose();
    toFocus.dispose();
    toController.dispose();
    super.onClose();
  }

  void gotoSelectLocation() {
    bottomSheetController.animateTo(1,
      duration: const Duration(milliseconds: 100), 
      curve: Curves.linear
    );
    // rideState.value = RideState.selectLocation;
  }

  void getLocation(String q) async {
    locationToken ??= 'debug';
    // locationToken ??= uuid.v4();
    predictions.value = await rideService.getLocation(q, token: locationToken);
  }

  /*void getPlaceDetails(String id) async {
    await rideService.getPlaceDetails(id);
  }*/

  void gotoSelectRide() async {
    change(null, status: RxStatus.loading());
    rideState.value = RideState.selectRide;
    maxBottomSheetSize.value = .8;
    bottomSheetController.reset();
    final GoogleMapController mapCtrl = await mapController.future;
    final fromLoc = await rideService.getPlaceDetails(fromId!);
    final toLoc = await rideService.getPlaceDetails(fromId!);
    /*await mapCtrl.moveCamera(CameraUpdate.newLatLngBounds(
      computeBounds([
        LatLng(toLoc['lat'], toLoc['lng']),
        LatLng(fromLoc['lat'], fromLoc['lng']),
      ]), 
      70
    ));*/

    /* Set Pins */
    print('Adding marker 1');
    markers.value.add(Marker(
      markerId: const MarkerId('srcPin'),
      position: LatLng(fromLoc['lat'], fromLoc['lng']),
    ));
    print('Adding marker 2');
    markers.value.add(Marker(
      markerId: const MarkerId('dstPin'),
      position: LatLng(toLoc['lat'], toLoc['lng']),
    ));

    print('Markers: $markers');


    /* Set polylines */
    print('Setting polylines');
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      request: PolylineRequest(
        origin: PointLatLng(fromLoc['lat'], fromLoc['lng']), 
        destination: PointLatLng(toLoc['lat'], toLoc['lng']), 
        mode: TravelMode.driving
      ),
      googleApiKey: const String.fromEnvironment('GOOGLE_API_KEY')
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    Polyline polyline = Polyline(
      polylineId: PolylineId('poly'),
      width: 5,
      patterns: [PatternItem.dash(10), PatternItem.gap(10)],
      color: colorPrimary,
      points: polylineCoordinates
    );

    polylines.value.add(polyline);
    print('Polylines added');
    change(null, status: RxStatus.success());
  }

  LatLngBounds computeBounds(List<LatLng> list) {
    assert(list.isNotEmpty);
    var firstLatLng = list.first;
    var s = firstLatLng.latitude,
        n = firstLatLng.latitude,
        w = firstLatLng.longitude,
        e = firstLatLng.longitude;
    for (var i = 1; i < list.length; i++) {
      var latlng = list[i];
      s = min(s, latlng.latitude);
      n = max(n, latlng.latitude);
      w = min(w, latlng.longitude);
      e = max(e, latlng.longitude);
    }
    return LatLngBounds(southwest: LatLng(s, w), northeast: LatLng(n, e));
  }
}

enum RideState {
  initial,
  selectLocation,
  selectRide,
  awaitingDriver,
  inProgress,
  summary
}

enum ActiveField {
  from,
  to
}

enum RideType {
  regular,
  executive,
  economy
}