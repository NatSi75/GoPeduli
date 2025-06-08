import 'package:flutter/material.dart';
import 'package:gopeduli/dashboard/helper/device_utility.dart';

class GoPeduliHeader extends StatelessWidget implements PreferredSizeWidget {
  const GoPeduliHeader({super.key, this.scaffoldKey});

  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: 1.0,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: AppBar(
        leading: !GoPeduliDeviceUtility.isDesktopScreen(context)
            ? IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => scaffoldKey?.currentState?.openDrawer(),
              )
            : null,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(75.0);
}
