import 'package:flutter/material.dart';

class EaziRide extends StatelessWidget {
  const EaziRide({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData(
      useMaterial3: false,
      primaryColor: Colors.teal,
      // textTheme: 
    );

    return MaterialApp(
      title: 'EaziRide',
      theme: theme,
      initialRoute: '/',
    );
  }
}