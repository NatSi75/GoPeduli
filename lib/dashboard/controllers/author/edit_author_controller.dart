import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gopeduli/dashboard/controllers/author/author_controller.dart';
import 'package:gopeduli/dashboard/features/popup/loaders.dart';
import 'package:gopeduli/dashboard/repository/author_model.dart';
import 'package:gopeduli/dashboard/repository/author_repository.dart';
import 'package:gopeduli/dashboard/routes/routes.dart';

class EditAuthorController extends GetxController {
  static EditAuthorController get instance => Get.find();

  final name = TextEditingController();
  final email = TextEditingController();
  final phoneNumber = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Init Data
  void init(AuthorModel author) {
    name.text = author.name;
    email.text = author.email;
    phoneNumber.text = author.phoneNumber;
  }

  void resetFields() {
    name.clear();
    email.clear();
    phoneNumber.clear();
  }

  // Edit Author
  Future<void> editAuthor(AuthorModel author) async {
    try {
      if (!formKey.currentState!.validate()) {
        return;
      }

      //Map Data
      author.name = name.text.trim();
      author.email = email.text.trim();
      author.phoneNumber = phoneNumber.text.trim();
      author.createdAt = DateTime.now();

      // Call Repository
      await AuthorRepository.instance.updateAuthor(author);

      // Update All Data List
      AuthorController.instance.updateAuthorFromLists(author);

      //Reset Form
      resetFields();

      GoPeduliLoaders.successSnackBar(
          title: 'Congratulations', message: 'Author has been edited.');

      Future.delayed(const Duration(milliseconds: 2000), () {
        Get.offNamed(GoPeduliRoutes.authors);
      });
    } catch (e) {
      GoPeduliLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}
