import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:gopeduli/dashboard/features/popup/loaders.dart';
import 'package:gopeduli/dashboard/helper/color.dart';
import 'package:gopeduli/dashboard/helper/size.dart';
import 'package:gopeduli/dashboard/repository/author_model.dart';
import 'package:gopeduli/dashboard/repository/author_repository.dart';
import 'package:gopeduli/dashboard/routes/routes.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class AuthorController extends GetxController {
  static AuthorController get instance => Get.find();

  final authorRepository = Get.put(AuthorRepository());

  RxList<AuthorModel> allAuthors = <AuthorModel>[].obs;
  RxList<AuthorModel> filteredAuthors = <AuthorModel>[].obs;
  RxList<bool> selectedRows =
      <bool>[].obs; //Observable list to store selected rows
  RxInt sortColumnIndex =
      2.obs; //Observable for tracking the index of the column for string
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
      List<AuthorModel> fetchedAuthors = [];
      if (allAuthors.isEmpty) {
        fetchedAuthors = await authorRepository.getAllAuthors();
      }
      allAuthors.assignAll(fetchedAuthors);
      filteredAuthors.assignAll(allAuthors);
      selectedRows.assignAll(List.generate(allAuthors.length, (_) => false));
    } catch (e) {
      GoPeduliLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  void sortByName(int columnIndex, bool ascending) {
    sortColumnIndex.value = columnIndex;
    sortAscending.value = ascending;

    filteredAuthors.sort((a, b) {
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

    filteredAuthors.sort((a, b) {
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

    filteredAuthors.sort((a, b) {
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
    filteredAuthors.assignAll(allAuthors.where(
        (author) => author.name.toLowerCase().contains(query.toLowerCase())));
  }

  confirmAndDeleteAuthor(AuthorModel author) {
    // Show a confirmation
    Get.defaultDialog(
        title: 'Delete Author',
        titleStyle: const TextStyle(color: GoPeduliColors.white),
        content: const Text('Are you sure you would to delete this author?',
            style: TextStyle(color: GoPeduliColors.white)),
        backgroundColor: GoPeduliColors.primary,
        confirm: SizedBox(
          width: 60,
          child: ElevatedButton(
              onPressed: () async => await deleteOnConfirm(author),
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

  deleteOnConfirm(AuthorModel author) async {
    try {
      Get.back();

      // Delete Firestore Data
      await authorRepository.deleteAuthor(author.id);

      GoPeduliLoaders.successSnackBar(
          title: 'Author Deleted', message: 'Author has been deleted.');
      removeAuthorFromLists(author);
    } catch (e) {
      GoPeduliLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  void removeAuthorFromLists(AuthorModel author) {
    allAuthors.remove(author);
    filteredAuthors.remove(author);
    selectedRows.assignAll(List.generate(allAuthors.length, (index) => false));
  }

  void addAuthorFromLists(AuthorModel author) {
    allAuthors.add(author);
    filteredAuthors.add(author);
    selectedRows.assignAll(List.generate(allAuthors.length, (index) => false));
    filteredAuthors.refresh();
  }

  void updateAuthorFromLists(AuthorModel author) {
    final authorIndex = allAuthors.indexWhere((i) => i == author);
    final filteredAuthorIndex = filteredAuthors.indexWhere((i) => i == author);

    if (authorIndex != -1) allAuthors[authorIndex] = author;
    if (filteredAuthorIndex != -1) filteredAuthors[authorIndex] = author;

    filteredAuthors.refresh();
  }
}

class MyDataAuthor extends DataTableSource {
  final controller = AuthorController.instance;

  @override
  DataRow? getRow(int index) {
    final author = controller.filteredAuthors[index];

    return DataRow2(
        selected: controller.selectedRows[index],
        onSelectChanged: (value) => {
              controller.selectedRows[index] = value ?? false,
              controller.filteredAuthors.refresh()
            },
        cells: [
          DataCell(
            Text(author.name),
          ),
          DataCell(
            Text(author.email),
          ),
          DataCell(
            Text(author.phoneNumber),
          ),
          DataCell(Text(author.createdAt == null ? '' : author.formattedDate)),
          DataCell(Row(
            children: [
              IconButton(
                  onPressed: () =>
                      Get.toNamed(GoPeduliRoutes.editAuthor, arguments: author),
                  icon: const Icon(
                    Symbols.edit,
                    color: Colors.blue,
                  )),
              IconButton(
                  onPressed: () => controller.confirmAndDeleteAuthor(author),
                  icon: const Icon(Symbols.delete, color: Colors.red)),
            ],
          )),
        ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.filteredAuthors.length;

  @override
  int get selectedRowCount => 0;
}
