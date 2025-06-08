import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:gopeduli/dashboard/features/authentication/user_repository.dart';
import 'package:gopeduli/dashboard/features/popup/loaders.dart';
import 'package:gopeduli/dashboard/helper/color.dart';
import 'package:gopeduli/dashboard/helper/size.dart';
import 'package:gopeduli/dashboard/repository/user_model.dart';
import 'package:material_symbols_icons/symbols.dart';

class CourierController extends GetxController {
  static CourierController get instance => Get.find();

  final userRepository = Get.put(UserRepository());

  RxList<UserModel> allCouriers = <UserModel>[].obs;
  RxList<UserModel> filteredCouriers = <UserModel>[].obs;
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
      List<UserModel> fetchedCouriers = [];
      if (allCouriers.isEmpty) {
        fetchedCouriers = await userRepository.getAllCouriers();
      }
      allCouriers.assignAll(fetchedCouriers);
      filteredCouriers.assignAll(allCouriers);
      selectedRows.assignAll(List.generate(allCouriers.length, (_) => false));
    } catch (e) {
      GoPeduliLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  void sortByName(int columnIndex, bool ascending) {
    sortColumnIndex.value = columnIndex;
    sortAscending.value = ascending;

    filteredCouriers.sort((a, b) {
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

    filteredCouriers.sort((a, b) {
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

    filteredCouriers.sort((a, b) {
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
    filteredCouriers.assignAll(allCouriers.where(
        (user) => user.name.toLowerCase().contains(query.toLowerCase())));
  }

  confirmAndDeleteCourier(UserModel courier) {
    // Show a confirmation
    Get.defaultDialog(
        title: 'Delete Courier',
        titleStyle: const TextStyle(color: GoPeduliColors.white),
        content: const Text('Are you sure you would to delete this courier?',
            style: TextStyle(color: GoPeduliColors.white)),
        backgroundColor: GoPeduliColors.primary,
        confirm: SizedBox(
          width: 60,
          child: ElevatedButton(
              onPressed: () async => await deleteOnConfirm(courier),
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

  deleteOnConfirm(UserModel courier) async {
    try {
      Get.back();

      // Delete Firestore Data
      await userRepository.deleteUser(courier.id!);

      GoPeduliLoaders.successSnackBar(
          title: 'Courier Deleted', message: 'Courier has been deleted.');
      removeCourierFromLists(courier);
    } catch (e) {
      GoPeduliLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  void removeCourierFromLists(UserModel courier) {
    allCouriers.remove(courier);
    filteredCouriers.remove(courier);
    selectedRows.assignAll(List.generate(allCouriers.length, (index) => false));
  }

  void addCourierFromLists(UserModel courier) {
    allCouriers.add(courier);
    filteredCouriers.add(courier);
    selectedRows.assignAll(List.generate(allCouriers.length, (index) => false));
    filteredCouriers.refresh();
  }

  void updateCourierFromLists(UserModel courier) {
    final courierIndex = allCouriers.indexWhere((i) => i == courier);
    final filteredCourierIndex =
        filteredCouriers.indexWhere((i) => i == courier);

    if (courierIndex != -1) allCouriers[courierIndex] = courier;
    if (filteredCourierIndex != -1) filteredCouriers[courierIndex] = courier;

    filteredCouriers.refresh();
  }
}

class MyDataCourier extends DataTableSource {
  final controller = CourierController.instance;

  @override
  DataRow? getRow(int index) {
    final courier = controller.filteredCouriers[index];

    return DataRow2(cells: [
      DataCell(
        Text(courier.name),
      ),
      DataCell(
        Text(courier.email),
      ),
      DataCell(Text(courier.createdAt == null ? '' : courier.formattedDate)),
      DataCell(Row(
        children: [
          IconButton(
              onPressed: () => controller.confirmAndDeleteCourier(courier),
              icon: const Icon(Symbols.delete, color: Colors.red)),
        ],
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.filteredCouriers.length;

  @override
  int get selectedRowCount => 0;
}
