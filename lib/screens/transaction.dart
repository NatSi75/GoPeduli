import 'package:flutter/material.dart';
import '../models/cart_model.dart';
import '../widgets/navigation.dart';

class TransactionSuccessScreen extends StatelessWidget {
  final List<CartItem> items;

  const TransactionSuccessScreen({Key? key, required this.items})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color bgColor = Color(0xffe8f3f1);
    const Color primaryColor = Color(0xff199a8e);

    return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: primaryColor,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Text(
            'Transaction Complete',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              letterSpacing: 1.1,
            ),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: primaryColor,
                  size: 100,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Payment Successful!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Thank you for your purchase. We have received your payment.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(
                    Icons.home,
                    color: Colors.white, // Ubah warna ikon jadi putih
                  ),
                  label: const Text(
                    'Back to Home',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white, // Ubah warna teks jadi putih
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Navigation());
  }
}
