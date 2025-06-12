import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyOrdersScreen extends StatelessWidget {
  final String courierId;

  MyOrdersScreen({Key? key, required this.courierId}) : super(key: key);

  final Color primaryColor = const Color(0xFF00B4A6);
  final Color backgroundColor = const Color(0xfff5f5f5);

  Future<void> _updateStatus(
    String orderId,
    String newStatus,
    BuildContext context,
  ) async {
    try {
      if (newStatus == 'ready') {
        await FirebaseFirestore.instance
            .collection('transactions')
            .doc(orderId)
            .update({'status': 'ready', 'courier_id': null});
      } else {
        await FirebaseFirestore.instance
            .collection('transactions')
            .doc(orderId)
            .update({'status': newStatus});
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update status: $e')),
      );
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
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('My Orders', style: TextStyle(fontFamily: 'Poppins')),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('transactions')
            .where('courier_id', isEqualTo: courierId)
            .where('status', whereIn: [
              'pending',
              'processing',
              'ready',
              'shipped',
              'delivered'
            ])
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
            return const Center(child: Text('No order has been claimed'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final data = order.data() as Map<String, dynamic>;

              return buildOrderCard(context, order.id, data);
            },
          );
        },
      ),
    );
  }

  Widget buildOrderCard(
      BuildContext context, String docId, Map<String, dynamic> data) {
    final items = data['items'] as List<dynamic>? ?? [];
    final orderId = data['order_id'] ?? 'Unknown';
    final status = data['status'] ?? 'Unknown';
    final timestamp = data['timestamp'] as Timestamp?;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildOrderHeader(orderId, timestamp, status),
          const Divider(height: 24),
          const Text('Order Items:',
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          ...items.map((item) => buildOrderItem(item)).toList(),
          const SizedBox(height: 16),
          buildStatusActions(context, docId, status),
        ],
      ),
    );
  }

  Widget buildOrderItem(dynamic item) {
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
            ? Image.network(image, width: 50, height: 50, fit: BoxFit.cover)
            : Container(
                width: 50,
                height: 50,
                color: Colors.grey[200],
                child: const Icon(Icons.image_not_supported),
              ),
      ),
      title: Text(name),
      subtitle: Text('Qty: $quantity'),
      trailing: Text(
        formatCurrency(price),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildOrderHeader(String orderId, Timestamp? timestamp, String status) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.receipt_long, color: Color(0xFF00B4A6)),
            const SizedBox(width: 8),
            Text(
              orderId,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.access_time, size: 18, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              formatTime(timestamp),
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.info_outline, size: 18, color: Colors.black),
            const SizedBox(width: 4),
            Text(
              'Status: $status',
              style: const TextStyle(
                color: Color(0xFF00B4A6),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        if (status == 'delivered') ...[
          const SizedBox(height: 6),
          const Text(
            'Waiting for customer to complete the order',
            style: TextStyle(
              color: Colors.grey,
              fontStyle: FontStyle.italic,
              fontSize: 13,
            ),
          ),
        ],
      ],
    );
  }

  Widget buildStatusActions(
      BuildContext context, String orderId, String currentStatus) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          buildStatusButton(context, orderId, 'shipped', currentStatus),
          const SizedBox(width: 8),
          buildStatusButton(context, orderId, 'delivered', currentStatus),
          const SizedBox(width: 8),
          OutlinedButton.icon(
            onPressed: () => _updateStatus(orderId, 'ready', context),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color.fromARGB(255, 245, 64, 64),
              side: const BorderSide(
                color: Color.fromARGB(255, 245, 64, 64),
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
            icon: const Icon(Icons.cancel, size: 18),
            label: const Text('Cancel Order'),
          ),
        ],
      ),
    );
  }

  Widget buildStatusButton(BuildContext context, String orderId,
      String targetStatus, String currentStatus) {
    final bool isActive = targetStatus == currentStatus;
    final Map<String, String> statusLabels = {
      'pending': 'Pending',
      'processing': 'Processing',
      'ready': 'Ready',
      'shipped': 'Shipped',
      'delivered': 'Delivered',
    };

    return OutlinedButton(
      onPressed: () => _updateStatus(orderId, targetStatus, context),
      style: OutlinedButton.styleFrom(
        backgroundColor: isActive ? primaryColor : Colors.transparent,
        foregroundColor: isActive ? Colors.white : primaryColor,
        side: BorderSide(color: primaryColor, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Text(
        statusLabels[targetStatus] ?? targetStatus,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: isActive ? Colors.white : primaryColor,
        ),
      ),
    );
  }
}
