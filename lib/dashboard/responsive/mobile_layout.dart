import 'package:flutter/material.dart';
import 'package:gopeduli/dashboard/layouts/headers/header.dart';
import 'package:gopeduli/dashboard/layouts/sidebars/sidebar.dart';

class MobileLayout extends StatelessWidget {
  MobileLayout({super.key, this.body});

  final Widget? body;

  final GlobalKey<ScaffoldState>? scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        drawer: const GoPeduliSidebar(),
        appBar: GoPeduliHeader(
          scaffoldKey: scaffoldKey,
        ),
        body: body ?? const SizedBox());
  }
}
