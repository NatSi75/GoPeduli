import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:gopeduli/dashboard/features/authentication/user_repository.dart';
import 'package:gopeduli/dashboard/features/popup/loaders.dart';
import 'package:gopeduli/dashboard/helper/color.dart';
import 'package:gopeduli/dashboard/helper/size.dart';
import 'package:gopeduli/dashboard/repository/user_model.dart';
import 'package:material_symbols_icons/symbols.dart';

class DoctorController extends GetxController {
  static DoctorController get instance => Get.find();

  final userRepository = Get.put(UserRepository());

  RxList<UserModel> allDoctors = <UserModel>[].obs;
  RxList<UserModel> filteredDoctors = <UserModel>[].obs;
  RxList<bool> selectedRows =
      <bool>[].obs; //Observable list to store selected rows
  RxInt sortColumnIndex =
      3.obs; //Observable for tracking the index of the column for string
  RxBool sortAscending = true
      .obs; // Observable for tracking the sorting order (ascending or descending)
  final searchTextController =
      TextEditingController(); // Controller for handling search text input

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  Future<void> fetchData() async {
    try {
      List<UserModel> fetchedDoctors = [];
      if (allDoctors.isEmpty) {
        fetchedDoctors = await userRepository.getAllDoctors();
      }
      allDoctors.assignAll(fetchedDoctors);
      filteredDoctors.assignAll(allDoctors);
      selectedRows.assignAll(List.generate(allDoctors.length, (_) => false));
    } catch (e) {
      GoPeduliLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  void sortByName(int columnIndex, bool ascending) {
    sortColumnIndex.value = columnIndex;
    sortAscending.value = ascending;

    filteredDoctors.sort((a, b) {
      if (ascending) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      } else {
        return b.name.toLowerCase().compareTo(a.name.toLowerCase());
      }
    });
  }

  void sortByEmail(int columnIndex, bool ascending) {
    sortColumnIndex.value = columnIndex;
    sortAscending.value = ascending;

    filteredDoctors.sort((a, b) {
      if (ascending) {
        return a.email.toLowerCase().compareTo(b.email.toLowerCase());
      } else {
        return b.email.toLowerCase().compareTo(a.email.toLowerCase());
      }
    });
  }

  void sortByCreateDate(int columnIndex, bool ascending) {
    sortColumnIndex.value = columnIndex;
    sortAscending.value = ascending;

    filteredDoctors.sort((a, b) {
      final aCreatedAt = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bCreatedAt = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      if (ascending) {
        return aCreatedAt.compareTo(bCreatedAt);
      } else {
        return bCreatedAt.compareTo(aCreatedAt);
      }
    });
  }

  searchQuery(String query) {
    filteredDoctors.assignAll(allDoctors.where(
        (user) => user.name.toLowerCase().contains(query.toLowerCase())));
  }

  confirmAndDeleteDoctor(UserModel doctor) {
    // Show a confirmation
    Get.defaultDialog(
        title: 'Delete Doctor',
        titleStyle: const TextStyle(color: GoPeduliColors.white),
        content: const Text('Are you sure you would to delete this doctor?',
            style: TextStyle(color: GoPeduliColors.white)),
        backgroundColor: GoPeduliColors.primary,
        confirm: SizedBox(
          width: 60,
          child: ElevatedButton(
              onPressed: () async => await deleteOnConfirm(doctor),
              style: OutlinedButton.styleFrom(
                  backgroundColor: GoPeduliColors.quaternary,
                  padding: const EdgeInsets.symmetric(
                      vertical: GoPeduliSize.paddingHeightSmall),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          GoPeduliSize.borderRadiusSmall))),
              child: const Text('Yes',
                  style: TextStyle(color: GoPeduliColors.white))),
        ),
        cancel: SizedBox(
          width: 80,
          child: ElevatedButton(
              onPressed: () => Get.back(),
              style: OutlinedButton.styleFrom(
                  backgroundColor: GoPeduliColors.quaternary,
                  padding: const EdgeInsets.symmetric(
                      vertical: GoPeduliSize.paddingHeightSmall),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          GoPeduliSize.borderRadiusSmall))),
              child: const Text('Cancel',
                  style: TextStyle(color: GoPeduliColors.white))),
        ));
  }

  deleteOnConfirm(UserModel doctor) async {
    try {
      Get.back();

      // Delete Firestore Data
      await userRepository.deleteUser(doctor.id!);

      GoPeduliLoaders.successSnackBar(
          title: 'Doctor Deleted', message: 'Doctor has been deleted.');
      removeDoctorFromLists(doctor);
    } catch (e) {
      GoPeduliLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  void removeDoctorFromLists(UserModel doctor) {
    allDoctors.remove(doctor);
    filteredDoctors.remove(doctor);
    selectedRows.assignAll(List.generate(allDoctors.length, (index) => false));
  }

  void addDoctorFromLists(UserModel doctor) {
    allDoctors.add(doctor);
    filteredDoctors.add(doctor);
    selectedRows.assignAll(List.generate(allDoctors.length, (index) => false));
    filteredDoctors.refresh();
  }

  void updateDoctorFromLists(UserModel doctor) {
    final doctorIndex = allDoctors.indexWhere((i) => i == doctor);
    final filteredDoctorIndex = filteredDoctors.indexWhere((i) => i == doctor);

    if (doctorIndex != -1) allDoctors[doctorIndex] = doctor;
    if (filteredDoctorIndex != -1) filteredDoctors[doctorIndex] = doctor;

    filteredDoctors.refresh();
  }
}

class MyDataDoctor extends DataTableSource {
  final controller = DoctorController.instance;

  @override
  DataRow? getRow(int index) {
    final doctor = controller.filteredDoctors[index];

    return DataRow2(cells: [
      DataCell(
        Text(doctor.name),
      ),
      DataCell(
        Text(doctor.email),
      ),
      DataCell(Text(doctor.createdAt == null ? '' : doctor.formattedDate)),
      DataCell(Row(
        children: [
          IconButton(
              onPressed: () => controller.confirmAndDeleteDoctor(doctor),
              icon: const Icon(Symbols.delete, color: Colors.red)),
        ],
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.filteredDoctors.length;

  @override
  int get selectedRowCount => 0;
}
