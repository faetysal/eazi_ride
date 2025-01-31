import 'package:eazi_ride/src/config.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Widget? child;
  final Function()? onPressed;

  const Button({
    super.key,
    required this.label,
    this.icon,
    this.child,
    this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    if (child != null) {
      return TextButton(
        onPressed: onPressed, 
        style: _buildButtonStyle(),
        child: child!
      );
    }

    return TextButton.icon(
      onPressed: onPressed, 
      label: Text(label, style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold
      )),
      icon: icon != null
        ? Icon(icon)
        : null,
      iconAlignment: IconAlignment.end,
      style: _buildButtonStyle()
    );
  }

  ButtonStyle? _buildButtonStyle() {
    return TextButton.styleFrom(
      backgroundColor: colorPrimary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8)
      )
    );
  }
}