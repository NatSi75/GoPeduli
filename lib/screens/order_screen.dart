import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'courier_order_screen.dart';
import 'delivery_history_screen.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  String? courierId;
  bool loading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initCourier();
  }

  Future<void> _initCourier() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          errorMessage = 'User belum login';
          loading = false;
        });
        return;
      }

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (!userDoc.exists) {
        setState(() {
          errorMessage = 'Data user tidak ditemukan';
          loading = false;
        });
        return;
      }

      final role = userDoc.data()?['Role'] ?? '';
      if (role != 'courier') {
        setState(() {
          errorMessage = 'Anda bukan kurir';
          loading = false;
        });
        return;
      }

      final id = user.uid;
      final count = await _countActiveOrders(id);

      setState(() {
        courierId = id;
        loading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Terjadi kesalahan: $e';
        loading = false;
      });
    }
  }

  Future<void> addCourierIdField() async {
    final firestore = FirebaseFirestore.instance;

    final snapshot = await firestore.collection('transactions').get();

    for (var doc in snapshot.docs) {
      await firestore.collection('transactions').doc(doc.id).update({
        'courier_id': null,
      });
    }

    print('All documents updated successfully.');
  }

  Future<int> _countActiveOrders(String id) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('transactions')
        .where('courier_id', isEqualTo: id)
        .where(
      'status',
      whereIn: ['pending', 'processing', 'shipped', 'delivered'],
    ).get();
    return snapshot.docs.length;
  }

  Future<void> _takeOrder(String orderId) async {
    if (courierId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Kurir belum terdeteksi')));
      return;
    }

    try {
      // Hitung active orders saat ini langsung dari Firestore (real-time)
      final count = await _countActiveOrders(courierId!);
      if (count >= 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'You can not claim more than 2 orders, please complete or cancel your current orders first',
            ),
          ),
        );
        return;
      }

      // Update klaim order
      await FirebaseFirestore.instance
          .collection('transactions')
          .doc(orderId)
          .update({'status': 'processing', 'courier_id': courierId});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order successfully claimed')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Fail to claim order: $e')));
    }
  }

  String formatCurrency(int price) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 2,
    );
    return formatter.format(price);
  }

  String formatTime(Timestamp? timestamp) {
    if (timestamp == null) return '-';
    final date = timestamp.toDate();
    return DateFormat.Hm().format(date);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (errorMessage.isNotEmpty) {
      return Scaffold(body: Center(child: Text(errorMessage)));
    }

    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Available Orders',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.assignment_turned_in_rounded),
            tooltip: 'My Orders',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyOrdersScreen(courierId: courierId!),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Delivery History',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DeliveryHistoryScreen(courierId: courierId!),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('transactions')
            .where('courier_id', isNull: true)
            .where('status', isEqualTo: 'ready')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data?.docs ?? [];
          if (orders.isEmpty) {
            return const Center(child: Text('No available orders.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final data = order.data() as Map<String, dynamic>;
              final items = data['items'] as List<dynamic>? ?? [];
              final orderId = data['order_id'] ?? 'Unknown';
              final timestamp = data['timestamp'] as Timestamp?;
              final userId = data['user_id'] ?? '';

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (userSnapshot.hasError) {
                    return const Text("Error loading user data");
                  }

                  final userData =
                      userSnapshot.data?.data() as Map<String, dynamic>?;

                  final address = userData?['Address'] ?? 'Address not found';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(
                        color: const Color(0xFF00B4A6),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.receipt_long,
                                color: Color(0xFF00B4A6),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Order ID: $orderId',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                size: 18,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                formatTime(timestamp),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 18,
                                color: Colors.red,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  address,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          const Text(
                            'Order Items:',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...items.map((item) {
                            final itemData = item as Map<String, dynamic>;
                            final name = itemData['name'] ?? '';
                            final quantity = itemData['quantity'] ?? 0;
                            final price = itemData['price'] ?? 0;
                            final image = itemData['image'] ?? '';

                            return ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: image != ''
                                    ? Image.network(
                                        image,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        width: 50,
                                        height: 50,
                                        color: Colors.grey[200],
                                        child: const Icon(
                                          Icons.image_not_supported,
                                        ),
                                      ),
                              ),
                              title: Text(name),
                              subtitle: Text('Qty: $quantity'),
                              trailing: Text(
                                formatCurrency(price),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                _takeOrder(order.id);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00B4A6),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: const Icon(
                                Icons.assignment_turned_in_outlined,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'Claim Order',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
