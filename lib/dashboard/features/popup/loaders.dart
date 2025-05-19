import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gopeduli/dashboard/helper/color.dart';
import 'package:gopeduli/dashboard/helper/size.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class GoPeduliLoaders {
  static hideSnackBar() =>
      ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();

  static customToast({required message}) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
        width: 500,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.transparent,
        content: Container(
          padding: const EdgeInsets.all(12.0),
          margin: const EdgeInsets.symmetric(horizontal: 30.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: GoPeduliColors.primary),
          child: Center(
            child: Text(
              message,
              style: const TextStyle(fontSize: GoPeduliSize.fontSizeSubtitle),
            ),
          ),
        )));
  }

  static successSnackBar({required title, message = ' ', duration = 3}) {
    Get.snackbar(title, message,
        maxWidth: 600,
        isDismissible: true,
        shouldIconPulse: true,
        colorText: GoPeduliColors.white,
        backgroundColor: GoPeduliColors.primary,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: duration),
        margin: const EdgeInsets.all(10),
        icon: const Icon(
          Symbols.check,
          color: GoPeduliColors.white,
        ));
  }

  static warningSnackBar({required title, message = ' '}) {
    Get.snackbar(title, message,
        maxWidth: 600,
        isDismissible: true,
        shouldIconPulse: true,
        colorText: GoPeduliColors.white,
        backgroundColor: Colors.orange,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(20),
        icon: const Icon(
          Symbols.warning,
          color: GoPeduliColors.white,
        ));
  }

  static errorSnackBar({required title, message = ' '}) {
    Get.snackbar(title, message,
        maxWidth: 600,
        isDismissible: true,
        shouldIconPulse: true,
        colorText: GoPeduliColors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(20),
        icon: const Icon(
          Symbols.error,
          color: GoPeduliColors.white,
        ));
  }
}
