import 'package:flutter/material.dart';
import 'package:gopeduli/dashboard/layouts/templates/site_layout.dart';
import 'package:gopeduli/dashboard/screens/authors/createAuthor/create_author_desktop.dart';
import 'package:gopeduli/dashboard/screens/authors/createAuthor/create_author_mobile.dart';
import 'package:gopeduli/dashboard/screens/authors/createAuthor/create_author_tablet.dart';

class CreateAuthorScreen extends StatelessWidget {
  const CreateAuthorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const GoPeduliSiteTemplate(
        desktop: CreateAuthorDesktop(),
        tablet: CreateAuthorTablet(),
        mobile: CreateAuthorMobile());
  }
}
