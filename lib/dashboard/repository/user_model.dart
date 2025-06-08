import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gopeduli/dashboard/helper/enums.dart';
import 'package:gopeduli/dashboard/helper/formatter.dart';

class UserModel {
  String? id;
  String name;
  String email;
  String phoneNumber;
  AppRole role;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserModel({
    this.id,
    this.name = '',
    required this.email,
    this.phoneNumber = '',
    this.role = AppRole.user,
    this.createdAt,
    this.updatedAt,
  });

  //Helper method
  String get formattedDate => GoPeduliFormatter.formatDate(createdAt);
  String get formattedUpdateAtDate => GoPeduliFormatter.formatDate(updatedAt);
  String get formattedPhoneNo =>
      GoPeduliFormatter.formatPhoneNumber(phoneNumber);

  //Static function to create an empty user model
  static UserModel empty() => UserModel(email: '');

  //Convert model to JSON structure for storing data in Firebase
  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'Email': email,
      'PhoneNumber': phoneNumber,
      'Role': role.name.toString(),
      'CreatedAt': createdAt,
      'UpdatedAt': updatedAt = DateTime.now(),
    };
  }

  //Factory method to create a UserModel from a Firebase document snapshot
  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return UserModel(
        id: document.id,
        name: data.containsKey('Name') ? data['Name'] ?? '' : '',
        email: data.containsKey('Email') ? data['Email'] ?? '' : '',
        phoneNumber:
            data.containsKey('PhoneNumber') ? data['PhoneNumber'] ?? '' : '',
        role: data.containsKey('Role')
            ? (data['Role'] ?? AppRole.user) == AppRole.admin.name.toString()
                ? AppRole.admin
                : AppRole.user
            : AppRole.user,
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
