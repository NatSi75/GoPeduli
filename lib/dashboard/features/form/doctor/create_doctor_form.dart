import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gopeduli/dashboard/controllers/doctor/create_doctor_controller.dart';
import 'package:gopeduli/dashboard/helper/color.dart';
import 'package:gopeduli/dashboard/helper/size.dart';
import 'package:gopeduli/dashboard/helper/validation.dart';
import 'package:material_symbols_icons/symbols.dart';

class CreateDoctorForm extends StatelessWidget {
  const CreateDoctorForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateDoctorController());
    return Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Create Doctor Account',
                style: TextStyle(
                    fontSize: GoPeduliSize.fontSizeTitle,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              ),
            ),
            const SizedBox(height: GoPeduliSize.sizedBoxHeightSmall),
            TextFormField(
              controller: controller.name,
              validator: (value) =>
                  GoPeduliValidator.validateEmptyText('Name', value),
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
                  'Name',
                  style: TextStyle(fontSize: GoPeduliSize.fontSizeBody),
                ),
                labelStyle: TextStyle(
                    color: Colors.black, fontSize: GoPeduliSize.fontSizeBody),
              ),
            ),
            const SizedBox(height: GoPeduliSize.sizedBoxHeightSmall),
            const Text(
              'Select Available Days',
              style: TextStyle(
                  fontSize: GoPeduliSize.fontSizeBody, color: Colors.black),
            ),
            const SizedBox(height: GoPeduliSize.sizedBoxHeightSmall),
            Obx(
              () => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: controller.daysOfWeek.map((dayName) {
                  final isSelected =
                      controller.selectedAvailableDays.contains(dayName);
                  return FilterChip(
                    label: Text(dayName,
                        style: TextStyle(
                            fontSize: GoPeduliSize.fontSizeBody,
                            color: isSelected
                                ? GoPeduliColors.white
                                : Colors.black)),
                    backgroundColor: GoPeduliColors.white,
                    selectedColor: GoPeduliColors.primary,
                    selected: isSelected,
                    onSelected: (bool selected) {
                      if (selected) {
                        controller.selectedAvailableDays.add(dayName);
                      } else {
                        controller.selectedAvailableDays.remove(dayName);
                      }
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: GoPeduliSize.sizedBoxHeightSmall),
            TextFormField(
              controller: controller.hospital,
              validator: (value) =>
                  GoPeduliValidator.validateEmptyText('Hospital', value),
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
                  'Hospital',
                  style: TextStyle(fontSize: GoPeduliSize.fontSizeBody),
                ),
                labelStyle: TextStyle(
                    color: Colors.black, fontSize: GoPeduliSize.fontSizeBody),
              ),
            ),
            const SizedBox(height: GoPeduliSize.sizedBoxHeightSmall),
            TextFormField(
              controller: controller.email,
              validator: (value) =>
                  GoPeduliValidator.validateEmptyText('Email', value),
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
                  'Email',
                  style: TextStyle(fontSize: GoPeduliSize.fontSizeBody),
                ),
                labelStyle: TextStyle(
                    color: Colors.black, fontSize: GoPeduliSize.fontSizeBody),
              ),
            ),
            const SizedBox(height: GoPeduliSize.sizedBoxHeightSmall),
            Obx(
              () => TextFormField(
                cursorColor: GoPeduliColors.primary,
                style: const TextStyle(
                    fontSize: GoPeduliSize.fontSizeBody, color: Colors.black),
                controller: controller.password,
                validator: (value) =>
                    GoPeduliValidator.validateEmptyText('Password', value),
                obscureText: controller.hidePassword.value,
                decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: GoPeduliColors.primary, width: 1),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: GoPeduliColors.primary, width: 1),
                    ),
                    suffixIcon: IconButton(
                        onPressed: () => controller.hidePassword.value =
                            !controller.hidePassword.value,
                        icon: Icon(
                          controller.hidePassword.value
                              ? Symbols.visibility_off_rounded
                              : Symbols.visibility_rounded,
                          color: Colors.black,
                        )),
                    prefixIcon: const Icon(
                      Symbols.password_rounded,
                      color: Colors.black,
                    ),
                    labelStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: GoPeduliSize.fontSizeBody),
                    label: const Text('Password',
                        style: TextStyle(fontSize: GoPeduliSize.fontSizeBody))),
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
                  onPressed: () => controller.registerDoctor(),
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
