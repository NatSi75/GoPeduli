import 'package:flutter/material.dart';
import 'package:gopeduli/dashboard/repository/article_model.dart';

class EditArticleMobile extends StatelessWidget {
  const EditArticleMobile({super.key, required this.article});

  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [],
          ),
        ),
      ),
    );
  }
}
