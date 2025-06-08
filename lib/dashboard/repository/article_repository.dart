import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:gopeduli/dashboard/repository/article_model.dart';
import 'package:gopeduli/dashboard/repository/author_model.dart';
import 'package:gopeduli/dashboard/repository/user_model.dart';

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

  // Get all article authors from the 'authors' collection
  Future<List<AuthorModel>> getAllAuthors() async {
    try {
      final authorsQuery = await _db.collection("authors").get();
      final authors = authorsQuery.docs
          .map((doc) => AuthorModel.fromSnapshot(doc))
          .toList();
      return authors;
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something Went Wrong! Please try again.';
    }
  }

  // Get all doctors from the 'users' collection
  Future<List<UserModel>> getAllDoctors() async {
    try {
      final snapshot = await _db
          .collection("users")
          .where(
            'Role',
            isEqualTo: 'doctor',
          )
          .get();
      final result =
          snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
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
