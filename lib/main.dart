import 'package:eazi_ride/src/app.dart';
import 'package:eazi_ride/src/services/auth_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]
  );

  await initServices();
  runApp(const EaziRide());
}

Future initServices() async {
  await GetStorage.init();
  Get.put(AuthManager());
}