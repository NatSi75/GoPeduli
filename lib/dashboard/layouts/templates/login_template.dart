import 'package:flutter/material.dart';
import 'package:gopeduli/dashboard/helper/color.dart';

class LoginTemplate extends StatelessWidget {
  const LoginTemplate({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 350,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: GoPeduliColors.primary,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
