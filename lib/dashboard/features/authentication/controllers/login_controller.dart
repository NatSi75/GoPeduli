import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gopeduli/dashboard/features/authentication/authentication_repository.dart';
import 'package:gopeduli/dashboard/features/authentication/controllers/user_controller.dart';
import 'package:gopeduli/dashboard/features/authentication/user_repository.dart';
import 'package:gopeduli/dashboard/features/popup/full_screen_loader.dart';
import 'package:gopeduli/dashboard/features/popup/loaders.dart';
import 'package:gopeduli/dashboard/helper/enums.dart';
import 'package:gopeduli/dashboard/repository/user_model.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final hidePassword = true.obs;
  final rememberMe = false.obs;
  final localStorage = GetStorage();

  final email = TextEditingController();
  final password = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    email.text = localStorage.read('REMEMBER_ME_EMAIL') ?? '';
    password.text = localStorage.read('REMEMBER_ME_PASSWORD') ?? '';
    super.onInit();
  }

  // Handles email and password sign-in process
  Future<void> emailAndPasswordSignIn() async {
    try {
      // Form Validation
      if (!loginFormKey.currentState!.validate()) {
        return;
      }

      // Save Date if Remember Me is selected
      if (rememberMe.value) {
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      }

      // Login user using email & password authentication
      await AuthenticationRepository.instance
          .loginWithEmailAndPassword(email.text.trim(), password.text.trim());

      // Fetch user details and assign to UserController
      final user = await UserController.instance.fetchUserDetails();

      if (user.role != AppRole.admin) {
        await AuthenticationRepository.instance.logout();
        GoPeduliLoaders.errorSnackBar(
            title: 'Not Authorized',
            message:
                'You are not authorized or do have access. Contact Admin! ${user.email}');
      } else {
        AuthenticationRepository.instance.screenRedirect();
      }
    } catch (e) {
      GoPeduliLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  // Handles registration of admin user
  Future<void> registerAdmin() async {
    try {
      // Start loading
      GoPeduliFullScreenLoader.openLoadingDialog(
          'Registering Admin Account', 'Please wait...');

      // Register user using Email an Password Authentication
      await AuthenticationRepository.instance
          .registerWithEmailAndPassword('admin@gmail.com', 'admin123');

      // Create admin record in the Firestore
      final userRepository = Get.put(UserRepository());
      await userRepository.createUser(
        UserModel(
          id: AuthenticationRepository.instance.authUser!.uid,
          firstName: 'GoPeduli',
          lastName: 'Admin',
          email: 'admin@gmail.com',
          role: AppRole.admin,
          createdAt: DateTime.now(),
        ),
      );
      // Redirect
      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      GoPeduliLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}
