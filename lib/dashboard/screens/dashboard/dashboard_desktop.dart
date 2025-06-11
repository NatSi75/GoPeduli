import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gopeduli/dashboard/controllers/dashboard/dashboard_controller.dart';
import 'package:gopeduli/dashboard/features/dashboard_card.dart';
import 'package:gopeduli/dashboard/features/data_table.dart';
import 'package:gopeduli/dashboard/features/order_status_graph.dart';
import 'package:gopeduli/dashboard/features/rounded_container.dart';
import 'package:gopeduli/dashboard/features/weekly_sales.dart';
import 'package:gopeduli/dashboard/helper/size.dart';

class DashboardDesktopScreen extends StatelessWidget {
  const DashboardDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(GoPeduliSize.paddingHeightSmall),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: GoPeduliDashboardCard(
                          title: 'Sales Total',
                          subTitle: controller.formatCurrency(
                              controller.monthlySalesTotal.value),
                          stats: controller.salesComparisonPercentage.value,
                          comparisonText: 'Compared to previous month'),
                    ),
                    const SizedBox(width: GoPeduliSize.paddingHeightSmall),
                    Expanded(
                      child: GoPeduliDashboardCard(
                          title: 'Average Order Value',
                          subTitle: controller.formatCurrency(
                              controller.monthlyAverageOrderValue.value),
                          stats: controller
                              .avgOrderValueComparisonPercentage.value,
                          comparisonText: 'Compared to previous month'),
                    ),
                    const SizedBox(width: GoPeduliSize.paddingHeightSmall),
                    Expanded(
                      child: GoPeduliDashboardCard(
                          title: 'Total Orders',
                          subTitle:
                              controller.monthlyTotalOrders.value.toString(),
                          stats: controller.ordersComparisonPercentage.value,
                          comparisonText: 'Compared to previous month'),
                    ),
                    const SizedBox(width: GoPeduliSize.paddingHeightSmall),
                    Expanded(
                      child: GoPeduliDashboardCard(
                          title: 'Total Users',
                          subTitle: controller.totalUsers.value.toString(),
                          stats: controller.usersComparisonPercentage.value,
                          comparisonText: 'Compared to previous month'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: GoPeduliSize.paddingHeightSmall),

              // Graphs
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        // Bar Graph
                        WeeklySales(),
                        SizedBox(height: GoPeduliSize.paddingHeightSmall),

                        // Orders
                        GoPeduliRoundedContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Recent Orders',
                                style: TextStyle(
                                    fontSize: GoPeduliSize.fontSizeSubtitle),
                              ),
                              SizedBox(height: GoPeduliSize.paddingHeightSmall),
                              DashboardOrderTable(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: GoPeduliSize.paddingHeightSmall),

                  // Pie Chart
                  Expanded(child: OrderStatusGraph())
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
