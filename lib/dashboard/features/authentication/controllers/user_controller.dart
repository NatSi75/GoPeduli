import 'package:data_table_2/data_table_2.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:gopeduli/dashboard/features/authentication/user_repository.dart';
import 'package:gopeduli/dashboard/features/popup/loaders.dart';
import 'package:gopeduli/dashboard/repository/user_model.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final userRepository = Get.put(UserRepository());

  RxList<UserModel> allUsers = <UserModel>[].obs;
  RxList<UserModel> filteredUsers = <UserModel>[].obs;
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
      List<UserModel> fetchedUsers = [];
      if (allUsers.isEmpty) {
        fetchedUsers = await userRepository.getAllUsers();
      }
      allUsers.assignAll(fetchedUsers);
      filteredUsers.assignAll(allUsers);
    } catch (e) {
      GoPeduliLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  void sortByName(int columnIndex, bool ascending) {
    sortColumnIndex.value = columnIndex;
    sortAscending.value = ascending;

    filteredUsers.sort((a, b) {
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

    filteredUsers.sort((a, b) {
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

    filteredUsers.sort((a, b) {
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
    filteredUsers.assignAll(allUsers.where(
        (user) => user.name.toLowerCase().contains(query.toLowerCase())));
  }

  // Fetches user details from repository
  Future<UserModel> fetchUserDetails() async {
    try {
      final user = await userRepository.fetchAdminDetails();
      return user;
    } catch (e) {
      GoPeduliLoaders.errorSnackBar(
          title: 'Something went wrong', message: e.toString());
      return UserModel.empty(); // Return an empty user model in case of error
    }
  }
}

class MyDataUser extends DataTableSource {
  final controller = UserController.instance;

  @override
  DataRow? getRow(int index) {
    final user = controller.filteredUsers[index];

    return DataRow2(cells: [
      DataCell(
        Text(user.name),
      ),
      DataCell(
        Text(user.email),
      ),
      DataCell(
        Text(user.phoneNumber),
      ),
      DataCell(Text(user.createdAt == null ? '' : user.formattedDate)),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.filteredUsers.length;

  @override
  int get selectedRowCount => 0;
}
