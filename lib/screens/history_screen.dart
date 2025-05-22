import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  final Color headerColor = const Color(0xFFDDDDDD);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Transaction History",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,),
        ),
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false, // <- menghilangkan tombol back
      ),
      body: ListView(
        children: [
          _buildMonthSection("March 2025", [
            _buildTransactionItem(
              name: "2x Paracetamol 10 Kaplet",
              price: "Rp 15.000,00",
              subtotal: "Rp 30.000,00",
              tax: "Rp 10.500,00",
              total: "Rp 40.500,00",
            ),
            _buildTransactionItem(
              name: "3x Ibuprofen 350ml",
              price: "Rp 25.000,00",
              subtotal: "Rp 75.000,00",
              tax: "Rp 10.500,00",
              total: "Rp 85.500,00",
            ),
          ]),
          _buildMonthSection("February 2025", [
            _buildTransactionItem(
              name: "1x Vicks Inhaler",
              price: "Rp 25.000,00",
              subtotal: "Rp 25.000,00",
              tax: "Rp 10.500,00",
              total: "Rp 35.500,00",
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildMonthSection(String month, List<Widget> transactions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: headerColor,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            month,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        ...transactions,
      ],
    );
  }

  Widget _buildTransactionItem({
    required String name,
    required String price,
    required String subtotal,
    required String tax,
    required String total,
  }) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(price),
            ],
          ),
          const SizedBox(height: 4),
          Text("Subtotal: $subtotal", style: const TextStyle(fontSize: 12)),
          Text("Service + Tax: $tax", style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Total: $total", style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
