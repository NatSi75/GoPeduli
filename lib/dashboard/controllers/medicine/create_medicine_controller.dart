import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gopeduli/dashboard/controllers/medicine/medicine_controller.dart';
import 'package:gopeduli/dashboard/features/popup/loaders.dart';
import 'package:gopeduli/dashboard/repository/medicine_model.dart';
import 'package:gopeduli/dashboard/repository/medicine_repository.dart';
import 'package:gopeduli/dashboard/routes/routes.dart';

class CreateMedicineController extends GetxController {
  static CreateMedicineController get instance => Get.find();

  final nameProduct = TextEditingController();
  final nameMedicine = TextEditingController();
  final category = TextEditingController();
  final classMedicine = TextEditingController();
  final price = TextEditingController();
  final stock = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void resetFields() {
    nameProduct.clear();
    nameMedicine.clear();
    category.clear();
    classMedicine.clear();
    price.clear();
    stock.clear();
  }

  Future<void> createMedicine() async {
    try {
      if (!formKey.currentState!.validate()) {
        return;
      }

      final newMedicine = MedicineModel(
          id: '',
          nameProduct: nameProduct.text.trim(),
          nameMedicine: nameMedicine.text.trim(),
          category: category.text.trim(),
          classMedicine: classMedicine.text.trim(),
          price: price.text.trim(),
          stock: stock.text.trim(),
          createdAt: DateTime.now());

      newMedicine.id =
          await MedicineRepository.instance.createMedicine(newMedicine);

      MedicineController.instance.addMedicineFromLists(newMedicine);

      //Reset Form
      resetFields();

      GoPeduliLoaders.successSnackBar(
          title: 'Congratulations', message: 'New Medicine has been added.');
      Future.delayed(const Duration(milliseconds: 2000), () {
        Get.offNamed(
            GoPeduliRoutes.medicines); // Ganti '/article' sesuai route kamu
      });
    } catch (e) {
      GoPeduliLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}
