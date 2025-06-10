import 'package:cloud_firestore/cloud_firestore.dart';

class Article {
  final String id;
  final String title;
  final String author;
  final String body;
  final String imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String verifiedBy;

  Article({
    required this.id,
    required this.title,
    required this.author,
    required this.body,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.verifiedBy,
  });

  factory Article.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Article(
      id: doc.id,
      title: data['Title'] ?? 'No Title',
      author: data['Author'] ?? 'Unknown Author',
      body: data['Body'] ?? '',
      imageUrl: data['Image'] ?? '',
      createdAt: (data['CreatedAt'] as Timestamp).toDate(),
      updatedAt: (data['UpdatedAt'] as Timestamp).toDate(),
      verifiedBy: data['VerifiedBy'] ?? '',
    );
  }

  String get formattedDate {
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }
}
