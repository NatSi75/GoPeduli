import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:gopeduli/dashboard/repository/medicine_repository.dart';
import 'package:gopeduli/dashboard/routes/routes.dart';
import 'package:material_symbols_icons/symbols.dart';

class MedicineController extends GetxController {
  static MedicineController get instance => Get.find();

  final medicineController = Get.put(MedicineRepository());

  var dataList = <Map<String, String>>[].obs;
  var filteredDataList = <Map<String, String>>[].obs;
  RxList<bool> selectedRows =
      <bool>[].obs; //Observable list to store selected rows
  RxInt sortColumnIndex =
      1.obs; //Observable for tracking the index of the column for string
  RxBool sortAscending = true
      .obs; // Observable for tracking the sorting order (ascending or descending)
  final searchTextController =
      TextEditingController(); // Controller for handling search text input

  @override
  void onInit() {
    super.onInit();
    fetchDummyData();
  }

  void sortById(int sortColumnIndex, bool ascending) {
    sortAscending.value = ascending;
    filteredDataList.sort((a, b) {
      if (ascending) {
        return filteredDataList[0]['column1']
            .toString()
            .toLowerCase()
            .compareTo(filteredDataList[0]['column1'].toString().toLowerCase());
      } else {
        return filteredDataList[0]['column1']
            .toString()
            .toLowerCase()
            .compareTo(filteredDataList[0]['column1'].toString().toLowerCase());
      }
    });
    this.sortColumnIndex.value = sortColumnIndex;
  }

  void searchQuery(String query) {
    filteredDataList.assignAll(dataList
        .where((item) => item['column1']!.contains(query.toLowerCase())));
  }

  void fetchDummyData() {
    selectedRows.assignAll(
        List.generate(10, (index) => false)); //Initialize selected rows

    dataList.addAll(List.generate(
        10,
        (index) => {
              'Column1': 'data ${index + 1} - 1',
              'Column2': 'data ${index + 1} - 2',
              'Column3': 'data ${index + 1} - 3',
              'Column4': 'data ${index + 1} - 4',
              'Column5': 'data ${index + 1} - 5',
              'Column6': 'data ${index + 1} - 6',
            }));

    filteredDataList.addAll(List.generate(
        10,
        (index) => {
              'Column1': 'data ${index + 1} - 1',
              'Column2': 'data ${index + 1} - 2',
              'Column3': 'data ${index + 1} - 3',
              'Column4': 'data ${index + 1} - 4',
              'Column5': 'data ${index + 1} - 5',
              'Column6': 'data ${index + 1} - 6',
            }));
  }
}

class MyDataMedicine extends DataTableSource {
  final MedicineController controller = Get.put(MedicineController());

  @override
  DataRow? getRow(int index) {
    final data = controller.filteredDataList[index];

    return DataRow2(
        onTap: () {},
        selected: controller.selectedRows[index],
        onSelectChanged: (value) =>
            controller.selectedRows[index] = value ?? false,
        cells: [
          const DataCell(Text('Paracetamol 500 mg')),
          const DataCell(Text('Paracetamol')),
          const DataCell(Text('Analgesic')),
          const DataCell(Text('Over-the-counter')),
          const DataCell(Text('Rp5.000')),
          const DataCell(Text('120')),
          DataCell(Row(
            children: [
              IconButton(
                  onPressed: () => Get.toNamed(GoPeduliRoutes.editMedicine),
                  icon: const Icon(
                    Symbols.edit,
                    color: Colors.blue,
                  )),
              IconButton(
                  onPressed: () => Get.toNamed(GoPeduliRoutes.editMedicine),
                  icon: const Icon(Symbols.delete, color: Colors.red)),
            ],
          )),
        ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.filteredDataList.length;

  @override
  int get selectedRowCount => 0;
}
