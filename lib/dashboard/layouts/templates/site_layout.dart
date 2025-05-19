import 'package:flutter/material.dart';
import 'package:gopeduli/dashboard/reponsive_design.dart';
import 'package:gopeduli/dashboard/responsive/desktop_layout.dart';
import 'package:gopeduli/dashboard/responsive/mobile_layout.dart';
import 'package:gopeduli/dashboard/responsive/tablet_layout.dart';

class GoPeduliSiteTemplate extends StatelessWidget {
  const GoPeduliSiteTemplate(
      {super.key,
      this.mobile,
      this.tablet,
      this.desktop,
      this.useLayout = true});

  final Widget? mobile;
  final Widget? tablet;
  final Widget? desktop;
  final bool useLayout;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoPeduliResponsiveWidget(
          mobile: useLayout
              ? MobileLayout(
                  body: mobile ?? desktop,
                )
              : mobile ?? desktop ?? Container(),
          tablet: useLayout
              ? TabletLayout(
                  body: tablet ?? desktop,
                )
              : tablet ?? desktop ?? Container(),
          desktop: useLayout
              ? DesktopLayout(
                  body: desktop,
                )
              : desktop ?? Container()),
    );
  }
}
