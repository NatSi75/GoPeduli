import 'package:flutter/material.dart';
import 'package:gopeduli/dashboard/helper/color.dart';
import 'package:gopeduli/dashboard/helper/size.dart';
import 'package:gopeduli/dashboard/layouts/sidebars/menu_item.dart';
import 'package:gopeduli/dashboard/routes/routes.dart';
import 'package:material_symbols_icons/symbols.dart';

class GoPeduliSidebar extends StatelessWidget {
  const GoPeduliSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const BeveledRectangleBorder(),
      child: Container(
        decoration: BoxDecoration(
            color: GoPeduliColors.white,
            border: Border(
              right: BorderSide(
                color: Colors.grey.shade300,
                width: 1.0,
              ),
            )),
        child: const SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: GoPeduliSize.paddingHeightSmall),
                child: CircleAvatar(
                  backgroundColor: GoPeduliColors.white,
                  radius: 50,
                  backgroundImage: AssetImage(
                      'assets/images/logo.png'), // Replace with your image URL
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: GoPeduliSize.paddingHeightUltraSmall,
                    horizontal: GoPeduliSize.paddingHeightSmall),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Menu',
                      style: TextStyle(
                          fontSize: GoPeduliSize.fontSizeSubtitle,
                          letterSpacing: 1.1),
                    ),
                    GoPeduliMenuItem(
                      route: GoPeduliRoutes.dashboard,
                      icon: Symbols.dashboard_rounded,
                      itemName: 'Dashboard',
                    ),
                    GoPeduliMenuItem(
                      route: GoPeduliRoutes.articles,
                      icon: Symbols.article_rounded,
                      itemName: 'Articles',
                    ),
                    GoPeduliMenuItem(
                      route: GoPeduliRoutes.medicines,
                      icon: Symbols.medication_rounded,
                      itemName: 'Medicines',
                    ),
                    GoPeduliMenuItem(
                      route: GoPeduliRoutes.orders,
                      icon: Symbols.orders_rounded,
                      itemName: 'Orders',
                    ),
                    GoPeduliMenuItem(
                      route: GoPeduliRoutes.doctors,
                      icon: Symbols.masks_rounded,
                      itemName: 'Doctors',
                    ),
                    GoPeduliMenuItem(
                      route: GoPeduliRoutes.authors,
                      icon: Symbols.person_edit_rounded,
                      itemName: 'Authors',
                    ),
                    GoPeduliMenuItem(
                      route: GoPeduliRoutes.users,
                      icon: Symbols.user_attributes_rounded,
                      itemName: 'Users',
                    ),
                    GoPeduliMenuItem(
                      route: GoPeduliRoutes.couriers,
                      icon: Symbols.directions_bike_rounded,
                      itemName: 'Couriers',
                    ),
                    Text(
                      'Other',
                      style: TextStyle(
                          fontSize: GoPeduliSize.fontSizeSubtitle,
                          letterSpacing: 1.1),
                    ),
                    GoPeduliMenuItem(
                      route: GoPeduliRoutes.logout,
                      icon: Symbols.logout_rounded,
                      itemName: 'Logout',
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
