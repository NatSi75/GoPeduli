import 'package:flutter/material.dart';
import 'package:gopeduli/dashboard/layouts/templates/site_layout.dart';

import 'allUser/users_desktop.dart';
import 'allUser/users_mobile.dart';
import 'allUser/users_tablet.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const GoPeduliSiteTemplate(
        desktop: UsersDesktop(), tablet: UsersTablet(), mobile: UsersMobile());
  }
}
