import 'package:flutter/material.dart';
import 'package:gopeduli/dashboard/features/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:gopeduli/dashboard/features/table2/article/article_heading_paginated_table.dart';
import 'package:gopeduli/dashboard/features/table2/article/article_paginated_table.dart';
import 'package:gopeduli/dashboard/helper/size.dart';

class ArticlesMobile extends StatelessWidget {
  const ArticlesMobile({super.key});

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
                  heading: 'Articles', breadcrumbItems: ['Articles']),
              SizedBox(
                height: GoPeduliSize.sizedBoxHeightSmall,
              ),
              Column(
                children: [
                  GoPeduliHeadingPaginatedTableArticle(),
                  SizedBox(
                    height: 10,
                  ),
                  GoPeduliPaginatedTableArticle(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
