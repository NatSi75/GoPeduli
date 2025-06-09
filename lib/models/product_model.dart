class ProductModel {
  final String id;
  final String imageUrl;
  final String nameProduct;
  final double price;
  final String description;
  final int stock;
  final List<String>
      types; // dari Category, bisa berisi lebih dari satu kategori

  ProductModel({
    required this.id,
    required this.imageUrl,
    required this.nameProduct,
    required this.price,
    required this.description,
    required this.stock,
    required this.types,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map, String documentId) {
    return ProductModel(
      id: documentId,
      imageUrl: map['Image'] ?? '',
      nameProduct: map['NameProduct'] ?? '',
      price: double.tryParse(map['Price'] ?? '0') ?? 0.0,
      description: map['Description'] ?? '',
      stock: int.tryParse(map['Stock'] ?? '0') ?? 0,
      types: _parseCategory(map['Category']),
    );
  }

  static List<String> _parseCategory(dynamic categoryData) {
    if (categoryData is List) {
      return List<String>.from(categoryData);
    } else if (categoryData is String) {
      return categoryData.split(',').map((e) => e.trim()).toList();
    } else {
      return [];
    }
  }
}
