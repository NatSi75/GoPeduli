import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gopeduli/dashboard/controllers/medicine/medicine_controller.dart';
import 'package:gopeduli/dashboard/features/popup/loaders.dart';
import 'package:gopeduli/dashboard/repository/medicine_model.dart';
import 'package:gopeduli/dashboard/repository/medicine_repository.dart';
import 'package:gopeduli/dashboard/routes/routes.dart';

class EditMedicineController extends GetxController {
  static EditMedicineController get instance => Get.find();

  final nameProduct = TextEditingController();
  final nameMedicine = TextEditingController();
  final category = TextEditingController();
  final classMedicine = TextEditingController();
  final price = TextEditingController();
  final stock = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Init Data
  void init(MedicineModel medicine) {
    nameProduct.text = medicine.nameProduct;
    nameMedicine.text = medicine.nameMedicine;
    category.text = medicine.category;
    classMedicine.text = medicine.classMedicine;
    price.text = medicine.price;
    stock.text = medicine.stock;
  }

  void resetFields() {
    nameProduct.clear();
    nameMedicine.clear();
    category.clear();
    classMedicine.clear();
    price.clear();
    stock.clear();
  }

  // Edit Medicine
  Future<void> editMedicine(MedicineModel medicine) async {
    try {
      if (!formKey.currentState!.validate()) {
        return;
      }

      //Map Data
      medicine.nameProduct = nameProduct.text.trim();
      medicine.nameMedicine = nameMedicine.text.trim();
      medicine.category = category.text.trim();
      medicine.classMedicine = classMedicine.text.trim();
      medicine.price = price.text.trim();
      medicine.stock = stock.text.trim();
      medicine.createdAt = DateTime.now();

      // Call Repository
      await MedicineRepository.instance.updateMedicine(medicine);

      // Update All Data List
      MedicineController.instance.updateMedicineFromLists(medicine);

      //Reset Form
      resetFields();

      GoPeduliLoaders.successSnackBar(
          title: 'Congratulations', message: 'Medicine has been edited.');

      Future.delayed(const Duration(milliseconds: 2000), () {
        Get.offNamed(GoPeduliRoutes.medicines);
      });
    } catch (e) {
      GoPeduliLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}
