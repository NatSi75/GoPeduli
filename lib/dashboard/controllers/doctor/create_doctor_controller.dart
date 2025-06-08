import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:gopeduli/dashboard/controllers/doctor/doctor_controller.dart';
import 'package:gopeduli/dashboard/features/authentication/authentication_repository.dart';
import 'package:gopeduli/dashboard/features/authentication/user_repository.dart';
import 'package:gopeduli/dashboard/features/popup/loaders.dart';
import 'package:gopeduli/dashboard/helper/enums.dart';
import 'package:gopeduli/dashboard/repository/user_model.dart';
import 'package:gopeduli/dashboard/routes/routes.dart';

class CreateDoctorController extends GetxController {
  static CreateDoctorController get instance => Get.find();

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

  // Handles registration of doctor
  Future<void> registerDoctor() async {
    try {
      if (!formKey.currentState!.validate()) {
        return;
      }

      // Register user using Email an Password Authentication
      await AuthenticationRepository.instance.registerWithEmailAndPassword(
          email.text.trim(), password.text.trim());

      final newDoctor = UserModel(
        id: AuthenticationRepository.instance.authUser!.uid,
        name: name.text.trim(),
        email: email.text.trim(),
        role: AppRole.doctor,
        createdAt: DateTime.now(),
      );

      // Create doctor record in the Firestore
      await UserRepository.instance.createUser(newDoctor);

      DoctorController.instance.addDoctorFromLists(newDoctor);

      //Reset Form
      resetFields();

      GoPeduliLoaders.successSnackBar(
          title: 'Congratulations', message: 'New Doctor has been added.');

      Future.delayed(const Duration(milliseconds: 2000), () {
        Get.offNamed(GoPeduliRoutes.doctors);
      });
    } catch (e) {
      GoPeduliLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}
