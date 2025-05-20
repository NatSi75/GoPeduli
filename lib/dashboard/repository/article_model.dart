import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gopeduli/dashboard/helper/formatter.dart';

class ArticleModel {
  String id;
  String image;
  String title;
  String body;
  String author;
  String verifiedBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  ArticleModel({
    required this.id,
    required this.image,
    required this.title,
    required this.body,
    required this.author,
    this.verifiedBy = '',
    this.createdAt,
    this.updatedAt,
  });

  static ArticleModel empty() =>
      ArticleModel(id: '', image: '', title: '', body: '', author: '');
  String get formattedDate => GoPeduliFormatter.formatDate(createdAt);
  String get formattedUpdateAtDate => GoPeduliFormatter.formatDate(updatedAt);

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Image': image,
      'Title': title,
      'Body': body,
      'Author': author,
      'VerifiedBy': verifiedBy,
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
        image: data.containsKey('Image') ? data['Image'] ?? '' : '',
        title: data.containsKey('Title') ? data['Title'] ?? '' : '',
        body: data.containsKey('Body') ? data['Body'] ?? '' : '',
        author: data.containsKey('Author') ? data['Author'] ?? '' : '',
        verifiedBy:
            data.containsKey('VerfiedBy') ? data['VerfiedBy'] ?? '' : '',
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
