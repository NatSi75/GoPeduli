import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gopeduli/dashboard/controllers/article/article_controller.dart';
import 'package:gopeduli/dashboard/features/popup/loaders.dart';
import 'package:gopeduli/dashboard/repository/article_model.dart';
import 'package:gopeduli/dashboard/repository/article_repository.dart';
import 'package:gopeduli/dashboard/repository/author_model.dart';
import 'package:gopeduli/dashboard/repository/user_model.dart';
import 'package:gopeduli/dashboard/routes/routes.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

final imageDataNotifier = ValueNotifier<Uint8List?>(null);
final imageUrlNotifier = ValueNotifier<String?>(null);

class EditArticleController extends GetxController {
  static EditArticleController get instance => Get.find();

  List<AuthorModel> authors = <AuthorModel>[].obs;
  List<UserModel> doctors = <UserModel>[].obs;
  RxString imageURL = ''.obs;
  String previousImageUrl = '';
  final title = TextEditingController();
  final body = TextEditingController();
  RxnString author = RxnString();
  RxnString verifiedBy = RxnString();
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    fetchAuthors();
    fetchDoctors();
    super.onInit();
  }

  void fetchAuthors() async {
    try {
      final result = await ArticleRepository.instance.getAllAuthors();
      authors.assignAll(result);
    } catch (e) {
      GoPeduliLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  void fetchDoctors() async {
    try {
      final result = await ArticleRepository.instance.getAllDoctors();
      doctors.assignAll(result);
    } catch (e) {
      GoPeduliLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  // Init Data
  void init(ArticleModel article) {
    title.text = article.title;
    body.text = article.body;
    author.value = article.author;
    verifiedBy.value = article.verifiedBy;
    imageURL.value = article.image;
    previousImageUrl = article.image;
  }

  void resetFields() {
    title.clear();
    body.clear();
    author.value = null;
    verifiedBy.value = null;
    imageURL.value = '';
    previousImageUrl = '';
    imageDataNotifier.value = null;
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final Uint8List data = await image.readAsBytes();

      imageDataNotifier.value = data;

      GoPeduliLoaders.successSnackBar(
          title: 'Congratulations', message: 'Image has been selected.');
    }
  }

  // Edit Article
  Future<void> editArticle(ArticleModel article) async {
    try {
      if (!formKey.currentState!.validate()) {
        return;
      }

      if (imageDataNotifier.value != null) {
        final data = imageDataNotifier.value!;
        final fileName = 'articles/${title.text.trim()}_edited_image.jpg';
        final ref = FirebaseStorage.instance.ref().child(fileName);

        if (previousImageUrl.isNotEmpty) {
          try {
            final oldRef =
                FirebaseStorage.instance.refFromURL(previousImageUrl);
            await oldRef.delete();
          } catch (e) {
            GoPeduliLoaders.errorSnackBar(
                title: 'Oh Snap', message: e.toString());
          }
        }

        final task = await ref.putData(data);
        final downloadUrl = await task.ref.getDownloadURL();
        imageURL.value = downloadUrl;
      }

      //Map Data
      article.title = title.text.trim();
      article.body = body.text.trim();
      article.author = author.value ?? '';
      article.verifiedBy = verifiedBy.value ?? '';
      article.image = imageURL.value;
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
