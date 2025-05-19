import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:gopeduli/dashboard/repository/article_repository.dart';
import 'package:gopeduli/dashboard/routes/routes.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class ArticleController extends GetxController {
  static ArticleController get instance => Get.find();

  final articleRepository = Get.put(ArticleRepository());

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
            }));

    filteredDataList.addAll(List.generate(
        10,
        (index) => {
              'Column1': 'data ${index + 1} - 1',
              'Column2': 'data ${index + 1} - 2',
              'Column3': 'data ${index + 1} - 3',
              'Column4': 'data ${index + 1} - 4',
              'Column5': 'data ${index + 1} - 5',
            }));
  }
}

class MyDataArticle extends DataTableSource {
  final ArticleController controller = Get.put(ArticleController());

  @override
  DataRow? getRow(int index) {
    final data = controller.filteredDataList[index];

    return DataRow2(
        onTap: () {},
        selected: controller.selectedRows[index],
        onSelectChanged: (value) =>
            controller.selectedRows[index] = value ?? false,
        cells: [
          const DataCell(
            Text('Lorem'),
          ),
          const DataCell(Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ullamcorper efficitur quam. Nulla laoreet elementum aliquam. Phasellus ornare ut purus feugiat hendrerit. Nullam vel odio vel magna tristique sagittis. Phasellus non rutrum nunc. Phasellus a eleifend ligula. Nullam porttitor vel lectus sed eleifend. Suspendisse pellentesque sem a fringilla pharetra. Cras dui diam, viverra vel dolor auctor, aliquet lacinia purus. Duis eu ante eget lectus fringilla bibendum ullamcorper vitae nibh. Praesent et viverra ligula, eget fringilla urna. Phasellus enim orci, tristique non pulvinar ut, ultrices eget massa. Suspendisse sed felis non dolor venenatis pellentesque id id mi. Ut in semper ante, eget imperdiet quam. Quisque ultrices euismod ullamcorper. Fusce convallis et metus quis tincidunt. Pellentesque vitae ligula scelerisque, tristique ligula vitae, gravida diam. Nunc felis velit, viverra sit amet nisl quis, pretium aliquam nunc. Sed sit amet luctus odio, vitae condimentum magna. Nullam in diam non tellus accumsan maximus. Curabitur sit amet turpis fringilla, posuere ligula at, semper lacus. Donec et cursus enim. Quisque aliquet tempor nisi, vel euismod ante rutrum non.'),
          )),
          DataCell(Text(DateTime.now().toString())),
          const DataCell(Text('Natanael Sion')),
          const DataCell(Text('Dr. Indah')),
          DataCell(Row(
            children: [
              IconButton(
                  onPressed: () => Get.toNamed(GoPeduliRoutes.editArticle),
                  icon: const Icon(
                    Symbols.edit,
                    color: Colors.blue,
                  )),
              IconButton(
                  onPressed: () => Get.toNamed(GoPeduliRoutes.editArticle),
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
