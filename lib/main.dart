import 'package:eazi_ride/src/app.dart';
import 'package:eazi_ride/src/services/auth_manager.dart';
import 'package:eazi_ride/src/services/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light
    )
  );

  // await FlutterConfig.loadEnvVariables();

  await initServices();
  runApp(const EaziRide());
}

Future initServices() async {
  await GetStorage.init();
  Get.put(AuthManager());
  Get.put<UserService>(UserService());
}