import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gopeduli/dashboard/controllers/dashboard/dashboard_controller.dart';
import 'package:gopeduli/dashboard/features/rounded_container.dart';
import 'package:gopeduli/dashboard/helper/color.dart';
import 'package:gopeduli/dashboard/helper/device_utility.dart';
import 'package:gopeduli/dashboard/helper/size.dart';
import 'package:intl/intl.dart';

class WeeklySales extends StatelessWidget {
  const WeeklySales({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());
    return GoPeduliRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weekly Sales',
            style: TextStyle(fontSize: GoPeduliSize.fontSizeSubtitle),
          ),
          const SizedBox(height: GoPeduliSize.paddingHeightSmall),
          // Graph
          SizedBox(
              height: 400,
              child: Obx(
                () => BarChart(
                  BarChartData(
                      titlesData:
                          buildFlTitlesData(controller.weeklySalesDates),
                      borderData: FlBorderData(
                          show: true,
                          border: const Border(
                              top: BorderSide.none,
                              right: BorderSide.none,
                              left: BorderSide.none,
                              bottom: BorderSide(color: Colors.grey))),
                      gridData: const FlGridData(
                          show: true,
                          drawHorizontalLine: true,
                          drawVerticalLine: false,
                          horizontalInterval: 100000),
                      barGroups: controller.weeklySales
                          .asMap()
                          .entries
                          .map((entry) =>
                              BarChartGroupData(x: entry.key, barRods: [
                                BarChartRodData(
                                    width: 30,
                                    toY: entry.value,
                                    color: GoPeduliColors.primary,
                                    borderRadius: BorderRadius.circular(8))
                              ]))
                          .toList(),
                      groupsSpace: GoPeduliSize.paddingHeightSmall,
                      barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                              getTooltipColor: (_) => GoPeduliColors.secondary),
                          touchCallback:
                              GoPeduliDeviceUtility.isDesktopScreen(context)
                                  ? (barTouchEvent, barTouchResponse) {}
                                  : null)),
                ),
              )),
        ],
      ),
    );
  }
}

FlTitlesData buildFlTitlesData(List<DateTime> dates) {
  String formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0)
        .format(amount);
  }

  return FlTitlesData(
    show: true,
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          // Calculate the index and ensure it wraps around for the correct day
          final index = value.toInt() % dates.length;
          if (index < 0 || index >= dates.length) {
            return const SizedBox
                .shrink(); // Kembalikan widget kosong jika indeks tidak valid
          }
          // Get the day corresponding to the calculated index
          final day = dates[index];
          final dayName = DateFormat('EEE').format(day);

          return SideTitleWidget(
            space: 4,
            meta: meta,
            child: Text(
              dayName,
              style: const TextStyle(fontSize: GoPeduliSize.fontSizeSubBody),
            ),
          );
        },
      ),
    ),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        interval: 100000,
        reservedSize: 100,
        getTitlesWidget: (value, meta) {
          return Text(
            formatCurrency(value),
            style: const TextStyle(fontSize: GoPeduliSize.fontSizeSubBody),
          );
        },
      ),
    ),
    topTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    rightTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
  );
}
