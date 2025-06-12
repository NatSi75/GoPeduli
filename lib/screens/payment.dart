import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/cart_model.dart';
import 'transaction.dart';
import 'cart_screen.dart';

class PaymentScreen extends StatefulWidget {
  final List<CartItem> items;

  const PaymentScreen({Key? key, required this.items}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late String transactionId;
  String? qrData;
  String? orderId;
  Duration remainingTime = const Duration(minutes: 10);
  Timer? countdownTimer;
  Timer? pollingTimer;

  @override
  void initState() {
    super.initState();
    transactionId = const Uuid().v4();
    generateSnapToken();
    startCountdown();
  }

  void generateSnapToken() async {
    final url = Uri.parse(
      'https://us-central1-gopeduli-4f028.cloudfunctions.net/createSnapToken',
    );

    final user = FirebaseAuth.instance.currentUser;
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();
    final email = userDoc.get('Email') ?? 'user@example.com';
    final name = userDoc.get('Name') ?? 'User';

    // Pakai helper function untuk subtotal, tax, dan total
    final subtotal = calculateSubtotal();
    final tax = calculateTax(subtotal);
    final totalAmount = calculateTotalWithTax().toInt(); // Sudah termasuk pajak

    final body = {
      "amount":
          totalAmount, // Ini yang dikirim ke Midtrans (sudah termasuk pajak)
      "customer": {"first_name": name, "email": email},
      "user_id": user?.uid,
      "items": widget.items
          .map(
            (item) => {
              "name": item.name,
              "quantity": item.quantity,
              "price": item.price,
              "image": item.imageUrl,
            },
          )
          .toList(),
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          qrData =
              "https://app.sandbox.midtrans.com/snap/v2/vtweb/${data['snapToken']}";
          orderId = data['orderId'];
        });
        startPolling();
      } else {
        print("Failed to get snap token: ${response.body}");
      }
    } catch (e) {
      print("Error generating snap token: $e");
    }
  }

  void startCountdown() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remainingTime.inSeconds > 0) {
        setState(() {
          remainingTime = remainingTime - const Duration(seconds: 1);
        });
      } else {
        countdownTimer?.cancel();
        pollingTimer?.cancel();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => CartScreen(cartItems: widget.items),
          ),
          (route) => false,
        );
      }
    });
  }

  void startPolling() {
    pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      if (orderId == null) return;

      final snapshot = await FirebaseFirestore.instance
          .collection('transactions')
          .doc(orderId)
          .get();

      if (snapshot.exists) {
        final status = snapshot.get('status');
        if (status == 'settlement' || status == 'capture') {
          countdownTimer?.cancel();
          pollingTimer?.cancel();

          if (mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => TransactionSuccessScreen(items: widget.items),
              ),
              (route) => false,
            );
          }
        }
      }
    });
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    pollingTimer?.cancel();
    super.dispose();
  }

  String formatRupiah(double amount) {
    final intAmount = amount.toInt();
    final rupiah = intAmount.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match match) => '${match[1]}.',
        );
    return 'Rp $rupiah,00';
  }

  double calculateSubtotal() {
    return widget.items.fold(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );
  }

  double calculateTax(double subtotal) {
    return subtotal * 0.1;
  }

  double calculateTotalWithTax() {
    final subtotal = calculateSubtotal();
    final tax = calculateTax(subtotal);
    return subtotal + tax;
  }

  @override
  Widget build(BuildContext context) {
    double total = widget.items.fold(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );
    double tax = total * 0.1;
    double finalTotal = total + tax;
    String formattedTime =
        '${remainingTime.inMinutes.toString().padLeft(2, '0')}:${(remainingTime.inSeconds % 60).toString().padLeft(2, '0')}';

    const Color bgColor = Color(0xffe8f3f1);
    const Color primaryColor = Color(0xff199a8e);
    const Color whiteColor = Colors.white;
    const Color textGray = Color(0xFF6B7280);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Payment',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: whiteColor,
          ),
        ),
        leading: const BackButton(color: whiteColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 6),
                  const Text(
                    'Scan to Pay',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 14),
                  qrData == null
                      ? const CircularProgressIndicator()
                      : Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: bgColor),
                          ),
                          child: QrImageView(data: qrData!, size: 220),
                        ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.timer_outlined, color: Colors.red),
                        const SizedBox(width: 8),
                        Text(
                          formattedTime,
                          style: TextStyle(
                            color: Colors.red.shade600,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Order Summary
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.shopping_bag_outlined, color: primaryColor),
                      SizedBox(width: 8),
                      Text(
                        'Order Summary',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...widget.items.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Color(0xff199a8e),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                item.imageUrl,
                                width: 65,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'x${item.quantity}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              formatRupiah(item.price * item.quantity),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Divider(),
                  _buildSummaryRow('Subtotal', total),
                  _buildSummaryRow('Tax (10%)', tax),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          formatRupiah(finalTotal),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String title, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            formatRupiah(amount),
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
