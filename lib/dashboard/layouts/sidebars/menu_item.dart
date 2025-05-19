import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gopeduli/dashboard/helper/color.dart';
import 'package:gopeduli/dashboard/helper/size.dart';
import 'package:gopeduli/dashboard/layouts/sidebars/sidebar_controller.dart';

class GoPeduliMenuItem extends StatelessWidget {
  const GoPeduliMenuItem({
    super.key,
    required this.route,
    required this.icon,
    required this.itemName,
  });

  final String route;
  final IconData icon;
  final String itemName;

  @override
  Widget build(BuildContext context) {
    final menuController = Get.put(SidebarController());
    return InkWell(
      onTap: () => menuController.menuOnTap(route),
      onHover: (hovering) => hovering
          ? menuController.changeHoverItem(route)
          : menuController.changeHoverItem(""),
      child: Obx(
        () => Padding(
          padding: const EdgeInsets.symmetric(
              vertical: GoPeduliSize.paddingHeightExtraUltraSmall),
          child: Container(
            decoration: BoxDecoration(
              color: menuController.isHovering(route) ||
                      menuController.isActive(route)
                  ? GoPeduliColors.primary
                  : Colors.transparent,
              borderRadius:
                  BorderRadius.circular(GoPeduliSize.borderRadiusSmall),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: GoPeduliSize.paddingHeightUltraSmall,
                      horizontal: GoPeduliSize.paddingHeightSmall),
                  child: menuController.isActive(route)
                      ? Icon(icon, color: GoPeduliColors.white)
                      : Icon(icon,
                          color: menuController.isHovering(route)
                              ? Colors.white
                              : Colors.grey),
                ),
                if (menuController.isHovering(route) ||
                    menuController.isActive(route))
                  Flexible(
                    child: Text(itemName,
                        style: const TextStyle(
                            color: GoPeduliColors.white,
                            fontSize: GoPeduliSize.fontSizeBody)),
                  )
                else
                  Flexible(
                    child: Text(itemName,
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: GoPeduliSize.fontSizeBody)),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
