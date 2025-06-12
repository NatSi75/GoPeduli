import 'package:flutter/material.dart';
import 'package:gopeduli/dashboard/features/rounded_container.dart';
import 'package:gopeduli/dashboard/helper/device_utility.dart';
import 'package:gopeduli/dashboard/helper/size.dart';
import 'package:gopeduli/dashboard/repository/order_model.dart';
import 'package:intl/intl.dart';

class OrderInfo extends StatelessWidget {
  const OrderInfo({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    String formatCurrency(int amount) {
      return NumberFormat.currency(
              locale: 'id', symbol: 'Rp ', decimalDigits: 0)
          .format(amount);
    }

    return GoPeduliRoundedContainer(
      padding: const EdgeInsets.all(GoPeduliSize.paddingHeightSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Order Information'),
          const SizedBox(
            height: GoPeduliSize.sizedBoxHeightSmall,
          ),
          Row(
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [const Text('Date'), Text(order.formattedDate)],
              )),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Amount'),
                  Text(formatCurrency(order.total))
                ],
              )),
              Expanded(
                  flex: GoPeduliDeviceUtility.isMobileScreen(context) ? 2 : 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [const Text('Status'), Text(order.status)],
                  ))
            ],
          )
        ],
      ),
    );
  }
}
