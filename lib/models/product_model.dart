class ProductModel {
  final String id;
  final String name;
  final int price;
  final String image;
  final String description;
  final List<String> types;
  final int stock;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.description,
    required this.types,
    required this.stock,
  });
}
