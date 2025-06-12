import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gopeduli/dashboard/helper/formatter.dart';

class OrderItemModel {
  String id;
  String image;
  String name;
  int price;
  int quantity;
  DateTime? createdAt;
  DateTime? updatedAt;

  OrderItemModel({
    required this.id,
    required this.image,
    required this.name,
    required this.price,
    required this.quantity,
    this.createdAt,
    this.updatedAt,
  });

  static OrderItemModel empty() => OrderItemModel(
        id: '',
        image: '',
        name: '',
        price: 0,
        quantity: 0,
      );
  String get formattedDate => GoPeduliFormatter.formatDate(createdAt);
  String get formattedUpdateAtDate => GoPeduliFormatter.formatDate(updatedAt);

  Map<String, dynamic> toJson() {
    return {
      'Image': image,
      'Name': name,
      'Price': price,
      'Quantity': quantity,
      'CreatedAt': createdAt,
      'UpdatedAt': updatedAt = DateTime.now(),
    };
  }

  factory OrderItemModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return OrderItemModel(
        id: document.id,
        image: data['Image'] ?? '',
        name: data['Name'] ?? '',
        price: data['Price'] ?? 0,
        quantity: data['Quantity'] ?? 0,
        createdAt:
            data.containsKey('CreatedAt') ? data['CreatedAt']?.toDate() : null,
        updatedAt:
            data.containsKey('UpdatedAt') ? data['UpdatedAt']?.toDate() : null,
      );
    } else {
      return empty();
    }
  }

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      id: map['id'] ??
          '', // Asumsi ID mungkin ada di map jika data bersarang, jika tidak, bisa dihapus atau diabaikan
      image: map['image'] ?? '', // <--- UBAH: dari 'Image' ke 'image'
      name: map['name'] ?? '', // <--- UBAH: dari 'Name' ke 'name'
      price: (map['price'] as num?)?.toInt() ??
          0, // <--- UBAH: dari 'Price' ke 'price'
      quantity: (map['quantity'] as num?)?.toInt() ??
          0, // <--- UBAH: dari 'Quantity' ke 'quantity'
      // createdAt dan updatedAt tidak ada di map yang disematkan, jadi biarkan null atau hapus jika tidak perlu.
      createdAt: map.containsKey('createdAt')
          ? (map['createdAt'] as Timestamp?)?.toDate()
          : null,
      updatedAt: map.containsKey('updatedAt')
          ? (map['updatedAt'] as Timestamp?)?.toDate()
          : null,
    );
  }
}
