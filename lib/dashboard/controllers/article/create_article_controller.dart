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

class CreateArticleController extends GetxController {
  static CreateArticleController get instance => Get.find();

  List<AuthorModel> authors = <AuthorModel>[].obs;
  List<UserModel> doctors = <UserModel>[].obs;
  RxString imageURL = ''.obs;
  final title = TextEditingController();
  final body = TextEditingController();
  RxnString author = RxnString();
  RxnString verifiedBy = RxnString();
  final formKey = GlobalKey<FormState>();

  void resetFields() {
    title.clear();
    body.clear();
    author.value = null;
    verifiedBy.value = null;
    imageURL.value = '';
    imageDataNotifier.value = null;
  }

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

  Future<void> createArticle() async {
    try {
      if (!formKey.currentState!.validate()) {
        return;
      }

      if (imageDataNotifier.value != null) {
        final data = imageDataNotifier.value!;
        final ref = FirebaseStorage.instance
            .ref()
            .child('articles/${title.text.trim()}_article_image.jpg');

        try {
          final task = await ref.putData(data);
          final url = await task.ref.getDownloadURL();
          imageURL.value = url;
        } catch (e) {
          GoPeduliLoaders.errorSnackBar(
              title: 'Oh Snap', message: e.toString());
        }
      } else {
        GoPeduliLoaders.errorSnackBar(
          title: 'Oh Snap',
          message: 'Image is required.',
        );
        return;
      }

      final newArticle = ArticleModel(
          id: '',
          image: imageURL.value,
          title: title.text.trim(),
          body: body.text.trim(),
          author: author.value ?? '',
          verifiedBy: verifiedBy.value ?? '',
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
