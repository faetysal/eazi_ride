import 'package:eazi_ride/src/config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PopupManager {
  String? title;
  String? message;
  Color? backgroundColor;
  Color? foregroundColor;
  Duration duration = const Duration(seconds: 5);
  
  PopupManager.error({this.title, this.message}) {
    foregroundColor = Colors.white;
    backgroundColor = Colors.red;

    Get.snackbar(
      title ?? 'Error', 
      message ?? 'Something went wrong. Please try again later.',
      backgroundColor: backgroundColor,
      colorText: foregroundColor,
      duration: duration
    );
  }

  PopupManager.success({this.title = '', this.message = ''}) {
    foregroundColor = Colors.white;
    backgroundColor = Colors.green;

    Get.snackbar(
      title ?? '', 
      message ?? '',
      backgroundColor: backgroundColor,
      colorText: foregroundColor,
      duration: duration
    );
  }

  PopupManager.info({this.title = '', this.message = ''}) {
    foregroundColor = colorBlack;
    backgroundColor = colorNeutral;

    Get.snackbar(
      title ?? '', 
      message ?? '',
      backgroundColor: backgroundColor,
      colorText: foregroundColor,
      duration: duration
    );
  }

}