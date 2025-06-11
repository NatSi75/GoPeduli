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
    generateSnapToken(); // Generate Snap Token saat layar dibuka
    startCountdown();
  }

  void generateSnapToken() async {
    final url = Uri.parse(
        'https://us-central1-gopeduli-4f028.cloudfunctions.net/createSnapToken');

    final user = FirebaseAuth.instance.currentUser;
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();
    final email = userDoc.get('Email') ?? 'user@example.com';
    final name = userDoc.get('Name') ?? 'User';

    final totalAmount = widget.items
        .fold<double>(0.0, (sum, item) => sum + (item.price * item.quantity))
        .toInt();

    final body = {
      "amount": totalAmount,
      "customer": {
        "first_name": name,
        "email": email,
      },
      "user_id": user?.uid,
      "items": widget.items
          .map((item) => {
                "name": item.name,
                "quantity": item.quantity,
                "price": item.price,
                "image": item.imageUrl,
              })
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
        startPolling(); // Mulai polling setelah dapat orderId
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

  @override
  Widget build(BuildContext context) {
    double total =
        widget.items.fold(0, (sum, item) => sum + (item.price * item.quantity));
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
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Payment',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: whiteColor,
            fontSize: 18,
          ),
        ),
        leading: const BackButton(color: whiteColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // SECTION: QR Code
            const SizedBox(height: 10),
            const Text(
              'Scan here to pay',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            qrData == null
                ? const CircularProgressIndicator()
                : QrImageView(
                    data: qrData!,
                    version: QrVersions.auto,
                    size: 210,
                    backgroundColor: whiteColor,
                  ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.timer_outlined, color: Colors.redAccent),
                const SizedBox(width: 6),
                Text(
                  '${formattedTime}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.red.shade400,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            // SECTION: Order Summary
            const SizedBox(height: 36),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.shopping_bag_outlined,
                          color: primaryColor, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Order Summary',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...widget.items.map((item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              child: Image.network(
                                item.imageUrl,
                                width: 70,
                                height: 80,
                                fit: BoxFit.fill,
                              ),
                            ),
                            const SizedBox(width: 40),
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
                                  const SizedBox(height: 2),
                                  Text(
                                    'x${item.quantity}',
                                    style: TextStyle(
                                      color: textGray,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              formatRupiah(item.price * item.quantity),
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      )),
                  const Divider(height: 30),
                  _buildSummaryRow('Subtotal', total,
                      icon: Icons.attach_money_outlined),
                  _buildSummaryRow('Tax (10%)', tax, icon: Icons.receipt_long),
                  const SizedBox(height: 6),
                  _buildSummaryRow('Total', finalTotal,
                      isTotal: true, icon: Icons.payment_outlined),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String title, double value,
      {bool isTotal = false, IconData? icon}) {
    final Color primaryColor = const Color(0xff199a8e); // hijau kesehatan
    final Color bgColor =
        const Color(0xffd0f0e9); // hijau terang untuk background total

    Widget content = Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (icon != null)
                Icon(
                  icon,
                  size: 18,
                  color: isTotal ? Colors.black : Colors.grey[700],
                ),
              if (icon != null) const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: isTotal ? 16 : 14,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                  color: isTotal ? Colors.black : Colors.black87,
                ),
              ),
            ],
          ),
          Text(
            formatRupiah(value),
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.black : Colors.black87,
            ),
          ),
        ],
      ),
    );

    // Jika total, bungkus dengan container berwarna
    return isTotal
        ? Container(
            decoration: BoxDecoration(
              color: bgColor,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: content,
          )
        : content;
  }
}
