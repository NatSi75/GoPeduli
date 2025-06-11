import 'package:get/get.dart';
import 'package:gopeduli/dashboard/controllers/article/article_controller.dart';
import 'package:gopeduli/dashboard/controllers/author/author_controller.dart';
import 'package:gopeduli/dashboard/controllers/doctor/doctor_controller.dart';
import 'package:gopeduli/dashboard/controllers/medicine/medicine_controller.dart';
import 'package:gopeduli/dashboard/controllers/order/order_controller.dart';
import 'package:gopeduli/dashboard/features/authentication/controllers/user_controller.dart';
import 'package:gopeduli/dashboard/repository/category_repository.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OrderController(), fenix: true);
    Get.lazyPut(() => CategoryRepository(), fenix: true);
    Get.lazyPut(() => DoctorController(), fenix: true);
    Get.lazyPut(() => MedicineController(), fenix: true);
    Get.lazyPut(() => AuthorController(), fenix: true);
    Get.lazyPut(() => UserController(), fenix: true);
    Get.lazyPut(() => ArticleController(), fenix: true);
  }
}
