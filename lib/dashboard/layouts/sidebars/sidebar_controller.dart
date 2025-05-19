import 'package:get/get.dart';
import 'package:gopeduli/dashboard/features/authentication/authentication_repository.dart';
import 'package:gopeduli/dashboard/helper/device_utility.dart';
import 'package:gopeduli/dashboard/routes/routes.dart';

class SidebarController extends GetxController {
  final activeItem = GoPeduliRoutes.dashboard.obs;
  final hoverItem = ''.obs;

  void changeActiveItem(String route) => activeItem.value = route;

  void changeHoverItem(String route) {
    if (!isActive(route)) hoverItem.value = route;
  }

  bool isActive(String route) => activeItem.value == route;
  bool isHovering(String route) => hoverItem.value == route;

  void menuOnTap(String route) {
    if (route == GoPeduliRoutes.logout) {
      AuthenticationRepository.instance.logout();
    }

    if (!isActive(route)) {
      changeActiveItem(route);

      if (GoPeduliDeviceUtility.isMobileScreen(Get.context!)) Get.back();

      Get.toNamed(route);
    }
  }
}
