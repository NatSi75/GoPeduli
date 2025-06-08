import 'package:flutter/material.dart';
import 'package:gopeduli/dashboard/features/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:gopeduli/dashboard/features/table2/author/author_heading_paginated_table.dart';
import 'package:gopeduli/dashboard/features/table2/author/author_paginated_table.dart';
import 'package:gopeduli/dashboard/helper/size.dart';

class AuthorsDesktop extends StatelessWidget {
  const AuthorsDesktop({super.key});

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
                  heading: 'Authors', breadcrumbItems: ['Authors']),
              SizedBox(
                height: GoPeduliSize.sizedBoxHeightSmall,
              ),
              Column(
                children: [
                  GoPeduliHeadingPaginatedTableAuthor(),
                  SizedBox(
                    height: 10,
                  ),
                  GoPeduliPaginatedTableAuthor(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
