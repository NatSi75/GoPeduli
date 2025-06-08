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

class EditMedicineController extends GetxController {
  static EditMedicineController get instance => Get.find();

  RxString imageURL = ''.obs;
  String previousImageUrl = '';
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

  // Init Data
  void init(MedicineModel medicine) {
    nameProduct.text = medicine.nameProduct;
    description.text = medicine.description;
    nameMedicine.text = medicine.nameMedicine;
    classMedicine.text = medicine.classMedicine;
    selectedCategories
        .assignAll(medicine.category.split(',').map((e) => e.trim()));
    price.text = medicine.price;
    stock.text = medicine.stock;
    imageURL.value = medicine.image;
    previousImageUrl = medicine.image;
  }

  void resetFields() {
    nameProduct.clear();
    description.clear();
    nameMedicine.clear();
    selectedCategories.clear();
    classMedicine.clear();
    price.clear();
    stock.clear();
    imageURL.value = '';
    previousImageUrl = '';
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

  // Edit Medicine
  Future<void> editMedicine(MedicineModel medicine) async {
    try {
      if (!formKey.currentState!.validate()) {
        return;
      }

      if (imageDataNotifier.value != null) {
        final data = imageDataNotifier.value!;
        final fileName =
            'medicines/${nameProduct.text.trim()}_edited_image.jpg';
        final ref = FirebaseStorage.instance.ref().child(fileName);

        if (previousImageUrl.isNotEmpty) {
          try {
            final oldRef =
                FirebaseStorage.instance.refFromURL(previousImageUrl);
            await oldRef.delete();
          } catch (e) {
            GoPeduliLoaders.errorSnackBar(
                title: 'Oh Snap', message: e.toString());
          }
        }

        final task = await ref.putData(data);
        final downloadUrl = await task.ref.getDownloadURL();
        imageURL.value = downloadUrl;
      }

      //Map Data
      medicine.image = imageURL.value;
      medicine.nameProduct = nameProduct.text.trim();
      medicine.description = description.text.trim();
      medicine.nameMedicine = nameMedicine.text.trim();
      medicine.category = selectedCategories
          .where((element) => element.trim().isNotEmpty)
          .join(', ');
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
