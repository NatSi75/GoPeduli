import 'package:flutter/material.dart';
import 'package:gopeduli/dashboard/layouts/templates/site_layout.dart';
import 'package:gopeduli/dashboard/screens/couriers/allCourier/couriers_desktop.dart';
import 'package:gopeduli/dashboard/screens/couriers/allCourier/couriers_mobile.dart';
import 'package:gopeduli/dashboard/screens/couriers/allCourier/couriers_tablet.dart';

class CouriersScreen extends StatelessWidget {
  const CouriersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const GoPeduliSiteTemplate(
        desktop: CouriersDesktop(),
        tablet: CouriersTablet(),
        mobile: CouriersMobile());
  }
}
