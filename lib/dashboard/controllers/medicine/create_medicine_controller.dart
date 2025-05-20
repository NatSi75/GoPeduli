import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gopeduli/dashboard/features/popup/loaders.dart';
import 'package:gopeduli/dashboard/repository/medicine_model.dart';
import 'package:gopeduli/dashboard/repository/medicine_repository.dart';

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
          await MedicineRepository.instance.createArticle(newMedicine);
      GoPeduliLoaders.successSnackBar(
          title: 'Congratulations', message: 'New Medicine has been added.');
    } catch (e) {
      GoPeduliLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}
