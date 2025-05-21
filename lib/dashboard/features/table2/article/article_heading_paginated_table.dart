import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gopeduli/dashboard/controllers/article/article_controller.dart';
import 'package:gopeduli/dashboard/helper/color.dart';
import 'package:gopeduli/dashboard/helper/device_utility.dart';
import 'package:gopeduli/dashboard/helper/size.dart';
import 'package:gopeduli/dashboard/routes/routes.dart';
import 'package:material_symbols_icons/symbols.dart';

class GoPeduliHeadingPaginatedTableArticle extends StatelessWidget {
  const GoPeduliHeadingPaginatedTableArticle({super.key});

  @override
  Widget build(BuildContext context) {
    final ArticleController controller = Get.put(ArticleController());
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: GoPeduliDeviceUtility.isDesktopScreen(context) ? 3 : 1,
            child: Row(
              children: [
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                      onPressed: () =>
                          Get.toNamed(GoPeduliRoutes.createArticle),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: GoPeduliColors.primary,
                          foregroundColor: GoPeduliColors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  GoPeduliSize.borderRadiusSmall))),
                      child: const Text(
                        'Create New Article',
                        style: TextStyle(fontSize: GoPeduliSize.fontSizeBody),
                      )),
                ),
              ],
            ),
          ),
          Expanded(
            flex: GoPeduliDeviceUtility.isDesktopScreen(context) ? 1 : 1,
            child: TextFormField(
              controller: controller.searchTextController,
              onChanged: (query) => controller.searchQuery(query),
              cursorColor: GoPeduliColors.primary,
              style: const TextStyle(
                  fontSize: GoPeduliSize.fontSizeBody, color: Colors.black),
              decoration: const InputDecoration(
                hintText: 'Search Title Article',
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
