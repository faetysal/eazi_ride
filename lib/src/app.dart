import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'config.dart';
import 'init.dart';

class EaziRide extends StatelessWidget {
  const EaziRide({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData(
      useMaterial3: false,
      primaryColor: colorPrimary,
      textTheme: GoogleFonts.spaceGroteskTextTheme()
    );

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EaziRide',
      theme: theme,
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => Init()
        )
      ],
    );
  }
}