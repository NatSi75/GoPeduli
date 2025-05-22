import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gopeduli/dashboard/controllers/article/article_controller.dart';
import 'package:gopeduli/dashboard/features/popup/loaders.dart';
import 'package:gopeduli/dashboard/repository/article_model.dart';
import 'package:gopeduli/dashboard/repository/article_repository.dart';
import 'package:gopeduli/dashboard/routes/routes.dart';

class CreateArticleController extends GetxController {
  static CreateArticleController get instance => Get.find();

  RxString imageURL = ''.obs;
  final title = TextEditingController();
  final body = TextEditingController();
  final author = TextEditingController();
  final verifiedBy = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void resetFields() {
    title.clear();
    body.clear();
    author.clear();
    verifiedBy.clear();
    imageURL.value = '';
  }

  Future<void> createArticle() async {
    try {
      if (!formKey.currentState!.validate()) {
        return;
      }

      final newArticle = ArticleModel(
          id: '',
          image: imageURL.value,
          title: title.text.trim(),
          body: body.text.trim(),
          author: author.text.trim(),
          verifiedBy: verifiedBy.text.trim(),
          createdAt: DateTime.now());

      newArticle.id =
          await ArticleRepository.instance.createArticle(newArticle);

      ArticleController.instance.addArticleFromLists(newArticle);

      //Reset Form
      resetFields();

      GoPeduliLoaders.successSnackBar(
          title: 'Congratulations', message: 'New Article has been added.');

      Future.delayed(const Duration(milliseconds: 2000), () {
        Get.offNamed(
            GoPeduliRoutes.articles); // Ganti '/article' sesuai route kamu
      });
    } catch (e) {
      GoPeduliLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}
