import 'package:flutter/material.dart';
import 'package:gopeduli/dashboard/layouts/headers/header.dart';
import 'package:gopeduli/dashboard/layouts/sidebars/sidebar.dart';

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({super.key, this.body});

  final Widget? body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Expanded(child: GoPeduliSidebar()),
          Expanded(
              flex: 7,
              child: Column(
                children: [
                  //Header
                  const GoPeduliHeader(),

                  //Body
                  body ?? const SizedBox()
                ],
              ))
        ],
      ),
    );
  }
}
