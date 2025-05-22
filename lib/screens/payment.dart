import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/cart_model.dart';
import 'cart_screen.dart';
import 'transaction.dart';
import 'dart:async';

class PaymentScreen extends StatefulWidget {
  final List<CartItem> items;

  const PaymentScreen({Key? key, required this.items}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late String transactionId;
  late String qrData;
  Duration remainingTime = const Duration(minutes: 1);
  Timer? countdownTimer;

  @override
  void initState() {
    super.initState();
    transactionId = const Uuid().v4();
    qrData = 'https://pembayaran.gopeduli.com/pay/$transactionId';
    startCountdown();
  }

  void startCountdown() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remainingTime.inSeconds > 0) {
        setState(() {
          remainingTime = remainingTime - const Duration(seconds: 1);
        });
      } else {
        countdownTimer?.cancel();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => CartScreen(cartItems: widget.items),
          ),
          (route) => false,
        );
      }
    });
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  // Fungsi helper untuk format Rupiah dengan titik ribuan
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
            letterSpacing: 1.1,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        leading: BackButton(color: whiteColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 220,
                backgroundColor: whiteColor,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              '$formattedTime',
              style: TextStyle(
                fontSize: 19,
                color: const Color.fromARGB(255, 237, 5, 5).withOpacity(0.8),
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 40),

            // Keterangan "Payment Detail" sebelum list produk
            Align(
              alignment: Alignment.center,
              child: Text(
                'Payment Detail',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  color: primaryColor,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // List produk digabung dalam satu container
            Container(
              padding: const EdgeInsets.all(5),
              child: Column(
                children: widget.items.map((item) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2a2c2e),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            item.imageUrl,
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Nama Produk
                              Text(
                                item.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 2),

                              // Harga per satuan dan jumlah
                              Row(
                                children: [
                                  const Icon(Icons.price_change,
                                      color: Colors.greenAccent, size: 13),
                                  const SizedBox(width: 6),
                                  Text(
                                    formatRupiah(item.price),
                                    style: TextStyle(
                                      color:
                                          Colors.greenAccent.withOpacity(0.9),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  const Icon(Icons.confirmation_number_outlined,
                                      color: Colors.amber, size: 13),
                                  const SizedBox(width: 6),
                                  Text(
                                    'x${item.quantity}',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.85),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),

                              // Total Harga
                              Row(
                                children: [
                                  const Icon(Icons.shopping_bag,
                                      size: 18, color: Colors.cyanAccent),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Total: ${formatRupiah(item.price * item.quantity)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.cyanAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),

            // Summary container warna beda, teks dan icon hitam
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: const Color(0xffd4e7e4), // warna beda dari list produk
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  _buildSummaryRow('Subtotal', total, Colors.black,
                      icon: Icons.receipt_long),
                  const Divider(
                      color: Colors.black54, height: 28, thickness: 1),
                  _buildSummaryRow('Tax (10%)', tax, Colors.black,
                      icon: Icons.percent),
                  const Divider(
                      color: Colors.black54, height: 28, thickness: 1),
                  _buildSummaryRow(
                    'Total to Pay',
                    finalTotal,
                    Colors.black,
                    icon: Icons.payment,
                    isTotal: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        TransactionSuccessScreen(items: widget.items),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Buy Now',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, Color textColor,
      {IconData? icon, bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon,
                  color: textColor.withOpacity(0.8), size: isTotal ? 26 : 20),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: isTotal ? 18 : 14, // font size diperkecil
                fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
        Text(
          formatRupiah(amount),
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: textColor,
          ),
        ),
      ],
    );
  }
}
