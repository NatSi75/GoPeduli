import 'package:flutter/material.dart';
import 'package:gopeduli/dashboard/layouts/templates/site_layout.dart';
import 'package:gopeduli/dashboard/screens/articles/allArticle/articles_desktop.dart';
import 'package:gopeduli/dashboard/screens/articles/allArticle/articles_mobile.dart';
import 'package:gopeduli/dashboard/screens/articles/allArticle/articles_tablet.dart';

class ArticlesScreen extends StatelessWidget {
  const ArticlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const GoPeduliSiteTemplate(
        desktop: ArticlesDesktop(),
        tablet: ArticlesTablet(),
        mobile: ArticlesMobile());
  }
}
