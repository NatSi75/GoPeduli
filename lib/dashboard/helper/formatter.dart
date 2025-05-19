import 'package:intl/intl.dart';

class GoPeduliFormatter {
  static String formatDate(DateTime? date) {
    date ??= DateTime.now();
    final onlyDate = DateFormat('dd/MM/yyyy').format(date);
    final onlyTime = DateFormat('hh:mm').format(date);
    return '$onlyDate at $onlyTime';
  }

  static String formatCurrency(double amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(amount);
  }

  static String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.length == 11) {
      return '(${phoneNumber.substring(0, 2)})-${phoneNumber.substring(3, 6)}-${phoneNumber.substring(7)}';
    } else if (phoneNumber.length == 12) {
      return '(${phoneNumber.substring(0, 3)})-${phoneNumber.substring(4, 7)}-${phoneNumber.substring(8)}';
    }
    return phoneNumber;
  }
}
