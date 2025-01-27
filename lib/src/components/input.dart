import 'package:eazi_ride/src/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Input extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? placeholder;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Function()? onSuffixIconTap;
  final bool obscureText;
  final bool readOnly;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;

  const Input({
    super.key,
    this.controller,
    this.validator,
    this.placeholder,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.obscureText = false,
    this.readOnly = false,
    this.inputFormatters,
    this.keyboardType
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      readOnly: readOnly,
      decoration: InputDecoration(
        hintText: placeholder,
        prefixIcon: prefixIcon != null
          ? Icon(prefixIcon)
          : null,
        suffixIcon: suffixIcon != null
          ? InkWell(
            focusNode: FocusNode(skipTraversal: true),
            onTap: onSuffixIconTap,
            child: Icon(suffixIcon)
          )
          : null,
        focusedBorder: _buildInputBorder(),
      ),
      inputFormatters: inputFormatters,
      keyboardType: keyboardType
    );
  }

  UnderlineInputBorder _buildInputBorder({Color color = colorBlack}) {
    return UnderlineInputBorder(
      borderSide: BorderSide(color: color)
    );
  }
}