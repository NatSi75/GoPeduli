import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:gopeduli/dashboard/features/popup/loaders.dart';
import 'package:gopeduli/dashboard/helper/size.dart';
import 'package:gopeduli/dashboard/repository/article_model.dart';
import 'package:gopeduli/dashboard/repository/article_repository.dart';
import 'package:gopeduli/dashboard/routes/routes.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class ArticleController extends GetxController {
  static ArticleController get instance => Get.find();

  final articleRepository = Get.put(ArticleRepository());

  RxList<ArticleModel> allArticles = <ArticleModel>[].obs;
  RxList<ArticleModel> filteredArticles = <ArticleModel>[].obs;
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
    fetchData();
    super.onInit();
  }

  Future<void> fetchData() async {
    try {
      List<ArticleModel> fetchedArticles = [];
      if (allArticles.isEmpty) {
        fetchedArticles = await articleRepository.getAllArticles();
      }
      allArticles.assignAll(fetchedArticles);
      filteredArticles.assignAll(allArticles);
      selectedRows.assignAll(List.generate(allArticles.length, (_) => false));
    } catch (e) {
      GoPeduliLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  void sortByTitle(int columnIndex, bool ascending) {
    sortColumnIndex.value = columnIndex;
    sortAscending.value = ascending;

    filteredArticles.sort((a, b) {
      if (ascending) {
        return a.title.toLowerCase().compareTo(b.title.toLowerCase());
      } else {
        return b.title.toLowerCase().compareTo(a.title.toLowerCase());
      }
    });
  }

  void sortByPublishDate(int columnIndex, bool ascending) {
    sortColumnIndex.value = columnIndex;
    sortAscending.value = ascending;

    filteredArticles.sort((a, b) {
      final aCreatedAt = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bCreatedAt = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      if (ascending) {
        return aCreatedAt.compareTo(bCreatedAt);
      } else {
        return bCreatedAt.compareTo(aCreatedAt);
      }
    });
  }

  void sortByAuthor(int columnIndex, bool ascending) {
    sortColumnIndex.value = columnIndex;
    sortAscending.value = ascending;

    filteredArticles.sort((a, b) {
      if (ascending) {
        return a.author.toLowerCase().compareTo(b.author.toLowerCase());
      } else {
        return b.author.toLowerCase().compareTo(a.author.toLowerCase());
      }
    });
  }

  void sortByVerified(int columnIndex, bool ascending) {
    sortColumnIndex.value = columnIndex;
    sortAscending.value = ascending;

    filteredArticles.sort((a, b) {
      if (ascending) {
        return a.verifiedBy.toLowerCase().compareTo(b.verifiedBy.toLowerCase());
      } else {
        return b.verifiedBy.toLowerCase().compareTo(a.verifiedBy.toLowerCase());
      }
    });
  }

  searchQuery(String query) {
    filteredArticles.assignAll(allArticles.where((article) =>
        article.title.toLowerCase().contains(query.toLowerCase())));
  }

  confirmAndDeleteArticle(ArticleModel article) {
    // Show a confirmation
    Get.defaultDialog(
        title: 'Delete Article',
        content: const Text('Are you sure you would to delete this article?'),
        confirm: SizedBox(
          width: 60,
          child: ElevatedButton(
              onPressed: () async => await deleteOnConfirm(article),
              style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: GoPeduliSize.paddingHeightSmall),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          GoPeduliSize.borderRadiusSmall))),
              child: const Text('Yes')),
        ),
        cancel: SizedBox(
          width: 80,
          child: OutlinedButton(
              onPressed: () => Get.back(),
              style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: GoPeduliSize.paddingHeightSmall),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          GoPeduliSize.borderRadiusSmall))),
              child: const Text('Cancel')),
        ));
  }

  deleteOnConfirm(ArticleModel article) async {
    try {
      Get.back();

      // Delete Firestore Data
      await articleRepository.deleteArticle(article.id);
      final ref = FirebaseStorage.instance.refFromURL(article.image);
      await ref.delete();

      GoPeduliLoaders.successSnackBar(
          title: 'Article Deleted', message: 'Article has been deleted.');
      removeArticleFromLists(article);
    } catch (e) {
      GoPeduliLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  void removeArticleFromLists(ArticleModel article) {
    allArticles.remove(article);
    filteredArticles.remove(article);
    selectedRows.assignAll(List.generate(allArticles.length, (index) => false));
  }

  void addArticleFromLists(ArticleModel article) {
    allArticles.add(article);
    filteredArticles.add(article);
    selectedRows.assignAll(List.generate(allArticles.length, (index) => false));
    filteredArticles.refresh();
  }

  void updateArticleFromLists(ArticleModel article) {
    final articleIndex = allArticles.indexWhere((i) => i == article);
    final filteredArticleIndex =
        filteredArticles.indexWhere((i) => i == article);

    if (articleIndex != -1) allArticles[articleIndex] = article;
    if (filteredArticleIndex != -1) filteredArticles[articleIndex] = article;

    filteredArticles.refresh();
  }
}

class MyDataArticle extends DataTableSource {
  final controller = ArticleController.instance;

  @override
  DataRow? getRow(int index) {
    final article = controller.filteredArticles[index];

    return DataRow2(
        selected: controller.selectedRows[index],
        onSelectChanged: (value) => {
              controller.selectedRows[index] = value ?? false,
              controller.filteredArticles.refresh()
            },
        cells: [
          DataCell(
            Text(article.title),
          ),
          DataCell(
            Image.network(article.image, width: 200, height: 200),
          ),
          DataCell(Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(article.body),
          )),
          DataCell(
              Text(article.createdAt == null ? '' : article.formattedDate)),
          DataCell(Text(article.author)),
          DataCell(Text(article.verifiedBy)),
          DataCell(Row(
            children: [
              IconButton(
                  onPressed: () => Get.toNamed(GoPeduliRoutes.editArticle,
                      arguments: article),
                  icon: const Icon(
                    Symbols.edit,
                    color: Colors.blue,
                  )),
              IconButton(
                  onPressed: () => controller.confirmAndDeleteArticle(article),
                  icon: const Icon(Symbols.delete, color: Colors.red)),
            ],
          )),
        ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.filteredArticles.length;

  @override
  int get selectedRowCount => 0;
}
