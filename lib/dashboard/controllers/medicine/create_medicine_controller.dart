import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gopeduli/dashboard/controllers/medicine/medicine_controller.dart';
import 'package:gopeduli/dashboard/features/popup/loaders.dart';
import 'package:gopeduli/dashboard/repository/category_model.dart';
import 'package:gopeduli/dashboard/repository/category_repository.dart';
import 'package:gopeduli/dashboard/repository/medicine_model.dart';
import 'package:gopeduli/dashboard/repository/medicine_repository.dart';
import 'package:gopeduli/dashboard/routes/routes.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

final imageDataNotifier = ValueNotifier<Uint8List?>(null);
final imageUrlNotifier = ValueNotifier<String?>(null);

class CreateMedicineController extends GetxController {
  static CreateMedicineController get instance => Get.find();

  RxString imageURL = ''.obs;
  List<CategoryModel> categorys = <CategoryModel>[].obs;
  final RxList<String> selectedCategories = <String>[].obs;
  final nameProduct = TextEditingController();
  final description = TextEditingController();
  final nameMedicine = TextEditingController();
  final category = TextEditingController();
  final classMedicine = TextEditingController();
  final price = TextEditingController();
  final stock = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void resetFields() {
    imageURL.value = '';
    nameProduct.clear();
    description.clear();
    nameMedicine.clear();
    selectedCategories.clear();
    classMedicine.clear();
    price.clear();
    stock.clear();
    imageDataNotifier.value = null;
  }

  @override
  void onInit() {
    fetchCategory();
    super.onInit();
  }

  void fetchCategory() async {
    try {
      final result = await CategoryRepository.instance.getAllCategory();
      categorys.assignAll(result);
    } catch (e) {
      GoPeduliLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  Future<void> createCategory() async {
    try {
      final newCategory = CategoryModel(
          id: '',
          nameCategory: category.text.trim(),
          createdAt: DateTime.now());

      newCategory.id =
          await CategoryRepository.instance.createCategory(newCategory);

      category.clear();

      fetchCategory();
    } catch (e) {
      GoPeduliLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  deleteCategory(CategoryModel category) async {
    try {
      // Delete Firestore Data
      await CategoryRepository.instance.deleteCategory(category.id);
      fetchCategory();
    } catch (e) {
      GoPeduliLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final Uint8List data = await image.readAsBytes();

      imageDataNotifier.value = data;

      GoPeduliLoaders.successSnackBar(
          title: 'Congratulations', message: 'Image has been selected.');
    }
  }

  Future<void> createMedicine() async {
    try {
      if (!formKey.currentState!.validate()) {
        return;
      }

      if (imageDataNotifier.value != null) {
        final data = imageDataNotifier.value!;
        final ref = FirebaseStorage.instance
            .ref()
            .child('medicines/${nameProduct.text.trim()}_medicine_image.jpg');

        try {
          final task = await ref.putData(data);
          final url = await task.ref.getDownloadURL();
          imageURL.value = url;
        } catch (e) {
          GoPeduliLoaders.errorSnackBar(
              title: 'Oh Snap', message: e.toString());
        }
      } else {
        GoPeduliLoaders.errorSnackBar(
          title: 'Oh Snap',
          message: 'Image is required.',
        );
        return;
      }

      final newMedicine = MedicineModel(
          id: '',
          image: imageURL.value,
          nameProduct: nameProduct.text.trim(),
          description: description.text.trim(),
          nameMedicine: nameMedicine.text.trim(),
          category: selectedCategories.join(', '),
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
        Get.offNamed(GoPeduliRoutes.medicines);
      });
    } catch (e) {
      GoPeduliLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}
