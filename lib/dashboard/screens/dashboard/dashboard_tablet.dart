import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gopeduli/dashboard/controllers/dashboard/dashboard_controller.dart';
import 'package:gopeduli/dashboard/features/dashboard_card.dart';
import 'package:gopeduli/dashboard/features/data_table.dart';
import 'package:gopeduli/dashboard/features/order_status_graph.dart';
import 'package:gopeduli/dashboard/features/rounded_container.dart';
import 'package:gopeduli/dashboard/features/weekly_sales.dart';
import 'package:gopeduli/dashboard/helper/size.dart';

class DashboardTabletScreen extends StatelessWidget {
  const DashboardTabletScreen({super.key});

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
              //Cards
              Obx(
                // Obx for the first row of cards
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
                  ],
                ),
              ),
              const SizedBox(height: GoPeduliSize.paddingHeightSmall),
              Obx(
                // Obx for the second row of cards
                () => Row(
                  children: [
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
                          title: 'Users',
                          subTitle: controller.totalUsers.value
                              .toString(), // Display total users
                          stats: controller.usersComparisonPercentage.value,
                          comparisonText: 'Compared to previous month'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: GoPeduliSize.paddingHeightSmall),

              // Bar Graph
              const WeeklySales(),
              const SizedBox(height: GoPeduliSize.paddingHeightSmall),

              // Orders
              GoPeduliRoundedContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recent Orders',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: GoPeduliSize.paddingHeightSmall),
                    const DashboardOrderTable(),
                  ],
                ),
              ),
              const SizedBox(height: GoPeduliSize.paddingHeightSmall),

              //Pie Chart
              const OrderStatusGraph(),
            ],
          ),
        ),
      ),
    );
  }
}
