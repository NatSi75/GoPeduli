import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gopeduli/dashboard/helper/formatter.dart';
import 'package:gopeduli/dashboard/repository/order_item_model.dart';

class OrderModel {
  String orderId;
  String userId;
  List<OrderItemModel> items;
  String fraudStatus;
  String status;
  int total;
  DateTime? createdAt;
  DateTime? updatedAt;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.items,
    required this.fraudStatus,
    required this.status,
    required this.total,
    this.createdAt,
    this.updatedAt,
  });

  static OrderModel empty() => OrderModel(
      orderId: '',
      userId: '',
      items: [],
      fraudStatus: '',
      status: '',
      total: 0);
  String get formattedDate => GoPeduliFormatter.formatDate(createdAt);
  String get formattedUpdateAtDate => GoPeduliFormatter.formatDate(updatedAt);

  OrderModel copyWith({
    String? orderId,
    String? userId,
    int? total,
    String? fraudStatus,
    String? status,
    DateTime? createdAt,
    String? formattedDate,
  }) {
    return OrderModel(
      orderId: orderId ??
          this.orderId, // Jika orderId baru tidak diberikan, gunakan yang lama
      userId: userId ?? this.userId,
      items: List<OrderItemModel>.from(items), // Copy the list of items
      total: total ?? this.total,
      fraudStatus: fraudStatus ?? this.fraudStatus,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'OrderID': orderId,
      'UserID': userId,
      'Items': items.map((item) => item.toJson()).toList(),
      'Total': total,
      'FraudStatus': fraudStatus,
      'Status': status,
      'Timestamp': createdAt,
      'UpdatedAt': updatedAt = DateTime.now(),
    };
  }

  factory OrderModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return OrderModel(
        orderId: document.id,
        userId: data['user_id'] ?? '',
        items: (data['items'] as List<dynamic>?)
                ?.map((itemMap) =>
                    OrderItemModel.fromMap(itemMap as Map<String, dynamic>))
                .toList() ??
            [],
        fraudStatus: data['fraud_status'] ?? '',
        status: data['status'] ?? '',
        total: data['total'] ?? 0,
        createdAt:
            data.containsKey('timestamp') ? data['timestamp']?.toDate() : null,
        updatedAt:
            data.containsKey('UpdatedAt') ? data['UpdatedAt']?.toDate() : null,
      );
    } else {
      return empty();
    }
  }
}
