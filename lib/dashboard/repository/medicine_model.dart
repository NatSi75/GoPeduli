import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gopeduli/dashboard/helper/formatter.dart';

class MedicineModel {
  String id;
  String nameProduct;
  String nameMedicine;
  String category;
  String classMedicine;
  String price;
  String stock;
  DateTime? createdAt;
  DateTime? updatedAt;

  MedicineModel({
    required this.id,
    required this.nameProduct,
    required this.nameMedicine,
    required this.category,
    required this.classMedicine,
    required this.price,
    required this.stock,
    this.createdAt,
    this.updatedAt,
  });

  static MedicineModel empty() => MedicineModel(
      id: '',
      nameProduct: '',
      nameMedicine: '',
      category: '',
      classMedicine: '',
      price: '',
      stock: '');
  String get formattedDate => GoPeduliFormatter.formatDate(createdAt);
  String get formattedUpdateAtDate => GoPeduliFormatter.formatDate(updatedAt);

  Map<String, dynamic> toJson() {
    return {
      'NameProduct': nameProduct,
      'NameMedicine': nameMedicine,
      'Category': category,
      'ClassMedicine': classMedicine,
      'Price': price,
      'Stock': stock,
      'CreatedAt': createdAt,
      'UpdatedAt': updatedAt = DateTime.now(),
    };
  }

  factory MedicineModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return MedicineModel(
        id: document.id,
        nameProduct: data['NameProduct'] ?? '',
        nameMedicine: data['NameMedicine'] ?? '',
        category: data['Category'] ?? '',
        classMedicine: data['ClassMedicine'] ?? '',
        price: data['Price'] ?? '',
        stock: data['Stock'] ?? '',
        createdAt:
            data.containsKey('CreatedAt') ? data['CreatedAt']?.toDate() : null,
        updatedAt:
            data.containsKey('UpdatedAt') ? data['UpdatedAt']?.toDate() : null,
      );
    } else {
      return empty();
    }
  }
}
