import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gopeduli/dashboard/features/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:gopeduli/dashboard/helper/color.dart';
import 'package:gopeduli/dashboard/repository/article_model.dart';
import 'package:gopeduli/dashboard/controllers/article/create_article_controller.dart';
import 'package:gopeduli/dashboard/helper/size.dart';
import 'package:gopeduli/dashboard/helper/validation.dart';
import 'package:gopeduli/dashboard/routes/routes.dart';

class EditArticleDesktop extends StatelessWidget {
  const EditArticleDesktop({super.key, required this.article});

  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateArticleController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(GoPeduliSize.paddingHeightLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const GoPeduliBreadCrumbsWithHeading(
                  returnToPreviousScreen: true,
                  heading: 'Edit Article',
                  breadcrumbItems: [GoPeduliRoutes.articles, 'Edit Article']),
              const SizedBox(
                height: GoPeduliSize.sizedBoxHeightSmall,
              ),
              Container(
                width: 400,
                decoration: BoxDecoration(
                    color: GoPeduliColors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 0,
                          offset: const Offset(1, 1))
                    ],
                    borderRadius:
                        BorderRadius.circular(GoPeduliSize.borderRadiusSmall)),
                padding:
                    const EdgeInsets.all(GoPeduliSize.sizedBoxHeightMedium),
                child: Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            'Edit Article',
                            style: TextStyle(
                                fontSize: GoPeduliSize.fontSizeTitle,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                        ),
                        const SizedBox(
                            height: GoPeduliSize.sizedBoxHeightSmall),
                        TextFormField(
                          controller: controller.title,
                          validator: (value) =>
                              GoPeduliValidator.validateEmptyText(
                                  'Title', value),
                          cursorColor: GoPeduliColors.primary,
                          style: const TextStyle(
                              fontSize: GoPeduliSize.fontSizeBody,
                              color: Colors.black),
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: GoPeduliColors.primary, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: GoPeduliColors.primary, width: 1),
                            ),
                            label: Text(
                              'Title',
                              style: TextStyle(
                                  fontSize: GoPeduliSize.fontSizeBody),
                            ),
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: GoPeduliSize.fontSizeBody),
                          ),
                        ),
                        const SizedBox(
                            height: GoPeduliSize.sizedBoxHeightSmall),
                        TextFormField(
                          maxLines: 10,
                          controller: controller.body,
                          validator: (value) =>
                              GoPeduliValidator.validateEmptyText(
                                  'Body', value),
                          cursorColor: GoPeduliColors.primary,
                          style: const TextStyle(
                              fontSize: GoPeduliSize.fontSizeBody,
                              color: Colors.black),
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: GoPeduliColors.primary, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: GoPeduliColors.primary, width: 1),
                            ),
                            label: Text(
                              'Body',
                              style: TextStyle(
                                  fontSize: GoPeduliSize.fontSizeBody),
                            ),
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: GoPeduliSize.fontSizeBody),
                          ),
                        ),
                        const SizedBox(
                            height: GoPeduliSize.sizedBoxHeightSmall),
                        TextFormField(
                          controller: controller.author,
                          validator: (value) =>
                              GoPeduliValidator.validateEmptyText(
                                  'Author', value),
                          cursorColor: GoPeduliColors.primary,
                          style: const TextStyle(
                              fontSize: GoPeduliSize.fontSizeBody,
                              color: Colors.black),
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: GoPeduliColors.primary, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: GoPeduliColors.primary, width: 1),
                            ),
                            label: Text(
                              'Author',
                              style: TextStyle(
                                  fontSize: GoPeduliSize.fontSizeBody),
                            ),
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: GoPeduliSize.fontSizeBody),
                          ),
                        ),
                        const SizedBox(
                            height: GoPeduliSize.sizedBoxHeightSmall),
                        TextFormField(
                          controller: controller.verifiedBy,
                          validator: (value) =>
                              GoPeduliValidator.validateEmptyText(
                                  'Verified By', value),
                          cursorColor: GoPeduliColors.primary,
                          style: const TextStyle(
                              fontSize: GoPeduliSize.fontSizeBody,
                              color: Colors.black),
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: GoPeduliColors.primary, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: GoPeduliColors.primary, width: 1),
                            ),
                            label: Text(
                              'Verified By',
                              style: TextStyle(
                                  fontSize: GoPeduliSize.fontSizeBody),
                            ),
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: GoPeduliSize.fontSizeBody),
                          ),
                        ),
                        const SizedBox(
                            height: GoPeduliSize.sizedBoxHeightSmall),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () => controller.createArticle(),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: GoPeduliColors.primary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          GoPeduliSize.borderRadiusSmall))),
                              child: const Text('Update',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: GoPeduliSize.fontSizeBody))),
                        )
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
