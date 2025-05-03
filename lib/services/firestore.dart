import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference articles =
      FirebaseFirestore.instance.collection('articles');

  // Create Article
  Future<void> createArticle(String title, String content) async {
    await articles.add({
      'title': title,
      'content': content,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Read Articles
  Stream<QuerySnapshot> getArticles() {
    final articlesStream =
        articles.orderBy('createdAt', descending: true).snapshots();
    return articlesStream;
  }

  // Read Article by ID
  Stream<DocumentSnapshot> getArticleById(String id) {
    final articleStream = articles.doc(id).snapshots();
    return articleStream;
  }

  // Update Article
  Future<void> updateArticle(String id, String title, String content) async {
    await articles.doc(id).update({
      'title': title,
      'content': content,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Delete Article
  Future<void> deleteArticle(String id) async {
    await articles.doc(id).delete();
  }
}
