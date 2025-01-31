import 'package:eazi_ride/src/services/ride.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class HomeController extends GetxController with StateMixin {
  late String mapStyle;
  final bottomSheetController = DraggableScrollableController();
  final RxDouble locationPickerPos = RxDouble(-150);
  final Rx<RideState> rideState = RideState.initial.obs;

  late FocusNode fromFocus;
  late TextEditingController fromController;
  RxList fromPredictions = RxList.empty();
  String? fromId;

  late FocusNode toFocus;
  late TextEditingController toController;
  RxList toPredictions = RxList.empty();
  String? toId;

  RxList predictions = RxList.empty();
  ActiveField? activeField; 

  final RideService rideService = Get.find();
  String? locationToken;
  final uuid = const Uuid();

  Rx<RideType> rideType = RideType.regular.obs;

  @override
  void onInit() async {
    super.onInit();
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
  void onReady() {
    change(null, status: RxStatus.success());
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

  void getFromLocation(String q) async {
    locationToken ??= 'debug';
    // locationToken ??= uuid.v4();
    fromPredictions.value = await rideService.getLocation(q, token: locationToken);
  }

  void getToLocation(String q) async {
    locationToken ??= 'debug';
    // locationToken ??= uuid.v4();
    toPredictions.value = await rideService.getLocation(q, token: locationToken);
  }

  void getLocation(String q) async {
    locationToken ??= 'debug';
    // locationToken ??= uuid.v4();
    predictions.value = await rideService.getLocation(q, token: locationToken);
  }

  void gotoSelectRide() {
    rideState.value = RideState.selectRide;
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