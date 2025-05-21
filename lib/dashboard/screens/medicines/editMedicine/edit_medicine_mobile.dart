import 'package:flutter/material.dart';
import 'package:gopeduli/dashboard/features/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:gopeduli/dashboard/features/form/medicine/edit_medicine_form.dart';
import 'package:gopeduli/dashboard/helper/color.dart';
import 'package:gopeduli/dashboard/helper/size.dart';
import 'package:gopeduli/dashboard/repository/medicine_model.dart';
import 'package:gopeduli/dashboard/routes/routes.dart';

class EditMedicineMobile extends StatelessWidget {
  const EditMedicineMobile({super.key, required this.medicine});

  final MedicineModel medicine;

  @override
  Widget build(BuildContext context) {
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
                          color: Colors.black.withValues(alpha: 0.1),
                          spreadRadius: 2,
                          blurRadius: 0,
                          offset: const Offset(1, 1))
                    ],
                    borderRadius:
                        BorderRadius.circular(GoPeduliSize.borderRadiusSmall)),
                padding:
                    const EdgeInsets.all(GoPeduliSize.sizedBoxHeightMedium),
                child: EditMedicineForm(
                  medicine: medicine,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
