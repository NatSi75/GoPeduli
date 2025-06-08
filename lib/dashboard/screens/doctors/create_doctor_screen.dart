import 'package:flutter/material.dart';
import 'package:gopeduli/dashboard/layouts/templates/site_layout.dart';
import 'package:gopeduli/dashboard/screens/doctors/createDoctor/create_doctor_desktop.dart';
import 'package:gopeduli/dashboard/screens/doctors/createDoctor/create_doctor_mobile.dart';
import 'package:gopeduli/dashboard/screens/doctors/createDoctor/create_doctor_tablet.dart';

class CreateDoctorScreen extends StatelessWidget {
  const CreateDoctorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const GoPeduliSiteTemplate(
        desktop: CreateDoctorDesktop(),
        tablet: CreateDoctorTablet(),
        mobile: CreateDoctorMobile());
  }
}
