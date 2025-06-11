import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gopeduli/dashboard/features/authentication/user_repository.dart';
import 'package:gopeduli/dashboard/features/popup/loaders.dart';
import 'package:gopeduli/dashboard/helper/enums.dart';
import 'package:gopeduli/dashboard/helper/formatter.dart';
import 'package:gopeduli/dashboard/repository/order_model.dart';
import 'package:gopeduli/dashboard/repository/order_repository.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

class DashboardController extends GetxController {
  static DashboardController get instance => Get.find();
  final orderRepository = Get.put(OrderRepository());
  final userRepository = Get.put(UserRepository());

  final RxList<double> weeklySales = <double>[].obs;
  final RxMap<OrderStatus, int> orderStatusData = <OrderStatus, int>{}.obs;
  final RxMap<OrderStatus, double> totalAmounts = <OrderStatus, double>{}.obs;
  final RxList<DateTime> weeklySalesDates = <DateTime>[].obs;
  final RxList<OrderModel> recentOrders = <OrderModel>[].obs;

  final RxDouble monthlySalesTotal = 0.0.obs;
  final RxDouble monthlyAverageOrderValue = 0.0.obs;
  final RxInt monthlyTotalOrders = 0.obs;
  final RxInt totalUsers = 0.obs;
  final RxInt monthlyNewUsers = 0.obs;

  final RxDouble previousMonthlySalesTotal = 0.0.obs;
  final RxDouble previousMonthlyAverageOrderValue = 0.0.obs;
  final RxInt previousMonthlyTotalOrders = 0.obs;
  final RxInt previousMonthlyTotalUsers = 0.obs;
  final RxInt previousMonthlyNewUsers = 0.obs;

  final RxInt salesComparisonPercentage = 0.obs;
  final Rx<IconData> salesComparisonIcon = Icons.arrow_right_alt.obs;
  final Rx<Color> salesComparisonColor = Colors.grey.obs;

  final RxInt avgOrderValueComparisonPercentage = 0.obs;
  final Rx<IconData> avgOrderValueComparisonIcon = Icons.arrow_right_alt.obs;
  final Rx<Color> avgOrderValueComparisonColor = Colors.grey.obs;

  final RxInt ordersComparisonPercentage = 0.obs;
  final Rx<IconData> ordersComparisonIcon = Icons.arrow_right_alt.obs;
  final Rx<Color> ordersComparisonColor = Colors.grey.obs;

  final RxInt usersComparisonPercentage = 0.obs;
  final Rx<IconData> usersComparisonIcon = Icons.arrow_right_alt.obs;
  final Rx<Color> usersComparisonColor = Colors.grey.obs;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadDashboardData();
  }

  void _loadDashboardData() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final List<OrderModel> ordersForOneDay =
          await orderRepository.getAllOrdersOneDay();
      final List<OrderModel> ordersForSevenDays =
          await orderRepository.getAllOrdersSevenDays();
      final List<OrderModel> ordersForThirtyDays =
          await orderRepository.getAllOrdersThirtyDays();
      final List<OrderModel> ordersForPreviousThirtyDays =
          await orderRepository.getAllOrdersPreviousThirtyDays();

      final int fetchedTotalUsers = await userRepository.getTotalUsers();
      final DateTime now = DateTime.now();
      final DateTime endOfPreviousMonth = DateTime(now.year, now.month, now.day)
          .subtract(const Duration(days: 30));
      final int fetchedPreviousTotalUsers =
          await userRepository.getTotalUsersAtDate(endOfPreviousMonth);
      final int fetchedMonthlyNewUsers =
          await userRepository.getNewUsersMonthly();
      final int fetchedPreviousMonthlyNewUsers =
          await userRepository.getNewUsersPreviousMonthly();

      _calculateMonthlyMetrics(ordersForThirtyDays);
      totalUsers.value = fetchedTotalUsers;
      monthlyNewUsers.value = fetchedMonthlyNewUsers;

      _calculatePreviousMonthlyMetrics(ordersForPreviousThirtyDays);
      previousMonthlyTotalUsers.value = fetchedPreviousTotalUsers;
      previousMonthlyNewUsers.value = fetchedPreviousMonthlyNewUsers;

      _performComparisons();

      _calculateWeeklySales(ordersForSevenDays);
      _calculateOrderStatusData(ordersForOneDay);
      _fetchRecentOrders(ordersForOneDay);
    } catch (e) {
      GoPeduliLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  // Calculate weekly sales
  void _calculateWeeklySales(List<OrderModel> orders) async {
    weeklySales.clear();
    weeklySalesDates.clear();

    final Map<String, double> dailySalesMap = {};

    final DateTime now = DateTime.now();
    final List<DateTime> last7Days = List.generate(7, (index) {
      return DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: 6 - index));
    });

    for (var date in last7Days) {
      dailySalesMap[GoPeduliFormatter.formatDateWeekly(date)] = 0.0;
      weeklySalesDates.add(date);
    }

    for (var order in orders) {
      if (order.createdAt != null &&
          order.status.toLowerCase() == 'completed') {
        final orderDateString =
            GoPeduliFormatter.formatDateWeekly(order.createdAt!);
        if (dailySalesMap.containsKey(orderDateString)) {
          dailySalesMap[orderDateString] =
              (dailySalesMap[orderDateString] ?? 0.0) + order.total.toDouble();
        }
      }
    }

    for (var date in last7Days) {
      final dateString = GoPeduliFormatter.formatDateWeekly(date);
      weeklySales.add(dailySalesMap[dateString] ?? 0.0);
    }
  }

  // Calculate order status data
  void _calculateOrderStatusData(List<OrderModel> orders) async {
    orderStatusData.clear();
    totalAmounts.clear();

    for (var status in OrderStatus.values) {
      orderStatusData[status] = 0;
      totalAmounts[status] = 0.0;
    }

    for (var order in orders) {
      OrderStatus? statusEnum;
      switch (order.status.toLowerCase()) {
        case 'pending':
          statusEnum = OrderStatus.pending;
          break;
        case 'processing':
          statusEnum = OrderStatus.proccessing;
          break;
        case 'ready':
          statusEnum = OrderStatus.ready;
          break;
        case 'shipped':
          statusEnum = OrderStatus.shipped;
          break;
        case 'delivered':
          statusEnum = OrderStatus.delivered;
          break;
        case 'completed':
          statusEnum = OrderStatus.completed;
          break;
        case 'cancelled':
          statusEnum = OrderStatus.cancelled;
          break;
        default:
          continue;
      }

      orderStatusData[statusEnum] = (orderStatusData[statusEnum] ?? 0) + 1;
      totalAmounts[statusEnum] =
          (totalAmounts[statusEnum] ?? 0.0) + order.total.toDouble();
    }
  }

  void _fetchRecentOrders(List<OrderModel> orders) async {
    recentOrders.clear();
    try {
      orders.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      recentOrders.assignAll(orders);
    } catch (e) {
      GoPeduliLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  void _calculateMonthlyMetrics(List<OrderModel> orders) {
    double totalSales = 0.0;
    int totalOrdersCount = 0;

    for (var order in orders) {
      if (order.status.toLowerCase() == 'completed') {
        totalSales += order.total.toDouble();
        totalOrdersCount++;
      }
    }

    monthlySalesTotal.value = totalSales;
    monthlyTotalOrders.value = totalOrdersCount;

    if (totalOrdersCount > 0) {
      monthlyAverageOrderValue.value = totalSales / totalOrdersCount;
    } else {
      monthlyAverageOrderValue.value = 0.0;
    }
  }

  void _calculatePreviousMonthlyMetrics(List<OrderModel> orders) {
    double totalSales = 0.0;
    int totalOrdersCount = 0;

    for (var order in orders) {
      if (order.status.toLowerCase() == 'completed') {
        totalSales += order.total.toDouble();
        totalOrdersCount++;
      }
    }

    previousMonthlySalesTotal.value = totalSales;
    previousMonthlyTotalOrders.value = totalOrdersCount;

    if (totalOrdersCount > 0) {
      previousMonthlyAverageOrderValue.value = totalSales / totalOrdersCount;
    } else {
      previousMonthlyAverageOrderValue.value = 0.0;
    }
  }

  void _performComparisons() {
    // Sales Total
    _updateComparison(
      currentValue: monthlySalesTotal.value,
      previousValue: previousMonthlySalesTotal.value,
      percentageRx: salesComparisonPercentage,
      iconRx: salesComparisonIcon,
      colorRx: salesComparisonColor,
    );

    // Average Order Value
    _updateComparison(
      currentValue: monthlyAverageOrderValue.value,
      previousValue: previousMonthlyAverageOrderValue.value,
      percentageRx: avgOrderValueComparisonPercentage,
      iconRx: avgOrderValueComparisonIcon,
      colorRx: avgOrderValueComparisonColor,
    );

    // Total Orders
    _updateComparison(
      currentValue: monthlyTotalOrders.value.toDouble(),
      previousValue: previousMonthlyTotalOrders.value.toDouble(),
      percentageRx: ordersComparisonPercentage,
      iconRx: ordersComparisonIcon,
      colorRx: ordersComparisonColor,
    );

    // Total Users
    _updateComparison(
      currentValue: totalUsers.value.toDouble(),
      previousValue: previousMonthlyTotalUsers.value.toDouble(),
      percentageRx: usersComparisonPercentage,
      iconRx: usersComparisonIcon,
      colorRx: usersComparisonColor,
    );
  }

  // Helper method for comparison logic
  void _updateComparison({
    required double currentValue,
    required double previousValue,
    required RxInt percentageRx,
    required Rx<IconData> iconRx,
    required Rx<Color> colorRx,
  }) {
    if (previousValue == 0) {
      // If previous value is 0, and current is > 0, it's infinite growth (show 100% up)
      if (currentValue > 0) {
        percentageRx.value = 100;
        iconRx.value = Symbols.arrow_upward_rounded;
        colorRx.value = Colors.green;
      } else {
        // Both are 0
        percentageRx.value = 0;
        iconRx.value = Icons.arrow_right_alt;
        colorRx.value = Colors.grey;
      }
    } else {
      final double change = currentValue - previousValue;
      final double percentage = (change / previousValue) * 100;
      percentageRx.value =
          percentage.abs().toInt(); // Absolute value for display

      if (change > 0) {
        iconRx.value = Symbols.arrow_upward_rounded;
        colorRx.value = Colors.green;
      } else if (change < 0) {
        iconRx.value = Symbols.arrow_downward_rounded;
        colorRx.value = Colors.red;
      } else {
        iconRx.value = Icons.arrow_right_alt;
        colorRx.value = Colors.grey;
      }
    }
  }

  OrderStatus getStatusEnumFromString(String statusString) {
    switch (statusString.toLowerCase()) {
      case 'pending':
        return OrderStatus.pending;
      case 'processing':
        return OrderStatus.proccessing;
      case 'ready':
        return OrderStatus.ready;
      case 'shipped':
        return OrderStatus.shipped;
      case 'delivered':
        return OrderStatus.delivered;
      case 'completed':
        return OrderStatus.completed;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending; // Default if unknown
    }
  }

  String getDisplayStatusName(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.proccessing:
        return 'Processing';
      case OrderStatus.ready:
        return 'Ready';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  String formatCurrency(double amount) {
    return NumberFormat.currency(
            locale: 'id_ID', symbol: 'Rp', decimalDigits: 0)
        .format(amount);
  }
}
