import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gopeduli/dashboard/features/authentication/controllers/user_controller.dart';
import 'package:gopeduli/dashboard/helper/color.dart';
import 'package:gopeduli/dashboard/helper/device_utility.dart';
import 'package:gopeduli/dashboard/helper/size.dart';
import 'package:material_symbols_icons/symbols.dart';

class GoPeduliHeadingPaginatedTableUser extends StatelessWidget {
  const GoPeduliHeadingPaginatedTableUser({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController controller = Get.put(UserController());
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: GoPeduliDeviceUtility.isDesktopScreen(context) ? 1 : 1,
            child: TextFormField(
              controller: controller.searchTextController,
              onChanged: (query) => controller.searchQuery(query),
              cursorColor: GoPeduliColors.primary,
              style: const TextStyle(
                  fontSize: GoPeduliSize.fontSizeBody, color: Colors.black),
              decoration: const InputDecoration(
                hintText: 'Search Name User',
                prefix: Icon(
                  Symbols.search,
                  size: 14,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: GoPeduliColors.primary, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: GoPeduliColors.primary, width: 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
