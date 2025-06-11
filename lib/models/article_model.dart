// article_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Article {
  final String id;
  final String title;
  final String author;
  final String body;
  final String imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String verifiedBy;
  final int views;

  Article({
    required this.id,
    required this.title,
    required this.author,
    required this.body,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.verifiedBy,
    this.views = 0,
  });

  factory Article.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Article(
      id: doc.id,
      title: data['Title'] ?? 'No Title',
      author: data['Author'] ?? 'Unknown Author',
      body: data['Body'] ?? 'No Content',
      imageUrl: data['Image'] ?? '',
      createdAt: (data['CreatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['UpdatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      verifiedBy: data['VerifiedBy'] ?? 'Admin',
      views: data['Views'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'Title': title,
      'Author': author,
      'Body': body,
      'Image': imageUrl,
      'CreatedAt': Timestamp.fromDate(createdAt),
      'UpdatedAt': Timestamp.fromDate(updatedAt),
      'VerifiedBy': verifiedBy,
      'Views': views,
    };
  }

  String get formattedDate {
    return DateFormat('d/M/yyyy').format(createdAt);
  }
}
