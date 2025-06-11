import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gopeduli/dashboard/controllers/dashboard/dashboard_controller.dart';
import 'package:gopeduli/dashboard/features/table_source.dart';
import 'package:gopeduli/dashboard/helper/color.dart';
import 'package:gopeduli/dashboard/helper/size.dart';

class DashboardOrderTable extends StatelessWidget {
  const DashboardOrderTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());
    return SizedBox(
      height: 400,
      child: Obx(
        () {
          const availableRows = <int>[10, 20];
          final rowsPerPage =
              controller.recentOrders.isNotEmpty && availableRows.contains(10)
                  ? 10
                  : availableRows.first;
          return PaginatedDataTable2(
            key: const ValueKey('dashboard_order_table'),
            isVerticalScrollBarVisible: true,
            columnSpacing: 12,
            minWidth: 786,
            dividerThickness: 0.5,
            horizontalMargin: 12,
            dataRowHeight: 56,
            availableRowsPerPage: availableRows,
            rowsPerPage: rowsPerPage,
            headingTextStyle:
                const TextStyle(fontSize: GoPeduliSize.fontSizeTitle),
            headingRowColor: WidgetStateProperty.resolveWith(
                (states) => GoPeduliColors.primary),
            headingRowDecoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8), topRight: Radius.circular(8))),
            //CheckBox Column
            showCheckboxColumn: false,
            //Pagination
            showFirstLastButtons: true,
            onPageChanged: (value) {},
            renderEmptyRowsInTheEnd: false,
            onRowsPerPageChanged: (noOfRows) {},
            columns: const [
              DataColumn2(
                label: Text(
                  'Order ID',
                  style: TextStyle(
                      color: GoPeduliColors.white,
                      fontSize: GoPeduliSize.fontSizeBody),
                ),
              ),
              DataColumn2(
                label: Text(
                  'Name User',
                  style: TextStyle(
                      color: GoPeduliColors.white,
                      fontSize: GoPeduliSize.fontSizeBody),
                ),
              ),
              DataColumn2(
                  label: Text('Amount',
                      style: TextStyle(
                          color: GoPeduliColors.white,
                          fontSize: GoPeduliSize.fontSizeBody))),
              DataColumn2(
                  label: Text('Fraud Status',
                      style: TextStyle(
                          color: GoPeduliColors.white,
                          fontSize: GoPeduliSize.fontSizeBody))),
              DataColumn2(
                  label: Text('Status',
                      style: TextStyle(
                          color: GoPeduliColors.white,
                          fontSize: GoPeduliSize.fontSizeBody))),
              DataColumn2(
                  label: Text('Transaction Time',
                      style: TextStyle(
                          color: GoPeduliColors.white,
                          fontSize: GoPeduliSize.fontSizeBody))),
            ],
            source:
                OrderRows(controller.recentOrders, controller.orderRepository),
          );
        },
      ),
    );
  }
}
