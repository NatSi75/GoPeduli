import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gopeduli/dashboard/controllers/dashboard/dashboard_controller.dart';
import 'package:gopeduli/dashboard/features/circular_container.dart';
import 'package:gopeduli/dashboard/features/rounded_container.dart';
import 'package:gopeduli/dashboard/helper/enums.dart';
import 'package:gopeduli/dashboard/helper/helper_function.dart';
import 'package:gopeduli/dashboard/helper/size.dart';
import 'package:intl/intl.dart';

class OrderStatusGraph extends StatelessWidget {
  const OrderStatusGraph({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = DashboardController.instance;

    String formatCurrency(double amount) {
      return NumberFormat.currency(
              locale: 'id', symbol: 'Rp ', decimalDigits: 0)
          .format(amount);
    }

    return GoPeduliRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Orders Status',
            style: TextStyle(fontSize: GoPeduliSize.fontSizeSubtitle),
          ),
          const SizedBox(
            height: GoPeduliSize.paddingHeightSmall,
          ),

          // Graph
          SizedBox(
            height: 400,
            child: Obx(
              () => PieChart(PieChartData(
                  sections: controller.orderStatusData.entries
                      .map((entry) {
                        final status = entry.key;
                        final count = entry.value;

                        if (count == 0) {
                          return null; // Mengembalikan null untuk mengabaikan segmen ini
                        }

                        return PieChartSectionData(
                          color: GoPeduliHelperFunction.getOrderStatusColor(
                              status),
                          value: count.toDouble(),
                          title: count.toString(),
                          radius: 50,
                          titleStyle: const TextStyle(
                                  fontSize: GoPeduliSize.fontSizeSubtitle)
                              .copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      })
                      .whereType<PieChartSectionData>()
                      .toList(),
                  pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        //hande
                      },
                      enabled: true))),
            ),
          ),

          // Show Status and Color Meta
          SizedBox(
            width: double.infinity,
            child: Obx(
              () => DataTable(
                columns: const [
                  DataColumn(
                      label: Text('Status',
                          style:
                              TextStyle(fontSize: GoPeduliSize.fontSizeBody))),
                  DataColumn(
                      label: Text('Orders',
                          style:
                              TextStyle(fontSize: GoPeduliSize.fontSizeBody))),
                  DataColumn(
                      label: Text('Total',
                          style:
                              TextStyle(fontSize: GoPeduliSize.fontSizeBody)))
                ],
                rows: controller.orderStatusData.entries
                    .map((entry) {
                      final OrderStatus status = entry.key;
                      final int count = entry.value;
                      final totalAmount =
                          controller.totalAmounts[status] ?? 0.0;

                      // --- Filter keluar status dengan count 0 di sini ---
                      if (count == 0) {
                        return null; // Mengembalikan null untuk mengabaikan baris ini
                      }

                      return DataRow(cells: [
                        DataCell(Row(
                          children: [
                            GoPeduliCircularContainer(
                              width: 20,
                              height: 20,
                              backgroundColor:
                                  GoPeduliHelperFunction.getOrderStatusColor(
                                      status),
                            ),
                            const SizedBox(
                              width: GoPeduliSize.paddingHeightSmall,
                            ),
                            Expanded(
                                child: Text(
                                    controller.getDisplayStatusName(status),
                                    style: const TextStyle(
                                        fontSize:
                                            GoPeduliSize.fontSizeSubBody)))
                          ],
                        )),
                        DataCell(Text(count.toString(),
                            style: const TextStyle(
                                fontSize: GoPeduliSize.fontSizeSubBody))),
                        DataCell(Text(formatCurrency(totalAmount),
                            style: const TextStyle(
                                fontSize: GoPeduliSize.fontSizeSubBody))),
                      ]);
                    })
                    .whereType<DataRow>()
                    .toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
