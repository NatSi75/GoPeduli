import 'package:flutter/material.dart';
import 'package:gopeduli/dashboard/helper/size.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Login',
              style: TextStyle(
                fontSize: GoPeduliSize.fontSizeTitle,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              'Silahkan login untuk melanjutkan',
              style: TextStyle(fontSize: GoPeduliSize.fontSizeSubtitle),
            ),
          ),
        ],
      ),
    );
  }
}
