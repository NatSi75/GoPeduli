import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gopeduli/dashboard/controllers/medicine/create_medicine_controller.dart';
import 'package:gopeduli/dashboard/controllers/medicine/medicine_controller.dart';
import 'package:gopeduli/dashboard/helper/color.dart';
import 'package:gopeduli/dashboard/helper/size.dart';
import 'package:gopeduli/dashboard/helper/validation.dart';

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
            TextFormField(
              controller: controller.category,
              validator: (value) =>
                  GoPeduliValidator.validateEmptyText('Category', value),
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
                  'Category',
                  style: TextStyle(fontSize: GoPeduliSize.fontSizeBody),
                ),
                labelStyle: TextStyle(
                    color: Colors.black, fontSize: GoPeduliSize.fontSizeBody),
              ),
            ),
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
