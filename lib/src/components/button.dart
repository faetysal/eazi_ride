import 'package:eazi_ride/src/config.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String label;
  final IconData? icon;

  const Button({
    super.key,
    required this.label,
    this.icon
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {}, 
      label: Text(label, style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold
      )),
      icon: icon != null
        ? Icon(icon)
        : null,
      iconAlignment: IconAlignment.end,
      style: TextButton.styleFrom(
        backgroundColor: colorPrimary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8)
        )
      ),
    );
  }
}