import 'package:flutter/material.dart';
import 'package:gopeduli/dashboard/features/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:gopeduli/dashboard/features/table2/user/user_heading_paginated_table.dart';
import 'package:gopeduli/dashboard/features/table2/user/user_paginated_table.dart';
import 'package:gopeduli/dashboard/helper/size.dart';

class UsersMobile extends StatelessWidget {
  const UsersMobile({super.key});

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
                  heading: 'Users', breadcrumbItems: ['Users']),
              SizedBox(
                height: GoPeduliSize.sizedBoxHeightSmall,
              ),
              Column(
                children: [
                  GoPeduliHeadingPaginatedTableUser(),
                  SizedBox(
                    height: 10,
                  ),
                  GoPeduliPaginatedTableUser(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
