import 'package:flutter/material.dart';
import 'package:gopeduli/dashboard/features/authentication/screens/login_form.dart';
import 'package:gopeduli/dashboard/features/authentication/screens/login_header.dart';
import 'package:gopeduli/dashboard/layouts/templates/login_template.dart';

class LoginScreenDesktopTablet extends StatelessWidget {
  const LoginScreenDesktopTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginTemplate(
      child: Column(
        children: [
          //Header
          LoginHeader(),

          LoginForm()
        ],
      ),
    );
  }
}
