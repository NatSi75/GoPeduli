import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:gopeduli/dashboard/controllers/doctor/doctor_controller.dart';
import 'package:gopeduli/dashboard/features/authentication/authentication_repository.dart';
import 'package:gopeduli/dashboard/features/authentication/user_repository.dart';
import 'package:gopeduli/dashboard/features/popup/loaders.dart';
import 'package:gopeduli/dashboard/helper/enums.dart';
import 'package:gopeduli/dashboard/repository/user_model.dart';
import 'package:gopeduli/dashboard/routes/routes.dart';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

final imageDataNotifier = ValueNotifier<Uint8List?>(null);
final imageUrlNotifier = ValueNotifier<String?>(null);

class CreateDoctorController extends GetxController {
  static CreateDoctorController get instance => Get.find();

  RxString imageURL = ''.obs;
  final hidePassword = true.obs;
  final name = TextEditingController();
  final hospital = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final RxList<String> selectedAvailableDays = <String>[].obs;
  final List<String> daysOfWeek = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu'
  ];

  void resetFields() {
    imageURL.value = '';
    name.clear();
    selectedAvailableDays.clear();
    hospital.clear();
    email.clear();
    password.clear();
    imageDataNotifier.value = null;
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

  // Handles registration of doctor
  Future<void> registerDoctor() async {
    try {
      if (!formKey.currentState!.validate()) {
        return;
      }

      if (selectedAvailableDays.isEmpty) {
        GoPeduliLoaders.errorSnackBar(
            title: 'Oh Snap',
            message: 'Please select at least one available day.');
        return;
      }

      if (imageDataNotifier.value != null) {
        final data = imageDataNotifier.value!;
        final ref = FirebaseStorage.instance
            .ref()
            .child('doctors/${name.text.trim()}_doctor_image.jpg');

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

      // Register user using Email an Password Authentication
      await AuthenticationRepository.instance.registerWithEmailAndPassword(
          email.text.trim(), password.text.trim());

      final newDoctor = UserModel(
        id: AuthenticationRepository.instance.authUser!.uid,
        profilePicture: imageURL.value,
        name: name.text.trim(),
        hospital: hospital.text.trim(),
        schedule: selectedAvailableDays
            .where((element) => element.trim().isNotEmpty)
            .join(', '),
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
