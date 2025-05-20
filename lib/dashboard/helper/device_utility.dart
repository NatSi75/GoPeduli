import 'package:flutter/material.dart';

class GoPeduliDeviceUtility {
  static bool isDesktopScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1366;
  }

  static bool isTabletScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 1366 &&
        MediaQuery.of(context).size.width >= 768;
  }

  static bool isMobileScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 768;
  }
}
