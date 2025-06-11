import 'package:flutter/material.dart';
import 'package:gopeduli/dashboard/layouts/templates/site_layout.dart';
import 'package:gopeduli/dashboard/screens/orders/allOrder/orders_desktop.dart';
import 'package:gopeduli/dashboard/screens/orders/allOrder/orders_mobile.dart';
import 'package:gopeduli/dashboard/screens/orders/allOrder/orders_tablet.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const GoPeduliSiteTemplate(
        desktop: OrdersDesktop(),
        tablet: OrdersTablet(),
        mobile: OrdersMobile());
  }
}
