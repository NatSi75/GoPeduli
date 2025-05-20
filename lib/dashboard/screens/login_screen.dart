import 'package:flutter/material.dart';
import 'package:gopeduli/dashboard/features/authentication/screens/login_desktop_table.dart';
import 'package:gopeduli/dashboard/features/authentication/screens/login_mobile.dart';
import 'package:gopeduli/dashboard/layouts/templates/site_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return const GoPeduliSiteTemplate(
      useLayout: false,
      desktop: LoginScreenDesktopTablet(),
      mobile: LoginScreenMobile(),
    );
  }
}
