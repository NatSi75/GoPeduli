import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gopeduli/dashboard/controllers/article/create_article_controller.dart';
import 'package:gopeduli/dashboard/helper/color.dart';
import 'package:gopeduli/dashboard/helper/size.dart';
import 'package:gopeduli/dashboard/helper/validation.dart';

class CreateArticleFrom extends StatelessWidget {
  const CreateArticleFrom({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateArticleController());
    return Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Create Article',
                style: TextStyle(
                    fontSize: GoPeduliSize.fontSizeTitle,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              ),
            ),
            const SizedBox(height: GoPeduliSize.sizedBoxHeightSmall),
            TextFormField(
              controller: controller.title,
              validator: (value) =>
                  GoPeduliValidator.validateEmptyText('Title', value),
              cursorColor: GoPeduliColors.primary,
              style: const TextStyle(
                  fontSize: GoPeduliSize.fontSizeBody, color: Colors.black),
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: GoPeduliColors.primary, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: GoPeduliColors.primary, width: 1),
                ),
                label: Text(
                  'Title',
                  style: TextStyle(fontSize: GoPeduliSize.fontSizeBody),
                ),
                labelStyle: TextStyle(
                    color: Colors.black, fontSize: GoPeduliSize.fontSizeBody),
              ),
            ),
            const SizedBox(height: GoPeduliSize.sizedBoxHeightSmall),
            TextFormField(
              maxLines: 10,
              controller: controller.body,
              validator: (value) =>
                  GoPeduliValidator.validateEmptyText('Body', value),
              cursorColor: GoPeduliColors.primary,
              style: const TextStyle(
                  fontSize: GoPeduliSize.fontSizeBody, color: Colors.black),
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: GoPeduliColors.primary, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: GoPeduliColors.primary, width: 1),
                ),
                label: Text(
                  'Body',
                  style: TextStyle(fontSize: GoPeduliSize.fontSizeBody),
                ),
                labelStyle: TextStyle(
                    color: Colors.black, fontSize: GoPeduliSize.fontSizeBody),
              ),
            ),
            const SizedBox(height: GoPeduliSize.sizedBoxHeightSmall),
            Obx(() {
              return DropdownButtonFormField<String>(
                value: controller.author.value,
                validator: (value) =>
                    GoPeduliValidator.validateEmptyText('Author', value),
                onChanged: (value) => controller.author.value = value,
                items: controller.authors.map((author) {
                  return DropdownMenuItem<String>(
                    value: author.name,
                    child: Text(author.name),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: GoPeduliColors.primary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: GoPeduliColors.primary),
                  ),
                  labelText: 'Author',
                  labelStyle: TextStyle(
                      color: Colors.black, fontSize: GoPeduliSize.fontSizeBody),
                ),
              );
            }),
            const SizedBox(height: GoPeduliSize.sizedBoxHeightSmall),
            Obx(() {
              return DropdownButtonFormField<String>(
                value: controller.verifiedBy.value,
                validator: (value) =>
                    GoPeduliValidator.validateEmptyText('Doctor', value),
                onChanged: (value) => controller.verifiedBy.value = value,
                items: controller.doctors.map((doctor) {
                  return DropdownMenuItem<String>(
                    value: doctor.name,
                    child: Text(doctor.name),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: GoPeduliColors.primary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: GoPeduliColors.primary),
                  ),
                  labelText: 'Doctor',
                  labelStyle: TextStyle(
                      color: Colors.black, fontSize: GoPeduliSize.fontSizeBody),
                ),
              );
            }),
            const SizedBox(height: GoPeduliSize.sizedBoxHeightSmall),
            Center(
              child: ValueListenableBuilder<Uint8List?>(
                valueListenable: imageDataNotifier,
                builder: (context, imageData, child) {
                  if (imageData == null) {
                    return const Text('No Image Yet',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: GoPeduliSize.fontSizeBody));
                  }
                  return Image.memory(imageData,
                      height: 200, fit: BoxFit.cover);
                },
              ),
            ),
            const SizedBox(height: GoPeduliSize.sizedBoxHeightSmall),
            Center(
              child: ElevatedButton(
                onPressed: controller.pickImage,
                style: ElevatedButton.styleFrom(
                    backgroundColor: GoPeduliColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            GoPeduliSize.borderRadiusSmall))),
                child: const Text('Select Image',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: GoPeduliSize.fontSizeBody)),
              ),
            ),
            const SizedBox(height: GoPeduliSize.sizedBoxHeightSmall),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () => controller.createArticle(),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: GoPeduliColors.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              GoPeduliSize.borderRadiusSmall))),
                  child: const Text('Create',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: GoPeduliSize.fontSizeBody))),
            )
          ],
        ));
  }
}
