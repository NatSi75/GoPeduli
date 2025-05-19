import 'package:flutter/material.dart';
import 'package:gopeduli/dashboard/layouts/templates/site_layout.dart';
import 'package:gopeduli/dashboard/screens/dashboard/dashboard_desktop.dart';
import 'package:gopeduli/dashboard/screens/dashboard/dashboard_mobile.dart';
import 'package:gopeduli/dashboard/screens/dashboard/dashboard_tablet.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return const GoPeduliSiteTemplate(
        desktop: DashboardDesktopScreen(),
        tablet: DashboardTabletScreen(),
        mobile: DashboardMobileScreen());
  }
}
