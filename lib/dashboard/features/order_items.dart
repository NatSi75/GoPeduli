import 'package:flutter/material.dart';
import 'package:gopeduli/dashboard/features/rounded_container.dart';
import 'package:gopeduli/dashboard/helper/size.dart';
import 'package:gopeduli/dashboard/repository/order_model.dart';
import 'package:intl/intl.dart';

class OrderItems extends StatelessWidget {
  const OrderItems({super.key, required this.order});

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
          const Text('Items'),
          const SizedBox(
            height: GoPeduliSize.sizedBoxHeightSmall,
          ),
          ListView.separated(
              itemBuilder: (_, index) {
                final item = order.items[index];
                return Row(
                  children: [
                    Expanded(
                        child: Row(
                      children: [
                        Image.network(item.image, width: 100, height: 100),
                        const SizedBox(
                          width: GoPeduliSize.paddingHeightSmall,
                        ),
                        Expanded(
                            child: Column(
                          children: [
                            Text(
                              item.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ))
                      ],
                    )),
                    Text(formatCurrency(item.price)),
                    Text(item.quantity.toString()),
                  ],
                );
              },
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (_, __) => const SizedBox(
                    height: GoPeduliSize.sizedBoxHeightSmall,
                  ),
              itemCount: order.items.length)
        ],
      ),
    );
  }
}
