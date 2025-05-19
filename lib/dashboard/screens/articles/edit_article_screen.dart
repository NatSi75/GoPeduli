import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gopeduli/dashboard/layouts/templates/site_layout.dart';
import 'package:gopeduli/dashboard/repository/article_model.dart';
import 'package:gopeduli/dashboard/screens/articles/editArticle/edit_article_desktop.dart';
import 'package:gopeduli/dashboard/screens/articles/editArticle/edit_article_mobile.dart';
import 'package:gopeduli/dashboard/screens/articles/editArticle/edit_article_tablet.dart';

class EditArticleScreen extends StatelessWidget {
  const EditArticleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final article =
        ArticleModel(id: '', image: '', title: '', body: '', author: '');
    return GoPeduliSiteTemplate(
        desktop: EditArticleDesktop(
          article: article,
        ),
        tablet: EditArticleTablet(article: article),
        mobile: EditArticleMobile(article: article));
  }
}
