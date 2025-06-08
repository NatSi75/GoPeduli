import 'package:flutter/material.dart';
import 'package:gopeduli/dashboard/features/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:gopeduli/dashboard/features/form/courier/create_courier_form.dart';
import 'package:gopeduli/dashboard/helper/color.dart';
import 'package:gopeduli/dashboard/helper/size.dart';
import 'package:gopeduli/dashboard/routes/routes.dart';

class CreateCourierTablet extends StatelessWidget {
  const CreateCourierTablet({super.key});

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
                  heading: 'Create Courier',
                  breadcrumbItems: [GoPeduliRoutes.couriers, 'Create Courier']),
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
                child: const CreateCourierForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
