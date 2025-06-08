import 'package:flutter/material.dart';
import 'package:gopeduli/dashboard/layouts/templates/site_layout.dart';
import 'package:gopeduli/dashboard/screens/authors/allAuthor/authors_desktop.dart';
import 'package:gopeduli/dashboard/screens/authors/allAuthor/authors_mobile.dart';
import 'package:gopeduli/dashboard/screens/authors/allAuthor/authors_tablet.dart';

class AuthorsScreen extends StatelessWidget {
  const AuthorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const GoPeduliSiteTemplate(
        desktop: AuthorsDesktop(),
        tablet: AuthorsTablet(),
        mobile: AuthorsMobile());
  }
}
