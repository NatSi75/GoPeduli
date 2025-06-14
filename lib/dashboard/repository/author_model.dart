import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gopeduli/dashboard/helper/formatter.dart';

class AuthorModel {
  String id;
  String name;
  String email;
  String phoneNumber;
  DateTime? createdAt;
  DateTime? updatedAt;

  AuthorModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.createdAt,
    this.updatedAt,
  });

  //Helper method
  String get formattedDate => GoPeduliFormatter.formatDate(createdAt);
  String get formattedUpdateAtDate => GoPeduliFormatter.formatDate(updatedAt);
  String get formattedPhoneNo =>
      GoPeduliFormatter.formatPhoneNumber(phoneNumber);

  //Static function to create an empty user model
  static AuthorModel empty() =>
      AuthorModel(id: '', name: '', email: '', phoneNumber: '');

  //Convert model to JSON structure for storing data in Firebase
  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'Email': email,
      'PhoneNumber': phoneNumber,
      'CreatedAt': createdAt,
      'UpdatedAt': updatedAt = DateTime.now(),
    };
  }

  //Factory method to create a AuthorModel from a Firebase document snapshot
  factory AuthorModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return AuthorModel(
        id: document.id,
        name: data.containsKey('Name') ? data['Name'] ?? '' : '',
        email: data.containsKey('Email') ? data['Email'] ?? '' : '',
        phoneNumber:
            data.containsKey('PhoneNumber') ? data['PhoneNumber'] ?? '' : '',
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
