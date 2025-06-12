import 'package:flutter/material.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../screens/home_screen.dart';
import '../screens/shop_screen.dart';
import '../screens/message_list_screen.dart';
import '../screens/transaction_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/order_screen.dart';

/// Ini widget utama yang pertama kali dipanggil.
/// Mengecek role dari Firebase, lalu mengarahkan ke tampilan user atau kurir.
class Navigation extends StatelessWidget {
  const Navigation({super.key});

  Future<bool> checkIfCourier() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    final role = doc.data()?['Role'] ?? '';

    return role.toString().toLowerCase() == 'courier';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkIfCourier(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text('Terjadi kesalahan saat mengambil role.')),
          );
        }

        final isCourier = snapshot.data ?? false;
        return NavigationBody(isCourier: isCourier);
      },
    );
  }
}

/// Ini widget yang menampilkan bottom navigation bar.
/// Membedakan isi screen & item berdasarkan apakah dia kurir atau bukan.
class NavigationBody extends StatefulWidget {
  final bool isCourier;

  const NavigationBody({super.key, required this.isCourier});

  @override
  State<NavigationBody> createState() => _NavigationBodyState();
}

class _NavigationBodyState extends State<NavigationBody> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    const activeColor = Colors.white;
    const inactiveColor = Color(0xff199A8E);

    final screen = widget.isCourier
        ? [
            const ProfileScreen(),
            const OrderScreen(),
            const MessageListScreen(),
          ]
        : [
            const HomeScreen(),
            const ShopScreen(),
            const MessageListScreen(),
            TransactionScreen(),
            const ProfileScreen(),
          ];

    final items = widget.isCourier
        ? [
            CurvedNavigationBarItem(
              child: Icon(
                Symbols.account_circle_rounded,
                color: currentIndex == 0 ? activeColor : inactiveColor,
              ),
            ),
            CurvedNavigationBarItem(
              child: Icon(
                Symbols.order_approve_rounded,
                color: currentIndex == 1 ? activeColor : inactiveColor,
              ),
            ),
            CurvedNavigationBarItem(
              child: Icon(
                Symbols.chat_rounded,
                color: currentIndex == 2 ? activeColor : inactiveColor,
              ),
            ),
          ]
        : [
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
          ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: IndexedStack(index: currentIndex, children: screen),
      bottomNavigationBar: CurvedNavigationBar(
        height: 55,
        iconPadding: 8,
        animationCurve: Curves.fastOutSlowIn,
        buttonBackgroundColor: const Color(0xff199A8E),
        backgroundColor: Colors.transparent,
        color: const Color(0xffe8f3f1),
        items: items,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
