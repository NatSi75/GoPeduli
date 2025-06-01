import 'package:flutter/material.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../screens/home_screen.dart';
import '../screens/shop_screen.dart';
import '../screens/message_list_screen.dart';
import '../screens/history_screen.dart';
import '../screens/profile_screen.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int currentIndex = 0;
  bool isDarkMode = false;
  final screen = [
    const HomeScreen(),
    const ShopScreen(),
    const MessageListScreen(),
    const HistoryScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    const activeColor = Colors.white;
    const inactiveColor = Color(0xff199A8E);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: IndexedStack(
        index: currentIndex,
        children: screen,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        height: 55,
        iconPadding: 8,
        animationCurve: Curves.fastOutSlowIn,
        buttonBackgroundColor: const Color(0xff199A8E),
        backgroundColor: Colors.transparent,
        color: const Color(0xffe8f3f1),
        items: [
          CurvedNavigationBarItem(
            child: Icon(
              Symbols.home_rounded,
              color: currentIndex == 0 ? activeColor : inactiveColor,
            ),
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Symbols.shopping_bag_rounded,
              color: currentIndex == 1 ? activeColor : inactiveColor,
            ),
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Symbols.chat_rounded,
              color: currentIndex == 2 ? activeColor : inactiveColor,
            ),
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Symbols.order_approve_rounded,
              color: currentIndex == 3 ? activeColor : inactiveColor,
            ),
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Symbols.account_circle_rounded,
              color: currentIndex == 4 ? activeColor : inactiveColor,
            ),
          ),
        ],
        onTap: (index) {
          _onItemTapped(index);
        },
      ),
    );
  }
}
