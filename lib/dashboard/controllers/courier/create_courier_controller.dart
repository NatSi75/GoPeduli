import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:gopeduli/dashboard/controllers/courier/courier_controller.dart';
import 'package:gopeduli/dashboard/features/authentication/authentication_repository.dart';
import 'package:gopeduli/dashboard/features/authentication/user_repository.dart';
import 'package:gopeduli/dashboard/features/popup/loaders.dart';
import 'package:gopeduli/dashboard/helper/enums.dart';
import 'package:gopeduli/dashboard/repository/user_model.dart';
import 'package:gopeduli/dashboard/routes/routes.dart';

class CreateCourierController extends GetxController {
  static CreateCourierController get instance => Get.find();

  final hidePassword = true.obs;
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void resetFields() {
    name.clear();
    email.clear();
    password.clear();
  }

  // Handles registration of courier
  Future<void> registerCourier() async {
    try {
      if (!formKey.currentState!.validate()) {
        return;
      }

      // Register user using Email an Password Authentication
      await AuthenticationRepository.instance.registerWithEmailAndPassword(
          email.text.trim(), password.text.trim());

      final newCourier = UserModel(
        id: AuthenticationRepository.instance.authUser!.uid,
        profilePicture: '',
        hospital: '',
        name: name.text.trim(),
        email: email.text.trim(),
        role: AppRole.courier,
        createdAt: DateTime.now(),
      );

      // Create courier record in the Firestore
      await UserRepository.instance.createUser(newCourier);

      CourierController.instance.addCourierFromLists(newCourier);

      //Reset Form
      resetFields();

      GoPeduliLoaders.successSnackBar(
          title: 'Congratulations', message: 'New Courier has been added.');

      Future.delayed(const Duration(milliseconds: 2000), () {
        Get.offNamed(GoPeduliRoutes.couriers);
      });
    } catch (e) {
      GoPeduliLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}
