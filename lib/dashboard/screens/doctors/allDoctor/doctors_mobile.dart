import 'package:flutter/material.dart';
import 'package:gopeduli/dashboard/features/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:gopeduli/dashboard/features/table2/doctor/doctor_heading_paginated_table.dart';
import 'package:gopeduli/dashboard/features/table2/doctor/doctor_paginated_table.dart';
import 'package:gopeduli/dashboard/helper/size.dart';

class DoctorsMobile extends StatelessWidget {
  const DoctorsMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(GoPeduliSize.paddingHeightLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GoPeduliBreadCrumbsWithHeading(
                  heading: 'Doctors', breadcrumbItems: ['Doctors']),
              SizedBox(
                height: GoPeduliSize.sizedBoxHeightSmall,
              ),
              Column(
                children: [
                  GoPeduliHeadingPaginatedTableDoctor(),
                  SizedBox(
                    height: 10,
                  ),
                  GoPeduliPaginatedTableDoctor(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
