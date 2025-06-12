import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gopeduli/dashboard/layouts/templates/site_layout.dart';
import 'package:gopeduli/dashboard/screens/orders/orderDetaiil/order_detail_desktop.dart';
import 'package:gopeduli/dashboard/screens/orders/orderDetaiil/order_detail_mobile.dart';
import 'package:gopeduli/dashboard/screens/orders/orderDetaiil/order_detail_tablet.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final order = Get.arguments;
    return GoPeduliSiteTemplate(
        desktop: OrderDetailDesktop(order: order),
        tablet: OrderDetailTablet(order: order),
        mobile: OrderDetailMobile(order: order));
  }
}
