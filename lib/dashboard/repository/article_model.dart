import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gopeduli/dashboard/helper/formatter.dart';

class ArticleModel {
  String id;
  String image;
  String title;
  String body;
  String author;
  String verifiedBy;
  int views;
  DateTime? createdAt;
  DateTime? updatedAt;

  ArticleModel({
    required this.id,
    required this.image,
    required this.title,
    required this.body,
    required this.author,
    required this.verifiedBy,
    required this.views,
    this.createdAt,
    this.updatedAt,
  });

  static ArticleModel empty() => ArticleModel(
      id: '',
      image: '',
      title: '',
      body: '',
      author: '',
      verifiedBy: '',
      views: 0);
  String get formattedDate => GoPeduliFormatter.formatDate(createdAt);
  String get formattedUpdateAtDate => GoPeduliFormatter.formatDate(updatedAt);

  Map<String, dynamic> toJson() {
    return {
      'Image': image,
      'Title': title,
      'Body': body,
      'Author': author,
      'VerifiedBy': verifiedBy,
      'Views': views,
      'CreatedAt': createdAt,
      'UpdatedAt': updatedAt = DateTime.now(),
    };
  }

  factory ArticleModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return ArticleModel(
        id: document.id,
        image: data['Image'] ?? '',
        title: data['Title'] ?? '',
        body: data['Body'] ?? '',
        author: data['Author'] ?? '',
        verifiedBy: data['VerifiedBy'] ?? '',
        views: data['Views'] ?? '',
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
