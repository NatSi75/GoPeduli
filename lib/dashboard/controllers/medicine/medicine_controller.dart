import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:gopeduli/dashboard/features/popup/loaders.dart';
import 'package:gopeduli/dashboard/helper/color.dart';
import 'package:gopeduli/dashboard/helper/size.dart';
import 'package:gopeduli/dashboard/repository/medicine_model.dart';
import 'package:gopeduli/dashboard/repository/medicine_repository.dart';
import 'package:gopeduli/dashboard/routes/routes.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:intl/intl.dart';

class MedicineController extends GetxController {
  static MedicineController get instance => Get.find();

  final medicineRepository = Get.put(MedicineRepository());

  RxList<MedicineModel> allMedicines = <MedicineModel>[].obs;
  RxList<MedicineModel> filteredMedicines = <MedicineModel>[].obs;
  RxList<bool> selectedRows =
      <bool>[].obs; //Observable list to store selected rows
  RxInt sortColumnIndex =
      8.obs; //Observable for tracking the index of the column for string
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
      List<MedicineModel> fetchedMedicines = [];
      if (allMedicines.isEmpty) {
        fetchedMedicines = await medicineRepository.getAllMedicines();
      }
      allMedicines.assignAll(fetchedMedicines);
      filteredMedicines.assignAll(allMedicines);
      selectedRows.assignAll(List.generate(allMedicines.length, (_) => false));
    } catch (e) {
      GoPeduliLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  void sortByNameProduct(int columnIndex, bool ascending) {
    sortColumnIndex.value = columnIndex;
    sortAscending.value = ascending;

    filteredMedicines.sort((a, b) {
      if (ascending) {
        return a.nameProduct
            .toLowerCase()
            .compareTo(b.nameProduct.toLowerCase());
      } else {
        return b.nameProduct
            .toLowerCase()
            .compareTo(a.nameProduct.toLowerCase());
      }
    });
  }

  void sortByNameMedicine(int columnIndex, bool ascending) {
    sortColumnIndex.value = columnIndex;
    sortAscending.value = ascending;

    filteredMedicines.sort((a, b) {
      if (ascending) {
        return a.nameMedicine
            .toLowerCase()
            .compareTo(b.nameMedicine.toLowerCase());
      } else {
        return b.nameMedicine
            .toLowerCase()
            .compareTo(a.nameMedicine.toLowerCase());
      }
    });
  }

  void sortByNameCategory(int columnIndex, bool ascending) {
    sortColumnIndex.value = columnIndex;
    sortAscending.value = ascending;

    filteredMedicines.sort((a, b) {
      if (ascending) {
        return a.category.toLowerCase().compareTo(b.category.toLowerCase());
      } else {
        return b.category.toLowerCase().compareTo(a.category.toLowerCase());
      }
    });
  }

  void sortByClassMedicine(int columnIndex, bool ascending) {
    sortColumnIndex.value = columnIndex;
    sortAscending.value = ascending;

    filteredMedicines.sort((a, b) {
      if (ascending) {
        return a.classMedicine
            .toLowerCase()
            .compareTo(b.classMedicine.toLowerCase());
      } else {
        return b.classMedicine
            .toLowerCase()
            .compareTo(a.classMedicine.toLowerCase());
      }
    });
  }

  void sortByPrice(int columnIndex, bool ascending) {
    sortColumnIndex.value = columnIndex;
    sortAscending.value = ascending;

    filteredMedicines.sort((a, b) {
      final priceA = int.tryParse(a.price.replaceAll('.', '')) ?? 0;
      final priceB = int.tryParse(b.price.replaceAll('.', '')) ?? 0;

      if (ascending) {
        return priceA.compareTo(priceB);
      } else {
        return priceB.compareTo(priceA);
      }
    });
  }

  void sortByStock(int columnIndex, bool ascending) {
    sortColumnIndex.value = columnIndex;
    sortAscending.value = ascending;

    filteredMedicines.sort((a, b) {
      final stockA = int.tryParse(a.stock.replaceAll('.', '')) ?? 0;
      final stockB = int.tryParse(b.stock.replaceAll('.', '')) ?? 0;

      if (ascending) {
        return stockA.compareTo(stockB);
      } else {
        return stockB.compareTo(stockA);
      }
    });
  }

  searchQuery(String query) {
    filteredMedicines.assignAll(allMedicines.where((medicine) =>
        medicine.nameProduct.toLowerCase().contains(query.toLowerCase())));
  }

  confirmAndDeleteMedicine(MedicineModel medicine) {
    // Show a confirmation
    Get.defaultDialog(
        title: 'Delete Medicine',
        titleStyle: const TextStyle(color: GoPeduliColors.white),
        content: const Text(
          'Are you sure you would to delete this medicine?',
          style: TextStyle(color: GoPeduliColors.white),
        ),
        backgroundColor: GoPeduliColors.primary,
        confirm: SizedBox(
          width: 60,
          child: ElevatedButton(
              onPressed: () async => await deleteOnConfirm(medicine),
              style: OutlinedButton.styleFrom(
                  backgroundColor: GoPeduliColors.quaternary,
                  padding: const EdgeInsets.symmetric(
                      vertical: GoPeduliSize.paddingHeightSmall),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          GoPeduliSize.borderRadiusSmall))),
              child: const Text(
                'Yes',
                style: TextStyle(color: GoPeduliColors.white),
              )),
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

  deleteOnConfirm(MedicineModel medicine) async {
    try {
      Get.back();

      // Delete Firestore Data
      await medicineRepository.deleteMedicine(medicine.id);
      final ref = FirebaseStorage.instance.refFromURL(medicine.image);
      await ref.delete();

      GoPeduliLoaders.successSnackBar(
          title: 'Medicine Deleted', message: 'Medicine has been deleted.');
      removeMedicineFromLists(medicine);
    } catch (e) {
      GoPeduliLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  void removeMedicineFromLists(MedicineModel medicine) {
    allMedicines.remove(medicine);
    filteredMedicines.remove(medicine);
    selectedRows
        .assignAll(List.generate(allMedicines.length, (index) => false));
  }

  void addMedicineFromLists(MedicineModel medicine) {
    allMedicines.add(medicine);
    filteredMedicines.add(medicine);
    selectedRows
        .assignAll(List.generate(allMedicines.length, (index) => false));
    filteredMedicines.refresh();
  }

  void updateMedicineFromLists(MedicineModel medicine) {
    final medicineIndex = allMedicines.indexWhere((i) => i == medicine);
    final filteredMedicineIndex =
        filteredMedicines.indexWhere((i) => i == medicine);

    if (medicineIndex != -1) allMedicines[medicineIndex] = medicine;
    if (filteredMedicineIndex != -1) {
      filteredMedicines[medicineIndex] = medicine;
    }

    filteredMedicines.refresh();
  }
}

class MyDataMedicine extends DataTableSource {
  final controller = MedicineController.instance;

  String formatCurrency(int amount) {
    return NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0)
        .format(amount);
  }

  @override
  DataRow? getRow(int index) {
    final medicine = controller.filteredMedicines[index];

    return DataRow2(
        selected: controller.selectedRows[index],
        onSelectChanged: (value) => {
              controller.selectedRows[index] = value ?? false,
              controller.filteredMedicines.refresh()
            },
        cells: [
          DataCell(
            Image.network(medicine.image, width: 200, height: 200),
          ),
          DataCell(
            Text(medicine.nameProduct),
          ),
          DataCell(Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(medicine.description),
          )),
          DataCell(
            Text(medicine.nameMedicine),
          ),
          DataCell(
            Text(medicine.category),
          ),
          DataCell(
            Text(medicine.classMedicine),
          ),
          DataCell(
            Text(formatCurrency(int.parse(medicine.price))),
          ),
          DataCell(
            Text(medicine.stock),
          ),
          DataCell(Row(
            children: [
              IconButton(
                  onPressed: () => Get.toNamed(GoPeduliRoutes.editMedicine,
                      arguments: medicine),
                  icon: const Icon(
                    Symbols.edit,
                    color: Colors.blue,
                  )),
              IconButton(
                  onPressed: () =>
                      controller.confirmAndDeleteMedicine(medicine),
                  icon: const Icon(Symbols.delete, color: Colors.red)),
            ],
          )),
        ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.filteredMedicines.length;

  @override
  int get selectedRowCount => 0;
}
