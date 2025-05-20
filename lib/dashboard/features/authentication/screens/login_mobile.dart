import 'package:flutter/material.dart';
import 'package:gopeduli/dashboard/features/authentication/screens/login_form.dart';
import 'package:gopeduli/dashboard/features/authentication/screens/login_header.dart';

class LoginScreenMobile extends StatelessWidget {
  const LoginScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            //Header
            LoginHeader(),

            LoginForm()
          ],
        ),
      ),
    );
  }
}
