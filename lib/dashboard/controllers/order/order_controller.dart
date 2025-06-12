import 'package:data_table_2/data_table_2.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:gopeduli/dashboard/features/popup/loaders.dart';
import 'package:gopeduli/dashboard/helper/color.dart';
import 'package:gopeduli/dashboard/helper/size.dart';
import 'package:gopeduli/dashboard/repository/order_model.dart';
import 'package:gopeduli/dashboard/repository/order_repository.dart';
import 'package:gopeduli/dashboard/routes/routes.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:intl/intl.dart';

class OrderController extends GetxController {
  static OrderController get instance => Get.find();

  final orderRepository = Get.put(OrderRepository());

  RxList<OrderModel> allOrders = <OrderModel>[].obs;
  RxList<OrderModel> filteredOrders = <OrderModel>[].obs;
  RxMap<String, String> userNames = <String, String>{}.obs;
  RxMap<String, String> userEmails = <String, String>{}.obs;
  RxInt sortColumnIndex =
      5.obs; //Observable for tracking the index of the column for string
  RxBool sortAscending = true
      .obs; // Observable for tracking the sorting order (ascending or descending)
  final searchTextController =
      TextEditingController(); // Controller for handling search text input
  // List of possible order statuses
  final List<String> possibleStatuses = [
    'pending',
    'proccessing',
    'ready',
    'shipped',
    'delivered',
    'completed',
    'cancelled'
  ];

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  Future<void> fetchUserName(String userId) async {
    if (userNames.containsKey(userId)) return; // Hindari fetch ulang

    try {
      final name = await OrderRepository.instance.getUserNameById(userId);
      userNames[userId] = name; // Simpan nama pengguna dalam map
    } catch (e) {
      GoPeduliLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  Future<void> fetchUserEmail(String userId) async {
    if (userEmails.containsKey(userId)) return; // Hindari fetch ulang

    try {
      final email = await OrderRepository.instance.getUserEmailById(userId);
      userEmails[userId] = email; // Simpan nama pengguna dalam map
    } catch (e) {
      GoPeduliLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  Future<void> fetchData() async {
    try {
      List<OrderModel> fetchedOrders = [];
      if (allOrders.isEmpty) {
        fetchedOrders = await orderRepository.getAllOrders();
      }
      allOrders.assignAll(fetchedOrders);
      filteredOrders.assignAll(allOrders);

      // Ambil nama user untuk semua order
      for (var order in allOrders) {
        await fetchUserName(order.userId);
        await fetchUserEmail(order.userId);
      }

      sortByCreateDate(sortColumnIndex.value, sortAscending.value);
    } catch (e) {
      GoPeduliLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  void sortByCreateDate(int columnIndex, bool ascending) {
    sortColumnIndex.value = columnIndex;
    sortAscending.value = ascending;

    filteredOrders.sort((a, b) {
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
    filteredOrders.assignAll(allOrders.where((user) =>
        (userNames[user.userId]?.toLowerCase().contains(query.toLowerCase()) ??
            false)));
  }

  /// Show a dialog to update the status of a specific order.
  void showUpdateStatusDialog(OrderModel order) {
    // Use a reactive variable to hold the selected status in the dialog
    RxString selectedStatus = order.status.obs;

    Get.defaultDialog(
        title: 'Update Status Pesanan',
        titleStyle: const TextStyle(
            color: GoPeduliColors.white, fontSize: GoPeduliSize.fontSizeTitle),
        backgroundColor: GoPeduliColors.primary,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID Pesanan: ${order.orderId}',
                style: const TextStyle(
                    color: GoPeduliColors.white,
                    fontSize: GoPeduliSize.fontSizeBody)),
            Text('Status Saat Ini: ${order.status}',
                style: const TextStyle(
                    color: GoPeduliColors.white,
                    fontSize: GoPeduliSize.fontSizeBody)),
            const SizedBox(height: 16),
            const Text('Pilih Status Baru:',
                style: TextStyle(
                    color: GoPeduliColors.white,
                    fontSize: GoPeduliSize.fontSizeBody)),
            Obx(
              () => DropdownButton<String>(
                value: selectedStatus.value,
                dropdownColor: GoPeduliColors.primary,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    selectedStatus.value = newValue;
                  }
                },
                items: possibleStatuses
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,
                        style: const TextStyle(
                            color: GoPeduliColors.white,
                            fontSize: GoPeduliSize.fontSizeBody)),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        confirm: SizedBox(
          width: 120,
          child: ElevatedButton(
              onPressed: () {
                updateOrderStatus(order.orderId, selectedStatus.value);
                Get.back();
              },
              style: OutlinedButton.styleFrom(
                  backgroundColor: GoPeduliColors.quaternary,
                  padding: const EdgeInsets.symmetric(
                      vertical: GoPeduliSize.paddingHeightSmall),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          GoPeduliSize.borderRadiusSmall))),
              child: const Text('Update Status',
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

  /// Update the status of an order in the repository and refresh the data.
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      // Call the actual update method in OrderRepository
      await orderRepository.updateOrderStatus(orderId, newStatus);

      // After successful update in Firestore, refresh the local data
      // Find the order in allOrders and update its status
      int index = allOrders.indexWhere((o) => o.orderId == orderId);
      if (index != -1) {
        // Create a new OrderModel with updated status
        final updatedOrder = allOrders[index].copyWith(status: newStatus);
        allOrders[index] = updatedOrder; // Update in allOrders list

        // Re-assign filteredOrders to trigger UI update and re-sort
        filteredOrders.assignAll(allOrders);
        sortByCreateDate(
            sortColumnIndex.value, sortAscending.value); // Re-sort after update
        GoPeduliLoaders.successSnackBar(
            title: 'Berhasil',
            message:
                'Status pesanan $orderId berhasil diupdate menjadi $newStatus.');
      } else {
        GoPeduliLoaders.errorSnackBar(
            title: 'Gagal',
            message: 'Pesanan tidak ditemukan di daftar lokal.');
      }
    } catch (e) {
      GoPeduliLoaders.errorSnackBar(
          title: 'Oh Snap',
          message: 'Gagal mengupdate status: ${e.toString()}');
    }
  }
}

class MyDataOrder extends DataTableSource {
  final controller = OrderController.instance;

  String formatCurrency(int amount) {
    return NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0)
        .format(amount);
  }

  @override
  DataRow? getRow(int index) {
    final order = controller.filteredOrders[index];

    return DataRow2(
        onTap: () => Get.toNamed(GoPeduliRoutes.detailOrder, arguments: order),
        selected: false,
        onSelectChanged: (value) {},
        cells: [
          DataCell(
            Text(order.orderId),
          ),
          DataCell(
            Obx(() {
              final name = controller.userNames[order.userId] ?? 'Loading...';
              return Text(name);
            }),
          ),
          DataCell(
            Text(formatCurrency(order.total)),
          ),
          DataCell(
            Text(order.fraudStatus),
          ),
          DataCell(
            Text(order.status),
          ),
          DataCell(Text(order.createdAt == null ? '' : order.formattedDate)),
          DataCell(Row(
            children: [
              IconButton(
                  onPressed: () => controller.showUpdateStatusDialog(order),
                  icon: const Icon(
                    Symbols.edit,
                    color: Colors.blue,
                  )),
            ],
          )),
        ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.filteredOrders.length;

  @override
  int get selectedRowCount => 0;
}
