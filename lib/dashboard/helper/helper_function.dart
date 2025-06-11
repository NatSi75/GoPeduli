import 'package:flutter/material.dart';
import 'package:gopeduli/dashboard/helper/enums.dart';

class GoPeduliHelperFunction {
  static DateTime getStartOfWeek(DateTime date) {
    final int daysUntilMonday = date.weekday - 1;
    final DateTime startOfWeek = date.subtract(Duration(days: daysUntilMonday));
    return DateTime(
        startOfWeek.year, startOfWeek.month, startOfWeek.day, 0, 0, 0, 0, 0);
  }

  static Color getOrderStatusColor(OrderStatus value) {
    if (OrderStatus.pending == value) {
      return Colors.orange;
    } else if (OrderStatus.proccessing == value) {
      return Colors.blue;
    } else if (OrderStatus.ready == value) {
      return Colors.lightBlueAccent;
    } else if (OrderStatus.shipped == value) {
      return Colors.purple;
    } else if (OrderStatus.delivered == value) {
      return Colors.green;
    } else if (OrderStatus.completed == value) {
      return Colors.teal;
    } else if (OrderStatus.completed == value) {
      return Colors.red;
    } else {
      return Colors.grey; // Default color for unknown status
    }
  }
}
