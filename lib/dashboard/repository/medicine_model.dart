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
      'Id': id,
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
        nameProduct:
            data.containsKey('NameProduct') ? data['NameProduct'] ?? '' : '',
        nameMedicine:
            data.containsKey('NameMedicine') ? data['NameMedicine'] ?? '' : '',
        category: data.containsKey('Category') ? data['Category'] ?? '' : '',
        classMedicine: data.containsKey('ClassMedicine')
            ? data['ClassMedicine'] ?? ''
            : '',
        price: data.containsKey('Price') ? data['Price'] ?? '' : '',
        stock: data.containsKey('Stock') ? data['Stock'] ?? '' : '',
        createdAt: data.containsKey('CreatedAt')
            ? (data['CreatedAt']?.toDate() ?? DateTime.now())
            : DateTime.now(),
        updatedAt: data.containsKey('UpdatedAt')
            ? (data['UpdatedAt']?.toDate() ?? DateTime.now())
            : DateTime.now(),
      );
    } else {
      return empty();
    }
  }
}
