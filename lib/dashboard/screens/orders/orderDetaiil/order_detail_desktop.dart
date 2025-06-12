import 'package:flutter/material.dart';
import 'package:gopeduli/dashboard/features/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:gopeduli/dashboard/features/order_customer.dart';
import 'package:gopeduli/dashboard/features/order_info.dart';
import 'package:gopeduli/dashboard/features/order_items.dart';
import 'package:gopeduli/dashboard/helper/size.dart';
import 'package:gopeduli/dashboard/repository/order_model.dart';
import 'package:gopeduli/dashboard/routes/routes.dart';

class OrderDetailDesktop extends StatelessWidget {
  const OrderDetailDesktop({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(GoPeduliSize.paddingHeightSmall),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GoPeduliBreadCrumbsWithHeading(
                  returnToPreviousScreen: true,
                  heading: order.orderId,
                  breadcrumbItems: const [GoPeduliRoutes.orders, 'Details']),
              const SizedBox(
                height: GoPeduliSize.sizedBoxHeightSmall,
              ),

              // Body
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Side Order Information
                  Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          // Order Info
                          OrderInfo(order: order),
                          const SizedBox(
                            height: GoPeduliSize.sizedBoxHeightSmall,
                          ),

                          // Items
                          OrderItems(order: order),
                          const SizedBox(
                            height: GoPeduliSize.sizedBoxHeightSmall,
                          ),
                        ],
                      )),
                  const SizedBox(
                    width: GoPeduliSize.sizedBoxHeightSmall,
                  ),

                  // Right Side Order Orders
                  Expanded(
                      child: Column(
                    children: [
                      // Customer Info
                      OrderCustomer(order: order),
                      const SizedBox(
                        height: GoPeduliSize.sizedBoxHeightSmall,
                      ),
                    ],
                  ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
