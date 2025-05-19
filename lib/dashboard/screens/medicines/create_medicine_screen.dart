import 'package:flutter/material.dart';
import 'package:gopeduli/dashboard/layouts/templates/site_layout.dart';
import 'package:gopeduli/dashboard/screens/medicines/createMedicine/create_medicine_desktop.dart';
import 'package:gopeduli/dashboard/screens/medicines/createMedicine/create_medicine_mobile.dart';
import 'package:gopeduli/dashboard/screens/medicines/createMedicine/create_medicine_tablet.dart';

class CreateMedicineScreen extends StatelessWidget {
  const CreateMedicineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const GoPeduliSiteTemplate(
        desktop: CreateMedicineDesktop(),
        tablet: CreateMedicineTablet(),
        mobile: CreateMedicineMobile());
  }
}
