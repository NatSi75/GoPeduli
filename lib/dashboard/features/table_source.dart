import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:gopeduli/dashboard/helper/size.dart';
import 'package:gopeduli/dashboard/repository/order_model.dart';
import 'package:gopeduli/dashboard/repository/order_repository.dart';
import 'package:intl/intl.dart';

class OrderRows extends DataTableSource {
  final List<OrderModel> _orders;
  final OrderRepository _orderRepository;

  OrderRows(this._orders, this._orderRepository);
  @override
  DataRow? getRow(int index) {
    if (index >= _orders.length) {
      return null;
    }

    final order = _orders[index];

    // Helper untuk format Rupiah
    String formatCurrency(double amount) {
      return NumberFormat.currency(
              locale: 'id_ID', symbol: 'Rp', decimalDigits: 0)
          .format(amount);
    }

    // Helper untuk format tanggal transaksi
    String formatTransactionTime(DateTime? dateTime) {
      if (dateTime == null) return 'N/A';
      return DateFormat('dd MMM yyyy, HH:mm')
          .format(dateTime); // Contoh: 10 Jun 2025, 15:30
    }

    return DataRow2(
        color: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            // Contoh: Baris genap memiliki warna abu-abu muda
            if (index.isEven) {
              return Colors.grey.shade50;
            }
            return Colors.grey.shade50;
          },
        ),
        cells: [
          DataCell(
            Text(
              order.orderId,
              style: const TextStyle(fontSize: GoPeduliSize.fontSizeSubBody),
            ),
          ),
          DataCell(
            FutureBuilder<String>(
              future: _orderRepository.getUserNameById(
                  order.userId), // Panggil melalui _orderRepository
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  );
                } else if (snapshot.hasData) {
                  return Text(snapshot.data!,
                      style: const TextStyle(
                          fontSize: GoPeduliSize.fontSizeSubBody));
                }
                return const Text('N/A');
              },
            ),
          ),
          DataCell(
            Text(formatCurrency(order.total.toDouble()),
                style: const TextStyle(fontSize: GoPeduliSize.fontSizeSubBody)),
          ),
          DataCell(
            Text(order.fraudStatus,
                style: const TextStyle(fontSize: GoPeduliSize.fontSizeSubBody)),
          ),
          DataCell(
            Text(order.status,
                style: const TextStyle(fontSize: GoPeduliSize.fontSizeSubBody)),
          ),
          DataCell(Text(formatTransactionTime(order.createdAt),
              style: const TextStyle(fontSize: GoPeduliSize.fontSizeSubBody))),
        ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _orders.length;

  @override
  int get selectedRowCount => 0;
}
