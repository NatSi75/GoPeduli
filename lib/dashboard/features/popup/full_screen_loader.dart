import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GoPeduliFullScreenLoader {
  static void openLoadingDialog(String Text, String animation) {
    showDialog(
        context: Get.overlayContext!,
        barrierDismissible: false,
        builder: (_) => PopScope(
            canPop: false,
            child: Container(
              color: Colors.white,
              width: double.infinity,
              height: double.infinity,
              child: const Column(
                children: [
                  SizedBox(height: 250),
                ],
              ),
            )));
  }

  static void popUpCircular() {
    Get.defaultDialog(
        title: '',
        onWillPop: () async => false,
        backgroundColor: Colors.transparent);
  }
}
