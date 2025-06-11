import 'package:flutter/material.dart';
import 'package:gopeduli/dashboard/features/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:gopeduli/dashboard/features/table2/order/order_heading_paginated_table.dart';
import 'package:gopeduli/dashboard/features/table2/order/order_paginated_table.dart';
import 'package:gopeduli/dashboard/helper/size.dart';

class OrdersTablet extends StatelessWidget {
  const OrdersTablet({super.key});

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
                  heading: 'Orders', breadcrumbItems: ['Orders']),
              SizedBox(
                height: GoPeduliSize.sizedBoxHeightSmall,
              ),
              Column(
                children: [
                  GoPeduliHeadingPaginatedTableOrder(),
                  SizedBox(
                    height: 10,
                  ),
                  GoPeduliPaginatedTableOrder(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
