import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gopeduli/dashboard/controllers/medicine/medicine_controller.dart';
import 'package:gopeduli/dashboard/helper/color.dart';
import 'package:gopeduli/dashboard/helper/size.dart';
import 'package:material_symbols_icons/symbols.dart';

class GoPeduliPaginatedTableMedicine extends StatelessWidget {
  const GoPeduliPaginatedTableMedicine({super.key});

  @override
  Widget build(BuildContext context) {
    final MedicineController controller = Get.put(MedicineController());
    return Obx(
      () {
        //Orders & Selected Rows are Hidden => just to update the UI => Obx => [ProductRows]
        Visibility(
          visible: false,
          child: Text(controller.filteredMedicines.length.toString()),
        );

        return SizedBox(
          height: 574,
          child: Theme(
            //Use to set the Backend color
            data: Theme.of(context).copyWith(
                cardTheme:
                    const CardThemeData(color: GoPeduliColors.white, elevation: 0)),
            child: PaginatedDataTable2(
              isVerticalScrollBarVisible: true,
              columnSpacing: 12,
              minWidth: 786,
              dividerThickness: 0.5,
              horizontalMargin: 12,
              dataRowHeight: 80,
              rowsPerPage: defaultRowsPerPage,
              headingTextStyle: Theme.of(context).textTheme.titleMedium,
              headingRowColor: WidgetStateProperty.resolveWith(
                  (states) => GoPeduliColors.primary),
              headingRowDecoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8))),
              //CheckBox Column
              showCheckboxColumn: false,
              //Pagination
              showFirstLastButtons: true,
              onPageChanged: (value) {},
              renderEmptyRowsInTheEnd: false,
              onRowsPerPageChanged: (noOfRows) {},
              availableRowsPerPage: const <int>[
                defaultRowsPerPage,
                defaultRowsPerPage * 2
              ],
              //Sorting
              sortAscending: controller.sortAscending.value,
              sortArrowAlwaysVisible: true,
              sortArrowIcon: Symbols.line_axis,
              sortColumnIndex: controller.sortColumnIndex.value,
              sortArrowBuilder: (bool ascending, bool sorted) {
                if (sorted) {
                  return Icon(
                    ascending
                        ? Symbols.arrow_upward_rounded
                        : Symbols.arrow_downward_rounded,
                    size: GoPeduliSize.iconSmall,
                  );
                } else {
                  return const Icon(
                    Symbols.swap_vert_rounded,
                    size: GoPeduliSize.iconSmall,
                  );
                }
              },
              columns: [
                const DataColumn2(
                  label: Text('Image',
                      style: TextStyle(color: GoPeduliColors.white)),
                ),
                DataColumn2(
                    label: const Text('Name Product',
                        style: TextStyle(color: GoPeduliColors.white)),
                    onSort: (columnIndex, ascending) =>
                        controller.sortByNameProduct(columnIndex, ascending)),
                const DataColumn2(
                    label: Text('Description',
                        style: TextStyle(color: GoPeduliColors.white))),
                DataColumn2(
                    label: const Text('Name Medicine',
                        style: TextStyle(color: GoPeduliColors.white)),
                    onSort: (columnIndex, ascending) =>
                        controller.sortByNameMedicine(columnIndex, ascending)),
                DataColumn2(
                    label: const Text('Category',
                        style: TextStyle(color: GoPeduliColors.white)),
                    onSort: (columnIndex, ascending) =>
                        controller.sortByNameCategory(columnIndex, ascending)),
                DataColumn2(
                    label: const Text('Class',
                        style: TextStyle(color: GoPeduliColors.white)),
                    onSort: (columnIndex, ascending) =>
                        controller.sortByClassMedicine(columnIndex, ascending)),
                DataColumn2(
                    label: const Text('Price',
                        style: TextStyle(color: GoPeduliColors.white)),
                    onSort: (columnIndex, ascending) =>
                        controller.sortByPrice(columnIndex, ascending)),
                DataColumn2(
                    label: const Text('Stock',
                        style: TextStyle(color: GoPeduliColors.white)),
                    onSort: (columnIndex, ascending) =>
                        controller.sortByStock(columnIndex, ascending)),
                const DataColumn2(
                    label: Text('Action',
                        style: TextStyle(color: GoPeduliColors.white)),
                    fixedWidth: 100),
              ],
              source: MyDataMedicine(),
            ),
          ),
        );
      },
    );
  }
}
