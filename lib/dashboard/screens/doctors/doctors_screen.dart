import 'package:flutter/material.dart';
import 'package:gopeduli/dashboard/layouts/templates/site_layout.dart';
import 'package:gopeduli/dashboard/screens/doctors/allDoctor/doctors_desktop.dart';
import 'package:gopeduli/dashboard/screens/doctors/allDoctor/doctors_mobile.dart';
import 'package:gopeduli/dashboard/screens/doctors/allDoctor/doctors_tablet.dart';

class DoctorsScreen extends StatelessWidget {
  const DoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const GoPeduliSiteTemplate(
        desktop: DoctorsDesktop(),
        tablet: DoctorsTablet(),
        mobile: DoctorsMobile());
  }
}
