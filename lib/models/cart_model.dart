import 'product_model.dart';

class CartItem {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  int quantity;
  bool isSelected;
  final ProductModel product;

  CartItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.quantity = 1,
    this.isSelected = false,
    required this.product, // harus ditambahkan ini supaya product bisa diassign
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItem &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}
