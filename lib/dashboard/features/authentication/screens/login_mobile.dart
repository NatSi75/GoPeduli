import 'package:flutter/material.dart';
import 'package:gopeduli/dashboard/features/authentication/screens/login_form.dart';
import 'package:gopeduli/dashboard/features/authentication/screens/login_header.dart';
import 'package:gopeduli/dashboard/helper/color.dart';

class LoginScreenMobile extends StatelessWidget {
  const LoginScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: GoPeduliColors.primary,
          ),
          child: const Column(
            children: [
              //Header
              LoginHeader(),

              LoginForm()
            ],
          ),
        ),
      ),
    );
  }
}
