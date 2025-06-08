import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gopeduli/dashboard/layouts/templates/site_layout.dart';
import 'package:gopeduli/dashboard/screens/authors/editAuthor/edit_author_desktop.dart';
import 'package:gopeduli/dashboard/screens/authors/editAuthor/edit_author_mobile.dart';
import 'package:gopeduli/dashboard/screens/authors/editAuthor/edit_author_tablet.dart';

class EditAuthorScreen extends StatelessWidget {
  const EditAuthorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final author = Get.arguments;
    return GoPeduliSiteTemplate(
        desktop: EditAuthorDesktop(
          author: author,
        ),
        tablet: EditAuthorTablet(author: author),
        mobile: EditAuthorMobile(author: author));
  }
}
