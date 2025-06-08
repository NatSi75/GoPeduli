import 'package:flutter/material.dart';
import 'package:gopeduli/dashboard/layouts/templates/site_layout.dart';
import 'package:gopeduli/dashboard/screens/couriers/createCourier/create_courier_desktop.dart';
import 'package:gopeduli/dashboard/screens/couriers/createCourier/create_courier_mobile.dart';
import 'package:gopeduli/dashboard/screens/couriers/createCourier/create_courier_tablet.dart';

class CreateCourierScreen extends StatelessWidget {
  const CreateCourierScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const GoPeduliSiteTemplate(
        desktop: CreateCourierDesktop(),
        tablet: CreateCourierTablet(),
        mobile: CreateCourierMobile());
  }
}
