import 'package:flutter/material.dart';
import 'package:gopeduli/dashboard/layouts/templates/site_layout.dart';
import 'package:gopeduli/dashboard/screens/medicines/allMedicine/medicines_desktop.dart';
import 'package:gopeduli/dashboard/screens/medicines/allMedicine/medicines_mobile.dart';
import 'package:gopeduli/dashboard/screens/medicines/allMedicine/medicines_tablet.dart';

class MedicinesScreen extends StatefulWidget {
  const MedicinesScreen({super.key});

  @override
  State<MedicinesScreen> createState() => _MedicinesScreenState();
}

class _MedicinesScreenState extends State<MedicinesScreen> {
  @override
  Widget build(BuildContext context) {
    return const GoPeduliSiteTemplate(
        desktop: MedicinesDesktop(),
        tablet: MedicinesTablet(),
        mobile: MedicinesMobile());
  }
}
