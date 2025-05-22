import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:gopeduli/dashboard/layouts/templates/site_layout.dart';
import 'package:gopeduli/dashboard/screens/medicines/editMedicine/edit_medicine_desktop.dart';
import 'package:gopeduli/dashboard/screens/medicines/editMedicine/edit_medicine_mobile.dart';
import 'package:gopeduli/dashboard/screens/medicines/editMedicine/edit_medicine_tablet.dart';

class EditMedicineScreen extends StatelessWidget {
  const EditMedicineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final medicine = Get.arguments;
    return GoPeduliSiteTemplate(
        desktop: EditMedicineDesktop(
          medicine: medicine,
        ),
        tablet: EditMedicineTablet(medicine: medicine),
        mobile: EditMedicineMobile(medicine: medicine));
  }
}
