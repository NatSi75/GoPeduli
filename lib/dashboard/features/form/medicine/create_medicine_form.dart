import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gopeduli/dashboard/controllers/medicine/create_medicine_controller.dart';
import 'package:gopeduli/dashboard/controllers/medicine/medicine_controller.dart';
import 'package:gopeduli/dashboard/helper/color.dart';
import 'package:gopeduli/dashboard/helper/size.dart';
import 'package:gopeduli/dashboard/helper/validation.dart';
import 'package:material_symbols_icons/symbols.dart';

class CreateMedicineForm extends StatelessWidget {
  const CreateMedicineForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateMedicineController());
    final medicineController = Get.put(MedicineController());
    return Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Create Medicine',
                style: TextStyle(
                    fontSize: GoPeduliSize.fontSizeTitle,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              ),
            ),
            const SizedBox(height: GoPeduliSize.sizedBoxHeightSmall),
            TextFormField(
              controller: controller.nameProduct,
              validator: (value) =>
                  GoPeduliValidator.validateEmptyText('Name Product', value),
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
                  'Name Product',
                  style: TextStyle(fontSize: GoPeduliSize.fontSizeBody),
                ),
                labelStyle: TextStyle(
                    color: Colors.black, fontSize: GoPeduliSize.fontSizeBody),
              ),
            ),
            const SizedBox(height: GoPeduliSize.sizedBoxHeightSmall),
            TextFormField(
              maxLines: 10,
              controller: controller.description,
              validator: (value) =>
                  GoPeduliValidator.validateEmptyText('Description', value),
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
                  'Description',
                  style: TextStyle(fontSize: GoPeduliSize.fontSizeBody),
                ),
                labelStyle: TextStyle(
                    color: Colors.black, fontSize: GoPeduliSize.fontSizeBody),
              ),
            ),
            const SizedBox(height: GoPeduliSize.sizedBoxHeightSmall),
            TextFormField(
              controller: controller.nameMedicine,
              validator: (value) =>
                  GoPeduliValidator.validateEmptyText('Name Medicine', value),
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
                  'Name Medicine',
                  style: TextStyle(fontSize: GoPeduliSize.fontSizeBody),
                ),
                labelStyle: TextStyle(
                    color: Colors.black, fontSize: GoPeduliSize.fontSizeBody),
              ),
            ),
            const SizedBox(height: GoPeduliSize.sizedBoxHeightSmall),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Add New Category',
                    style: TextStyle(
                        fontSize: GoPeduliSize.fontSizeBody,
                        color: Colors.black)),
                const SizedBox(height: GoPeduliSize.sizedBoxHeightSmall),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        cursorColor: GoPeduliColors.primary,
                        controller: controller.category,
                        decoration: const InputDecoration(
                          hintText: 'Enter new category',
                          hintStyle: TextStyle(
                              fontSize: GoPeduliSize.fontSizeBody,
                              color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: GoPeduliColors.primary, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: GoPeduliColors.primary, width: 1),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        controller.createCategory();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: GoPeduliColors.primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  GoPeduliSize.borderRadiusSmall))),
                      child: const Text('Add',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: GoPeduliSize.fontSizeBody)),
                    )
                  ],
                ),
                const SizedBox(height: GoPeduliSize.sizedBoxHeightSmall),
                const Text(
                  'Select Categories',
                  style: TextStyle(
                      fontSize: GoPeduliSize.fontSizeBody, color: Colors.black),
                ),
                const SizedBox(height: GoPeduliSize.sizedBoxHeightSmall),
                Obx(() => Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: controller.categorys.map((cat) {
                        final isSelected = controller.selectedCategories
                            .contains(cat.nameCategory);
                        return FilterChip(
                          label: Text(cat.nameCategory,
                              style: const TextStyle(
                                  fontSize: GoPeduliSize.fontSizeBody,
                                  color: Colors.black)),
                          backgroundColor: GoPeduliColors.white,
                          selectedColor: GoPeduliColors.primary,
                          selected: isSelected,
                          onSelected: (bool selected) {
                            if (selected) {
                              controller.selectedCategories
                                  .add(cat.nameCategory);
                            } else {
                              controller.selectedCategories
                                  .remove(cat.nameCategory);
                            }
                          },
                        );
                      }).toList(),
                    )),
              ],
            ),
            const SizedBox(height: GoPeduliSize.sizedBoxHeightSmall),
            Obx(() => Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: controller.categorys.map((cat) {
                    return Chip(
                      label: Text(cat.nameCategory),
                      onDeleted: () => controller.deleteCategory(cat),
                      deleteIcon: const Icon(Symbols.delete_forever_rounded,
                          color: Colors.red),
                    );
                  }).toList(),
                )),
            const SizedBox(height: GoPeduliSize.sizedBoxHeightSmall),
            Obx(() {
              final classList = medicineController.allMedicines
                  .map((e) => e.classMedicine)
                  .toSet()
                  .toList();

              if (classList.length < 2) {
                return TextFormField(
                  controller: controller.classMedicine,
                  validator: (value) => GoPeduliValidator.validateEmptyText(
                      'Class Medicine', value),
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
                      'Class Medicine',
                      style: TextStyle(fontSize: GoPeduliSize.fontSizeBody),
                    ),
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: GoPeduliSize.fontSizeBody),
                  ),
                );
              } else {
                return DropdownButtonFormField<String>(
                  value: controller.classMedicine.text.isNotEmpty
                      ? controller.classMedicine.text
                      : null,
                  style: const TextStyle(
                      fontSize: GoPeduliSize.fontSizeBody, color: Colors.black),
                  decoration: const InputDecoration(
                    labelText: 'Class Medicine',
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: GoPeduliSize.fontSizeBody),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: GoPeduliColors.primary, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: GoPeduliColors.primary, width: 1),
                    ),
                  ),
                  items: classList
                      .map((className) => DropdownMenuItem<String>(
                            value: className,
                            child: Text(className),
                          ))
                      .toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      controller.classMedicine.text = newValue;
                    }
                  },
                );
              }
            }),
            const SizedBox(height: GoPeduliSize.sizedBoxHeightSmall),
            TextFormField(
              controller: controller.price,
              validator: (value) =>
                  GoPeduliValidator.validateEmptyText('Price', value),
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
                  'Price',
                  style: TextStyle(fontSize: GoPeduliSize.fontSizeBody),
                ),
                labelStyle: TextStyle(
                    color: Colors.black, fontSize: GoPeduliSize.fontSizeBody),
              ),
            ),
            const SizedBox(height: GoPeduliSize.sizedBoxHeightSmall),
            TextFormField(
              controller: controller.stock,
              validator: (value) =>
                  GoPeduliValidator.validateEmptyText('Stock', value),
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
                  'Stock',
                  style: TextStyle(fontSize: GoPeduliSize.fontSizeBody),
                ),
                labelStyle: TextStyle(
                    color: Colors.black, fontSize: GoPeduliSize.fontSizeBody),
              ),
            ),
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
                  onPressed: () => controller.createMedicine(),
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
