import 'package:get/get.dart';
import 'package:gopeduli/dashboard/features/authentication/controllers/user_controller.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserController(), fenix: true);
  }
}
