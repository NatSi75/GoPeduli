import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:gopeduli/dashboard/controllers/medicine/medicine_controller.dart';
import 'package:gopeduli/dashboard/features/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:gopeduli/dashboard/helper/color.dart';
import 'package:gopeduli/dashboard/helper/device_utility.dart';
import 'package:gopeduli/dashboard/helper/size.dart';
import 'package:gopeduli/dashboard/routes/routes.dart';
import 'package:material_symbols_icons/symbols.dart';

class MedicinesDesktop extends StatelessWidget {
  const MedicinesDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final MedicineController controller = Get.put(MedicineController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(GoPeduliSize.paddingHeightLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const GoPeduliBreadCrumbsWithHeading(
                  heading: 'Medicines', breadcrumbItems: ['Medicines']),
              const SizedBox(
                height: GoPeduliSize.sizedBoxHeightSmall,
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: GoPeduliDeviceUtility.isDesktopScreen(context)
                              ? 3
                              : 1,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 200,
                                child: ElevatedButton(
                                    onPressed: () => Get.toNamed(
                                        GoPeduliRoutes.createMedicine),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: GoPeduliColors.primary,
                                        foregroundColor: GoPeduliColors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                GoPeduliSize
                                                    .borderRadiusSmall))),
                                    child: const Text(
                                      'Create New Medicine',
                                      style: TextStyle(
                                          fontSize: GoPeduliSize.fontSizeBody),
                                    )),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: GoPeduliDeviceUtility.isDesktopScreen(context)
                              ? 1
                              : 1,
                          child: TextFormField(
                            controller: controller.searchTextController,
                            onChanged: (query) => controller.searchQuery(query),
                            cursorColor: GoPeduliColors.primary,
                            style: const TextStyle(
                                fontSize: GoPeduliSize.fontSizeBody,
                                color: Colors.black),
                            decoration: const InputDecoration(
                              hintText: 'Search Medicine',
                              prefix: Icon(
                                Symbols.search,
                                size: 14,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: GoPeduliColors.primary, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: GoPeduliColors.primary, width: 1),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(
                    () {
                      //Orders & Selected Rows are Hidden => just to update the UI => Obx => [ProductRows]
                      Visibility(
                        visible: false,
                        child:
                            Text(controller.filteredDataList.length.toString()),
                      );

                      return SizedBox(
                        height: 574,
                        child: Theme(
                          //Use to set the Backend color
                          data: Theme.of(context).copyWith(
                              cardTheme: const CardTheme(
                                  color: GoPeduliColors.white, elevation: 0)),
                          child: PaginatedDataTable2(
                            isVerticalScrollBarVisible: true,
                            columnSpacing: 12,
                            minWidth: 786,
                            dividerThickness: 0.5,
                            horizontalMargin: 12,
                            dataRowHeight: 56,
                            rowsPerPage: defaultRowsPerPage,
                            headingTextStyle:
                                Theme.of(context).textTheme.titleMedium,
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
                            columns: const [
                              DataColumn2(
                                  label: Text('Name Product',
                                      style: TextStyle(
                                          color: GoPeduliColors.white))),
                              DataColumn2(
                                  label: Text('Name Medicine',
                                      style: TextStyle(
                                          color: GoPeduliColors.white))),
                              DataColumn2(
                                  label: Text('Category',
                                      style: TextStyle(
                                          color: GoPeduliColors.white))),
                              DataColumn2(
                                  label: Text('Class',
                                      style: TextStyle(
                                          color: GoPeduliColors.white))),
                              DataColumn2(
                                  label: Text('Price',
                                      style: TextStyle(
                                          color: GoPeduliColors.white))),
                              DataColumn2(
                                  label: Text('Stock',
                                      style: TextStyle(
                                          color: GoPeduliColors.white))),
                              DataColumn2(
                                  label: Text('Action',
                                      style: TextStyle(
                                          color: GoPeduliColors.white)),
                                  fixedWidth: 100),
                            ],
                            source: MyDataMedicine(),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
