import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gopeduli/dashboard/controllers/author/author_controller.dart';
import 'package:gopeduli/dashboard/features/popup/loaders.dart';
import 'package:gopeduli/dashboard/repository/author_model.dart';
import 'package:gopeduli/dashboard/repository/author_repository.dart';
import 'package:gopeduli/dashboard/routes/routes.dart';

class CreateAuthorController extends GetxController {
  static CreateAuthorController get instance => Get.find();

  final name = TextEditingController();
  final email = TextEditingController();
  final phoneNumber = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void resetFields() {
    name.clear();
    email.clear();
    phoneNumber.clear();
  }

  Future<void> createAuthor() async {
    try {
      if (!formKey.currentState!.validate()) {
        return;
      }

      final newAuthor = AuthorModel(
          id: '',
          name: name.text.trim(),
          email: email.text.trim(),
          phoneNumber: phoneNumber.text.trim(),
          createdAt: DateTime.now());

      newAuthor.id = await AuthorRepository.instance.createAuthor(newAuthor);

      AuthorController.instance.addAuthorFromLists(newAuthor);

      //Reset Form
      resetFields();

      GoPeduliLoaders.successSnackBar(
          title: 'Congratulations', message: 'New Author has been added.');

      Future.delayed(const Duration(milliseconds: 2000), () {
        Get.offNamed(GoPeduliRoutes.authors);
      });
    } catch (e) {
      GoPeduliLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}
