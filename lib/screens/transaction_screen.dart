import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  String formatRupiah(int amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  String formatDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    final formatter = DateFormat('yyyy-MM-dd HH.mm');
    return formatter.format(date);
  }

  Future<void> completeOrder(String docId, BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('transactions')
        .doc(docId)
        .update({'status': 'completed'});

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("order completed!")));
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Center(
        child: Text('You must be logged in to view transactions.'),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          children: [
            // Custom AppBar ala shop_screen
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Transaction',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('transactions')
                    .where('user_id', isEqualTo: currentUser.uid)
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No transactions found.'));
                  }

                  final allTransactions = snapshot.data!.docs;

                  // Pisahkan completed dan non-completed
                  final notCompleted = allTransactions
                      .where((doc) => doc['status'] != 'completed')
                      .toList();
                  final completed = allTransactions
                      .where((doc) => doc['status'] == 'completed')
                      .toList();

                  final transactions = [...notCompleted, ...completed];

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      final items = transaction['items'] as List<dynamic>;
                      final status = transaction['status'] ?? 'Unknown';
                      final timestamp = transaction['timestamp'] as Timestamp;
                      final total = transaction['total'] ?? 0;

                      // Check apakah ini completed
                      final isCompleted = status == 'completed';

                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? const Color(0xFFE6F7EC)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isCompleted
                                ? const Color(0xFF28A745)
                                : const Color(0xFF00B4A6),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      isCompleted
                                          ? Icons.check_circle
                                          : Icons.shopping_bag,
                                      color: isCompleted
                                          ? const Color(0xFF28A745)
                                          : const Color(0xFF00B4A6),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      formatDate(timestamp),
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isCompleted
                                        ? const Color(0xFF28A745)
                                        : const Color(0xFF00B4A6),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    status,
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Items List
                            ...items.map((item) {
                              final imageUrl = item['image'] ?? '';
                              final name = item['name'] ?? '';
                              final price = item['price'] ?? 0;
                              final quantity = item['quantity'] ?? 0;

                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FDFD),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.06),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        imageUrl,
                                        width: 70,
                                        height: 70,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(
                                          Icons.image_not_supported,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 40),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            name,
                                            style: const TextStyle(
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            formatRupiah(price),
                                            style: const TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 12,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '$quantity item(s)',
                                            style: const TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 10,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            const SizedBox(height: 10),

                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                formatRupiah(total),
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Complete Order button (hanya kalau delivered & belum completed)
                            if (status == 'delivered') ...[
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () =>
                                      completeOrder(transaction.id, context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF00B4A6),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 18,
                                    ),
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    shadowColor: const Color(
                                      0xFF00B4A6,
                                    ).withOpacity(0.4),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.check_circle_outline,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'Complete the Order',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
