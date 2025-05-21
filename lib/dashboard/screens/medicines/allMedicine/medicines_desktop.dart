import 'package:flutter/material.dart';
import 'package:gopeduli/dashboard/features/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:gopeduli/dashboard/features/table2/medicine/medicine_heading_paginated_table.dart';
import 'package:gopeduli/dashboard/features/table2/medicine/medicine_paginated_table.dart';
import 'package:gopeduli/dashboard/helper/size.dart';

class MedicinesDesktop extends StatelessWidget {
  const MedicinesDesktop({super.key});

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
                  heading: 'Medicines', breadcrumbItems: ['Medicines']),
              SizedBox(
                height: GoPeduliSize.sizedBoxHeightSmall,
              ),
              Column(
                children: [
                  GoPeduliHeadingPaginatedTableMedicine(),
                  SizedBox(
                    height: 10,
                  ),
                  GoPeduliPaginatedTableMedicine(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
