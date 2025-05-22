import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gopeduli/dashboard/controllers/article/article_controller.dart';
import 'package:gopeduli/dashboard/features/popup/loaders.dart';
import 'package:gopeduli/dashboard/repository/article_model.dart';
import 'package:gopeduli/dashboard/repository/article_repository.dart';
import 'package:gopeduli/dashboard/routes/routes.dart';

class EditArticleController extends GetxController {
  static EditArticleController get instance => Get.find();

  RxString imageURL = ''.obs;
  final title = TextEditingController();
  final body = TextEditingController();
  final author = TextEditingController();
  final verifiedBy = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Init Data
  void init(ArticleModel article) {
    title.text = article.title;
    body.text = article.body;
    author.text = article.author;
    verifiedBy.text = article.verifiedBy;
  }

  void resetFields() {
    title.clear();
    body.clear();
    author.clear();
    verifiedBy.clear();
    imageURL.value = '';
  }

  // Edit Article
  Future<void> editArticle(ArticleModel article) async {
    try {
      if (!formKey.currentState!.validate()) {
        return;
      }

      //Map Data
      article.title = title.text.trim();
      article.body = body.text.trim();
      article.author = author.text.trim();
      article.verifiedBy = verifiedBy.text.trim();
      article.createdAt = DateTime.now();

      // Call Repository
      await ArticleRepository.instance.updateArticle(article);

      // Update All Data List
      ArticleController.instance.updateArticleFromLists(article);

      //Reset Form
      resetFields();

      GoPeduliLoaders.successSnackBar(
          title: 'Congratulations', message: 'Article has been edited.');

      Future.delayed(const Duration(milliseconds: 2000), () {
        Get.offNamed(GoPeduliRoutes.articles);
      });
    } catch (e) {
      GoPeduliLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}
