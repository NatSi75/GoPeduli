import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gopeduli/dashboard/controllers/order/order_controller.dart';
import 'package:gopeduli/dashboard/features/rounded_container.dart';
import 'package:gopeduli/dashboard/helper/device_utility.dart';
import 'package:gopeduli/dashboard/helper/size.dart';
import 'package:gopeduli/dashboard/repository/order_model.dart';
import 'package:intl/intl.dart';

class OrderCustomer extends StatelessWidget {
  const OrderCustomer({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderController());
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Personal Info
      GoPeduliRoundedContainer(
        padding: const EdgeInsets.all(GoPeduliSize.paddingHeightSmall),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Customer'),
            const SizedBox(
              height: GoPeduliSize.paddingHeightSmall,
            ),
            Row(
              children: [
                Expanded(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      final name =
                          controller.userNames[order.userId] ?? 'Loading...';
                      return Text(name);
                    }),
                    Obx(() {
                      final email =
                          controller.userEmails[order.userId] ?? 'Loading...';
                      return Text(email);
                    }),
                  ],
                ))
              ],
            )
          ],
        ),
      )
    ]);
  }
}
