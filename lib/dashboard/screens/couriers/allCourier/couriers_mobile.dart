import 'package:flutter/material.dart';
import 'package:gopeduli/dashboard/features/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:gopeduli/dashboard/features/table2/courier/courier_heading_paginated_table.dart';
import 'package:gopeduli/dashboard/features/table2/courier/courier_paginated_table.dart';
import 'package:gopeduli/dashboard/helper/size.dart';

class CouriersMobile extends StatelessWidget {
  const CouriersMobile({super.key});

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
                  heading: 'Couriers', breadcrumbItems: ['Couriers']),
              SizedBox(
                height: GoPeduliSize.sizedBoxHeightSmall,
              ),
              Column(
                children: [
                  GoPeduliHeadingPaginatedTableCourier(),
                  SizedBox(
                    height: 10,
                  ),
                  GoPeduliPaginatedTableCourier(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
