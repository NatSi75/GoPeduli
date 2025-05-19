import 'package:flutter/material.dart';
import 'package:gopeduli/dashboard/layouts/templates/site_layout.dart';
import 'package:gopeduli/dashboard/screens/articles/createArticle/create_article_desktop.dart';
import 'package:gopeduli/dashboard/screens/articles/createArticle/create_article_mobile.dart';
import 'package:gopeduli/dashboard/screens/articles/createArticle/create_article_tablet.dart';

class CreateArticleScreen extends StatelessWidget {
  const CreateArticleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const GoPeduliSiteTemplate(
        desktop: CreateArticleDesktop(),
        tablet: CreateArticleTablet(),
        mobile: CreateArticleMobile());
  }
}
