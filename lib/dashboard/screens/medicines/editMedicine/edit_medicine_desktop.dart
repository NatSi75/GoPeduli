import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:gopeduli/dashboard/controllers/medicine/create_medicine_controller.dart';
import 'package:gopeduli/dashboard/repository/medicine_model.dart';
import 'package:gopeduli/dashboard/features/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:gopeduli/dashboard/helper/color.dart';
import 'package:gopeduli/dashboard/helper/size.dart';
import 'package:gopeduli/dashboard/helper/validation.dart';
import 'package:gopeduli/dashboard/routes/routes.dart';

class EditMedicineDesktop extends StatelessWidget {
  const EditMedicineDesktop({super.key, required this.medicine});

  final MedicineModel medicine;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateMedicineController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(GoPeduliSize.paddingHeightLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const GoPeduliBreadCrumbsWithHeading(
                  returnToPreviousScreen: true,
                  heading: 'Edit Medicine',
                  breadcrumbItems: [GoPeduliRoutes.medicines, 'Edit Medicine']),
              const SizedBox(
                height: GoPeduliSize.sizedBoxHeightSmall,
              ),
              Container(
                width: 400,
                decoration: BoxDecoration(
                    color: GoPeduliColors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 0,
                          offset: const Offset(1, 1))
                    ],
                    borderRadius:
                        BorderRadius.circular(GoPeduliSize.borderRadiusSmall)),
                padding:
                    const EdgeInsets.all(GoPeduliSize.sizedBoxHeightMedium),
                child: Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            'Edit Medicine',
                            style: TextStyle(
                                fontSize: GoPeduliSize.fontSizeTitle,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                        ),
                        const SizedBox(
                            height: GoPeduliSize.sizedBoxHeightSmall),
                        TextFormField(
                          controller: controller.nameProduct,
                          validator: (value) =>
                              GoPeduliValidator.validateEmptyText(
                                  'Name Product', value),
                          cursorColor: GoPeduliColors.primary,
                          style: const TextStyle(
                              fontSize: GoPeduliSize.fontSizeBody,
                              color: Colors.black),
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: GoPeduliColors.primary, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: GoPeduliColors.primary, width: 1),
                            ),
                            label: Text(
                              'Name Product',
                              style: TextStyle(
                                  fontSize: GoPeduliSize.fontSizeBody),
                            ),
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: GoPeduliSize.fontSizeBody),
                          ),
                        ),
                        const SizedBox(
                            height: GoPeduliSize.sizedBoxHeightSmall),
                        TextFormField(
                          controller: controller.nameMedicine,
                          validator: (value) =>
                              GoPeduliValidator.validateEmptyText(
                                  'Name Medicine', value),
                          cursorColor: GoPeduliColors.primary,
                          style: const TextStyle(
                              fontSize: GoPeduliSize.fontSizeBody,
                              color: Colors.black),
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: GoPeduliColors.primary, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: GoPeduliColors.primary, width: 1),
                            ),
                            label: Text(
                              'Name Medicine',
                              style: TextStyle(
                                  fontSize: GoPeduliSize.fontSizeBody),
                            ),
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: GoPeduliSize.fontSizeBody),
                          ),
                        ),
                        const SizedBox(
                            height: GoPeduliSize.sizedBoxHeightSmall),
                        TextFormField(
                          controller: controller.category,
                          validator: (value) =>
                              GoPeduliValidator.validateEmptyText(
                                  'Category', value),
                          cursorColor: GoPeduliColors.primary,
                          style: const TextStyle(
                              fontSize: GoPeduliSize.fontSizeBody,
                              color: Colors.black),
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: GoPeduliColors.primary, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: GoPeduliColors.primary, width: 1),
                            ),
                            label: Text(
                              'Category',
                              style: TextStyle(
                                  fontSize: GoPeduliSize.fontSizeBody),
                            ),
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: GoPeduliSize.fontSizeBody),
                          ),
                        ),
                        const SizedBox(
                            height: GoPeduliSize.sizedBoxHeightSmall),
                        TextFormField(
                          controller: controller.classMedicine,
                          validator: (value) =>
                              GoPeduliValidator.validateEmptyText(
                                  'Class', value),
                          cursorColor: GoPeduliColors.primary,
                          style: const TextStyle(
                              fontSize: GoPeduliSize.fontSizeBody,
                              color: Colors.black),
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: GoPeduliColors.primary, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: GoPeduliColors.primary, width: 1),
                            ),
                            label: Text(
                              'Class',
                              style: TextStyle(
                                  fontSize: GoPeduliSize.fontSizeBody),
                            ),
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: GoPeduliSize.fontSizeBody),
                          ),
                        ),
                        const SizedBox(
                            height: GoPeduliSize.sizedBoxHeightSmall),
                        TextFormField(
                          controller: controller.price,
                          validator: (value) =>
                              GoPeduliValidator.validateEmptyText(
                                  'Price', value),
                          cursorColor: GoPeduliColors.primary,
                          style: const TextStyle(
                              fontSize: GoPeduliSize.fontSizeBody,
                              color: Colors.black),
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: GoPeduliColors.primary, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: GoPeduliColors.primary, width: 1),
                            ),
                            label: Text(
                              'Price',
                              style: TextStyle(
                                  fontSize: GoPeduliSize.fontSizeBody),
                            ),
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: GoPeduliSize.fontSizeBody),
                          ),
                        ),
                        const SizedBox(
                            height: GoPeduliSize.sizedBoxHeightSmall),
                        TextFormField(
                          controller: controller.stock,
                          validator: (value) =>
                              GoPeduliValidator.validateEmptyText(
                                  'Stock', value),
                          cursorColor: GoPeduliColors.primary,
                          style: const TextStyle(
                              fontSize: GoPeduliSize.fontSizeBody,
                              color: Colors.black),
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: GoPeduliColors.primary, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: GoPeduliColors.primary, width: 1),
                            ),
                            label: Text(
                              'Stock',
                              style: TextStyle(
                                  fontSize: GoPeduliSize.fontSizeBody),
                            ),
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: GoPeduliSize.fontSizeBody),
                          ),
                        ),
                        const SizedBox(
                            height: GoPeduliSize.sizedBoxHeightSmall),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () => controller.createMedicine(),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: GoPeduliColors.primary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          GoPeduliSize.borderRadiusSmall))),
                              child: const Text('Update',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: GoPeduliSize.fontSizeBody))),
                        )
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
