import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:gopeduli/dashboard/repository/article_model.dart';

class ArticleRepository extends GetxController {
  static ArticleRepository get instance => Get.find();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get all articles from the 'articles' collection
  Future<List<ArticleModel>> getAllArticles() async {
    try {
      final snapshot = await _db.collection("articles").get();
      final result =
          snapshot.docs.map((e) => ArticleModel.fromSnapshot(e)).toList();
      return result;
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something Went Wrong! Please try again.';
    }
  }

  // Create a new article document in the 'Articles' collection
  Future<String> createArticle(ArticleModel article) async {
    try {
      final result = await _db.collection("articles").add(article.toJson());
      return result.id;
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something Went Wrong! Please try again.';
    }
  }

  // Delete an existing article document from the 'articles' collection
  Future<void> deleteArticle(String articleId) async {
    try {
      await _db.collection('articles').doc(articleId).delete();
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something Went Wrong! Please try again.';
    }
  }

  // Update Article
  Future<void> updateArticle(ArticleModel article) async {
    try {
      await _db.collection('articles').doc(article.id).update(article.toJson());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something Went Wrong! Please try again.';
    }
  }
}
